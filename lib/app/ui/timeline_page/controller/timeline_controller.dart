import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:logger/logger.dart';
import '../../../hive/hive_boxes.dart';
import '../../../hive/models/timeline_local_model.dart';
import '../../../services/asset_service.dart';
import '../../../streak_controller.dart';

class TimeLineController extends GetxController {
  final userDataBox = HiveBoxes.getUserHiveBox();
  final streakDuration = Get.put(StreakController()).streakDuration;

  final timeLineBox = HiveBoxes.getTimelineLocalBox();
  final currentTimeLineData = Rxn<TimeLineData>(
    TimeLineData(timelineId: null),
  );

  final timelineIncrementCount = 0.obs;

  final rewarderdAd = Rx<RewardedAd?>(null);

  final isAdLoading = false.obs;

//MAKE THIS TRUE TO SHOW AD
  final showAd = true.obs;

  rewardedAdLoaded() {
    showAd.value = false;
  }

  incrementTimeLineData() {
    int maxKey = 0;
    timeLineBox.keys.toList().forEach((element) {
      try {
        int key = int.parse(element);
        if (key >= maxKey) {
          maxKey = key;
        }
      } catch (e) {
        Logger().wtf(e);
      }
    });
    int currentKey = int.parse(currentTimeLineData.value?.timelineId ?? '1');

    if (currentKey != maxKey) {
      timelineIncrementCount.value = timelineIncrementCount.value + 1;
      currentKey = currentKey + 1;
    } else {
      return maxKey;
    }
    var localTimeline = timeLineBox.get(currentKey.toString());

    if (localTimeline != null) {
      currentTimeLineData.value = localTimeline;
    }

    return maxKey;
  }

  decrementTimeLineData() {
    int currentKey = int.parse(currentTimeLineData.value?.timelineId ?? '1');
    if (currentKey != 1) {
      currentKey = currentKey - 1;
      timelineIncrementCount.value = timelineIncrementCount.value - 1;
    }

    var localTimeline = timeLineBox.get(currentKey.toString());

    if (localTimeline != null) {
      currentTimeLineData.value = localTimeline;
    }
  }

  initTimeLineData() async {
    if (timeLineBox.isEmpty) {
      await fillLocalList();
    }
    int currentDay = streakDuration.value.inDays;

    for (int i = 0; i < timeLineBox.values.length; i++) {
      TimeLineData data = timeLineBox.values.elementAt(i);

      if ((int.parse(data.timelineDayUpperBound!) >= currentDay) &&
          (int.parse(data.timelineDayLowerBound!) <= currentDay)) {
        currentTimeLineData.value = timeLineBox.values.elementAt(i);
        break;
      }
    }
  }

  fillLocalList() async {
    bool isboxEmpty = await timeLineBox.isEmpty;
    if (!isboxEmpty) {
      return;
    }

    Map<String, TimeLineData>? timeLineDataMap =
        await AssetService().getTimeLineData();

    if (timeLineDataMap == null) {
      return;
    }
    timeLineDataMap.forEach((key, value) {
      timeLineBox.put(key, value);
    });
  }
}
