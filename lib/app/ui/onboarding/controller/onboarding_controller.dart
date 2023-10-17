import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../../../hive/hive_boxes.dart';
import '../../../hive/models/local_user_model.dart';
import '../../../services/notification_service.dart';
import '../../../streak_controller.dart';

class OnboardingController extends GetxController {
  final userDataBox = HiveBoxes.getUserHiveBox();
  final streakController = Get.put(StreakController());

  final hide = false.obs;
  // final streakDuration = Duration(seconds: 0).obs;
  final accentColor = Color(0xff8081DB).obs;
  String selectedColorCode = "Light";

  final userNickNameEditingController = TextEditingController();
  final onboardingCustomDayCountEditingController = TextEditingController();

  final onboardingMotiveEditingController = TextEditingController();

  changeAccentColor({required Color newAccentColor}) {
    accentColor.value = newAccentColor;
  }

  saveOnboardingDataInHive() async {
    _setAppDownloadNotifications();
    DateTime streakStartDate =
        DateTime.now().subtract(streakController.streakDuration.value);
    await userDataBox.put(
      "local_user",
      LocalUserModel(
          firstName: userNickNameEditingController.text.trim(),
          streakDurationInSeconds:
              streakController.streakDuration.value.inSeconds,
          userMotive: onboardingMotiveEditingController.text.trim(),
          appOpenedDays: 0,
          effectiveAppDurationInSeconds: 0,
          appInitDate: streakStartDate,
          streakStartDate: streakStartDate,
          lastAppOpenedDate: DateTime.now()),
    );
  }

  _setAppDownloadNotifications() {
    LocalNotificationService().showScheduledNotification(
        id: 4,
        title:
            "Welcome to NoBeep! Unleash your full potential and conquer your dreams!😎",
        payload: 'home',
        body:
            "Hey there, go-getter! You're about to embark on an extraordinary journey with NOBEEP. Crush your limits, achieve greatness, and live life on your terms. Dive in now and unlock the boundless possibilities within you",
        scheduleDate: DateTime.now().add(Duration(hours: 1)));

    LocalNotificationService().showScheduledNotification(
        id: 5,
        title: "🚨Urges hitting hard? Tap to Explore the Emergency Section!🚨",
        payload: 'emergency',
        body:
            "Hey there, warrior! We know urges can be tough, but you're not alone. Discover our Emergency Section designed to help you conquer those challenging moments. Tap here for powerful strategies and immediate support.",
        scheduleDate: DateTime.now().add(Duration(days: 1)));

    LocalNotificationService().showScheduledNotification(
        id: 6,
        title: "📈 Tap to Explore the Timeline!",
        payload: 'timeline',
        body:
            "Your journey of transformation has just begun. Dive into our Timeline to witness the incredible changes happening in your mind and body. Get expert tips, inspiring stories, and enlightening YouTube videos. Start exploring now!",
        scheduleDate: DateTime.now().add(Duration(days: 2)));

    LocalNotificationService().showScheduledNotification(
        id: 7,
        title: "You've got this!💪 Imagine your streak at 90 days.",
        payload: 'home',
        body:
            "You're on fire, my friend! Picture yourself reaching a majestic 90-day streak like this. Let this image be a reminder of your strength and resilience. Keep pushing forward, and remember, you have what it takes to make it happen!",
        scheduleDate: DateTime.now().add(Duration(days: 3, hours: 6)));

    LocalNotificationService().showScheduledNotification(
        id: 8,
        title: "Unleash your potential! 🚀",
        payload: 'quotes',
        body:
            "Tap here to discover the untapped power within you. Break free from the chains that hold you back and embrace a life of limitless possibilities. You're destined for greatness!",
        scheduleDate: DateTime.now().add(Duration(days: 4, hours: 2)));

    LocalNotificationService().showScheduledNotification(
        id: 9,
        title: "Conquer your demons, become the hero of your story! 🦸‍♂️",
        payload: 'home',
        body:
            "You have the strength within you to rewrite your narrative. Rise above the challenges, embrace your inner hero, and create a future that inspires. Keep going, you're unstoppable!",
        scheduleDate: DateTime.now().add(Duration(days: 7)));

    LocalNotificationService().showScheduledNotification(
        id: 10,
        title: "Embrace discomfort, it's where growth begins! 💪",
        payload: 'home',
        body:
            "True growth lies outside your comfort zone. Embrace the challenges, face them head-on, and watch yourself transform into a stronger, more resilient version of yourself. Embrace the discomfort!",
        scheduleDate: DateTime.now().add(Duration(days: 9)));

    LocalNotificationService().showScheduledNotification(
        id: 11,
        title: "Every setback is a setup for a comeback! 🚀",
        payload: 'home',
        body:
            "In the face of setbacks, you have the power to bounce back stronger than ever. Embrace the lessons, learn from your experiences, and fuel your comeback. Your resilience knows no bounds!",
        scheduleDate: DateTime.now().add(Duration(days: 11)));

    LocalNotificationService().showScheduledNotification(
        id: 12,
        title: "Embrace the journey, create your masterpiece! 🎨",
        payload: 'quotes',
        body:
            "Life is your canvas, and you hold the brush. Embrace the ups and downs, the wins and losses, and paint your unique masterpiece. Your journey is an art of self-discovery and triumph!",
        scheduleDate: DateTime.now().add(Duration(days: 15)));

    LocalNotificationService().showScheduledNotification(
        id: 13,
        title: "Defy the odds, rewrite your story! ✍️",
        payload: 'home',
        body:
            "You are the author of your own destiny. Break free from the constraints of the past, redefine your narrative, and write a captivating story of strength, resilience, and triumph. You're the hero of your own tale!",
        scheduleDate: DateTime.now().add(Duration(days: 17)));

    LocalNotificationService().showScheduledNotification(
        id: 14,
        title: "Unleash your potential, set your soul on fire! 🔥",
        payload: 'quotes',
        body:
            "Tap here to ignite your passions, unleash your inner fire, and embrace a life filled with purpose and fulfillment. You have the power to create a future that sets your soul ablaze!",
        scheduleDate: DateTime.now().add(Duration(days: 20)));
  }
}
