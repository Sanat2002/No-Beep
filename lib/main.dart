import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:neep/app/init_controllers.dart';
import 'package:neep/app/services/analytics_service.dart';
import 'package:neep/app/services/dynamic_link_service.dart';
import 'package:neep/app/services/routes_service.dart';
import 'package:neep/app/services/shared_pref_service.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:path_provider/path_provider.dart';
import 'app/hive/hive_boxes.dart';
import 'app/hive/models/journal_local_model.dart';
import 'app/hive/models/local_reset_model.dart';
import 'app/hive/models/local_user_model.dart';
import 'app/hive/models/quotes_hive_model.dart';
import 'app/hive/models/timeline_local_model.dart';
import 'app/hive/models/timeline_yt_local_model.dart';
import 'app/services/notification_service.dart';
import 'app/ui/bottom_nav_bar/bottom_nav_bar_controller.dart';
import 'app/ui/theme.dart';
import 'package:hive/hive.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("this is backgrond message ${message.messageId}");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp();
  await FirebaseMessaging.instance.getInitialMessage();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await _initHive();
  await initControllers();
  AnalyticsService().initAmplitude();
  AdminData.isAdminRegInFB =
      await SharedPrefService.getBool("IS_ADMIN_REG_IN_FB");
  // print(AdminData.isAdminRegInFB);

  DynamicLinkService().handleDynamicLinks();

  runApp(MyApp());
}

class MyApp extends HookWidget {
  MyApp({Key? key}) : super(key: key);
  late final LocalNotificationService service;
  final userDataBox = HiveBoxes.getUserHiveBox();

  final User? isAdminSignedIn = FirebaseAuth.instance.currentUser;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final bottomNavController = Get.put(BottomNavController());

    final isUserPresent = userDataBox.get("local_user") != null &&
            userDataBox.get("local_user")!.userMotive.isNotEmpty
        ? true
        : false;

    void onClickedNotification(String? payload) {
      Logger().wtf(payload);
      int bottomNavIndex = 0;
      if (payload != null) {
        AnalyticsService()
            .logNotificationTappedAction(actionName: 'payload:${payload}');

        if (payload == 'home') {
          return;
        } else if (payload == 'emergency') {
          Get.toNamed(RoutesClass.emergencyPage);
          return;
        } else if (payload == 'quotes') {
          bottomNavIndex = 2;
        } else if (payload == 'journal') {
          bottomNavIndex = 1;
        } else if (payload == 'timeline') {
          bottomNavIndex = 3;
        }
        bottomNavController.changeBottomNavIndex(index: bottomNavIndex);
      }
    }

    void listenNotification() =>
        service.onNotificationClick.stream.listen(onClickedNotification);
    useMemoized(() {
      service = LocalNotificationService();
      service.intialize();
      listenNotification();
    });

    return OverlaySupport(
      child: GetMaterialApp(
        title: 'NoBeep',
        theme: Themes.light,
        debugShowCheckedModeBanner: false,
        // initialRoute: isUserPresent
        //         ? RoutesClass.addpost
        // : RoutesClass.intro,
        initialRoute: isAdminSignedIn != null
            ? (AdminData.isAdminRegInFB
                ? (isUserPresent ? RoutesClass.bottomNav : RoutesClass.intro)
                : RoutesClass.register)
            : RoutesClass.login,

        getPages: RoutesClass.routes,
      ),
    );
  }
}

Future? _initHive() async {
  await getApplicationDocumentsDirectory().then((dir) {
    Hive
      ..init(dir.path)
      ..registerAdapter(LocalUserModelAdapter())
      ..registerAdapter(QuotesLocalModelAdapter())
      ..registerAdapter(TimeLineDataAdapter())
      ..registerAdapter(YoutubeAdapter())
      ..registerAdapter(ResetLocalModelAdapter())
      ..registerAdapter(JournalLocalModelAdapter());
  });

  await Hive.openBox<LocalUserModel>('local_user');
  await Hive.openBox<QuotesLocalModel>('local_quotes');
  await Hive.openBox<QuotesLocalModel>('relapse_local_quotes');
  await Hive.openBox<TimeLineData>('local_timeline');
  await Hive.openBox<ResetLocalModel>('local_reset');
  await Hive.openBox<JournalLocalModel>('local_journal');
}

class AdminData {
  static bool _isAdminRegInFB = false;

  static bool get isAdminRegInFB => _isAdminRegInFB;
  static set isAdminRegInFB(bool isReg) {
    _isAdminRegInFB = isReg;
  }
}
