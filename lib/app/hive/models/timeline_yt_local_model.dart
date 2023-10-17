import 'package:hive/hive.dart';
import 'package:neep/app/hive/hive_type_ids.dart';

part 'timeline_yt_local_model.g.dart';

@HiveType(typeId: HiveTypeID.timelineTypeId_yt_model)
class Youtube {
  Youtube({
    this.videoId,
    this.videoTitle,
    this.videoAuthor,
  });
  @HiveField(0)
  String? videoId;
  @HiveField(1)
  String? videoTitle;
  @HiveField(2)
  String? videoAuthor;

  factory Youtube.fromJson(Map<String, dynamic> json) => Youtube(
        videoId: json["video_id"] == null ? null : json["video_id"],
        videoTitle: json["video_title"] == null ? null : json["video_title"],
        videoAuthor: json["video_author"] == null ? null : json["video_author"],
      );

  Map<String, dynamic> toJson() => {
        "video_id": videoId == null ? null : videoId,
        "video_title": videoTitle == null ? null : videoTitle,
        "video_author": videoAuthor == null ? null : videoAuthor,
      };
}
