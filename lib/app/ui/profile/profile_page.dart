import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:neep/app/services/routes_service.dart';
import '../../../constants.dart';
import '../../services/analytics_service.dart';
import '../../services/url_launcher_service.dart';
import '../../streak_controller.dart';
import '../ads/controller/ads_controller.dart';
import '../bottom_nav_bar/bottom_nav_bar_controller.dart';
import '../home/home_badge.dart';
import '../home/home_heatmap.dart';
import '../home/home_page.dart';
import '../widgets/premium_banner.dart';

class ProfilePage extends StatefulHookWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late ScrollController _scrollController;
  bool fabIsVisible = true;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      setState(() {
        fabIsVisible = _scrollController.position.userScrollDirection ==
            ScrollDirection.forward;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final adsController = Get.put(AdsController());
    final streakController = Get.put(StreakController());
    final bottomNavController = Get.put(BottomNavController());

    late BannerAd homePageBannerAd = adsController.statPageBannerAd;
    final isAdLoaded = adsController.isStatPageBannerAdLoaded;

    useEffect(() {
      return () {
        // _scrollController.dispose();
      };
    });

    useMemoized(() {
      adsController.initStatPageBannerAd();
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
        title:
            Text('PROFILE', style: Theme.of(context).textTheme.headlineMedium),
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
      floatingActionButton: fabIsVisible
          ? FloatingActionButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                      Radius.circular(15.0))), // isExtended: true,
              child: Icon(
                Icons.swap_vert,
                color: Colors.white,
              ),
              backgroundColor: Colors.green.withOpacity(0.7),
              onPressed: () {
                _scrollController.animateTo(
                  500,
                  curve: Curves.easeOut,
                  duration: const Duration(milliseconds: 300),
                );
                // AnalyticsService().logButtonTapped(buttonName: JOURNAL_ADD_FAB);
                // Get.toNamed(RoutesClass.writeJournal);
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
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: kToolbarHeight + 60,
                ),
                Visibility(
                  visible: false,
                  child: Padding(
                      padding: EdgeInsets.all(16),
                      child: GestureDetector(
                          onTap: () {
                            AnalyticsService().logButtonTapped(
                                buttonName: NEEP_PREMIUM_BANNER_TIMELINE_PAGE);
                            Get.toNamed(RoutesClass.subscriptionPage);
                          },
                          child: Hero(
                              tag: 'subscription_banner',
                              child: PremiumBanner()))),
                ),
                SizedBox(
                  height: 28,
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: HomeHeatMap()),
                SizedBox(
                  height: 20,
                ),
                Obx(
                  () => SizedBox(
                    child: isAdLoaded.value
                        ? Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: FocusDetector(
                              onVisibilityGained: () {
                                AnalyticsService()
                                    .logCardVisible(cardName: BADGE_AD_CARD);
                              },
                              onVisibilityLost: () {
                                AnalyticsService()
                                    .logCardInvisible(cardName: BADGE_AD_CARD);
                              },
                              child: Container(
                                height: homePageBannerAd.size.height.toDouble(),
                                width: homePageBannerAd.size.width.toDouble(),
                                child: AdWidget(ad: homePageBannerAd),
                              ),
                            ),
                          )
                        : SizedBox(),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: FocusDetector(
                        onVisibilityGained: () {
                          AnalyticsService()
                              .logCardVisible(cardName: BADGE_CARD);
                        },
                        onVisibilityLost: () {
                          AnalyticsService()
                              .logCardInvisible(cardName: BADGE_CARD);
                        },
                        child: BadgeWidget())),
                SizedBox(
                  height: 28,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      FocusDetector(
                        onVisibilityGained: () {
                          AnalyticsService()
                              .logCardVisible(cardName: HOME_CHANGE_DATE_CARD);
                        },
                        onVisibilityLost: () {
                          AnalyticsService().logCardInvisible(
                              cardName: HOME_CHANGE_DATE_CARD);
                        },
                        child: HomeQuickCard(
                          backgroundColor: hardColorsList[1],
                          onTap: () async {
                            AnalyticsService().logButtonTapped(
                                buttonName: HOME_CHANGE_START_DATE);
                            DateTime? selectedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now()
                                    .subtract(Duration(days: 365)),
                                lastDate: DateTime.now());

                            if (selectedDate != null) {
                              TimeOfDay? time = await showTimePicker(
                                  context: context,
                                  cancelText: '',
                                  confirmText: 'DONE',
                                  initialTime: TimeOfDay.now());
                              if (time != null) {
                                selectedDate = new DateTime(
                                    selectedDate.year,
                                    selectedDate.month,
                                    selectedDate.day,
                                    time.hour,
                                    time.minute,
                                    0);
                                if (selectedDate.isAfter(DateTime.now())) {
                                  selectedDate = DateTime(
                                      selectedDate.year,
                                      selectedDate.month,
                                      selectedDate.day,
                                      TimeOfDay.now().hour,
                                      TimeOfDay.now().minute);
                                }
                              }
                              bottomNavController.changeBottomNavIndex(
                                  index: 0);

                              AnalyticsService().logButtonAction(
                                  buttonFunction: 'CHANGE_START_SET_FROM_HOME');
                              streakController.setStreatDurationByDateTime(
                                  streakStartDate: selectedDate);
                              _scrollController.animateTo(
                                0.0,
                                curve: Curves.easeOut,
                                duration: const Duration(milliseconds: 300),
                              );
                            }
                          },
                          title: "CHANGE START DATE",
                          subtitle: "Change the start date of your streak.",
                          icon: Icon(
                            Icons.date_range,
                            size: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      FocusDetector(
                        onVisibilityGained: () {
                          AnalyticsService()
                              .logCardVisible(cardName: HOME_HISTORY_CARD);
                        },
                        onVisibilityLost: () {
                          AnalyticsService()
                              .logCardInvisible(cardName: HOME_HISTORY_CARD);
                        },
                        child: HomeQuickCard(
                          backgroundColor: hardColorsList[2],
                          onTap: () {
                            AnalyticsService().logButtonTapped(
                                buttonName: HOME_RELAPSE_HISTORY);
                            Get.toNamed(RoutesClass.resetHistory);
                          },
                          title: "RELAPSE HISTORY",
                          subtitle: "Checkout relapse history.",
                          icon: Icon(
                            Icons.chevron_right,
                            size: 30,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      HomeQuickCard(
                        backgroundColor: hardColorsList[3],
                        onTap: () {
                          AnalyticsService()
                              .logButtonTapped(buttonName: HOME_IMPROVE_NEEP);
                          UrlLauncherService().launchMail();
                        },
                        title: "IMPROVE NOBEEP ❤️",
                        subtitle: 'Tap to suggest features or report bugs.🐞',
                        icon: Icon(
                          Icons.mail,
                          size: 30,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
