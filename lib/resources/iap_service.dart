// import 'package:scribby_flutter_v2/settings/settings_controller.dart';

import 'dart:async';

import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:scribby_flutter_v2/settings/settings.dart';
const Set<String> _kProductIds = {
  'coins_500', 'coins_2000', 'coins_5000',
  'coins_10000', 'coins_20000', 'remove_ads',
};
class IAPService {
  static final IAPService _instance = IAPService._internal();
  factory IAPService() => _instance;
  IAPService._internal();

  final InAppPurchase _iap = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  SettingsController? _settings;

  void attach(SettingsController settings) {
    _settings = settings;
  }

  Future<void> initialize() async {
    final available = await _iap.isAvailable();
    if (!available) return;

    _subscription = _iap.purchaseStream.listen(
      _listenToPurchaseUpdated,
      onDone: () => _subscription.cancel(),
      onError: (error) => print('IAP error: $error'),
    );

    await loadProducts();
  }

  Future<void> loadProducts() async {
    print("🤑 Load products is being called");
    final response = await _iap.queryProductDetails(_kProductIds);
    print('IAP products found: ${response.productDetails.length}');
    _settings?.setIapProducts(response.productDetails);
  }

  Future<void> buyProduct(ProductDetails product) async {
    final isConsumable = product.id != 'remove_ads';
    final param = PurchaseParam(productDetails: product);
    if (isConsumable) {
      await _iap.buyConsumable(purchaseParam: param);
    } else {
      await _iap.buyNonConsumable(purchaseParam: param);
    }
  }

  Future<void> restorePurchases() async {
    await _iap.restorePurchases();
  }

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchases) async {
    for (final purchase in purchases) {
      if (purchase.status == PurchaseStatus.pending) {
        _settings?.setIsPurchasePending(true);

      } else if (purchase.status == PurchaseStatus.purchased ||
                 purchase.status == PurchaseStatus.restored) {
        final valid = await _verifyPurchase(purchase);
        if (valid) await _deliverProduct(purchase);
        _settings?.setIsPurchasePending(false);
        await _iap.completePurchase(purchase);

      } else if (purchase.status == PurchaseStatus.error) {
        _settings?.setIsPurchasePending(false);
        _settings?.setPurchaseError(purchase.error!.message);
      }
    }
  }

  Future<void> _deliverProduct(PurchaseDetails purchase) async {
    switch (purchase.productID) {
      case 'coins_500':  _settings?.addCoins(500);  break;
      case 'coins_2000':  _settings?.addCoins(2000);  break;
      case 'coins_5000': _settings?.addCoins(5000); break;
      case 'coins_10000': _settings?.addCoins(10000); break;
      case 'coins_20000': _settings?.addCoins(20000); break;
      case 'remove_ads': _settings?.setAdsRemoved(true); break;
    }
  }

  Future<bool> _verifyPurchase(PurchaseDetails purchase) async {
    return purchase.status == PurchaseStatus.purchased ||
           purchase.status == PurchaseStatus.restored;
  }

  void dispose() => _subscription.cancel();
}