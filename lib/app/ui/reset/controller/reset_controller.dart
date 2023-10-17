import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../hive/hive_boxes.dart';
import '../../../hive/models/local_reset_model.dart';
import '../../../streak_controller.dart';

class ResetController extends GetxController {
  final streakController = Get.put(StreakController());
  final streakDuration = Get.put(StreakController()).streakDuration;
  var resetReasonTextController = TextEditingController();
  final resetBox = HiveBoxes.getResetDataBox();
  List<String> gifs = [
    "https://media.tenor.com/GAUfqJcu630AAAAd/no-country.gif",
    "https://media.tenor.com/YABaufMSXw8AAAAd/hang-first-time.gif",
    "https://media.tenor.com/NpWx4DgpgP8AAAAd/jimchi-jim-chi-asmr.gif"
  ];

  reset() async {
    String reason = resetReasonTextController.value.text;
    String relapseDays = streakDuration.value.inDays.toString();
    await resetBox.put(
        DateTime.now().toIso8601String(),
        ResetLocalModel(
            realapseDay: relapseDays,
            reason: reason.isEmpty ? "No Reason Given" : reason,
            relapseTimeStamp: DateTime.now()));

    streakController.resetDuration();
  }
}
