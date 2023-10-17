import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:neep/app/model/user_model.dart';
import 'package:neep/app/utils/utils.dart';

class UserService {
  // static final _db = FirebaseFirestore.instance;
  // static final _userCollection = _db.collection("users_collection");
  static final _userDoc = FirebaseFirestore.instance
      .collection("users_collection")
      .doc('users_doc');

  static Future<bool> creatuser(Map<String, dynamic> newUser) async {
    bool isSucces = false;
    try {
      final bool isInternet = await checkInternet();
      if (isInternet) {
        _userDoc.set(newUser, SetOptions(merge: true));
        isSucces = true;
      }
    } catch (e) {
      requestFailureSnackbar("Something went wrong");
    }
    return isSucces;
  }

  static Future<Map<String, UserModel>> readAlluser() async {
    Map<String, UserModel> userMap = {};
    try {
      final bool isInternet = await checkInternet();
      if (isInternet) {
        DocumentSnapshot snapshot = await _userDoc.get();
        if (snapshot.data() != null) {
          final docData = snapshot.data() as Map<String, dynamic>;
          for (var entry in docData.entries) {
            userMap[entry.key] = UserModel.fromJson(entry.value);
          }
        }
      }
    } catch (e) {
      requestFailureSnackbar("Something went wrong");
    }
    return userMap;
  }

  static Future<bool> isAdminInfoPresentInFb(String email) async {
    bool isAdminInfoPresentInFb = false;
    try {
      final bool isInternet = await checkInternet();
      if (isInternet) {
        DocumentSnapshot snapshot = await _userDoc.get();
        if (snapshot.data() != null) {
          final docData = snapshot.data() as Map<String, dynamic>;
          if (docData.containsKey(email)) {
            isAdminInfoPresentInFb = true;
          }
        }
      }
    } catch (e) {
      requestFailureSnackbar("Something went wrong");
    }
    return isAdminInfoPresentInFb;
  }
}
