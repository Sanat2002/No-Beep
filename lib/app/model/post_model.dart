import 'dart:convert';

List<PostModel> postModelFromJson(dynamic json) => List<PostModel>.from(json.map((x) => PostModel.fromJson(x)));
class PostModel {
  String postID;
  String postedBy;
  String createdAt;
  List<String> mediaUrl;
  String caption;

  PostModel({
    required this.postID,
    required this.postedBy,
    required this.createdAt,
    required this.mediaUrl,
    required this.caption,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) => PostModel(
        postID: json["postID"],
        postedBy: json["postedBy"],
        createdAt: json["createdAt"],
        mediaUrl: List<String>.from(json["mediaUrl"].map((x) => x)),
        caption: json["caption"],
      );

  Map<String, dynamic> toJson() => {
        "postID": postID,
        "postedBy": postedBy,
        "createdAt": createdAt,
        "mediaUrl": List<dynamic>.from(mediaUrl.map((x) => x)),
        "caption": caption,
      };
}
