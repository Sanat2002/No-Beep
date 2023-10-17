import 'dart:math';
import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:neep/app/ui/quotes/controller/quotes_controller.dart';
import 'package:vibration/vibration.dart';

import '../../services/analytics_service.dart';

class QuotesPage extends StatefulHookWidget {
  const QuotesPage({required this.showRelapseQuotes});
  final bool showRelapseQuotes;

  @override
  State<QuotesPage> createState() => _QuotesPageState();
}

class _QuotesPageState extends State<QuotesPage> {
  @override
  Widget build(BuildContext context) {
    final quotesController = Get.put(QuotesController());
    final isAdLoading = quotesController.isLoading;
    final quotesList = widget.showRelapseQuotes
        ? quotesController.relapseQuotesDisplayList
        : quotesController.quotesDisplayList;
    final _confettiController = ConfettiController();

    // useEffect(() {
    //   return () {
    //     _confettiController.dispose();
    //   };
    // });

    RewardedAd? _rewardedAd;

    void _fullScreenContentCallback() {
      if (_rewardedAd != null) {
        _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
          onAdShowedFullScreenContent: (ad) {
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

    void _createRewardedAd() {
      isAdLoading.value = true;
      RewardedAd.load(
          adUnitId: dotenv.get("ADMOB_REWARD_UNIT", fallback: ''),
          request: AdRequest(),
          rewardedAdLoadCallback: RewardedAdLoadCallback(
            onAdLoaded: (ad) {
              quotesController.rewardedAdLoaded();

              isAdLoading.value = false;
              _rewardedAd = ad;
              _fullScreenContentCallback();
            },
            onAdFailedToLoad: (error) {
              isAdLoading.value = false;

              setState(() {
                _rewardedAd = null;
              });
            },
          ));
    }

    void _showRewardedAd() {
      if (_rewardedAd == null) {
        Get.snackbar("Couldn’t load Ad.",
            "Please check your internet connection and reopen the app.",
            colorText: Colors.white,
            backgroundColor: Colors.redAccent.withOpacity(0.6),
            duration: Duration(seconds: 6));
      }
      _rewardedAd?.show(onUserEarnedReward: ((ad, reward) {
        AnalyticsService()
            .logButtonAction(buttonFunction: "QUOTES_REWARD_GRANTED");

        quotesController.unlockNextQuotes();
      }));
    }

    useMemoized(() {
      if (widget.showRelapseQuotes) {
        quotesController.fillRelapseQuotesDisplayList();
      } else {
        quotesController.fillquotesDisplayList();
      }
      _confettiController.duration = Duration(seconds: 6);

      // quotesController.unlockNextQuotes();

      // _createRewardedAd();
    });

    final _controller = PageController();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent, // <-- SEE HERE
          statusBarIconBrightness:
              Brightness.dark, //<-- For Android SEE HERE (dark icons)
          statusBarBrightness:
              Brightness.light, //<-- For iOS SEE HERE (dark icons)
        ),
        title: Text('<-- SWIPE',
            style: Theme.of(context).textTheme.headlineMedium),
        leading: widget.showRelapseQuotes
            ? BouncingWidget(
                onPressed: () {
                  Get.back(result: false);
                },
                child: Icon(Icons.arrow_back))
            : null,
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: [
          Center(
            child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                      // Colors.black,
                      // Colors.black

                      Color(0xff0b0d0f),
                      Color(0xff0b0d0f),
                    ])),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: kToolbarHeight + 28,
                    ),

                    // SizedBox(
                    //   height: MediaQuery.of(context).size.height * 0.7,
                    //   child: PageView(
                    //     controller: _controller,
                    //     clipBehavior: Clip.none,
                    //     children: [
                    //       QuotesCard(),
                    //       QuotesCard(),
                    //       QuotesCard(),
                    //       QuotesCard(),
                    //       QuotesCard()
                    //     ],
                    //   ),
                    // ),

                    Obx(() => SizedBox(
                          height: MediaQuery.of(context).size.height * 0.8,
                          child: PageView.builder(
                              controller: _controller,
                              clipBehavior: Clip.none,
                              itemCount: quotesList.length,
                              padEnds: true,
                              onPageChanged: (value) {
                                if (value == 1 &&
                                    !isAdLoading.value &&
                                    !quotesController.isAdShown) {
                                  _createRewardedAd();
                                  Vibration.vibrate(duration: 40);
                                }

                                AnalyticsService().logCardVisible(
                                    cardName: 'quotes: ${value}');
                              },
                              itemBuilder: (context, index) {
                                return quotesList[index].quoteItemType ==
                                        "user_quote"
                                    ? QuotesCardCustomQuote()
                                    : GestureDetector(
                                        onTap: () {
                                          if (quotesList[index].quoteItemType ==
                                              'ad') {
                                            if (isAdLoading.value &&
                                                _rewardedAd == null) {
                                              Get.snackbar("Please hold on!",
                                                  "We are loading an Ad.",
                                                  colorText: Colors.white,
                                                  backgroundColor: Colors
                                                      .redAccent
                                                      .withOpacity(0.6),
                                                  duration:
                                                      Duration(seconds: 5));
                                              //please wait ad is loading
                                            } else if (!isAdLoading.value &&
                                                _rewardedAd == null) {
                                              quotesController
                                                  .unlockNextQuotes();
                                            } else if (_rewardedAd != null) {
                                              _showRewardedAd();
                                            }

                                            AnalyticsService().logButtonTapped(
                                                buttonName: QUOTES_AD_TAP);
                                          } else {
                                            AnalyticsService().logButtonTapped(
                                                buttonName: QUOTES_TAP);
                                            if (index < quotesList.length - 1) {
                                              _controller.animateToPage(
                                                  index + 1,
                                                  curve: Curves.easeIn,
                                                  duration: Duration(
                                                      milliseconds: 500));
                                            }
                                          }
                                        },
                                        child: QuotesCard(
                                          ShowSwipe: index == 0,
                                          backgroundImageUrl:
                                              quotesList[index].imageUrl,
                                          author: quotesList[index].author,
                                          quote: quotesList[index].quote,
                                        ),
                                      );
                              }),
                        )),

                    // Obx(() => SmoothPageIndicator(
                    //       controller: _controller,
                    //       count: isLoading.value ? 2 : quotesList.length,
                    //       onDotClicked: (index) {},
                    //       effect: JumpingDotEffect(
                    //         dotColor: Colors.black,
                    //         activeDotColor: Color(0xffEE4D37).withOpacity(0.3),
                    //         jumpScale: 2,
                    //       ),
                    //     ))

                    // )
                  ],
                )),
          ),
          Center(
            child: Container(
              child: ConfettiWidget(
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
            ),
          ),
        ],
      ),
    );
  }
}

