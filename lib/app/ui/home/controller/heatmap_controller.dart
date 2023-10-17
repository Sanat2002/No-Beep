import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import '../../../hive/hive_boxes.dart';
import '../../../hive/models/local_reset_model.dart';
import '../../../streak_controller.dart';

class HeatmapController extends GetxController {
  final streakController = Get.put(StreakController());
  final streakDuration = Get.put(StreakController()).streakDuration;
  var resetReasonTextController = TextEditingController();
  final resetBox = HiveBoxes.getResetDataBox();
  final userDataBox = HiveBoxes.getUserHiveBox();
  final RxMap<DateTime, int> heatDataSet = RxMap();
  reset() async {
    String reason = resetReasonTextController.value.text;
    String relapseDays = streakDuration.value.inDays.toString();
    await resetBox.put(
        DateTime.now().toIso8601String(),
        ResetLocalModel(
            realapseDay: relapseDays,
            reason: reason,
            relapseTimeStamp: DateTime.now()));

    streakController.resetDuration();
  }

  fillHeatMap() async {
    final appInitDate =
        await userDataBox.get('local_user')?.appInitDate ?? DateTime.now();

    List<DateTime> allDays = _getDaysInBeteween(appInitDate, DateTime.now());

    Set<DateTime> relapsedDays = {};

    resetBox.keys.forEach((element) {
      var relapsedTimeStamp = DateTime.parse(element);
      var relapsedDay = DateTime(relapsedTimeStamp.year,
          relapsedTimeStamp.month, relapsedTimeStamp.day);
      if (!relapsedDays.contains(relapsedDay)) {
        relapsedDays.add(relapsedDay);
      }
    });

    allDays.sort((a, b) => a.compareTo(b));

    int heatScore = 1;

    allDays.forEach((element) {
      if (relapsedDays.contains(element)) {
        heatDataSet[element] = 6;
        heatScore = 1;
      } else {
        heatDataSet[element] = heatScore;
        if (heatScore >= 5) {
          heatScore = 5;
        } else {
          heatScore = heatScore + 1;
        }
      }
    });
  }
}

List<DateTime> _getDaysInBeteween(DateTime startDate, DateTime endDate) {
  List<DateTime> days = [];
  for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
    days.add(DateTime(startDate.year, startDate.month, startDate.day + i));
  }
  days.add(DateTime(endDate.year, endDate.month, endDate.day));

  return days;
}
