import 'dart:math';
import 'dart:ui';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:logger/logger.dart';
import '../../../constants.dart';
import '../../services/analytics_service.dart';
import '../../services/routes_service.dart';
import '../emergency/emergency_page.dart';
import '../widgets/premium_banner.dart';
import '../widgets/youtube_video_card.dart';
import 'controller/timeline_controller.dart';

class ArticlesPage extends StatefulHookWidget {
  const ArticlesPage({Key? key}) : super(key: key);

  @override
  State<ArticlesPage> createState() => _ArticlesPageState();
}

class _ArticlesPageState extends State<ArticlesPage> {
  ScrollController _scrollController = new ScrollController();
  bool fabIsVisible = true;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    // _scrollController.addListener(() {
    //   setState(() {
    //     fabIsVisible = _scrollController.position.userScrollDirection ==
    //         ScrollDirection.forward;
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    final timeLineController = Get.put(TimeLineController());
    final showAd = timeLineController.showAd;
    final isAdLoading = timeLineController.isAdLoading;

    final timeLineData = timeLineController.currentTimeLineData;
    final timeineIcrementCount = timeLineController.timelineIncrementCount;

    final _confettiController = ConfettiController();

    final _rewardedAd = timeLineController.rewarderdAd;

    useEffect(() {
      return () {
        timeineIcrementCount.value = 0;
      };
    });
    void _fullScreenContentCallback() {
      if (_rewardedAd.value != null) {
        _rewardedAd.value!.fullScreenContentCallback =
            FullScreenContentCallback(
          onAdShowedFullScreenContent: (ad) {
            AnalyticsService()
                .logButtonAction(buttonFunction: 'TIMELINE_AD_REWARED');
            _confettiController.play();
          },
          onAdImpression: (ad) {},
          onAdDismissedFullScreenContent: (ad) {
            ad.dispose();
          },
          onAdFailedToShowFullScreenContent: (ad, error) {
            ad.dispose();
          },
        );
      }
    }

    Future<void> _createRewardedAd() async {
      isAdLoading.value = true;
      await RewardedAd.load(
          adUnitId: dotenv.get("ADMOB_TIMELINEPAGE_REWARD_UNIT", fallback: ''),
          request: AdRequest(),
          rewardedAdLoadCallback: RewardedAdLoadCallback(
            onAdLoaded: (ad) {
              isAdLoading.value = false;
              _rewardedAd.value = ad;
              _fullScreenContentCallback();
            },
            onAdFailedToLoad: (error) {
              isAdLoading.value = false;

              setState(() {
                _rewardedAd.value = null;
              });
            },
          ));
    }

    Future<void> _showRewardedAd() async {
      if (_rewardedAd.value != null) {
        await _rewardedAd.value?.show(onUserEarnedReward: ((ad, reward) {
          timeLineController.rewardedAdLoaded();
        }));
      } else {
        Get.snackbar("Please check your internet connection.", "And try again.",
            colorText: Colors.white,
            backgroundColor: Colors.redAccent.withOpacity(0.6),
            duration: Duration(seconds: 3));
      }
    }

    useMemoized(() {
      _confettiController.duration = Duration(seconds: 5);
      timeLineController.initTimeLineData();
    });

