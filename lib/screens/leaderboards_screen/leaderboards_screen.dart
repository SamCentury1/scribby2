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
import 'package:scribby_flutter_v2/resources/storage_methods.dart';
import 'package:scribby_flutter_v2/settings/settings.dart';
import 'package:image_picker/image_picker.dart';

class LeaderboardsScreen extends StatefulWidget {
  const LeaderboardsScreen({super.key});

  @override
  State<LeaderboardsScreen> createState() => _LeaderboardsScreenState();
}

class _LeaderboardsScreenState extends State<LeaderboardsScreen> {


  late List<Map<String,dynamic>> leaderboardData = [
    {'uid': '0a9cc6afa6ec4402b47d1d099ca7f48b', 'username': 'athletic-snake-7295', 'xp': 50},
    {'uid': '6005efe1063a48f5b4e9d7322a6f80ad', 'username': 'brutal-cheese-7273', 'xp': 121},
    {'uid': '2ae250c9c1584c87b46ba260fa15cef1', 'username': 'smart-snake-8699', 'xp': 209},
    {'uid': 'c8cae82253554cf88865fd210493fb3f', 'username': 'stale-berry-9402', 'xp': 464},
    {'uid': '9f4fe6bb76cb48c6a80fb52e8e15bb8f', 'username': 'travelling-star-8407', 'xp': 216},
    {'uid': '89e78951e95c4895adb13046ddb4ea21', 'username': 'travelling-star-7984', 'xp': 26},
    {'uid': 'd8481547686a4a52a59fc3a826e0716e', 'username': 'free-sheppard-6563', 'xp': 137},
    {'uid': 'aa4c038b3a454c4dbe06a4d34592ecee', 'username': 'athletic-stingray-4191', 'xp': 216},
    {'uid': 'd9dcd40eb0364354ab4e9a489983928a', 'username': 'breathing-cheese-4329', 'xp': 230},
    {'uid': '7efa6c23d0d24ed2b1802ace46dede49', 'username': 'breathing-berry-5726', 'xp': 12},
    {'uid': '0a0e87ca19184b4c84a2db7d4a61cad1', 'username': 'long-frying-pan-9278', 'xp': 349},
    {'uid': '462727e8d4c749f1817176ea9b41ebb5', 'username': 'smart-penguin-8294', 'xp': 153},
    {'uid': '8d32efa8c49b44d299620bced6adeabb', 'username': 'stale-penguin-3770', 'xp': 297},
    {'uid': '23f4c451e5e64492916d3bdb79e4c404', 'username': 'pretty-hurricane-1337', 'xp': 287},
    {'uid': '8946fc4afd4643fbbd79772ac7491f72', 'username': 'flowing-tree-5063', 'xp': 480},
    {'uid': 'e75f37fad0e047648cf8d6e772adcc9d', 'username': 'little-stone-3887', 'xp': 375},
    {'uid': '1b8b3bee8f9545159196e2a29fbb736a', 'username': 'janky-slinky-2742', 'xp': 180},
    {'uid': '518d60f7b048466b81b76503a382029e', 'username': 'treaturous-snake-7533', 'xp': 99},
    {'uid': '82d7921e04dd465386ead1979523e244', 'username': 'big-star-5381', 'xp': 415},
    {'uid': '76ca07e3b738421a902b1ee56d0ede46', 'username': 'sprouting-bear-9813', 'xp': 409},
    {'uid': '8cc0998165464f10bd125d9f6e28f3c8', 'username': 'active-avalanche-1321', 'xp': 145},
    {'uid': '6acbe8f9a27945ee929ad563d2168417', 'username': 'smart-star-9000', 'xp': 206},
    {'uid': '01bb9eb770cd40e1baa0ca7de0628571', 'username': 'terrible-iguana-5517', 'xp': 409},
    {'uid': 'c8c2d972e4094b4bbba041dcb2e26f8e', 'username': 'terrible-frying-pan-2523', 'xp': 169},
    {'uid': 'cbbd56f72b5a4458a10d084fb59fa494', 'username': 'treaturous-iguana-4137', 'xp': 283},
    {'uid': '759d7755bc5c4f86ade4c8129984ea29', 'username': 'big-penguin-9637', 'xp': 447},
    {'uid': '07b69bf9b6cc4f8494ee69e91c361c11', 'username': 'breathing-stone-8032', 'xp': 339},
    {'uid': '18e3a1cfb4ae4b159eb6e320b7f66ce6', 'username': 'blue-pirate-4861', 'xp': 147},
    {'uid': '04d1e8cb0dc24cdb95462829e3512bf2', 'username': 'free-cheese-6318', 'xp': 176},
    {'uid': '20c84a1c8a0d42a2800ca5d16aef344b', 'username': 'little-berry-7514', 'xp': 239},
    {'uid': '51577461b2074da1a795b60b3fcc68d4', 'username': 'crusty-penguin-2763', 'xp': 34},
    {'uid': '70d7703d510a41e78aa3d884369a2c97', 'username': 'blue-cheese-4131', 'xp': 215},
    {'uid': '3e8b753cecdb417daa1b47bdf42c1685', 'username': 'janky-stingray-7181', 'xp': 130},
    {'uid': 'a3b41f1863c5494f97609ba9f82c54fe', 'username': 'sparse-brick-5073', 'xp': 49},
    {'uid': '40777494e5d74800b12b832d06a75070', 'username': 'long-iguana-9585', 'xp': 341},
    {'uid': '404aa3da424f4c7db6ad0c110fb64df3', 'username': 'blue-snake-4931', 'xp': 356},
    {'uid': 'f41df2477d3b412086f25969d8b09683', 'username': 'brutal-cheese-9186', 'xp': 338},
    {'uid': '6d6de500b3b247bca2efed5cf98ce955', 'username': 'long-cowboy-3013', 'xp': 329},
    {'uid': '43c26a6621944a68804a3ed525d7e6e9', 'username': 'free-flamingo-8054', 'xp': 337},
    {'uid': 'b31074edc3c14357866225479e923946', 'username': 'flowing-star-2651', 'xp': 71},
    {'uid': '64e44c1d1d14470b8b570c0e7b1d3f70', 'username': 'free-hurricane-1783', 'xp': 474},
    {'uid': '2473274126a14e9997ef2e05630431e1', 'username': 'sparse-brick-3199', 'xp': 365},
    {'uid': 'eb9048ada16c4554a24f4049dbf8ade0', 'username': 'active-iguana-3059', 'xp': 94},
    {'uid': '488b4b70e3c743eaa323828d38cbd9e4', 'username': 'clever-prawn-9490', 'xp': 155},
    {'uid': '7bf69a551c1040f0b4bbbf22aefd769a', 'username': 'sprouting-flower-1418', 'xp': 496},
    {'uid': '1bd7f934343040578007e51983aaa1c1', 'username': 'treaturous-rocket-7033', 'xp': 315},
    {'uid': 'cf9e8204b50a4ad2bf6a7a87cd1a6b76', 'username': 'little-prawn-4072', 'xp': 315},
    {'uid': '1148d86fd0f14928a230346fb037daf2', 'username': 'crusty-pirate-3337', 'xp': 210},
    {'uid': 'b886ab4bb8a1410d95e5cf749bfdc4dd', 'username': 'big-blueberry-7535', 'xp': 403},
    {'uid': '471bc0d7014b425db046817a67ee88b1', 'username': 'little-frying-pan-6253', 'xp': 103},
    {'uid': 'b6771be1a017406fb6533ae0a374c5e6', 'username': 'pretty-star-6640', 'xp': 124},
    {'uid': '8d30349d782f47bf8ba485bb6df37847', 'username': 'janky-snake-5140', 'xp': 135},
    {'uid': '425a05d6af3f48fc98c55d4efbb0c851', 'username': 'clever-pirate-5077', 'xp': 116},
    {'uid': '1c9b6ca5677347f7b5b5c7e25f6d17d5', 'username': 'treaturous-iguana-2158', 'xp': 248},
    {'uid': '76f5b5f6927e442fb01c739594999665', 'username': 'treaturous-panther-3430', 'xp': 27},
    {'uid': '64abc50e728943ae82ff8b889bed4d4b', 'username': 'janky-stone-7628', 'xp': 381},
    {'uid': '08d2caf48a2548119e1012e5056df9a6', 'username': 'clever-star-2824', 'xp': 146},
    {'uid': '4ade4677ea024611b1703aed5fb24e97', 'username': 'sprouting-stone-1139', 'xp': 199},
    {'uid': 'eabea04cd6374b1cad3c576a78c96e41', 'username': 'private-monk-6666', 'xp': 186},
    {'uid': 'ae6b5929fcf342fcbd6d3d58a5aba1be', 'username': 'travelling-mammoth-5053', 'xp': 433},
    {'uid': '17292bf719344f2e852335a5d1900017', 'username': 'terrible-brick-7392', 'xp': 246},
    {'uid': 'db0733dc301645608ca88aed4f5b2912', 'username': 'big-penguin-7594', 'xp': 323},
    {'uid': 'fb7c41769fbd404a83c687292d6dc8e2', 'username': 'private-mammoth-1148', 'xp': 291},
    {'uid': 'f4fd7887a79c42c2827a043040219278', 'username': 'athletic-frying-pan-8671', 'xp': 321},
    {'uid': '556b6badb85a45bc95bbe5efbf480a7a', 'username': 'blue-penguin-7077', 'xp': 437},
    {'uid': '7942300b64dd4125a314e121197df0cc', 'username': 'smart-tree-1422', 'xp': 178},
    {'uid': '5a2ce3b7c04a467c98a6a1dffc292ad3', 'username': 'janky-cheese-1791', 'xp': 204},
    {'uid': 'dcf0da1e8d6148519c049a582eceb925', 'username': 'terrible-rocket-8030', 'xp': 220},
    {'uid': '2cc3ae5e710842698241df410ae17070', 'username': 'travelling-sheppard-6325', 'xp': 67},
    {'uid': '9d8caaca268f41dc92add9f3700889e3', 'username': 'treaturous-flower-5443', 'xp': 301},
    {'uid': '3de77f7d4eb4472ebe3095ed20e72af4', 'username': 'pretty-slinky-4649', 'xp': 414},
    {'uid': '2730d5d01c744c5bb893b6d12dea9b71', 'username': 'big-rocket-7318', 'xp': 233},
    {'uid': '7207613e1df34a948ce5b34b8e01e7fa', 'username': 'little-avalanche-4880', 'xp': 46},
    {'uid': 'a6c0f3296265481099a8b5606958fa44', 'username': 'terrible-flamingo-9903', 'xp': 100},
    {'uid': 'c43467d2bea1478fb8f02a5eef7012a3', 'username': 'terrible-stingray-7177', 'xp': 61},
    {'uid': '882a827f9a274804baa6b52f91af7acb', 'username': 'big-iguana-5827', 'xp': 378},
    {'uid': '2987dd56a7ba48d39d180c410d831a55', 'username': 'big-panther-2510', 'xp': 395},
    {'uid': 'fe1917ae1b4e4be5a0fd867d990b0c95', 'username': 'sprouting-brick-4543', 'xp': 122},
    {'uid': '7dc6fa02bf3e4a08916077d9553875c3', 'username': 'travelling-frying-pan-7263', 'xp': 347},
    {'uid': '1ff7dcb2856945858b4b2f71d2617862', 'username': 'smart-monk-2921', 'xp': 234},
    {'uid': 'f7750f57067a4ebcbc76d2076dffcbb2', 'username': 'terrible-monk-5873', 'xp': 294},
    {'uid': 'e776f49913f349c4a48c9023f43080ad', 'username': 'big-cowboy-1073', 'xp': 349},
    {'uid': '30821d4aaade43ee9ed3d09f15225ba1', 'username': 'sprouting-berry-1846', 'xp': 13},
    {'uid': '35c5ac6fcfbc47b6aea5726c332fcd43', 'username': 'breathing-cheese-1394', 'xp': 119},
    {'uid': 'b29b16e78c994ad49888188b9ac1550e', 'username': 'athletic-tree-3476', 'xp': 99},
    {'uid': '607967a076274ccbb51edafbb56587d5', 'username': 'long-flamingo-9224', 'xp': 242},
    {'uid': '449e883c8a82421f8e3241ddc079aa9a', 'username': 'sprouting-stone-2337', 'xp': 271},
    {'uid': '43588ce4d0554461ae635b789762ac06', 'username': 'brutal-frying-pan-5624', 'xp': 125},
    {'uid': 'c8a5750fe7204ce59c39f6d26ecb9c64', 'username': 'big-tree-5936', 'xp': 403},
    {'uid': '4ef81897aacb4b6fa974d2fcefcad6bd', 'username': 'stale-flamingo-3323', 'xp': 23},
    {'uid': 'c93379ef80144335aadee722af1a9805', 'username': 'travelling-bear-3357', 'xp': 102},
    {'uid': 'd510e44ae61240e8b2968f5112f419b7', 'username': 'smart-cowboy-3910', 'xp': 330},
    {'uid': '9ec53b4f89324464adb4fc3be3ba30dc', 'username': 'flowing-bear-4253', 'xp': 482},
    {'uid': 'cf175736ae83414b8bb78a98cf1871cd', 'username': 'little-cheese-7512', 'xp': 215},
    {'uid': '0da6fd5d2f1641858d822fe540e2a17b', 'username': 'active-stingray-5350', 'xp': 119},
    {'uid': '6e5840cf5cd44638a5dffe02d87d7f18', 'username': 'treaturous-cheese-9965', 'xp': 481},
    {'uid': '5a7f6417f78543f096b486b02800bf66', 'username': 'treaturous-prawn-3653', 'xp': 153},
    {'uid': 'b47b5ec1b259469690afd4800a3c380e', 'username': 'big-stone-1940', 'xp': 132},
    {'uid': '75f4b9b29cdc482d9b47536c8ec78c02', 'username': 'sprouting-brick-3268', 'xp': 352},
    {'uid': 'e44edf52c6204514a9c0fa3095ead30e', 'username': 'treaturous-rocket-4488', 'xp': 209},
  ];