class QuotesCard extends StatelessWidget {
  const QuotesCard(
      {Key? key,
      required this.backgroundImageUrl,
      required this.quote,
      required this.author,
      required this.ShowSwipe})
      : super(key: key);
  final String backgroundImageUrl;
  final String quote;
  final String author;
  final bool ShowSwipe;
  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      margin: EdgeInsets.symmetric(horizontal: 16),

      decoration: BoxDecoration(
        color: Color(0xff0b0d0f),
        borderRadius: BorderRadius.all(Radius.circular(10)),
        image: DecorationImage(
            fit: BoxFit.cover,
            filterQuality: FilterQuality.low,
            image: CachedNetworkImageProvider(
              backgroundImageUrl,
            )),
        boxShadow: [
          BoxShadow(
              color: Colors.black,
              offset: Offset(4, 4),
              blurRadius: 10,
              spreadRadius: 1),
          BoxShadow(
              color: Colors.white.withOpacity(0.1),
              offset: Offset(-2, -2),
              blurRadius: 4,
              spreadRadius: 0.3)
        ],
      ),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Visibility(
                child: Padding(
                  padding: const EdgeInsets.only(right: 4, bottom: 60),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        LottieBuilder.asset(
                          'assets/swipe.json',
                          width: 80,
                          height: 80,
                        ),
                      ],
                    ),
                  ),
                ),
                visible: ShowSwipe,
              ),
              Padding(
                  padding: const EdgeInsets.all(16),
                  child: Stack(
                    children: <Widget>[
                      // Stroked text as border.
                      Text(
                        quote,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                          foreground: Paint()
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = 3
                            ..color = Colors.black54,
                        ),
                      ),
                      Text(
                        quote,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          color: Colors.white70,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  )),
              SizedBox(
                height: 50,
              ),
              SizedBox(
                width: 150,
                child: Divider(
                  color: Color(0xffEE4D37).withOpacity(0.5),
                  thickness: 3,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                author,
                style: GoogleFonts.poppins(
                  color: Colors.white30,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ),
      // child: Image.asset(
      //   "assets/batman.jpeg",
      //   fit: BoxFit.cover,
      // ),
    );
  }
}

