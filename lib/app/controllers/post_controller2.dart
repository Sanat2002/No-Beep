import 'package:get/get.dart';
import 'package:neep/app/model/post_model.dart';
import 'package:neep/app/services/firebase_service/post_service.dart';
import 'package:neep/app/utils/utils.dart';

class PostController extends GetxController {
  PostController() {
    loadPostData();
  }

  static PostController get instance => Get.find<PostController>();

  RxList<PostModel> _postList = <PostModel>[].obs;
  List<PostModel> get postList => _postList.value;
  set postList(List<PostModel> newPostList) =>
      _postList.value = [...newPostList, ..._postList];

  RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;
  set isLoading(bool isLoading) => _isLoading.value = isLoading;

  loadPostData() async {
    isLoading = true;
    try {
      final postData = await PostService.readAllPost();
      postList = postData;
      print(postList.length);
    } catch (e) {
      requestFailureSnackbar("Something Went Wrong");
    }
    isLoading = false;
  }

  refreshPostData() async {
    try {
      final List<PostModel> postData = await PostService.readAllPost();
      List<PostModel> newPosts = [];
      int idxWhereSame = postData.indexWhere(
          (element) => DateTime.parse(element.createdAt).isAtSameMomentAs(
                DateTime.parse(postList.first.createdAt),
              ));
      if (idxWhereSame != -1 && idxWhereSame != 0) {
        newPosts = postList.getRange(0, idxWhereSame).toList();
        postList = newPosts;
      }
    } catch (e) {
      requestFailureSnackbar("Something Went Wrong");
    }
  }
}