  late ScrollController scrollController;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    

    SettingsController settings = Provider.of<SettingsController>(context, listen: false);

    Map<String,dynamic> userData = settings.userData.value as Map<String,dynamic>;
    int xp = settings.xp.value;

    Map<String,dynamic> userCard = {'uid': userData["uid"], 'username': userData["username"], 'xp': xp};
    leaderboardData.add(userCard);

    leaderboardData.sort((a, b) => b["xp"].compareTo(a["xp"]));

    for (Map<String,dynamic> leaderboardDataObject in leaderboardData) {
      int index = leaderboardData.indexOf(leaderboardDataObject);
      leaderboardDataObject["rank"] = index + 1;
    }

    int playerIndex = leaderboardData.indexOf(userCard);

    int startIndex = playerIndex-2 < 0 ? 0: playerIndex-2;
    int endIndex = playerIndex+10 > leaderboardData.length ? leaderboardData.length : playerIndex+10;




    leaderboardData = leaderboardData.sublist(startIndex,endIndex);    
  }
    
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
              return SizedBox(
                // width: MediaQuery.of(context).size.width,
                // height: MediaQuery.of(context).size.height,            
                child: SafeArea(
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
                          title: Text("Leaderboards", style: TextStyle(color: palette.text2, fontSize: 28*scalor),),
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
                                    ListView.builder(

                                      shrinkWrap: true,
                                      // physics: NeverScrollableScrollPhysics(),
                                      itemCount: leaderboardData.length,                                    
                                      itemBuilder: (BuildContext context, int index) {
                                
                                        Map<String,dynamic> userObject = leaderboardData[index];

                                        Color cardColor = palette.widget2;
                                        Color cardTextColor = palette.widgetText2;

                                        if (userObject["uid"]==userData["uid"]) {
                                          cardColor = palette.widget1;
                                          cardTextColor = palette.widgetText1;                                          
                                        }

                                        return Card(
                                          color: cardColor,
                                          child: Padding(
                                            padding: EdgeInsets.all(12.0),
                                            child: Row(
                                              children: [
                                                
                                                Expanded(
                                                  flex: 1,
                                                  child: Text(
                                                    (userObject["rank"]).toString(),
                                                    style: palette.mainAppFont(
                                                      textStyle: TextStyle(
                                                        color: cardTextColor,
                                                        fontSize: 23 * scalor
                                                      )
                                                    )
                                                  ),
                                                ),
                                                
                                                Expanded(
                                                  flex: 3,
                                                  child: Align(
                                                    alignment: Alignment.centerLeft,
                                                    child: FittedBox(
                                                      fit: BoxFit.scaleDown,
                                                      child: Text(
                                                        userObject["username"],
                                                        style: palette.mainAppFont(
                                                          textStyle: TextStyle(
                                                            color: cardTextColor,
                                                            fontSize: 18 * scalor
                                                          )
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 2,
                                                  child: Align(
                                                    alignment: Alignment.centerRight,
                                                    child: Text(
                                                      userObject["xp"].toString(),
                                                      style: palette.mainAppFont(
                                                        textStyle: TextStyle(
                                                          color: cardTextColor,
                                                          fontSize: 23 * scalor
                                                        )
                                                      )
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          )
                                        );
                                      }
                                    )
                                
                                
                                
                                
                                
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          ),
        );
      }
    );
  }
}