import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/components/background_painter.dart';
import 'package:scribby_flutter_v2/functions/helpers.dart';
import 'package:scribby_flutter_v2/providers/palette_state.dart';
import 'package:scribby_flutter_v2/providers/settings_state.dart';
import 'package:scribby_flutter_v2/resources/firestore_methods.dart';
import 'package:scribby_flutter_v2/resources/iap_service.dart';
import 'package:scribby_flutter_v2/resources/storage_methods.dart';
import 'package:scribby_flutter_v2/screens/shop_screen/components/shop_item.dart';
import 'package:scribby_flutter_v2/settings/settings.dart';
import 'package:image_picker/image_picker.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
    
  @override
  Widget build(BuildContext context) {


    
    return Consumer<SettingsController>(
      builder: (context,settings,child) {

        // ColorPalette palette = Provider.of<ColorPalette>(context, listen: false);



        late double scalor = 1.0;

        final Map<dynamic,dynamic> userData = settings.userData.value as Map<dynamic,dynamic>;


        


        return PopScope(
          canPop: true,
          child: Consumer<ColorPalette>(
            builder: (context,palette,child) {

              print("""
----------------------- settings.iapProducts.value ----------------------- 
${settings.iapProducts.value}
--------------------------------------------------------------------------
              """);
              return SafeArea(
                child: Stack(
                  children: [
                    Positioned(
                      // top: 1,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,//-MediaQuery.of(context).padding.top-MediaQuery.of(context).padding.bottom,
                        child: CustomPaint(
                          painter: GradientBackground(settings: settings, palette: palette, decorationData: []),
                        ),
                      ),
                    ),             
                    Scaffold(
                      backgroundColor: Colors.transparent,
                      onDrawerChanged: (var details) {},
                      appBar: AppBar(
                        backgroundColor: const Color.fromARGB(0, 49, 49, 49),
                        title: Text(
                          "Shop", 
                          style: palette.mainAppFont(
                            textStyle: TextStyle(
                              color: palette.appBarText,
                              fontSize: 36*scalor,
                            )
                          ),
                        ),
                        leading: IconButton(
                          icon: Icon(Icons.arrow_back, color: palette.text2),
                          onPressed: () => Navigator.of(context).pop(true),
                        ),
                      ),
                            
                      body: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                      
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12.0 * scalor),
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 100 * scalor),
                                  // ShopItem(fileName: "no_ads", label: "No Ads", cost: 2.99),
                                  // Divider(),
                                  // ShopItem(fileName: "coins_1", label: "100 Coins", cost: 0.99),
                                  // ShopItem(fileName: "coins_2", label: "350 Coins", cost: 1.99),
                                  // ShopItem(fileName: "coins_3", label: "500 Coins", cost: 3.49),
                                  // ShopItem(fileName: "coins_4", label: "1000 Coins", cost: 6.99),
                                  // ShopItem(fileName: "coins_5", label: "5000 Coins", cost: 25.49),

                                  // ...settings.iapProducts.value.map((product) => ListTile(
                                  //   tileColor: palette.widget2,
                                  //   textColor: palette.widgetText2,
                                    
                                  //   title: Text(product.title),
                                  //   subtitle: Text(product.price),
                                  //   onTap: () => IAPService().buyProduct(product),
                                  // )),

                                  // ...settings.iapProducts.value.map((product) => ShopItem(productdetails: product),
                                    // onTap: () => IAPService().buyProduct(product),
                                  // )
                                  // ),

                                  ShopItem(productId: "remove_ads",),
                                  Divider(),
                                  ShopItem(productId: "coins_500", ),
                                  ShopItem(productId: "coins_2000",),
                                  ShopItem(productId: "coins_5000", ),
                                  ShopItem(productId: "coins_10000", ),
                                  ShopItem(productId: "coins_20000", ),


                              
              
              
                                  // Restore purchases button (required by Apple)
                                  TextButton(
                                    onPressed: () => IAPService().restorePurchases(),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: palette.widget1,
                                      foregroundColor: palette.widgetText1
                                    ),
                                    child: Text('Restore purchases'),
                                  ), 


                                                             
                                ],
                              ),

                              
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Pending overlay
                    
                    Builder(
                      builder: (context) {
                        if (settings.isPurchasePending.value) {
                          return Container(
                            color: Colors.black54,
                            child: Center(child: CircularProgressIndicator()),
                          );
                        } else {
                          return SizedBox();
                        }
                      }
                    ),                      
                  ],
                ),
              );
            }
          ),
        );
      }
    );
  }
}
