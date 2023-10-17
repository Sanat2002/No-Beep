import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:neep/app/model/user_model.dart';

// void showSnackBar(BuildContext context, String content) {
//   ScaffoldMessenger.of(context).showSnackBar(
//     SnackBar(
//       content: Text(content),
//     ),
//   );
// }



class Global {
  static bool isUserfbPresent = false;
}


String getNameFromEmail(String email) {
  return email.split('@')[0];
}

Future<List<File>> pickMediaFiles() async {
  List<File> files = [];
  final ImagePicker _picker = ImagePicker();
  final _pickedFiles = await _picker.pickMultiImage();
  if (_pickedFiles.isNotEmpty) {
    for (final file in _pickedFiles) {
      print(file.path);
      files.add(File(file.path));
    }
  }
  return files;
}

Future<bool> checkInternet() async {
  var connectivityResult = await Connectivity().checkConnectivity();
  if (connectivityResult == ConnectivityResult.none) {
    // No internet connection
    noInternetSnackbar(
        "No Internet Connection. Please check your connection and try again");
    return false;
  }
  return true;
}

SnackbarController requestFailureSnackbar(String errorMessage) {
  return Get.snackbar("Error", errorMessage,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.withOpacity(0.1),
      colorText: Colors.red);
}

SnackbarController requestSuccessSnackbar(String message) {
  return Get.snackbar("Success", message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.withOpacity(0.1),
      colorText: Colors.green);
}

SnackbarController noInternetSnackbar(String errorMessage) {
  return Get.snackbar("Error", errorMessage,
      duration: Duration(seconds: 30),
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red.withOpacity(0.1),
      colorText: Colors.red);
}


