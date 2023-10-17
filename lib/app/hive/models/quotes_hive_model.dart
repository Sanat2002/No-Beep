import 'dart:convert';

import 'package:hive/hive.dart';

import '../hive_type_ids.dart';

part 'quotes_hive_model.g.dart';

QuotesResponse quotesResponseFromJson(String str) =>
    QuotesResponse.fromJson(json.decode(str));

class QuotesResponse {
  QuotesResponse({
    this.data,
  });

  List<QuotesLocalModel>? data;

  factory QuotesResponse.fromJson(Map<String, dynamic> json) => QuotesResponse(
        data: json["data"] == null
            ? null
            : List<QuotesLocalModel>.from(
                json["data"].map((x) => QuotesLocalModel.fromJson(x))),
      );
}

@HiveType(typeId: HiveTypeID.quotesTypeId)
class QuotesLocalModel {
  @HiveField(0)
  String quote;
  @HiveField(1)
  String author;
  @HiveField(2)
  int day;
  @HiveField(3)
  String imageUrl;
  @HiveField(4)
  String quoteItemType;
  QuotesLocalModel(
      {required this.quote,
      required this.author,
      required this.day,
      required this.imageUrl,
      this.quoteItemType = "quote"});

  factory QuotesLocalModel.fromJson(Map<String, dynamic> json) =>
      QuotesLocalModel(
        day: json["day"] == null ? null : json["day"],
        author: json["author"] == null ? null : json["author"],
        quote: json["quote"] == null ? null : json["quote"],
        imageUrl: json["image_url"] == null ? null : json["image_url"],
      );
}
