import 'package:get/get.dart';
import 'package:neep/app/model/user_model.dart';
import 'package:neep/app/services/firebase_service/user_service.dart';
import 'package:neep/app/utils/utils.dart';

class UserController extends GetxController {
  UserController() {
    loadAdminUserData();
  }

  static UserController get instance => Get.find<UserController>();

  RxMap<String, UserModel> _adminUserMap = <String, UserModel>{}.obs;
  UserModel? getUserData(String email) => _adminUserMap[email];
  void setAdminUserMap(Map<String, UserModel> newEntries) {
    _adminUserMap.addAll(newEntries);
  }

  RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;
  setIsLoading(bool isLoading) {
    _isLoading.value = isLoading;
  }

  loadAdminUserData() async {
    setIsLoading(true);
    try {
      final userData = await UserService.readAlluser();
      setAdminUserMap(userData);
    } catch (e) {
      requestFailureSnackbar("Something Went Wrong");
    }
    setIsLoading(false);
    // print(_adminUserMap);
  }
}