    return Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Color(0xff0b0d0f),
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent, // <-- SEE HERE
            statusBarIconBrightness:
                Brightness.dark, //<-- For Android SEE HERE (dark icons)
            statusBarBrightness:
                Brightness.light, //<-- For iOS SEE HERE (dark icons)
          ),
          title: Obx(() => Text(
              isAdLoading.value && timeineIcrementCount > 1
                  ? 'LOADING'
                  : 'TIMELINE',
              style: Theme.of(context).textTheme.headlineMedium)),
          centerTitle: true,
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          flexibleSpace: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 7, sigmaY: 7),
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),
        ),
        floatingActionButton: fabIsVisible && !isAdLoading.value
            ? FloatingActionButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                        Radius.circular(15.0))), // isExtended: true,
                child: Icon(
                  Icons.swap_vert,
                  color: Colors.white,
                ),
                backgroundColor: Colors.green.withOpacity(0.5),
                onPressed: () {
                  _scrollController.animateTo(
                    5000,
                    curve: Curves.easeOut,
                    duration: const Duration(milliseconds: 300),
                  );
                },
              )
            : null,
        body: ShaderMask(
          shaderCallback: (Rect bounds) {
            return LinearGradient(
              colors: [Colors.white, Colors.white.withOpacity(0.02)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.93, 1],
              tileMode: TileMode.mirror,
            ).createShader(bounds);
          },
          child: SingleChildScrollView(
              controller: _scrollController,
              child: Obx(
                () => isAdLoading.value && timeineIcrementCount > 1
                    ? Container(
                        height: MediaQuery.of(context).size.height * 0.26,
                        child: Center(child: LinearProgressIndicator()))
                    : Column(
                        children: [
                          SizedBox(
                            height: kToolbarHeight + 50,
                          ),
                          ConfettiWidget(
                            confettiController: _confettiController,
                            blastDirection: -pi / 2,
                            numberOfParticles: 7,
                            emissionFrequency: 0.05,
                            blastDirectionality: BlastDirectionality.explosive,
                            colors: [
                              Color(0xffac7e3e),
                              Colors.orangeAccent,
                              Colors.white,
                              Colors.red,
                              Colors.greenAccent,
                              Color(0xff8081DB)
                            ],
                            gravity: 0.1,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: ElevatedButton(
                                  onPressed: () {
                                    AnalyticsService().logButtonTapped(
                                        buttonName: TIMELINE_DAY_MINUS);
                                    timeLineController.decrementTimeLineData();
                                  },
                                  child: Icon(
                                    Icons.arrow_back_ios,
                                    color: Color(0xffEE4D37).withOpacity(0.6),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    shape: CircleBorder(),
                                    elevation: 5,
                                    shadowColor: Colors.redAccent,
                                    padding: EdgeInsets.all(20),
                                    backgroundColor:
                                        Color(0xff0b0d0f), // <-- Button color
                                    foregroundColor:
                                        Colors.black, // <-- Splash color
                                  ),
                                ),
                              ),
                              Text(timeLineData.value!.timelineLable!,
                                  style: GoogleFonts.openSans(
                                      fontSize: 18,
                                      color: Color(0xffEE4D37).withOpacity(0.6),
                                      letterSpacing: 5)),
                              Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: ElevatedButton(
                                  onPressed: () {
                                    AnalyticsService().logButtonTapped(
                                        buttonName: TIMELINE_DAY_PLUS);
                                    int maxLength = timeLineController
                                        .incrementTimeLineData();
                                    if (!isAdLoading.value &&
                                        _rewardedAd.value == null &&
                                        (maxLength -
                                                timeineIcrementCount.value) >=
                                            2) {
                                      _createRewardedAd();
                                    }
                                  },
                                  child: Icon(
                                    Icons.arrow_forward_ios,
                                    color: Color(0xffEE4D37).withOpacity(0.6),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    shape: CircleBorder(),
                                    elevation: 5,
                                    shadowColor: Color(0xffEE4D37),
                                    padding: EdgeInsets.all(20),
                                    backgroundColor:
                                        Color(0xff0b0d0f), // <-- Button color
                                    foregroundColor:
                                        Colors.black, // <-- Splash color
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    if (timeineIcrementCount >= 2 &&
                                        showAd.value) {
                                      AnalyticsService().logButtonTapped(
                                          buttonName: TIMELINE_SHOW_AD);
                                      if (isAdLoading.value &&
                                          _rewardedAd.value == null) {
                                        Get.snackbar("Please hold on!",
                                            "We are loading an Ad.",
                                            colorText: Colors.white,
                                            backgroundColor: Colors.redAccent
                                                .withOpacity(0.6),
                                            duration: Duration(seconds: 5));

                                        //please wait ad is loading
                                      } else if (!isAdLoading.value &&
                                          _rewardedAd.value == null) {
                                        timeLineController.rewardedAdLoaded();
                                      } else if (_rewardedAd.value != null) {
                                        _showRewardedAd();
                                      }
                                    } else {
                                      return;
                                    }
                                  },
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      for (int i = 0;
                                          i <
                                              timeLineData.value!.timelineSet!
                                                  .values.length;
                                          i++)
                                        TimelineInfoCard(
                                          cardInfoList: timeLineData
                                              .value!.timelineSet!.values
                                              .toList()[i],
                                          showAd: (timeineIcrementCount >= 2 &&
                                                  showAd.value)
                                              ? true
                                              : false,
                                          cardColor:
                                              colorsList[i % colorsList.length],
                                        ),
                                    ],
                                  ),
                                ),

                                Visibility(
                                  visible: timeLineData.value?.youtube !=
                                          null &&
                                      timeLineData.value!.youtube!.length != 0,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Divider(
                                        color: Colors.red.withOpacity(0.5),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 16, bottom: 20),
                                        child: Text('FEED',
                                            style: GoogleFonts.openSans(
                                                fontSize: 15,
                                                color: Color(0xffEE4D37)
                                                    .withOpacity(0.5),
                                                letterSpacing: 2)),
                                      ),
                                      Visibility(
                                        visible: false,
                                        child: GestureDetector(
                                            onTap: () {
                                              AnalyticsService().logButtonTapped(
                                                  buttonName:
                                                      NEEP_PREMIUM_BANNER_TIMELINE_PAGE);
                                              Get.toNamed(
                                                  RoutesClass.subscriptionPage);
                                            },
                                            child: Hero(
                                                tag: 'subscription_banner',
                                                child: FocusDetector(
                                                    onVisibilityGained: () {
                                                      AnalyticsService()
                                                          .logCardVisible(
                                                              cardName:
                                                                  TIMELINE_PREMIUM_CARD);
                                                    },
                                                    onVisibilityLost: () {
                                                      AnalyticsService()
                                                          .logCardInvisible(
                                                              cardName:
                                                                  TIMELINE_PREMIUM_CARD);
                                                    },
                                                    child: PremiumBanner()))),
                                      ),
                                      SizedBox(
                                        height: 12,
                                      ),
                                      for (int i = 0;
                                          i <
                                              timeLineData
                                                  .value!.youtube!.length;
                                          i++)
                                        YouTubeVideoCard(
                                          author: timeLineData.value!
                                                  .youtube![i].videoAuthor ??
                                              '',
                                          title: timeLineData
                                              .value!.youtube![i].videoTitle!,
                                          videoID: timeLineData
                                              .value!.youtube![i].videoId!,
                                        )
                                    ],
                                  ),
                                )
                                // ListView.builder(
                                //   shrinkWrap: true,
                                //   physics: NeverScrollableScrollPhysics(),
                                //   itemCount: 3,
                                //   itemBuilder: (context, i) {
                                //     return Padding(
                                //       padding: const EdgeInsets.symmetric(vertical: 10),
                                //       child: Column(
                                //         crossAxisAlignment: CrossAxisAlignment.start,
                                //         mainAxisSize: MainAxisSize.min,
                                //         children: [
                                //           SizedBox(
                                //             height: 200,
                                //             width: double.infinity,
                                //             child: CachedNetworkImage(
                                //                 fit: BoxFit.fitWidth,
                                //                 imageUrl:
                                //                     "https://img.youtube.com/vi/49Y_ZjvKado/0.jpg"),
                                //           ),
                                //           Text(
                                //             "How I made a million dollors by the age of 23 ?",
                                //             style: GoogleFonts.poppins(
                                //               fontSize: 15,
                                //               fontWeight: FontWeight.normal,
                                //               color: Colors.white.withOpacity(0.7),
                                //             ),
                                //           ),
                                //           Text("Utkarsh Shendge",
                                //               style: GoogleFonts.openSans(
                                //                   fontSize: 12,
                                //                   fontWeight: FontWeight.w400))
                                //         ],
                                //       ),
                                //     );

                                //   },
                                // )
                              ],
                            ),
                          )
                        ],
                      ),
              )),
        ));
  }
}

