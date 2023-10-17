import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lottie/lottie.dart';
import 'package:neep/app/services/routes_service.dart';
import 'package:neep/app/ui/journal/journal_info_page.dart';
import '../../../constants.dart';
import '../../services/analytics_service.dart';
import '../ads/controller/ads_controller.dart';
import '../emergency/emergency_page.dart';
import '../widgets/image_circular_loader.dart';
import 'controller/journal_controller.dart';

class JournalHome extends HookWidget {
  const JournalHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final journalController = Get.put(JournalController());
    final journalList = journalController.journalList;
    final journalBGIMage = journalController.journalHomeGif;
    final adsController = Get.put(AdsController());

    late BannerAd journalBannerAd = adsController.journalPageBannerAd;
    final isAdLoaded = adsController.isJournalPageBannerAdLoaded;

    useMemoized(() {
      adsController.initJournalPageBannerAd();

      journalController.fillJournalList();
    });

    return Scaffold(
        extendBodyBehindAppBar: true,
        floatingActionButton: FloatingActionButton(
          shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.all(Radius.circular(15.0))), // isExtended: true,
          child: Icon(Icons.add),
          backgroundColor: Color(0xffEE4D37).withOpacity(0.8),
          onPressed: () {
            AnalyticsService().logButtonTapped(buttonName: JOURNAL_ADD_FAB);
            Get.toNamed(RoutesClass.writeJournal);
          },
        ),
        backgroundColor: Color(0xff0b0d0f),
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent, // <-- SEE HERE
            statusBarIconBrightness:
                Brightness.dark, //<-- For Android SEE HERE (dark icons)
            statusBarBrightness:
                Brightness.light, //<-- For iOS SEE HERE (dark icons)
          ),
          title: Text('JOURNAL',
              style: Theme.of(context).textTheme.headlineMedium),
          centerTitle: true,
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
        ),
        body: Obx(
          () => CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                snap: false,
                pinned: true,
                floating: false,
                automaticallyImplyLeading: false,
                flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    title: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text('',
                          style: Theme.of(context).textTheme.headlineMedium),
                    ), //Text
                    background: CachedNetworkImage(
                      imageUrl: journalBGIMage.value,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => ImagePlaceHolder(),
                    ) //Images.network
                    ), //FlexibleSpaceBar
                expandedHeight: 230,
                elevation: 5,
                backgroundColor: Color(0xff0b0d0f),
                systemOverlayStyle: SystemUiOverlayStyle(
                  statusBarColor: Colors.transparent, // <-- SEE HERE
                  statusBarIconBrightness:
                      Brightness.dark, //<-- For Android SEE HERE (dark icons)
                  statusBarBrightness:
                      Brightness.light, //<-- For iOS SEE HERE (dark icons)
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 20,
                ),
              ),
              SliverToBoxAdapter(
                child: Obx(
                  () => SizedBox(
                    child: isAdLoaded.value && journalList.length > 3
                        ? Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Container(
                              height: journalBannerAd.size.height.toDouble(),
                              width: journalBannerAd.size.width.toDouble(),
                              child: AdWidget(ad: journalBannerAd),
                            ),
                          )
                        : SizedBox(),
                  ),
                ),
              ),

              journalList.isEmpty
                  ? SliverToBoxAdapter(
                      child: EmptyJournalWidget(),
                    )
                  : SliverList(
                      delegate: SliverChildBuilderDelegate(
                          (context, index) => Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 20),
                                child: GestureDetector(
                                  onTap: () {
                                    AnalyticsService().logButtonTapped(
                                        buttonName: JOURAL_TILE);
                                    Get.to(() => JournalInfoPage(
                                        journalDetail: journalList[index],
                                        bgColor: colorsList[
                                            index % colorsList.length]));
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    decoration: buttonTileDecoration(
                                        backgroundColor: colorsList[
                                            index % colorsList.length]),
                                    height: 200,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12, horizontal: 12),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                "DAY ",
                                                style: GoogleFonts.openSans(
                                                    fontSize: 12,
                                                    color: Colors.white,
                                                    letterSpacing: 5),
                                              ),
                                              Spacer(),
                                              Visibility(
                                                visible: true,
                                                child: Container(
                                                  decoration:
                                                      containerNeumorphicDecoration(),
                                                  child: Padding(
                                                    padding: EdgeInsets.all(5),
                                                    child: Text(
                                                      journalList[index].tag !=
                                                              'journal'
                                                          ? journalList[index]
                                                              .tag
                                                              .toUpperCase()
                                                          : getJournalAppBarTitle(
                                                                  date: journalList[
                                                                          index]
                                                                      .journalTimeStamp)
                                                              .toUpperCase(),
                                                      style: GoogleFonts.openSans(
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: journalList[
                                                                          index]
                                                                      .tag ==
                                                                  'journal'
                                                              ? Colors.white
                                                                  .withOpacity(
                                                                      0.7)
                                                              : Colors.green
                                                                  .withOpacity(
                                                                      0.7),
                                                          letterSpacing: 2),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Hero(
                                                tag: journalList[index].key,
                                                child: Material(
                                                  type: MaterialType
                                                      .transparency, // likely needed

                                                  child: Text(
                                                    journalList[index]
                                                        .journalDay
                                                        .toString(),
                                                    style: GoogleFonts.openSans(
                                                        fontSize: 50,
                                                        color: Colors.white
                                                            .withOpacity(0.6),
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                              Visibility(
                                                visible: index == 0,
                                                child: Lottie.network(
                                                    'https://assets9.lottiefiles.com/packages/lf20_jR229r.json',
                                                    height: 50),
                                              ),
                                              Spacer(),
                                              Icon(
                                                Icons.navigate_next,
                                                color: Colors.white,
                                                size: 28,
                                              )
                                            ],
                                          ),
                                          Spacer(),
                                          Text(
                                            journalList[index].journalText,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            style: GoogleFonts.poppins(
                                              fontSize: 16,
                                              color:
                                                  Colors.white.withOpacity(0.4),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 16,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          childCount: journalList.length)),

              // SliverToBoxAdapter(
              //   child: SingleChildScrollView(
              //     child: journalList.length == 0
              //         ? EmptyJournalWidget()
              //         : Container(
              //             color: Colors.yellow,
              //             child: ListView.builder(
              //                 physics: NeverScrollableScrollPhysics(),
              //                 shrinkWrap: true,
              //                 itemCount: journalList.length,
              //                 itemBuilder: (BuildContext context, int index) {
              //                   return Container(
              //                     color: Colors.green,
              //                     child: Padding(
              //                       padding: const EdgeInsets.symmetric(
              //                           vertical: 12, horizontal: 12),
              //                       child: Container(
              //                         width: double.infinity,
              //                         decoration:
              //                             containerNeumorphicDecoration(),
              //                         height: 200,
              //                         child: Padding(
              //                           padding: const EdgeInsets.symmetric(
              //                               vertical: 12, horizontal: 12),
              //                           child: Column(
              //                             crossAxisAlignment:
              //                                 CrossAxisAlignment.start,
              //                             children: [
              //                               Row(
              //                                 children: [
              //                                   Text(
              //                                     "DAY ",
              //                                     style: GoogleFonts.openSans(
              //                                         fontSize: 12,
              //                                         color: Color(0xffEE4D37)
              //                                             .withOpacity(0.8),
              //                                         letterSpacing: 5),
              //                                   ),
              //                                   Spacer(),
              //                                   Visibility(
              //                                     visible:
              //                                         journalList[index].tag !=
              //                                             JOURNAL_TAGS.journal,
              //                                     child: Container(
              //                                       decoration:
              //                                           containerNeumorphicDecoration(),
              //                                       child: Padding(
              //                                         padding:
              //                                             EdgeInsets.all(5),
              //                                         child: Text(
              //                                           "EMERGENCY",
              //                                           style: GoogleFonts
              //                                               .openSans(
              //                                                   fontSize: 8,
              //                                                   fontWeight:
              //                                                       FontWeight
              //                                                           .w500,
              //                                                   color: Colors
              //                                                       .green
              //                                                       .withOpacity(
              //                                                           0.7),
              //                                                   letterSpacing:
              //                                                       2),
              //                                         ),
              //                                       ),
              //                                     ),
              //                                   ),
              //                                 ],
              //                               ),
              //                               Row(
              //                                 crossAxisAlignment:
              //                                     CrossAxisAlignment.center,
              //                                 children: [
              //                                   Text(
              //                                     journalList[index]
              //                                         .journalDay
              //                                         .toString(),
              //                                     style: GoogleFonts.openSans(
              //                                         fontSize: 50,
              //                                         color: Color(0xffF3F1EB),
              //                                         fontWeight:
              //                                             FontWeight.bold),
              //                                   ),
              //                                   Visibility(
              //                                     visible: index == 0,
              //                                     child: Lottie.network(
              //                                         'https://assets1.lottiefiles.com/packages/lf20_VgPRtS.json',
              //                                         height: 28),
              //                                   ),
              //                                   Spacer(),
              //                                   Icon(
              //                                     Icons.navigate_next,
              //                                     color: Color(0xffEE4D37)
              //                                         .withOpacity(0.8),
              //                                     size: 28,
              //                                   )
              //                                 ],
              //                               ),
              //                               Spacer(),
              //                               Text(
              //                                 journalList[index].journalText,
              //                                 overflow: TextOverflow.ellipsis,
              //                                 maxLines: 2,
              //                                 style: GoogleFonts.poppins(
              //                                   fontSize: 16,
              //                                   color: Colors.white
              //                                       .withOpacity(0.4),
              //                                 ),
              //                               ),
              //                               SizedBox(
              //                                 height: 16,
              //                               ),
              //                             ],
              //                           ),
              //                         ),
              //                       ),
              //                     ),
              //                   );
              //                 }),
              //           ),

              //   ),
              // ),

              // SliverToBoxAdapter(
              //   child: Padding(
              //     padding:
              //         EdgeInsets.symmetric(horizontal: 12, vertical: 20),
              //     child: Text(
              //       "REFLECTIONS",
              //       style: GoogleFonts.openSans(
              //           fontSize: 12,
              //           color: Color(0xffEE4D37).withOpacity(0.4),
              //           letterSpacing: 5),
              //     ),
              //   ),
              // ),
              // journalList.length != 0
              //     ? SliverList(
              //         delegate: SliverChildBuilderDelegate(
              //           (context, index) => Padding(
              //             padding: const EdgeInsets.symmetric(
              //                 vertical: 8, horizontal: 12),
              //             child: Container(
              //               width: double.infinity,
              //               decoration: containerNeumorphicDecoration(),
              //               height: 200,
              //               child: Padding(
              //                 padding: const EdgeInsets.symmetric(
              //                     vertical: 12, horizontal: 12),
              //                 child: Column(
              //                   crossAxisAlignment:
              //                       CrossAxisAlignment.start,
              //                   children: [
              //                     Row(
              //                       children: [
              //                         Text(
              //                           "DAY ",
              //                           style: GoogleFonts.openSans(
              //                               fontSize: 12,
              //                               color: Color(0xffEE4D37)
              //                                   .withOpacity(0.8),
              //                               letterSpacing: 5),
              //                         ),
              //                         Spacer(),
              //                         Visibility(
              //                           child: Container(
              //                             decoration:
              //                                 containerNeumorphicDecoration(),
              //                             child: Padding(
              //                               padding: EdgeInsets.all(5),
              //                               child: Text(
              //                                 "EMERGENCY",
              //                                 style: GoogleFonts.openSans(
              //                                     fontSize: 8,
              //                                     fontWeight:
              //                                         FontWeight.w500,
              //                                     color: Colors.green
              //                                         .withOpacity(0.7),
              //                                     letterSpacing: 2),
              //                               ),
              //                             ),
              //                           ),
              //                         ),
              //                       ],
              //                     ),
              //                     Row(
              //                       crossAxisAlignment:
              //                           CrossAxisAlignment.center,
              //                       children: [
              //                         Text(
              //                           journalDummy[index].day.toString(),
              //                           style: GoogleFonts.openSans(
              //                               fontSize: 50,
              //                               color: Color(0xffF3F1EB),
              //                               fontWeight: FontWeight.bold),
              //                         ),
              //                         Visibility(
              //                           visible:
              //                               journalDummy[index].day == 43,
              //                           child: Lottie.network(
              //                               'https://assets1.lottiefiles.com/packages/lf20_VgPRtS.json',
              //                               height: 28),
              //                         ),
              //                         Spacer(),
              //                         Icon(
              //                           Icons.navigate_next,
              //                           color: Color(0xffEE4D37)
              //                               .withOpacity(0.8),
              //                           size: 28,
              //                         )
              //                       ],
              //                     ),
              //                     Spacer(),
              //                     Text(
              //                       journalDummy[index].title,
              //                       overflow: TextOverflow.ellipsis,
              //                       maxLines: 2,
              //                       style: GoogleFonts.poppins(
              //                         fontSize: 16,
              //                         color: Colors.white.withOpacity(0.4),
              //                       ),
              //                     ),
              //                     SizedBox(
              //                       height: 16,
              //                     ),
              //                   ],
              //                 ),
              //               ),
              //             ),
              //           ), //ListTile
              //           childCount: journalDummy.length,
              //         ), //SliverChildBuildDelegate
              //       )
              //     : EmptyJournalWidget() //SliverList
            ], //<Widget>[]
          ),
        ) //C Container(

        );
  }
}

class JournalModel {
  final int day;
  final String title;

  JournalModel({required this.day, required this.title});
}

List<JournalModel> journalDummy = [
  JournalModel(day: 43, title: 'Hello how are you all?'),
  JournalModel(
      day: 03, title: 'I am feeling great tbh. Had a great day today :'),
  JournalModel(
      day: 02,
      title: 'Today was a lame day. Eren. Chutiya Eren. Why mikasa man!'),
  JournalModel(day: 01, title: 'I am feeling great tbh. Had a great day today ')
];

class EmptyJournalWidget extends StatelessWidget {
  const EmptyJournalWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              '''“Journal writing, when it becomes a ritual for transformation, is not only life-changing but life-expanding.” – Jen Williamson''',
              style: GoogleFonts.poppins(
                fontSize: 15,
                color: Colors.white.withOpacity(0.4),
              ),
            ),
          ),
          SizedBox(
            height: 200,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Tap the "+" button',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Color(0xffEE4D37).withOpacity(0.8),
                letterSpacing: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
