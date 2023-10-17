import 'dart:convert';
import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:neep/app/controllers/user_controller.dart';
import 'package:neep/app/model/post_model.dart';
import 'package:neep/app/services/firebase_service/post_service.dart';
import 'package:neep/app/services/firebase_service/user_service.dart';
import 'package:neep/app/services/firebase_storage_service.dart';
import 'package:neep/app/ui/widgets/dataloader.dart';
import 'package:uuid/uuid.dart';
import '../../utils/utils.dart';
import '../widgets/rounded_small_button.dart';
import 'package:path/path.dart' as path;

class AddPost extends StatefulWidget {
  const AddPost({Key? key}) : super(key: key);

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  final captionController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String usertoken = "";

  void requestPermission() async {
    print("hleo");
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("permission granted");
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print("provisional permission granted");
    } else {
      print("declined");
    }
  }

  initInfo() {
    var androidInitialize =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOSInitialize = const IOSInitializationSettings();
    var initializationSettings =
        InitializationSettings(android: androidInitialize, iOS: iOSInitialize);

    FlutterLocalNotificationsPlugin().initialize(initializationSettings,
        onSelectNotification: (String? payload) async {
      try {
        if (payload != null && payload.isNotEmpty) {
        } else {}
      } catch (e) {}
      return;
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print(
            'Message also contained a notification: ${message.notification!.title}');
      }

      BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
          message.notification!.body.toString(),
          htmlFormatBigText: true,
          contentTitle: message.notification!.titleLocKey.toString(),
          htmlFormatContentTitle: true);

      AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails('dbfood', 'dbfood',
              importance: Importance.high,
              styleInformation: bigTextStyleInformation,
              priority: Priority.high,
              playSound: true);

      NotificationDetails platformChannelSpecifics = NotificationDetails(
          android: androidPlatformChannelSpecifics,
          iOS: IOSNotificationDetails());

      await FlutterLocalNotificationsPlugin().show(
          0,
          message.notification!.title,
          message.notification!.body,
          platformChannelSpecifics,
          payload: message.data['body']);
    });
  }

  void getToken() async {
    await FirebaseMessaging.instance.getToken().then((token) {
      setState(() {
        usertoken = token!;
        print("token $usertoken");
      });
      saveToken(usertoken);
    });
  }

  void saveToken(String token) async {
    await FirebaseFirestore.instance
        .collection("user")
        .doc("user_name")
        .update({
          "token": token,
        })
        .then((value) => print("successfully updated"))
        .catchError((error) => print(error));
  }

  void sendPushMessage(String token, String title, String body) async {
    print(token);
    try {
      var res =
          await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
              headers: <String, String>{
                'Content-Type': 'application/json',
                'Authorization':
                    'key=AAAA6Xwnvh8:APA91bHVcfUXzTXXTixcfnRCF64J8-xVuwn8dwYMmY5DyJQ6TNodIWTsH9ULGesMyuWjXYw0Z7H0p62Uwmn4IYwkbMX9Aue8__GZO9Noaf7FH-OPdqpxeA0bPFNl9xgDx0XP9rT8OrF-',
              },
              body: jsonEncode(<String, dynamic>{
                'priority': 'high',
                'data': <String, dynamic>{
                  'click_action': 'FLUTTER_NOTIFICATION_CLICK',
                  'status': 'done',
                  'body': body,
                  'title': title,
                },
                "notification": <String, dynamic>{
                  'title': title,
                  'body': body,
                  'android_channel_id': "dbfood"
                },
                "to": token
              }));
      print(res);
      print('done');
    } catch (e) {
      if (kDebugMode) {
        print("error push noti");
      }
    }
  }

  @override
  void initState() {
    requestPermission();
    getToken();
    // initInfo();
    super.initState();
  }

  // final captionTextController = TextEditingController(text: "");
  List<File> mediaFiles = [];
  List<String> mediaFileUrls = [];

  @override
  void dispose() {
    super.dispose();
    captionController.dispose();
  }

  bool isLoading = false;
  void onPickImages() async {
    List<File> files = await pickMediaFiles();

    for (var file in files) {
      mediaFiles.add(file);
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.close, size: 30),
        ),
        actions: [
          RoundedSmallButton(
            onTap: () async {
              print("hleo");
              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: ((context) {
                    return WillPopScope(
                        onWillPop: () async {
                          return false;
                        },
                        child: const Center(
                          child: DataLoader(),
                        ));
                  }));

              if (mediaFiles.isNotEmpty) {
                var fileUrlList = [];
                for (var file in mediaFiles) {
                  final fileUrl = await FirebaseStorageService()
                      .uploadFileToFirebaseStorage(file.path);
                  if (fileUrl != null && fileUrl.isNotEmpty) {
                    fileUrlList.add(fileUrl);
                  }
                }
                if (fileUrlList.isNotEmpty) {
                  mediaFileUrls = [...fileUrlList];
                }
              }
              var res = await PostService.creatPost(
                PostModel(
                    postedBy: _auth.currentUser!.email.toString(),
                    createdAt: DateTime.now().toIso8601String(),
                    mediaUrl: mediaFileUrls,
                    caption: captionController.text,
                    postID: Uuid().v1()),
              );
              // PostService.creatPost(captionController.text, mediaFileUrls);

              Navigator.pop(context);

              if (res) {
                Navigator.pop(context);
              }

              // sendPushMessage(usertoken, "Check", "Hey, there!!!");
            },
            label: 'Add Post',
            backgroundColor: Color.fromARGB(255, 255, 249, 249),
            textColor: Color.fromARGB(255, 0, 0, 0),
          ),
        ],
      ),
      body: isLoading
          ? DataLoader()
          : SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      children: [
                        const SizedBox(width: 15),
                        Expanded(
                          child: TextField(
                            cursorColor: Colors.black,
                            controller: captionController,
                            style: const TextStyle(
                              fontSize: 22,
                            ),
                            decoration: const InputDecoration(
                              hintText: "Share your thought...",
                              hintStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                              ),
                              border: InputBorder.none,
                            ),
                            maxLines: null,
                          ),
                        ),
                      ],
                    ),
                    if (mediaFiles.isNotEmpty)
                      SizedBox(
                        width: size.width * .95,
                        child: CarouselSlider(
                          items: mediaFiles.map(
                            (file) {
                              return InkWell(
                                onLongPress: () {
                                  print("le");
                                  //To Do--> to make show dialog for conformation of image deletion
                                  // showDialog(
                                  //   context: context,
                                  //   builder: (context) {
                                  //     return AlertDialog(
                                  //       content: Text("Delete this Image?"),

                                  //     );
                                  //   },
                                  // );
                                  mediaFiles.remove(file);
                                  setState(() {});
                                },
                                child: Container(
                                  clipBehavior: Clip.hardEdge,
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 10),
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                    image: FileImage(file),
                                    fit: BoxFit.cover,
                                  )),
                                ),
                              );
                            },
                          ).toList(),
                          options: CarouselOptions(
                            clipBehavior: Clip.hardEdge,
                            scrollDirection: Axis.vertical,
                            height: size.height * .5,
                            enableInfiniteScroll: false,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(bottom: 10),
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Colors.blue,
              width: 0.3,
            ),
          ),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0).copyWith(
                left: 15,
                right: 15,
              ),
              child: GestureDetector(
                onTap: onPickImages,
                // child: SvgPicture.asset(AssetsConstants.galleryIcon),
                child: Icon(Icons.image),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0).copyWith(
                left: 15,
                right: 15,
              ),
              // child: SvgPicture.asset(AssetsConstants.gifIcon),
              child: GestureDetector(
                onTap: onPickImages,
                child: Icon(
                  Icons.gif,
                  size: 35,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
