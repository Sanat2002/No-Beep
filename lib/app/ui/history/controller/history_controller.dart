import 'package:get/get.dart';
import '../../../hive/hive_boxes.dart';
import '../../../hive/models/local_reset_model.dart';

class HistoryController extends GetxController {
  final resetBox = HiveBoxes.getResetDataBox();
  var resetList = <ResetLocalModel>[].obs;
  final isLoading = false.obs;

  fillResetList() async {
    isLoading.value = true;
    resetList.value = await resetBox.values.toList();
    isLoading.value = false;
    resetList.value = List.of(resetList.reversed);
  }
}
