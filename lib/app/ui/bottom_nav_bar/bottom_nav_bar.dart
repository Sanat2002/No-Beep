import 'dart:async';
import 'dart:math';
import 'package:confetti/confetti.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:logger/logger.dart';
import 'package:lottie/lottie.dart';
import 'package:neep/app/services/analytics_service.dart';
import 'package:neep/app/services/notification_service.dart';
import 'package:neep/app/ui/bottom_nav_bar/bottom_nav_bar_controller.dart';
import 'package:neep/app/ui/posts/post_page.dart';
import '../../streak_controller.dart';
import '../profile/admin_profile_page.dart';
import '../snack_bars.dart';
import '../profile/profile_page.dart';
import '../timeline_page/timeline_page.dart';
import '../quotes/quotes_page.dart';
import '../home/home_page.dart';
import '../journal/journal_home.dart';

class BottomNavScreen extends StatefulHookWidget {
  const BottomNavScreen({Key? key}) : super(key: key);

  @override
  State<BottomNavScreen> createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  late final LocalNotificationService service;
  AppUpdateInfo? _updateInfo;

  static const List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    JournalHome(),
    PostPage(),
    ArticlesPage(),
    // ProfilePage(),
    // ProfilePage
    Profile()
  ];
  void showConnectivitySnackBar(ConnectivityResult result) {
    final hasInternet = result != ConnectivityResult.none;
    final message = hasInternet
        ? 'You have again ${result.toString()}'
        : 'You have no internet';
    final color = hasInternet ? Colors.green : Colors.red;
    if (!hasInternet) {
      SnackBarUtils.showNoInternetSnackbar(context, message, color);
    }
  }

  Future<void> checkForUpdate() async {
    try {
      AppUpdateInfo info = await InAppUpdate.checkForUpdate();
      Logger().wtf(info);
      setState(() {
        _updateInfo = info;
      });
      if (_updateInfo != null) {
        InAppUpdate.startFlexibleUpdate().catchError((e) {
          Logger().wtf(e);
        });
      }
    } catch (e) {
      Logger().wtf(e.toString());
    }

    // InAppUpdate.checkForUpdate().then((info) {
    //   setState(() {
    //     _updateInfo = info;
    //   });
    //   if (_updateInfo != null) {
    //     InAppUpdate.performImmediateUpdate().catchError((e) {
    //       Logger().wtf(e);
    //     });
    //   }
    // }).catchError((e) {
    //   Logger().wtf(e.toString());
    // });
  }

  late StreamSubscription subscription;

  @override
  void initState() {
    super.initState();

    subscription =
        Connectivity().onConnectivityChanged.listen(showConnectivitySnackBar);

    checkForUpdate();
  }

  @override
  void dispose() {
    subscription.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomNavController = Get.put(BottomNavController());
    final index = bottomNavController.bottomNavIndex;
    final streakController = Get.put(StreakController());
    final showFire = streakController.showHomeFireAnimation;
    final _confettiController = ConfettiController();

    useMemoized(() async {
      _confettiController.duration = Duration(seconds: 5);

      var badgeString = await streakController.getBadgeString();
      if (badgeString != null) {
        Get.snackbar("New Badge Achieved", "Tap to see",
            backgroundColor: Colors.green.withOpacity(0.7),
            onTap: (snack) =>
                {bottomNavController.changeBottomNavIndex(index: 4)},
            duration: Duration(seconds: 5));
        _confettiController.play();
      }

      index.value = 0;

      if (Get.arguments != null &&
          Get.arguments['showFireAnimation'] != null &&
          Get.arguments['showFireAnimation'] == true) {
        streakController.initHomeScreenFireAnimation(vibrate: true);
      }
    });

    return Scaffold(
      body: WillPopScope(
        onWillPop: () {
          if (index.value != 0) {
            bottomNavController.changeBottomNavIndex(index: 0);
            return Future.value(false);
          }
          return Future.value(true);
        },
        child: Stack(
          children: [
            Obx(() => Center(
                  child: _widgetOptions.elementAt(index.value),
                )),
            Obx(() => Visibility(
                  visible: showFire.value,
                  child: Positioned(
                    bottom: 0,
                    child: Lottie.asset('assets/fire_animation.json',
                        height: MediaQuery.of(context).size.height * 0.83,
                        fit: BoxFit.cover),
                  ),
                )),
            Center(
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirection: -pi / 2,
                numberOfParticles: 8,
                emissionFrequency: 0.1,
                blastDirectionality: BlastDirectionality.explosive,
                colors: [
                  Color(0xffac7e3e),
                  Colors.orangeAccent,
                  Colors.white,
                  Colors.red,
                ],
                gravity: 0.1,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Obx(() => SafeArea(
            child: BottomNavigationBar(
              backgroundColor: Colors.black,
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.timelapse_outlined),
                  label: "HOME",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.edit),
                  label: "JOURNAL",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.podcasts_sharp),
                  label: "Post",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.browse_gallery),
                  label: "TIMELINE",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: "PROFILE",
                ),
              ],
              currentIndex: index.value,
              type: BottomNavigationBarType.fixed,
              showUnselectedLabels: false,
              selectedItemColor: Colors.white,
              unselectedItemColor: Color(0xffC2C1BE).withOpacity(0.7),
              onTap: (value) {
                AnalyticsService()
                    .logBottomNavTappedAction(navItemName: value.toString());
                bottomNavController.changeBottomNavIndex(index: value);
              },
              elevation: 0,
            ),
          )),
    );
  }
}
