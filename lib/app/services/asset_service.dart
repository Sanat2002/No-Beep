import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:logger/logger.dart';
import 'package:neep/app/hive/models/timeline_local_model.dart';

import '../hive/models/quotes_hive_model.dart';

class AssetService {
  Future<List<QuotesLocalModel>?> getQuotesData(
      {bool isRelapseQuotes = false}) async {
    try {
      // final storageRef = FirebaseStorage.instance.ref();
      // final imageUrl =
      //     await storageRef.child("jsons/quotes_sample.json").getDownloadURL();
      // Logger().wtf(imageUrl);

      // Response response = await Dio().get(
      //   imageUrl,
      // );

      // Logger().w(response.statusCode);
      // if (response.statusCode == 200) {
      //   final QuotesResponse quotesList =
      //       QuotesResponse.fromJson( await parseJsonFromAsset(assetPath: 'assets/quotes_sample.json'));
      //   return quotesList.data;
      // }

      final QuotesResponse quotesList = QuotesResponse.fromJson(
          await parseJsonFromAsset(
              assetPath: isRelapseQuotes
                  ? 'assets/relapse_quotes.json'
                  : 'assets/quotes_sample.json'));
      return quotesList.data;
    } on FirebaseException catch (e) {
      // Caught an exception from Firebase.
      print("Failed with error '${e.code}': ${e.message}");
    } on DioError catch (dioError) {
      print("Failed with error '${dioError.error}': ${dioError.message}");
    }
    return null;
  }

  Future<Map<String, TimeLineData>?> getTimeLineData() async {
    try {
      // final storageRef = FirebaseStorage.instance.ref();
      // final jsonUrl =
      //     await storageRef.child("jsons/timeline.json").getDownloadURL();

      // Response response = await Dio().get(
      //   jsonUrl,
      // );

      // if (response.statusCode == 200) {
      //   final TimelineResponse timeLineResponse =
      //       TimelineResponse.fromJson(response.data);
      //   Logger().wtf(timeLineResponse.data?.length);
      //   return timeLineResponse.data;
      // }

      final TimelineResponse timeLineResponse = TimelineResponse.fromJson(
          await parseJsonFromAsset(assetPath: 'assets/timeline.json'));
      return timeLineResponse.data;
    } on FirebaseException catch (e) {
      // Caught an exception from Firebase.
      print("Failed with error '${e.code}': ${e.message}");
    } on DioError catch (dioError) {
      print("Failed with error '${dioError.error}': ${dioError.message}");
    }
    return null;
  }

  Future<String> _loadAsset({required String assetPath}) async {
    return await rootBundle.loadString(assetPath);
  }

  Future<Map<String, dynamic>> parseJsonFromAsset(
      {required String assetPath}) async {
    String jsonString = await _loadAsset(assetPath: assetPath);
    return json.decode(jsonString);
  }
}
