import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../hive/hive_boxes.dart';
import '../../hive/models/local_user_model.dart';

class EmergencyController extends GetxController {
  final userDataBox = HiveBoxes.getUserHiveBox();
  final isLoading = false.obs;
  var motiveTextEditingController = TextEditingController();
  final userMotive = ''.obs;
  final isEmergencyJournalAdded = false.obs;

  List<String> gifList = [
    'https://res.cloudinary.com/dhupov40f/image/upload/v1676325659/emergency_compressed_u1glss.gif',
    'https://res.cloudinary.com/dhupov40f/image/upload/v1676326508/emergency-compressed_3_ag23l5.gif',
    'https://res.cloudinary.com/dhupov40f/image/upload/v1676326508/emergency_compressed_2_g8hbmk.gif'
  ];

  String getUserMotive() {
    String motive = userDataBox.get("local_user")?.userMotive ?? '';
    userMotive.value = motive;
    motiveTextEditingController = TextEditingController(text: motive);
    return motiveTextEditingController.value.text;
  }

  setMotive() {
    LocalUserModel? localuser = userDataBox.get('local_user');
    localuser =
        localuser?.copyWith(userMotive: motiveTextEditingController.text);
    userMotive.value = motiveTextEditingController.text;
    userDataBox.put('local_user', localuser!);
  }

  addEmergencyJournal() {
    isEmergencyJournalAdded.value = true;
  }
}

dynamic getRandomFromList(List<dynamic>? list) {
  if (list == null) {
    return null;
  }
  var random = new Random();
  var randomIndex = random.nextInt(list.length);
  return list[randomIndex];
}
