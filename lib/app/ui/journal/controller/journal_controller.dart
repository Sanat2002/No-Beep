import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:neep/app/hive/hive_boxes.dart';
import '../../../hive/models/journal_local_model.dart';
import '../../../streak_controller.dart';

class JournalController extends GetxController {
  final journalBox = HiveBoxes.getLocalJournalBox();
  final streakController = Get.put(StreakController());

  TextEditingController journalTextEditingController = TextEditingController();
  var journalList = <JournalLocalModel>[].obs;
  final isLoading = false.obs;
  final journalHomeGif =
      'https://firebasestorage.googleapis.com/v0/b/neep-new.appspot.com/o/journal_images%2Fjournal_primary_compressed.gif?alt=media&token=0602d52e-a5e7-469c-9b30-0c1ca45e26b5'
          .obs;

  fillJournalList() {
    isLoading.value = true;
    if (journalBox.values.isEmpty) {
      return;
    }

    journalList.value = journalBox.values.toList();
    journalList
        .sort((b, a) => a.journalTimeStamp.compareTo(b.journalTimeStamp));
    int day = journalList[0].journalDay;
    int streakDays = streakController.streakDuration.value.inDays;
    if (day == streakDays) {
      journalHomeGif.value =
          "https://firebasestorage.googleapis.com/v0/b/neep-new.appspot.com/o/journal_images%2Fjournal_fight_club.gif?alt=media&token=38c7ec27-73fb-4629-93d3-b4852bd36372";
    } else {
      journalHomeGif.value =
          "https://firebasestorage.googleapis.com/v0/b/neep-new.appspot.com/o/journal_images%2Fjournal_taking_notes.gif?alt=media&token=738305a1-9b6d-428c-a234-e11996e370ae";
    }

    isLoading.value = false;
  }

  saveJournal({JOURNAL_TAGS? tag}) {
    DateTime timeStamp = DateTime.now();
    String journalText = journalTextEditingController.value.text;
    JOURNAL_TAGS journalTag = tag ?? JOURNAL_TAGS.journal;
    String journalKey = timeStamp.microsecondsSinceEpoch.toString();
    JournalLocalModel journal = JournalLocalModel(
        journalDay: streakController.streakDuration.value.inDays,
        journalText: journalText,
        journalTimeStamp: timeStamp,
        key: journalKey,
        tag: EnumToString.convertToString(journalTag));
    journalBox.put(timeStamp.microsecondsSinceEpoch.toString(), journal);
    journalList.insert(0, journal);
    journalHomeGif.value =
        "https://firebasestorage.googleapis.com/v0/b/neep-new.appspot.com/o/journal_images%2Fjournal_fight_club.gif?alt=media&token=38c7ec27-73fb-4629-93d3-b4852bd36372";
    journalTextEditingController.clear();
  }

  // editJournal(
  //     {required DateTime journalTimeStamp, required String journalText}) {
  //   JournalLocalModel? journalData =
  //       journalBox.get(journalTimeStamp.microsecondsSinceEpoch.toString());
  //   if (journalData == null) {
  //     return;
  //   }
  //   journalData = journalData.copyWith(journalText: journalText);
  //   journalBox.put(
  //       journalTimeStamp.microsecondsSinceEpoch.toString(), journalData);

  //   int index = journalList
  //       .indexWhere((element) => element.journalTimeStamp == journalTimeStamp);
  //   journalList.removeAt(index);
  //   journalList.insert(index, journalData);
  // }

  deleteJournal({required String key}) async {
    await journalBox.delete(key);
    journalList.removeWhere((element) => element.key == key);
  }
}

enum JOURNAL_TAGS { reset, emergency, journal }
