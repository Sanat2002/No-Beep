// To parse this JSON data, do
//
//     final timelineResponse = timelineResponseFromJson(jsonString);

import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:neep/app/hive/models/timeline_yt_local_model.dart';

import '../hive_type_ids.dart';
part 'timeline_local_model.g.dart';

TimelineResponse timelineResponseFromJson(String str) =>
    TimelineResponse.fromJson(json.decode(str));

class TimelineResponse {
  TimelineResponse({
    this.data,
  });

  Map<String, TimeLineData>? data;

  factory TimelineResponse.fromJson(Map<String, dynamic> json) =>
      TimelineResponse(
        data: json["data"] == null
            ? null
            : Map.from(json["data"]).map((k, v) =>
                MapEntry<String, TimeLineData>(k, TimeLineData.fromJson(v))),
      );
}

@HiveType(typeId: HiveTypeID.timelineTypeId)
class TimeLineData {
  TimeLineData(
      {this.timelineId,
      this.timelineLable,
      this.timelineSet,
      this.youtube,
      this.timelineDayLowerBound,
      this.timelineDayUpperBound});
  @HiveField(0)
  String? timelineId;
  @HiveField(1)
  String? timelineLable;
  @HiveField(2)
  Map<String, List<String>>? timelineSet;
  @HiveField(3)
  List<Youtube>? youtube;
  @HiveField(4)
  String? timelineDayLowerBound;
  @HiveField(5)
  String? timelineDayUpperBound;

  factory TimeLineData.fromJson(Map<String, dynamic> json) => TimeLineData(
        timelineId: json["timeline_id"] == null ? null : json["timeline_id"],
        timelineLable:
            json["timeline_lable"] == null ? null : json["timeline_lable"],
        timelineDayLowerBound:
            json["timeline_day_lb"] == null ? null : json["timeline_day_lb"],
        timelineDayUpperBound:
            json["timeline_day_ub"] == null ? null : json["timeline_day_ub"],
        timelineSet: json["timeline_set"] == null
            ? null
            : Map.from(json["timeline_set"]).map((k, v) =>
                MapEntry<String, List<String>>(
                    k, List<String>.from(v.map((x) => x)))),
        youtube: json["youtube"] == null
            ? null
            : List<Youtube>.from(
                json["youtube"].map((x) => Youtube.fromJson(x))),
      );
}
