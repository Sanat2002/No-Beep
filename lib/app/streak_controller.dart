import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neep/app/hive/hive_boxes.dart';
import 'package:neep/app/services/notification_service.dart';
import 'package:neep/app/services/routes_service.dart';
import 'package:neep/app/ui/home/controller/badge_controller.dart';
import 'package:vibration/vibration.dart';
import 'hive/models/local_user_model.dart';

class StreakController extends GetxController {
  final hide = false.obs;
  final streakDuration = Duration(seconds: 0).obs;
  final effectiveAppDuration = Duration(seconds: 0).obs;

  final quotesBox = HiveBoxes.getQuotesLocalBox();
  final relapseQuotesBox = HiveBoxes.getRelapseQuotesLocalBox();
  final timeLineBox = HiveBoxes.getTimelineLocalBox();

  final showHomeFireAnimation = false.obs;

  final accentColor = Color(0xff8081DB).obs;
  String selectedColorCode = "Light";
  final userDataBox = HiveBoxes.getUserHiveBox();

  Timer? timer;

  @override
  Future<void> onInit() async {
    super.onInit();
    await _setStreakDurationFromHive();

    startTimer();
  }

  _setStreakDurationFromHive() async {
    if (userDataBox.get("local_user") == null) {
      return;
    }
    LocalUserModel userModel = await userDataBox.get("local_user")!;

    // String? presentBadge = userModel.currentBadge;

    streakDuration.value = DateTime.now().difference(userModel.streakStartDate);

    // if (presentBadge == null) {
    //   LocalUserModel newModel = userModel.copyWith(
    //     currentBadge: 'newbie',
    //   );
    //   updateLocalUserModelInHive(localUserModel: newModel);
    // } else {
    //   String? newBadge;
    //   newBadge = getBadge()?.badgeId;

    //   if (presentBadge != newBadge) {
    //     LocalUserModel newModel = userModel.copyWith(
    //       currentBadge: newBadge,
    //     );
    //     updateLocalUserModelInHive(localUserModel: newModel);
    //     if (newBadge != 'newbie') {
    //       Get.toNamed(RoutesClass.newBagePage, arguments: {'badge': newBadge});
    //     }
    //   }
    // }
  }

  getBadgeString() async {
    LocalUserModel userModel = await userDataBox.get("local_user")!;
    String? presentBadge = userModel.currentBadge;

    if (presentBadge == null) {
      LocalUserModel newModel = userModel.copyWith(
        currentBadge: 'newbie',
      );
      updateLocalUserModelInHive(localUserModel: newModel);
    } else {
      String? newBadge;
      newBadge = getBadge()?.badgeId;

      if (presentBadge != newBadge) {
        LocalUserModel newModel = userModel.copyWith(
          currentBadge: newBadge,
        );
        updateLocalUserModelInHive(localUserModel: newModel);
        if (newBadge != 'newbie') {
          return newBadge;
          // Get.toNamed(RoutesClass.newBagePage, arguments: {'badge': newBadge});
        }
      }
    }
  }

  startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (t) {
      _incrementStreakDuration(duration: Duration(seconds: 1));
    });
  }

  resetDuration() {
    streakDuration.value = Duration(seconds: 0);
    LocalUserModel userModel = userDataBox.get("local_user")!;

    LocalUserModel newModel =
        userModel.copyWith(streakStartDate: DateTime.now(), appOpenedDays: 0);
    updateLocalUserModelInHive(localUserModel: newModel);
  }

  _incrementStreakDuration({required Duration duration}) {
    streakDuration.value = streakDuration.value + duration;
    effectiveAppDuration.value = effectiveAppDuration.value + duration;
    if (streakDuration.value.inSeconds % 5 == 0) {
      if (userDataBox.get("local_user") != null) {
        LocalUserModel userModel = userDataBox.get("local_user")!;
        DateTime lastOpenedTimeStamp = userModel.lastAppOpenedDate;
        int appOpendDays = userModel.appOpenedDays;
        if (_incrementIncrementAppOpenedDays(
            lastOpenedTimeStamp: lastOpenedTimeStamp)) {
          appOpendDays = appOpendDays + 1;
          if (appOpendDays % 6 == 0) {
            _clearMediaDB();
          }
          LocalNotificationService().showScheduledNotification(
              id: 1,
              title: "Beeep!😎",
              payload: 'quotes',
              body: "New quotes unlocked. Check them out!!",
              scheduleDate: DateTime.now().add(Duration(hours: 25)));

          LocalNotificationService().showScheduledNotification(
              id: 2,
              title: "Hey, its time.⏰",
              payload: 'journal',
              body: "Tap to write today's journal🖊",
              scheduleDate: getNotificationTime(hourOfDay: 22));

          LocalNotificationService().showScheduledNotification(
              id: 3,
              title: "BEEP!BEEP! 🔥",
              payload: 'timeline',
              body: "Your doing great!! Tap to see your progress.📈",
              scheduleDate: DateTime.now().add(Duration(days: 2)));
        }

        LocalUserModel newModel = userModel.copyWith(
            streakDurationInSeconds: streakDuration.value.inSeconds,
            effectiveAppDurationInSeconds: effectiveAppDuration.value.inSeconds,
            lastAppOpenedDate: DateTime.now(),
            appOpenedDays: appOpendDays);
        updateLocalUserModelInHive(localUserModel: newModel);
      } else {
        userDataBox.put(
          "local_user",
          LocalUserModel(
              firstName: "",
              streakDurationInSeconds: streakDuration.value.inSeconds,
              userMotive: "",
              effectiveAppDurationInSeconds:
                  effectiveAppDuration.value.inSeconds,
              appOpenedDays: 0,
              appInitDate: DateTime.now(),
              streakStartDate: DateTime.now(),
              lastAppOpenedDate: DateTime.now()),
        );
      }
    }
  }

  BadgeModel? getBadge() {
    int currentDay = streakDuration.value.inDays;
    BadgeModel? currentBadge;

    badgeMap.values.forEach((element) {
      int? badgeLL = element.badgeLowerBound;
      int? badgeUL = element.badgeUpperBound;

      if (badgeLL != null && badgeUL != null) {
        if (currentDay >= badgeLL && currentDay < badgeUL) {
          currentBadge = element;
        }
      } else if (badgeLL != null && badgeUL == null) {
        if (currentDay >= badgeLL) {
          currentBadge = element;
        }
      } else if (badgeLL == null && badgeUL != null) {
        if (currentDay >= badgeUL) {
          currentBadge = element;
        }
      }
    });

    return currentBadge;
  }

  _clearMediaDB() {
    quotesBox.clear();
    relapseQuotesBox.clear();
    timeLineBox.clear();
  }

  bool _incrementIncrementAppOpenedDays(
      {required DateTime lastOpenedTimeStamp}) {
    bool increment = false;
    DateTime lastMidnight = DateTime(lastOpenedTimeStamp.year,
        lastOpenedTimeStamp.month, lastOpenedTimeStamp.day);
    DateTime currentDate = DateTime.now();
    DateTime currentMidnight =
        DateTime(currentDate.year, currentDate.month, currentDate.day);

    if (lastMidnight.isBefore(currentMidnight)) {
      increment = true;
      initHomeScreenFireAnimation(vibrate: false);
    }
    return increment;
  }

  initHomeScreenFireAnimation({required bool vibrate}) {
    showHomeFireAnimation.value = true;
    if (vibrate) {
      Vibration.vibrate(pattern: [
        100,
        100,
        100,
        100,
        200,
        200,
        400,
        100,
        100,
        100,
        100,
        200,
        200,
        400,
        100,
        100,
        200,
        200,
        400,
        100,
        100,
        100,
      ]);
    }

    Future.delayed(const Duration(milliseconds: 3000), () {
      showHomeFireAnimation.value = false;
    });
  }

  bool setStreakDurationByDays({required String numberOfDays}) {
    try {
      int dayCount = int.parse(numberOfDays);

      if (dayCount > 600) {
        return false;
      }
      DateTime streakStartDate =
          DateTime.now().subtract(Duration(days: dayCount));
      Duration incrementtal = Duration(days: dayCount);
      streakDuration.value = incrementtal;

      setStreakDateInHive(streakStartDate);
      return true;
    } catch (e) {
      return false;
    }
  }

  setStreakDateInHive(DateTime streakStartDate) {
    if (userDataBox.get("local_user") != null) {
      LocalUserModel userModel = userDataBox.get("local_user")!;
      LocalUserModel newModel = userModel.copyWith(
          streakStartDate: streakStartDate, appInitDate: streakStartDate);
      userDataBox.put("local_user", newModel);
    }
  }

  setStreatDurationByDateTime({required DateTime streakStartDate}) {
    streakDuration.value = DateTime.now().difference(streakStartDate);
    setStreakDateInHive(streakStartDate);
  }

  double getStreakPercent() {
    if (streakDuration.value.inMinutes < 1) {
      return (streakDuration.value.inSeconds % 60) / 60;
    } else if (streakDuration.value.inHours < 1) {
      return (streakDuration.value.inMinutes % 60) / 60;
    } else if (streakDuration.value.inDays < 1) {
      return (streakDuration.value.inHours % 24) / 24;
    } else {
      return (streakDuration.value.inDays % 90) / 90;
    }
  }

  double getStreakPercentInSeconds() {
    return (streakDuration.value.inSeconds % 60) / 60;
  }

  double getStreakPercentInMinutes() {
    return (streakDuration.value.inMinutes % 60) / 60;
  }

  double getStreakPercentInHours() {
    return (streakDuration.value.inHours % 24) / 24;
  }

  double getStreakPercentInDays() {
    return (streakDuration.value.inDays % 90) / 90;
  }

  int getStreakCounterValue() {
    if (streakDuration.value.inMinutes < 1) {
      return streakDuration.value.inSeconds;
    } else if (streakDuration.value.inHours < 1) {
      return streakDuration.value.inMinutes;
    } else if (streakDuration.value.inDays < 1) {
      return streakDuration.value.inHours;
    } else {
      return streakDuration.value.inDays;
    }
  }

  int getStreakCounterValueInSeconds() {
    return streakDuration.value.inSeconds % 60;
  }

  int getStreakCounterValueInMinutes() {
    return streakDuration.value.inMinutes % 60;
  }

  int getStreakCounterValueInHours() {
    return streakDuration.value.inHours % 24;
  }

  int getStreakCounterValueInDays() {
    return streakDuration.value.inDays;
  }

  String getStreakCounterSubtitle() {
    if (streakDuration.value.inMinutes < 1) {
      return "SECONDS";
    } else if (streakDuration.value.inHours < 1) {
      return "MINUTES";
    } else if (streakDuration.value.inDays < 1) {
      return "HOURS";
    } else {
      return "DAYS";
    }
  }

  updateLocalUserModelInHive({required LocalUserModel localUserModel}) async {
    await userDataBox.put("local_user", localUserModel);
  }

  LocalUserModel? getLocalUserModelInHive() {
    if (userDataBox.get("local_user") != null) {
      LocalUserModel userModel = userDataBox.get("local_user")!;
      return userModel;
    }
    return null;
  }

  resetLocalStreak() {
    streakDuration.value = Duration(seconds: 0);

    if (userDataBox.get("local_user") != null) {
      LocalUserModel userModel = userDataBox.get("local_user")!;
      LocalUserModel newModel = userModel.copyWith(streakDurationInSeconds: 0);
      updateLocalUserModelInHive(localUserModel: newModel);
    }
  }
}

DateTime getNotificationTime({required int hourOfDay}) {
  DateTime currentTime = DateTime.now();

  if (currentTime.hour < hourOfDay) {
    Duration durationTillTen =
        DateTime(currentTime.year, currentTime.month, currentTime.day)
            .add(Duration(hours: hourOfDay))
            .difference(currentTime);
    return currentTime.add(durationTillTen);
  } else {
    return DateTime(currentTime.year, currentTime.month, currentTime.day)
        .add(Duration(days: 1, hours: hourOfDay));
  }
}