class QuotesCardCustomQuote extends HookWidget {
  const QuotesCardCustomQuote({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FocusNode focusNode = FocusNode();
    final quotesController = Get.put(QuotesController());
    final quotesModel = quotesController.customQuote;
    final _confettiController = ConfettiController();
    useEffect(() {
      return () {
        _confettiController.dispose();
      };
    });

    useMemoized(() {
      _confettiController.duration = Duration(seconds: 5);

      quotesController.initCustomQuote();
    });

    return Stack(
      children: [
        Obx(() => Container(
              clipBehavior: Clip.hardEdge,
              margin: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Color(0xff0b0d0f),
                borderRadius: BorderRadius.all(Radius.circular(10)),
                image: DecorationImage(
                    fit: BoxFit.cover,
                    filterQuality: FilterQuality.low,
                    image: AssetImage(
                      quotesModel.value.imageUrl,
                    )),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black,
                      offset: Offset(4, 4),
                      blurRadius: 15,
                      spreadRadius: 1),
                  BoxShadow(
                      color: Colors.white.withOpacity(0.1),
                      offset: Offset(-4, -4),
                      blurRadius: 15,
                      spreadRadius: 1)
                ],
              ),
              child: Center(
                child: SingleChildScrollView(
                  child: Container(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ConfettiWidget(
                        confettiController: _confettiController,
                        blastDirection: pi / 2,
                        colors: [
                          Color(0xffEE4D37),
                          Colors.redAccent,
                          Colors.white,
                          Colors.greenAccent
                        ],
                        gravity: 0.01,
                      ),
                      Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 24),
                          child: Stack(
                            children: <Widget>[
                              // Stroked text as border.
                              Text(
                                quotesModel.value.quote,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w500,
                                  foreground: Paint()
                                    ..style = PaintingStyle.stroke
                                    ..strokeWidth = 3
                                    ..color = Colors.black54,
                                ),
                              ),
                              Text(
                                quotesModel.value.quote,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  fontSize: 24,
                                  color: Colors.white70,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          )),
                      SizedBox(
                        height: 50,
                      ),
                      SizedBox(
                        width: 150,
                        child: Divider(
                          color: Color(0xffEE4D37).withOpacity(0.5),
                          thickness: 3,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        quotesModel.value.author,
                        style: GoogleFonts.poppins(
                          color: Colors.white30,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  )),
                ),
              ),
            )),
        Positioned(
          top: 0,
          right: 40,
          child: BouncingWidget(
            onPressed: () {
              AnalyticsService()
                  .logButtonTapped(buttonName: CUSTOM_QUOTE_EDIT_TAP);
              showMaterialModalBottomSheet(
                bounce: true,
                context: context,
                builder: (context) => SingleChildScrollView(
                  controller: ModalScrollController.of(context),
                  child: Container(
                    height: MediaQuery.of(context).size.height / 1.5,
                    color: Color(0xff0b0d0f),
                    child: Column(
                      children: [
                        Text("Add your Quote 🔥"),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 16, right: 12, top: 12),
                          child: TextField(
                            controller:
                                quotesController.customQuoteTextController,
                            keyboardType: TextInputType.text,
                            autofocus: true,
                            focusNode: focusNode,
                            style: GoogleFonts.montserrat(
                                color: Color(0xffEE4D37).withOpacity(0.5)),
                            decoration: InputDecoration(
                                hintText: 'Your Quote',
                                counterStyle: Theme.of(context)
                                    .inputDecorationTheme
                                    .hintStyle
                                    ?.copyWith(fontSize: 12),
                                border: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xffEE4D37).withOpacity(0.5),
                                  ),
                                ),
                                hintStyle: Theme.of(context)
                                    .inputDecorationTheme
                                    .hintStyle),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: BouncingWidget(
                            onPressed: () {
                              AnalyticsService().logButtonTapped(
                                  buttonName: CUSTOM_QUOTE_EDIT_SUCESS);
                              _confettiController.play();

                              quotesController.setCustomQuote();

                              Navigator.of(context).pop();
                            },
                            duration: Duration(milliseconds: 50),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Color(0xffEE4D37).withOpacity(0.5)),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 8),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "Done 👍",
                                      style: GoogleFonts.poppins(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
            duration: Duration(milliseconds: 100),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: 40,
                  child: Column(
                    children: [
                      Lottie.asset('assets/edit_animation.json', reverse: true),
                      Text(
                        "edit",
                        style: TextStyle(fontSize: 12, color: Colors.black),
                      )
                    ],
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(8),
                        bottomRight: Radius.circular(8)),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black,
                          offset: Offset(4, 4),
                          blurRadius: 15,
                          spreadRadius: 1),
                      // BoxShadow(
                      //     color: Colors.black.withOpacity(0.6),
                      //     offset: Offset(-4, -4),
                      //     blurRadius: 15,
                      //     spreadRadius: 1)
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
