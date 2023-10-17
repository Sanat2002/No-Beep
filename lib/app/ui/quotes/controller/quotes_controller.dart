import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../hive/hive_boxes.dart';
import '../../../hive/models/quotes_hive_model.dart';
import '../../../services/asset_service.dart';
import '../../../streak_controller.dart';

class QuotesController extends GetxController {
  final userDataBox = HiveBoxes.getUserHiveBox();
  final relapseDataBox = HiveBoxes.getResetDataBox();
  final streakDuration = Get.put(StreakController()).streakDuration;
  bool showAd = true;
//MAKE THIS TRUE TO SHOW ADDS
  bool isAdShown = false;

  final quotesBox = HiveBoxes.getQuotesLocalBox();
  final relapseQuotesBox = HiveBoxes.getRelapseQuotesLocalBox();
  var quotesDisplayList = <QuotesLocalModel>[].obs;
  List<QuotesLocalModel> quotesForTheDayList = [];

  var relapseQuotesDisplayList = <QuotesLocalModel>[].obs;

  final isLoading = false.obs;

  var customQuoteTextController = TextEditingController();
  var customQuote =
      QuotesLocalModel(quote: "", author: "", day: 0, imageUrl: "").obs;

  initCustomQuote() {
    if (customQuoteTextController.value.text.isNotEmpty) {
      return;
    }
    String quotesText = '';
    var userData = userDataBox.get("local_user");
    if (userData?.customQuote == null) {
      quotesText = userData?.userMotive ?? '';
    } else {
      quotesText = userData!.customQuote!;
    }
    customQuoteTextController = TextEditingController(text: quotesText);
    customQuote.value = QuotesLocalModel(
        quote: quotesText,
        author: "YOU",
        day: 0,
        imageUrl: "assets/batman.gif");
  }

  setCustomQuote() {
    String text = customQuoteTextController.value.text;
    var userData = userDataBox.get("local_user");
    customQuote.value = QuotesLocalModel(
        quote: text, author: "YOU", day: 0, imageUrl: "assets/batman.gif");

    if (userData != null) {
      userData = userData.copyWith(customQuote: text);
      userDataBox.put("local_user", userData);
    }
  }

  rewardedAdLoaded() {
    quotesDisplayList.removeAt(5);

    quotesDisplayList.insert(
        5,
        QuotesLocalModel(
            quote: "Tap to unlock quotes by watching an ad.❤️",
            author: "Tap Tap Tap",
            day: 0,
            imageUrl:
                "https://media.tenor.com/ryM0-bNSZ0cAAAAC/nouns-nouns-dao.gif",
            quoteItemType: 'ad'));

    quotesDisplayList.refresh();
  }

  fillquotesDisplayList() async {
    var userData = userDataBox.get("local_user");

    int? day = userData?.appOpenedDays;
    if (day == null) {
      return;
    }
    day = day % 29;

    if (quotesDisplayList.isNotEmpty && quotesDisplayList[0].day == day) {
      return;
    }

    await getQuotesList();

    quotesBox.values.forEach((element) {
      if (element.day == day) {
        quotesForTheDayList.add(element);
      }
    });

    if (quotesForTheDayList.length > 7) {
      quotesForTheDayList.add(QuotesLocalModel(
          quote: "",
          author: "",
          day: day,
          imageUrl: "",
          quoteItemType: 'user_quote'));
    } else {
      quotesForTheDayList.add(QuotesLocalModel(
          quote: "",
          author: "",
          day: day,
          imageUrl: "",
          quoteItemType: 'user_quote'));
    }

    quotesForTheDayList.add(QuotesLocalModel(
        quote:
            "Thats it for today. New Quotes on new day. \n See ya on a new day.",
        author: "Later!",
        day: day,
        imageUrl: "https://media.tenor.com/mFmmxJNuSxYAAAAC/batman.gif",
        quoteItemType: 'quote'));

    if (showAd) {
      quotesDisplayList.value = quotesForTheDayList.sublist(0, 5);

      quotesDisplayList.add(QuotesLocalModel(
          quote: "Loading...",
          author: "Hold on..3-2-1..",
          day: day,
          imageUrl:
              "https://media.tenor.com/VFCzXH21jsUAAAAC/dark-lighting.gif",
          quoteItemType: 'adload'));
    } else {
      quotesDisplayList.value = quotesForTheDayList;
    }
  }

  unlockNextQuotes() {
    isAdShown = true;
    quotesDisplayList.removeWhere((element) => element.quoteItemType == 'ad');
    quotesDisplayList.value = quotesForTheDayList;
  }

  getQuotesList() async {
    bool isboxEmpty = await quotesBox.isEmpty;
    if (!isboxEmpty) {
      return;
    }

    List<QuotesLocalModel>? quotesList = await AssetService().getQuotesData();

    if (quotesList == null) {
      return;
    }
    quotesList.forEach((element) {
      quotesBox.add(element);

      // var quotesMap=quotesBox.get(element.day);
      // List<QuotesLocalModel>? dayObj = quotesMap?[element.day];
      // Logger().wtf(element.day.toString());

      // if (dayObj != null) {
      //   List<QuotesLocalModel> quotesListForDay = dayObj;
      //   quotesListForDay.add(element);

      //   quotesBox.put(
      //       element.day.toString(), {element.day:quotesListForDay});
      // } else {
      //   quotesBox.put(element.day.toString(), {element.day});
      // }
    });
  }

  getRelapseQuotesList() async {
    bool isboxEmpty = await relapseQuotesBox.isEmpty;
    if (!isboxEmpty) {
      return;
    }

    List<QuotesLocalModel>? quotesList =
        await AssetService().getQuotesData(isRelapseQuotes: true);

    if (quotesList == null) {
      return;
    }
    quotesList.forEach((element) {
      relapseQuotesBox.add(element);

      // var quotesMap=quotesBox.get(element.day);
      // List<QuotesLocalModel>? dayObj = quotesMap?[element.day];
      // Logger().wtf(element.day.toString());

      // if (dayObj != null) {
      //   List<QuotesLocalModel> quotesListForDay = dayObj;
      //   quotesListForDay.add(element);

      //   quotesBox.put(
      //       element.day.toString(), {element.day:quotesListForDay});
      // } else {
      //   quotesBox.put(element.day.toString(), {element.day});
      // }
    });
  }

  fillRelapseQuotesDisplayList() async {
    relapseQuotesDisplayList.clear();
    int totalRelapses = relapseDataBox.values.length;
    await getRelapseQuotesList();

    relapseQuotesBox.values.forEach((element) {
      if (element.day == (totalRelapses % 4) + 1) {
        relapseQuotesDisplayList.add(element);
      }
    });

    relapseQuotesDisplayList.add(QuotesLocalModel(
        quote: "Thats it! Don't give up!",
        author: "Later!",
        day: totalRelapses,
        imageUrl: "https://media.tenor.com/gO_Nf7_7P8gAAAAd/berserk-guts.gif",
        quoteItemType: 'quote'));
  }
}
