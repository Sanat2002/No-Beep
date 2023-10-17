import 'dart:math';

import 'package:get/get.dart';

import '../../hive/hive_boxes.dart';

class BottomNavController extends GetxController {
  final userDataBox = HiveBoxes.getUserHiveBox();

  final bottomNavIndex = 0.obs;

  // int getBottomnavIndex() {
  //   var userData = userDataBox.get("local_user");

  //   int? day = userData?.appOpenedDays;
  //   if (day == null || day == 0) {
  //     return 0;
  //   } else {
  //     var random = new Random();
  //     var randomIndex = random.nextInt(botomNavIndexes.length);
  //     return botomNavIndexes[randomIndex];
  //   }
  // }

  List<int> botomNavIndexes = [0, 1, 3, 3, 4];

  changeBottomNavIndex({required int index}) {
    bottomNavIndex.value = index;
  }
}