class TimelineInfoCard extends StatelessWidget {
  const TimelineInfoCard(
      {Key? key,
      required this.cardInfoList,
      required this.cardColor,
      required this.showAd})
      : super(key: key);
  final List<String> cardInfoList;
  final Color cardColor;
  final bool showAd;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: GestureDetector(
        child: ContainerCard(
          backgroundColor: cardColor,
          parentColumnCrossAxisAlignment: CrossAxisAlignment.start,
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (int i = 0; i < cardInfoList.length; i++)
                    ImageFiltered(
                      imageFilter: showAd
                          ? ImageFilter.blur(sigmaX: 6, sigmaY: 6)
                          : ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                      child: Padding(
                        padding: EdgeInsets.all(12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Icon(
                            //   Icons.star,
                            //   size: 12,
                            //   color: Colors.red.withOpacity(0.3),
                            // ),
                            // SizedBox(
                            //   width: 8,
                            // ),
                            Expanded(
                              child: Text(
                                cardInfoList[i].replaceAll('\n', '0'),
                                style: GoogleFonts.poppins(
                                    fontSize: 18, color: Colors.white70),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
              showAd
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(
                          child: Text("TAP AND WATCH AD TO UNLOCK ALL 🙌",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.montserrat(
                                  fontSize: 20,
                                  letterSpacing: 3,
                                  color: Colors.white70,
                                  fontWeight: FontWeight.bold)),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Icon(
                          Icons.lock,
                          size: 60,
                          color: Colors.white60,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text("TAP TAP TAP",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.montserrat(
                                fontSize: 16,
                                color: Colors.white60,
                                letterSpacing: 4,
                                fontWeight: FontWeight.bold))
                      ],
                    )
                  : IgnorePointer(child: SizedBox()),
            ],
          ),
        ),
      ),
    );
    ;
  }
}
