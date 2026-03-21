import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';
import 'package:scribby_flutter_v2/functions/helpers.dart';
import 'package:scribby_flutter_v2/providers/palette_state.dart';
import 'package:scribby_flutter_v2/resources/iap_service.dart';
import 'package:scribby_flutter_v2/settings/settings.dart';

// class ShopItem extends StatelessWidget {
//   final String fileName;
//   final String label;
//   final double cost;
//   const ShopItem({
//     super.key,
//     required this.fileName,
//     required this.label,
//     required this.cost,
//   });

//   @override
//   Widget build(BuildContext context) {
//     ColorPalette palette = Provider.of<ColorPalette>(context, listen: false);
//     SettingsController settings = Provider.of<SettingsController>(context, listen: false);
//     final double scalor = Helpers().getScalor(settings);
//     return Card(
//       color: palette.widget2,
//       child: Padding(
//         padding: EdgeInsets.all(12.0 * scalor),
//         child: Row(
//           children: [
//             Expanded(
//               flex: 2,
//               child: SizedBox(
//                 width: 50*scalor,
//                 height: 50*scalor,
//                 child: Image(
//                   semanticLabel: "coins",
//                   image: AssetImage(
//                     'assets/images/$fileName.png'
//                   )
//                 ),
//               ),
//             ),
//             Expanded(
//               flex: 3,
//               child: Text(
//                 label,
//                 style: palette.mainAppFont(
//                   textStyle: TextStyle(
//                     color: palette.widgetText2,
//                     fontSize: 22 * scalor
//                   )
//                 ),
//               ),
//             ),
//             Expanded(
//               flex: 2,
//               child: Padding(
//                 padding: EdgeInsets.all(4.0 * scalor),
//                 child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: palette.widget1,
//                     foregroundColor: palette.widgetText1,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.all(Radius.circular(8*scalor))
//                     ),
//                     padding: EdgeInsets.all(8.0*scalor)
//                   ),
//                   onPressed: () => print("$label is gonna cost ya $cost"),
//                       child: FittedBox(
//                         fit: BoxFit.scaleDown,
//                         child: Text(
//                         "\$ ${cost.toString()}",
//                           style: palette.mainAppFont(
//                             // color: Colors.white,
//                             textStyle: TextStyle(
//                               fontSize: 24*scalor,
//                             ),
//                           ),
//                         ),
//                       ),                                                                                
                  
//                 ),

//               )
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


class ShopItem extends StatelessWidget {
  // final ProductDetails productdetails;
  final String productId;
  const ShopItem({
    super.key,
    // required this.productdetails
    required this.productId
  });

  @override
  Widget build(BuildContext context) {
    ColorPalette palette = Provider.of<ColorPalette>(context, listen: false);
    SettingsController settings = Provider.of<SettingsController>(context, listen: false);
    final double scalor = Helpers().getScalor(settings);

    final List<ProductDetails> queriedProductDetails = settings.iapProducts.value.where((e)=>e.id == productId).toList();


    void printData(ProductDetails details) {
      print("""
        PRODUCT DETAILS
        currencyCode:     ${details.currencyCode}
        currencySymbol:   ${details.currencySymbol}
        description:      ${details.description}
        id:               ${details.id}
        price:            ${details.price}
        rawPrice:         ${details.rawPrice}
        title:            ${details.title}
      """);
    }

    String getProductLabel(ProductDetails details) {
      Map<String,dynamic> labelMap = {
        "coins_10000": "10,000 Coins",
        "coins_2000": "2,000 Coins",
        "coins_20000": "20,000 Coins",
        "coins_500": "500 Coins",
        "coins_5000": "5,000 Coins",
        "remove_ads": "Remove Ads",
      };
      return labelMap[details.id];
    }

    String getProductFileName(ProductDetails details) {
      Map<String,dynamic> labelMap = {
        "coins_10000": "coins_4",
        "coins_2000": "coins_2",
        "coins_20000": "coins_5",
        "coins_500": "coins_1",
        "coins_5000": "coins_3",
        "remove_ads": "no_ads",
      };
      return labelMap[details.id];
    }


    return Builder(
      builder: (context) {
        
        if (queriedProductDetails.isNotEmpty) {
          final ProductDetails productDetails = queriedProductDetails.first;
          return Card(
            color: palette.widget2,
            child: GestureDetector(
              onTap: () => printData(productDetails),
              child: Padding(
                padding: EdgeInsets.all(12.0 * scalor),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: SizedBox(
                        width: 50*scalor,
                        height: 50*scalor,
                        child: Image(
                          semanticLabel: "coins",
                          image: AssetImage(
                            // 'assets/images/$fileName.png'
                            'assets/images/${getProductFileName(productDetails)}.png'
                          )
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        // label,
                        // "",
                        getProductLabel(productDetails),
                        style: palette.mainAppFont(
                          textStyle: TextStyle(
                            color: palette.widgetText2,
                            fontSize: 22 * scalor
                          )
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: EdgeInsets.all(4.0 * scalor),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: palette.widget1,
                            foregroundColor: palette.widgetText1,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(8*scalor))
                            ),
                            padding: EdgeInsets.all(8.0*scalor)
                          ),
                          // onPressed: () => printData(productDetails), // print("product details: ${productdetails.}"),
                          onPressed: () => IAPService().buyProduct(productDetails),
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                // "\$ ${cost.toString()}",
                                  "${productDetails.currencySymbol} ${productDetails.rawPrice}",
                                  style: palette.mainAppFont(
                                    // color: Colors.white,
                                    textStyle: TextStyle(
                                      fontSize: 24*scalor,
                                    ),
                                  ),
                                ),
                              ),                                                                                
                          
                        ),
              
                      )
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          return SizedBox();
        }
      }
    );
  }
}