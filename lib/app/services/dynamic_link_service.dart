import 'dart:async';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:neep/app/controllers/post_controller.dart';
import 'package:neep/app/controllers/post_controller2.dart';
import 'package:neep/app/model/post_model.dart';
import 'package:neep/app/services/firebase_service/post_service.dart';
import 'package:neep/app/ui/posts/post_page.dart';
import 'package:neep/app/utils/utils.dart';

class DynamicLinkService {
  Future handleDynamicLinks() async {
    ///STARTUP FROM DYNMAIC LINK LOGIC
    final PendingDynamicLinkData? data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    _handleDeepLink(data);

    ///INTO FOREGORUND FROM DYNAMIC LINK LOGIC
    FirebaseDynamicLinks.instance.onLink.listen((data) {
      _handleDeepLink(data);
    }, onError: (e) => print("Error : $e"));
  }

  Future<void> _handleDeepLink(PendingDynamicLinkData? data) async {
    // requestSuccessSnackbar("deep link open postpage");
    // Get.to(PostPage());
    if (data != null) {
      final Uri deepLink = data.link;

      Get.snackbar("Success", deepLink.toString());
      print('_handleDeepLink || deeplink = $deepLink');

      final bool isPost = deepLink.pathSegments.contains('RtQw');
      if (isPost) {
        final postID = deepLink.queryParameters['post_id'];
        if (postID != null) {
          final postController = PostController.instance;
          await Get.offAll(PostPage()); 
          int count = 0;
          await Timer.periodic(Duration(seconds: 20), (timer) {
            if (count > 5) {
              timer.cancel();
              return;
            }
            count++;
            if (!postController.isLoading) {
              int indexOfPost = postController.postList
                  .indexWhere((element) => element.postID == postID);
              if (indexOfPost != -1 && indexOfPost != 0) {
                PostModel post = postController.postList[indexOfPost];
                /// remove post from list
                postController.postList.remove(post);
                /// add that post to zero index
                postController.postList = [post];
              }
              timer.cancel();
            }
          });
        } else {
          requestFailureSnackbar("invalid Url");
        }
      } else {
        requestFailureSnackbar("Invalid Url");
      }
    }
  }

  Future<String> createDeepLink(String postID) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      link: Uri.parse("https://nobee.page.link/RtQw?post_id=$postID"),
      uriPrefix: 'https://nobee.page.link',
      androidParameters: AndroidParameters(packageName: 'com.cpark.nobee'),
    );

    final ShortDynamicLink postDeepLink =
        await FirebaseDynamicLinks.instance.buildShortLink(parameters);
    return postDeepLink.shortUrl.toString();
  }
}
