import 'package:get/get.dart';
import 'package:neep/app/controllers/post_controller.dart';
import 'package:neep/app/controllers/post_controller2.dart';
import 'package:neep/app/controllers/user_controller.dart';
import 'package:neep/app/services/firebase_service/post_service.dart';
import 'package:neep/app/services/firebase_service/user_service.dart';

Future<void> initControllers() async {
  Get.lazyPut(() => UserController());
  Get.lazyPut(() => PostController());
}
