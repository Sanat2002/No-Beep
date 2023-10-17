// import 'package:get/get.dart';
// import 'package:neep/app/model/post_model.dart';
// import 'package:neep/app/services/firebase_service/post_service.dart';
// import 'package:neep/app/utils/utils.dart';

// class PostController extends GetxController {
//   PostController() {
//     loadPostData();
//   }

//   static PostController get instance => Get.find<PostController>();

//   RxMap<String, PostModel> _postMap = <String, PostModel>{}.obs;
//   Map<String, PostModel> get postMap => _postMap;
//   PostModel? getSinglePost(String postID) => _postMap[postID];
//   void setPostMap(Map<String, PostModel> newEntries) {
//     // _postMap = {...newEntries , ..._postMap};
//     final Map<String, PostModel> newMap = {...newEntries, ..._postMap};
//     _postMap.clear();
//     _postMap.addAll(newMap);
//   }

//   RxBool _isLoading = false.obs;
//   bool get isLoading => _isLoading.value;
//   setIsLoading(bool isLoading) {
//     _isLoading.value = isLoading;
//   }

//   loadPostData() async {
//     setIsLoading(true);
//     try {
//       final postData = await PostService.readAllPost();
//       setPostMap(postData);
//     } catch (e) {
//       requestFailureSnackbar("Something Went Wrong");
//     }
//     setIsLoading(false);
//   }

//   refreshPostData() async {
//     try {
//       final Map<String, PostModel> postData = await PostService.readAllPost();
//       Map<String, PostModel> newPosts = {};
//       postData.forEach((key, value) {
//         if (!postMap.containsKey(key)) {
//           newPosts[key] = value;
//         }
//       });
//       setPostMap(newPosts);
//     } catch (e) {
//       requestFailureSnackbar("Something Went Wrong");
//     }
//   }
// }
