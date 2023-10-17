import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:neep/app/services/notification_service.dart';
import 'package:neep/app/streak_controller.dart';
import 'package:neep/app/ui/home/home_badge.dart';
import 'package:vibration/vibration.dart';
import '../../../constants.dart';
import '../../services/analytics_service.dart';
import '../../services/routes_service.dart';
import '../ads/controller/ads_controller.dart';
import '../bottom_nav_bar/bottom_nav_bar_controller.dart';
import '../emergency/emergency_controller.dart';
import '../emergency/emergency_page.dart';
import '../quotes/quotes_page.dart';
import '../widgets/home_counter_widget.dart';
import '../widgets/no_beep_title.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bottomNavController = Get.put(BottomNavController());
    final adsController = Get.put(AdsController());
    final streakController = Get.put(StreakController());

    BannerAd homePageBannerAd = adsController.homePageBannerAd;
    final isAdLoaded = adsController.isHomePageBannerAdLoaded;

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
        title: NoBeepTitle(),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Color(0xff0b0d0f),
        automaticallyImplyLeading: false,
      ),
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
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: kToolbarHeight + 50,
                ),

                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  child: HomeCounterWidgetPrimary(),
                ),
                SizedBox(
                  height: 68,
                ),
                GestureDetector(
                  onTap: () async {
                    // LocalNotificationService().showScheduledNotification(
                    //     id: 33,
                    //     title: "BEEP!BEEP! 🔥",
                    //     payload: 'timeline',
                    //     body: "Your doing great!! Tap to see your progress.📈",
                    //     scheduleDate: DateTime.now().add(Duration(seconds: 6)));

                    AnalyticsService().logButtonTapped(buttonName: RESET_HOME);
                    final isReset = await Get.toNamed(RoutesClass.resetPage);
                    if (isReset != null && isReset) {
                      Future.delayed(Duration(milliseconds: 1400), () {
                        Get.to(QuotesPage(
                          showRelapseQuotes: true,
                        ));
                      });

                      // showPostResetBottomSheet(
                      //     context: context, streakController: streakController);
                    }
                  },
                  child: Container(
                    width: 200,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Color(0xff8081DB).withOpacity(0.5),
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(8),
                          bottomRight: Radius.circular(8)),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black,
                            offset: Offset(4, 4),
                            blurRadius: 10,
                            spreadRadius: 1),
                        BoxShadow(
                            color: Colors.white.withOpacity(0.1),
                            offset: Offset(-4, -4),
                            blurRadius: 5,
                            spreadRadius: 1)
                      ],
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "RESET",
                            style: GoogleFonts.montserrat(
                                color: Colors.white, letterSpacing: 2),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Icon(
                            Icons.restart_alt,
                            color: Colors.white70,
                          )
                        ],
                      ),
                    ),
                  ),
                ),

                SizedBox(
                  height: 32,
                ),

                // GestureDetector(
                //     onTap: () {
                //       AnalyticsService()
                //           .logButtonTapped(buttonName: SCROLL_BUTTON_HOME);

                //       _scrollController.animateTo(
                //         400,
                //         curve: Curves.easeOut,
                //         duration: const Duration(milliseconds: 300),
                //       );
                //     },
                //     child: ScrollIndicator()),
                // SizedBox(
                //   height: 60,
                // ),
                GestureDetector(
                  onTap: () {
                    AnalyticsService()
                        .logButtonTapped(buttonName: EMERGENCY_HOME);
                    LocalNotificationService().showScheduledNotification(
                        id: 0,
                        title:
                            "Beep!Beep! 🚨 You tapped emergency button a while ago.",
                        payload: 'emergency',
                        body:
                            "How are you feeling now? If you replased please consider resetting the streak.🙈",
                        scheduleDate:
                            DateTime.now().add(Duration(minutes: 45)));

                    Get.toNamed(RoutesClass.emergencyPage);
                  },
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      width: 250,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.redAccent.shade200.withOpacity(0.5),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8),
                            bottomLeft: Radius.circular(8)),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black,
                              offset: Offset(4, 4),
                              blurRadius: 10,
                              spreadRadius: 1),
                          BoxShadow(
                              color: Colors.white.withOpacity(0.1),
                              offset: Offset(-4, -4),
                              blurRadius: 5,
                              spreadRadius: 1)
                        ],
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "EMERGENCY",
                              style: GoogleFonts.montserrat(
                                  color: Colors.white, letterSpacing: 1),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Icon(
                              Icons.warning_outlined,
                              color: Colors.white.withOpacity(0.7),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Obx(
                  () => SizedBox(
                    child: isAdLoaded.value
                        ? Container(
                            height: homePageBannerAd.size.height.toDouble(),
                            width: homePageBannerAd.size.width.toDouble(),
                            child: AdWidget(ad: homePageBannerAd),
                          )
                        : SizedBox(),
                  ),
                ),
                SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      BreathingCard(),
                      SizedBox(height: 20),
                      FocusDetector(
                        onVisibilityGained: () {
                          AnalyticsService()
                              .logCardVisible(cardName: HOME_QUOTES_CARD);
                        },
                        onVisibilityLost: () {
                          AnalyticsService()
                              .logCardInvisible(cardName: HOME_QUOTES_CARD);
                        },
                        child: HomeQuickCard(
                          onTap: () {
                            AnalyticsService()
                                .logButtonTapped(buttonName: HOME_QUOTES);
                            bottomNavController.changeBottomNavIndex(index: 2);
                          },
                          backgroundColor: hardColorsList[1],
                          title: "TAP FOR ➡️ QUOTES",
                          subtitle:
                              'Tap to checkout motivational quotes personalized for your streak.',
                          icon: Icon(
                            Icons.book_outlined,
                            size: 24,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      FocusDetector(
                        onVisibilityGained: () {
                          AnalyticsService()
                              .logCardVisible(cardName: HOME_TIMELINE_CARD);
                        },
                        onVisibilityLost: () {
                          AnalyticsService()
                              .logCardInvisible(cardName: HOME_TIMELINE_CARD);
                        },
                        child: HomeQuickCard(
                          onTap: () {
                            AnalyticsService()
                                .logButtonTapped(buttonName: HOME_TIMELINE);
                            bottomNavController.changeBottomNavIndex(index: 3);
                          },
                          backgroundColor: hardColorsList[0],
                          title: "TAP FOR ➡️ TIMELINE",
                          subtitle:
                              'Tap to checkout personalized tips and videos based on your streak.',
                          icon: Icon(
                            Icons.browse_gallery,
                            size: 24,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      SizedBox(height: 10),
                      FocusDetector(
                        onVisibilityGained: () {
                          AnalyticsService()
                              .logCardVisible(cardName: HOME_JOURNAL_CARD);
                        },
                        onVisibilityLost: () {
                          AnalyticsService()
                              .logCardInvisible(cardName: HOME_JOURNAL_CARD);
                        },
                        child: HomeQuickCard(
                          onTap: () {
                            AnalyticsService()
                                .logButtonTapped(buttonName: HOME_JOURNAL);
                            Get.toNamed(RoutesClass.writeJournal);
                          },
                          backgroundColor: hardColorsList[3],
                          title: "DAILY JOURNAL",
                          subtitle: 'Tap to write your daily journal',
                          icon: Icon(
                            Icons.edit,
                            size: 24,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      FocusDetector(
                        onVisibilityGained: () {
                          AnalyticsService()
                              .logCardVisible(cardName: HOME_BADGE_CARD);
                        },
                        onVisibilityLost: () {
                          AnalyticsService()
                              .logCardInvisible(cardName: HOME_BADGE_CARD);
                        },
                        child: HomeQuickCard(
                          onTap: () {
                            AnalyticsService()
                                .logButtonTapped(buttonName: HOME_PROGRESS);
                            bottomNavController.changeBottomNavIndex(index: 4);
                          },
                          backgroundColor: hardColorsList[4],
                          title: "PROFILE",
                          subtitle: 'Tap to see badges and progress.',
                          icon: Icon(
                            Icons.person,
                            size: 24,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(height: 28),
                      CoolText(),
                      // ContainerCard(
                      //   backgroundColor: hardColorsList[2],
                      //   parentColumnCrossAxisAlignment:
                      //       CrossAxisAlignment.center,
                      //   child: Text(
                      //     'Crafted with passion and grit, fueled by an empty stomach and an even emptier wallet. ❤️'
                      //         .toUpperCase(),
                      //     style: GoogleFonts.montserrat(
                      //         fontSize: 15,
                      //         color: Colors.white.withOpacity(0.8),
                      //         letterSpacing: 2),
                      //   ),
                      // ),
                      SizedBox(height: 50),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HomeQuickCard extends StatelessWidget {
  const HomeQuickCard(
      {Key? key,
      required this.title,
      required this.subtitle,
      this.icon,
      required this.onTap,
      required this.backgroundColor})
      : super(key: key);
  final String title;
  final String subtitle;
  final Widget? icon;
  final Color backgroundColor;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ContainerCard(
        parentColumnCrossAxisAlignment: CrossAxisAlignment.start,
        backgroundColor: backgroundColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  title,
                  style: GoogleFonts.montserrat(
                      fontSize: 12,
                      color: Colors.white,
                      letterSpacing: 2,
                      fontWeight: FontWeight.w500),
                ),
                Spacer(),
                icon != null ? icon! : SizedBox(),
              ],
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              subtitle,
              style: GoogleFonts.montserrat(
                  fontSize: 15, color: Colors.white.withOpacity(0.5)),
            ),
          ],
        ),
      ),
    );
  }
}

class CoolText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: Colors.white54,
        ),
        children: <TextSpan>[
          TextSpan(
            text: 'Crafted with ',
          ),
          TextSpan(
            text: 'passion and love',
            style: TextStyle(
              color: Colors.redAccent.withOpacity(0.5),
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text: ', fueled by an ',
          ),
          TextSpan(
            text: 'empty stomach ',
            style: TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text: 'and an even ',
          ),
          TextSpan(
            text: 'emptier wallet',
            style: TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text: ' ❤️',
          ),
        ],
      ),
    );
  }
}

showPostResetBottomSheet(
    {required BuildContext context,
    required StreakController streakController}) {
  showMaterialModalBottomSheet(
    backgroundColor: Colors.white,
    bounce: true,
    context: context,
    builder: (context) => SingleChildScrollView(
      controller: ModalScrollController.of(context),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("REMEMBER:"),
              SizedBox(
                height: 20,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Color(0xff8081DB).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(getRandomFromList(relapseQuotes),
                      style: GoogleFonts.poppins(
                        color: Colors.black54,
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      )),
                ),
              ),
              SizedBox(
                height: 28,
              ),
              GestureDetector(
                onTap: () {
                  AnalyticsService()
                      .logButtonTapped(buttonName: POST_RELAPSE_DIALOG);
                  Vibration.vibrate(duration: 50);
                  Navigator.of(context).pop();
                  Get.to(QuotesPage(
                    showRelapseQuotes: true,
                  ));
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xff8081DB).withOpacity(0.6),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "TAP FOR MORE QUOTES",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Lottie.network(
                            'https://assets3.lottiefiles.com/packages/lf20_Dob5qfagRb.json',
                            height: 28)
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    ),
  );
}

List<String> relapseQuotes = [
  "Relapse is not failure. It's a setback, but it doesn't define your journey to recovery. Keep moving forward. 💪",
  "The greatest glory in living lies not in never falling, but in rising every time we fall. - Nelson Mandela",
  "The road to recovery may be long and difficult, but it is worth it. You have the strength and courage to overcome this setback and achieve your goals. 💪",
  "Don't let a relapse define you. It's a temporary setback, not a permanent state. Get up, dust yourself off, and keep moving forward. 💪",
  "Recovery is a journey, not a destination. It's okay to stumble and fall, as long as you keep getting back up. 💪",
  "Don't let a relapse make you forget how far you've come. Keep striving for progress, not perfection. 💪",
  "Recovery is not a straight line. There may be ups and downs, but keep moving forward and you will reach your destination. 💪",
  "A man's true character is revealed not in his victories, but in how he responds to his defeats. 💪",
];
