import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:neep/app/model/post_model.dart';
import 'package:neep/app/utils/utils.dart';
import 'package:uuid/uuid.dart';

class PostService {
  static final _postDoc =
      FirebaseFirestore.instance.collection("post_collection2").doc("post_doc");

  static Future<bool> creatPost(PostModel post) async {
    bool toreturn = false;
    try {
      final bool isInternet = await checkInternet();
      if (isInternet) {
        // var uuid = Uuid();
        Map<String, dynamic> postToAdd = {
          'postList': FieldValue.arrayUnion([post.toJson()])
        };
        print(postToAdd);
        await _postDoc.update(postToAdd);
        toreturn = true;
      }
    } catch (e) {
      print(e);
      requestFailureSnackbar("Something went wrong");
    }
    return toreturn;
  }
  // static creatPost(String caption, List<String> mediaUrls) async {
  //   try {
  //     final bool isInternet = await checkInternet();
  //     if (isInternet) {
  //       // var uuid = Uuid();
  //       await _postDoc.update({
  //         'postList': FieldValue.arrayUnion([
  //           {
  //             "caption": caption,
  //             "postedBy": "sohail",
  //             "postID": Uuid().v1(),
  //             "createdAt": DateTime.now(),
  //             "mediaUrl": mediaUrls
  //           }
  //         ])
  //       });
  //     }
  //   } catch (e) {
  //     print(e);
  //     requestFailureSnackbar("Something went wrong");
  //   }
  // }

  static deletePost(PostModel post) async {
    try {
      final bool isInternet = await checkInternet();
      if (isInternet) {
        Map<String, dynamic> postToAdd = {
          'postList': FieldValue.arrayRemove([post.toJson()])
        };
        await _postDoc.update(postToAdd);
      }
    } catch (e) {
      requestFailureSnackbar("Something went wrong");
    }
  }

  static Future<List<PostModel>> readAllPost() async {
    List<PostModel> postData = [];
    try {
      final bool isInternet = await checkInternet();
      if (isInternet) {
        DocumentSnapshot snapshot = await _postDoc.get();
        if (snapshot.data() != null) {
          final docData = snapshot.data() as Map<String, dynamic>;
          postData = postModelFromJson(docData["postList"]);
        }
      }
    } catch (e) {
      requestFailureSnackbar("Something went wrong");
    }
    // postData.sort(
    //   (a, b) =>
    //       DateTime.parse(b.createdAt).compareTo(DateTime.parse(a.createdAt)),
    // );
    return postData;
  }

  // static Future<PostModel?> getPostByID(String postID) async {
  //   PostModel? post;
  //   try {
  //     final bool isInternet = await checkInternet();
  //     if (isInternet) {
  //       DocumentSnapshot snapshot = await _postDoc.get();
  //       if (snapshot.data() != null) {
  //         final docData = snapshot.data() as Map<String, dynamic>;
  //         if (docData.containsKey(postID)) {
  //           post = PostModel.fromJson(docData[postID]);
  //         }
  //       }
  //     }
  //   } catch (e) {
  //     requestFailureSnackbar("Something went wrong");
  //   }
  //   return post;
  // }
}
