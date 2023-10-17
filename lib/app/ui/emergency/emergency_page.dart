import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:neep/app/ui/emergency/emergency_controller.dart';
import '../../../constants.dart';
import '../../hive/models/timeline_yt_local_model.dart';
import '../../services/analytics_service.dart';
import '../../services/routes_service.dart';
import '../journal/controller/journal_controller.dart';
import '../widgets/image_circular_loader.dart';
import '../widgets/video_list_screen.dart';
import 'camera_page.dart';

class EmergencyPage extends HookWidget {
  const EmergencyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final journalController = Get.put(JournalController());
    final emergencyController = Get.put(EmergencyController());
    final isEmergencyJournalAdded = emergencyController.isEmergencyJournalAdded;

    return Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Color(0xff0b0d0f),
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent, // <-- SEE HERE
            statusBarIconBrightness:
                Brightness.dark, //<-- For Android SEE HERE (dark icons)
            statusBarBrightness:
                Brightness.light, //<-- For iOS SEE HERE (dark icons)
          ),
          title: Text('EMERGENCY',
              style: Theme.of(context).textTheme.headlineMedium),
          centerTitle: true,
          elevation: 0.0,
          leading: BouncingWidget(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Icon(Icons.arrow_back)),
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
        ),
        body: ShaderMask(
          shaderCallback: (Rect bounds) {
            return LinearGradient(
              colors: [Colors.white, Colors.white.withOpacity(0.02)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.93, 1],
              tileMode: TileMode.mirror,
            ).createShader(bounds);
          },
          child: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                snap: false,
                pinned: true,
                floating: false,
                automaticallyImplyLeading: false,
                flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    title: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text('',
                          style: Theme.of(context).textTheme.headlineMedium),
                    ), //Text
                    background: CachedNetworkImage(
                      imageUrl: getRandomFromList(emergencyController.gifList),
                      placeholder: (context, url) => ImagePlaceHolder(),
                      fit: BoxFit.fill,
                    ) //Images.network
                    ), //FlexibleSpaceBar
                expandedHeight: 230,
                elevation: 5,
                backgroundColor: Color(0xff0b0d0f),
                systemOverlayStyle: SystemUiOverlayStyle(
                  statusBarColor: Colors.transparent, // <-- SEE HERE
                  statusBarIconBrightness:
                      Brightness.dark, //<-- For Android SEE HERE (dark icons)
                  statusBarBrightness:
                      Brightness.light, //<-- For iOS SEE HERE (dark icons)
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "EMERGENCY",
                        style: GoogleFonts.openSans(
                            fontSize: 12,
                            color: Color(0xffEE4D37).withOpacity(0.7),
                            letterSpacing: 3),
                      ),

                      // Text(
                      //   "CALM DOWN",
                      //   style: GoogleFonts.openSans(
                      //       fontSize: 12,
                      //       color: Color(0xffEE4D37).withOpacity(0.5),
                      //       letterSpacing: 3),
                      // ),
                    ],
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16),
                      child: emergencyCards[index]),
                  childCount: emergencyCards.length,
                ),
              ),
              SliverToBoxAdapter(
                child: Obx(() => Padding(
                      padding: const EdgeInsets.only(
                          left: 16, right: 12, top: 12, bottom: 40),
                      child: isEmergencyJournalAdded.value
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "AWESOME!\nADDED TO JOURNAL!!",
                                  style: GoogleFonts.openSans(
                                      fontSize: 12,
                                      color: Colors.green.withOpacity(0.6),
                                      letterSpacing: 3),
                                ),
                              ],
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "WHAT IS THE REASON FOR URGE?",
                                  style: GoogleFonts.openSans(
                                      fontSize: 12,
                                      color: Color(0xffEE4D37).withOpacity(0.6),
                                      letterSpacing: 3),
                                ),
                                TextField(
                                  controller: journalController
                                      .journalTextEditingController,
                                  onTap: () {
                                    AnalyticsService().logButtonTapped(
                                        buttonName: EMeRGENCY_URGE_REASON);
                                  },
                                  keyboardType: TextInputType.text,
                                  cursorColor:
                                      Color(0xffEE4D37).withOpacity(0.2),
                                  style: GoogleFonts.montserrat(
                                      color:
                                          Color(0xffEE4D37).withOpacity(0.5)),
                                  onSubmitted: (value) {
                                    journalController.saveJournal(
                                        tag: JOURNAL_TAGS.emergency);
                                    emergencyController.addEmergencyJournal();
                                  },
                                  decoration: InputDecoration(
                                      hintText: 'TAP HERE TO RECORD..✍️',
                                      hintStyle: GoogleFonts.openSans(
                                          fontSize: 12,
                                          color: Colors.green.withOpacity(0.6),
                                          letterSpacing: 3)),
                                ),
                              ],
                            ),
                    )),
              )
            ], //<Widget>[]
          ),
        ));
  }
}

List<Widget> emergencyCards = [
  EmergencyMotiveCard(),
  EmergencyMirrorCard(),
  EmergencyMusicCard(),
  BreathingCard(),
  ActionableSteps()
];

class EmergencyMotiveCard extends HookWidget {
  const EmergencyMotiveCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final emergencyController = Get.put(EmergencyController());
    useMemoized(() => {emergencyController.getUserMotive()});

    return Stack(
      children: [
        ContainerCard(
          parentColumnCrossAxisAlignment: CrossAxisAlignment.center,
          backgroundColor: hardColorsList[4],
          // bottomShadowColor: Colors.redAccent.withOpacity(0.3),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "SOMEONE SAID THIS...👇",
                style: GoogleFonts.openSans(
                    fontSize: 13, color: Colors.white, letterSpacing: 3),
              ),
              SizedBox(
                height: 16,
              ),
              Obx(() => Text(
                    emergencyController.userMotive.value,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                        fontSize: 15, color: Colors.white.withOpacity(0.7)),
                  )),
            ],
          ),
        ),
        Positioned(
          top: 0,
          right: 16,
          child: BouncingWidget(
            onPressed: () {
              AnalyticsService()
                  .logButtonTapped(buttonName: EMERGENCY_MOTIVE_EDIT);
              showMaterialModalBottomSheet(
                bounce: true,
                context: context,
                builder: (context) => SingleChildScrollView(
                  controller: ModalScrollController.of(context),
                  child: Container(
                    height: MediaQuery.of(context).size.height / 1.5,
                    color: Color(0xff0b0d0f),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 40,
                        ),
                        Text(
                          "CHANGE YOUR MOTIVE",
                          style: GoogleFonts.openSans(
                              fontSize: 12,
                              color: Color(0xffEE4D37).withOpacity(0.4),
                              letterSpacing: 3),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 16, right: 12, top: 12),
                          child: TextField(
                            controller:
                                emergencyController.motiveTextEditingController,
                            // controller:
                            //     quotesController.customQuoteTextController,
                            keyboardType: TextInputType.text,
                            autofocus: true,
                            // focusNode: focusNode,
                            style: GoogleFonts.montserrat(
                                color: Color(0xffEE4D37).withOpacity(0.5)),
                            decoration: InputDecoration(
                                hintText: 'MOTIVE',
                                counterStyle: Theme.of(context)
                                    .inputDecorationTheme
                                    .hintStyle
                                    ?.copyWith(fontSize: 12),
                                border: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xffEE4D37).withOpacity(0.5),
                                  ),
                                ),
                                hintStyle: GoogleFonts.openSans(
                                    fontSize: 12,
                                    color: Color(0xffEE4D37).withOpacity(0.6),
                                    letterSpacing: 3)),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: BouncingWidget(
                            onPressed: () {
                              if (emergencyController
                                  .motiveTextEditingController
                                  .value
                                  .text
                                  .isEmpty) {
                                return;
                              }
                              AnalyticsService().logButtonTapped(
                                  buttonName: EMERGENCY_MOTIVE_EDIT_SUCCESS);
                              emergencyController.setMotive();
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              width: 200,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Color(0xff0b0d0f),
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(8),
                                    topRight: Radius.circular(8)),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black,
                                      offset: Offset(4, 4),
                                      blurRadius: 10,
                                      spreadRadius: 1),
                                  BoxShadow(
                                      color: Colors.white.withOpacity(0.1),
                                      offset: Offset(-4, -4),
                                      blurRadius: 5,
                                      spreadRadius: 1)
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("DONE"),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
            duration: Duration(milliseconds: 100),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: 40,
                  child: Column(
                    children: [
                      Lottie.asset('assets/edit_animation.json',
                          reverse: true, repeat: false, height: 24),
                      Text(
                        "edit",
                        style: TextStyle(fontSize: 12, color: Colors.black),
                      )
                    ],
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.5),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(8),
                        bottomRight: Radius.circular(8)),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black,
                          offset: Offset(4, 4),
                          blurRadius: 15,
                          spreadRadius: 1),
                      // BoxShadow(
                      //     color: Colors.black.withOpacity(0.6),
                      //     offset: Offset(-4, -4),
                      //     blurRadius: 15,
                      //     spreadRadius: 1)
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class EmergencyMirrorCard extends StatelessWidget {
  const EmergencyMirrorCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        AnalyticsService().logButtonTapped(buttonName: EMERGENCY_LOOK_MIRROR);
        await availableCameras().then((value) => Navigator.push(context,
            MaterialPageRoute(builder: (_) => CameraPage(cameras: value))));
      },
      child: ContainerCard(
        parentColumnCrossAxisAlignment: CrossAxisAlignment.start,
        backgroundColor: hardColorsList[0],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "TAP TO LOOK IN THE MIRROR",
                  style: GoogleFonts.openSans(
                      fontSize: 12, color: Colors.white, letterSpacing: 3),
                ),
                Spacer(),
                Icon(
                  Icons.chevron_right,
                  size: 30,
                  color: Colors.white,
                ),
                // Lottie.network(
                //     "https://assets6.lottiefiles.com/packages/lf20_bS9j3g.json",
                //     fit: BoxFit.fill,
                //     height: 30)
              ],
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              "Look at the person in the mirror Tell them what you’re trying to achieve. This will give a sense of reality.",
              style: GoogleFonts.poppins(fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }
}

class EmergencyMusicCard extends StatelessWidget {
  const EmergencyMusicCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        AnalyticsService().logButtonTapped(buttonName: EMERGENCY_LISTEN_MUSIC);
        Get.to(YTVideoListScreen(
          videoList: motivationalMusicList,
        ));
      },
      child: ContainerCard(
        parentColumnCrossAxisAlignment: CrossAxisAlignment.start,
        backgroundColor: hardColorsList[1],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "LISTEN TO MOTIVATIONAL MUSIC",
                  style: GoogleFonts.openSans(
                      fontSize: 12, color: Colors.white, letterSpacing: 3),
                ),
                Spacer(),
                Icon(
                  Icons.headphones,
                  size: 30,
                  color: Colors.white,
                ),
                // Lottie.network(
                //     "https://assets6.lottiefiles.com/packages/lf20_bS9j3g.json",
                //     fit: BoxFit.fill,
                //     height: 30)
              ],
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              "Music can instantly change your mood. Tap to see list of curated music",
              style: GoogleFonts.poppins(fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }
}

class BreathingCard extends StatelessWidget {
  const BreathingCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        AnalyticsService()
            .logButtonTapped(buttonName: EMERGENCY_BREATING_EXERCISE);
        Get.toNamed(RoutesClass.emergencyBreathing);
      },
      child: FocusDetector(
        onVisibilityGained: () {
          AnalyticsService().logCardVisible(cardName: EMERGENCY_BREATING_CARD);
        },
        onVisibilityLost: () {
          AnalyticsService()
              .logCardInvisible(cardName: EMERGENCY_BREATING_CARD);
        },
        child: ContainerCard(
          parentColumnCrossAxisAlignment: CrossAxisAlignment.start,
          backgroundColor: hardColorsList[2],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    "TAP FOR BREATHING EXERCISE",
                    style: GoogleFonts.montserrat(
                        fontSize: 12,
                        color: Colors.white,
                        letterSpacing: 2,
                        fontWeight: FontWeight.w500),
                  ),
                  Spacer(),
                  Icon(
                    Icons.self_improvement,
                    size: 30,
                    color: Colors.white,
                  ),
                  // Lottie.network(
                  //     "https://assets6.lottiefiles.com/packages/lf20_bS9j3g.json",
                  //     fit: BoxFit.fill,
                  //     height: 30)
                ],
              ),
              SizedBox(
                height: 16,
              ),
              Text(
                "Tap to perform breathing exercise. It can divert attention from distracting thoughts, it reduces stress and anxiety.",
                style: GoogleFonts.montserrat(
                    fontSize: 15, color: Colors.white.withOpacity(0.5)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ActionableSteps extends StatelessWidget {
  const ActionableSteps({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FocusDetector(
      onVisibilityGained: () {
        AnalyticsService()
            .logCardVisible(cardName: EMERGENCY_ACTIONABLE_STEPS_CARD);
      },
      onVisibilityLost: () {
        AnalyticsService()
            .logCardInvisible(cardName: EMERGENCY_ACTIONABLE_STEPS_CARD);
      },
      child: ContainerCard(
        parentColumnCrossAxisAlignment: CrossAxisAlignment.start,
        backgroundColor: hardColorsList[3],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "MORE ACTIONABLE TIPS",
                  style: GoogleFonts.openSans(
                      fontSize: 12,
                      color: Colors.white,
                      letterSpacing: 3,
                      fontWeight: FontWeight.w500),
                ),

                // Lottie.network(
                //     "https://assets6.lottiefiles.com/packages/lf20_bS9j3g.json",
                //     fit: BoxFit.fill,
                //     height: 30)
              ],
            ),
            SizedBox(
              height: 16,
            ),
            for (int i = 0; i < _tipsList.length; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.star,
                      color: Colors.white70,
                      size: 12,
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Flexible(
                      child: Text(
                        _tipsList[i],
                        style: GoogleFonts.poppins(
                            fontSize: 15, color: Colors.white.withOpacity(0.6)),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class ContainerCard extends StatelessWidget {
  const ContainerCard(
      {Key? key,
      required this.child,
      required this.parentColumnCrossAxisAlignment,
      this.bottomShadowColor,
      required this.backgroundColor})
      : super(key: key);
  final Widget child;
  final CrossAxisAlignment parentColumnCrossAxisAlignment;
  final Color? bottomShadowColor;
  final Color backgroundColor;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: buttonTileDecoration(
          innerShadowColor: bottomShadowColor,
          backgroundColor: backgroundColor),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: parentColumnCrossAxisAlignment,
          children: [
            // Align(
            //   alignment: Alignment.topLeft,
            //   child: CircleAvatar(
            //     radius: 6,
            //     backgroundColor: Colors.redAccent.withOpacity(0.3),
            //     child: CircleAvatar(
            //       radius: 2,
            //       backgroundColor: Color(0xff0b0d0f),
            //     ),
            //   ),
            // ),
            // SizedBox(
            //   height: 20,
            // ),
            child
          ],
        ),
      ),
    );
  }
}

BoxDecoration buttonTileDecoration(
    {Color? innerShadowColor, Color? backgroundColor}) {
  return BoxDecoration(
    color: backgroundColor ?? Color(0xff0b0d0f),
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      stops: [0.1, 0.96],
      colors: [
        backgroundColor ?? Color(0xff0b0d0f),
        Color(0xff0b0d0f).withOpacity(0.9),
      ],
    ),
    borderRadius: BorderRadius.all(Radius.circular(8)),
    // boxShadow: [
    //   BoxShadow(
    //       color: innerShadowColor ?? Colors.black,
    //       offset: Offset(4, 4),
    //       blurRadius: 10,
    //       spreadRadius: 1),
    //   BoxShadow(
    //       color: Colors.white.withOpacity(0.1),
    //       offset: Offset(-4, -4),
    //       blurRadius: 4,
    //       spreadRadius: 1)
    // ],
  );
}

BoxDecoration containerNeumorphicDecoration(
    {Color? innerShadowColor, Color? backgroundColor}) {
  return BoxDecoration(
    color: backgroundColor ?? Color(0xff0b0d0f),
    borderRadius: BorderRadius.all(Radius.circular(8)),
    boxShadow: [
      BoxShadow(
          color: innerShadowColor ?? Colors.black,
          offset: Offset(4, 4),
          blurRadius: 10,
          spreadRadius: 1),
      BoxShadow(
          color: Colors.white.withOpacity(0.1),
          offset: Offset(-4, -4),
          blurRadius: 4,
          spreadRadius: 1)
    ],
  );
}

List<Youtube> motivationalMusicList = [
  Youtube(
      videoId: 'mk48xRzuNvA',
      videoTitle: 'The Script - Hall of Fame (Official Video) ft. will.i.am',
      videoAuthor: 'The Script'),
  Youtube(
      videoId: 'NH9JnRDyqmg',
      videoTitle: 'Till I Collapse - Anime Training Motivation',
      videoAuthor: 'Blizzforte'),
  Youtube(
      videoId: 'b8-2Hb1Y7QI',
      videoTitle: 'can you feel my heart?',
      videoAuthor: 'pyknic'),
  Youtube(
      videoId: 's19Fr-_WaXo',
      videoTitle: 'How Music Affects Your Brain',
      videoAuthor: 'BuzzFeedVideo'),
  Youtube(
      videoId: 'IPXIgEAGe4U',
      videoTitle: 'Panic! At The Disco - High Hopes (Official Video)',
      videoAuthor: 'Panic! At The Disco'),
  Youtube(
      videoId: 'Y4o_8zbelwY',
      videoTitle: 'Fall Out Boy - Immortals (from Big Hero 6)',
      videoAuthor: 'Fall Out Boy'),
  Youtube(
      videoId: 'oVbftx2nBh4',
      videoTitle: 'The Beauty Of The Batman',
      videoAuthor: 'The Beauty Of'),
  Youtube(
      videoId: '5JqY-6q-RNA',
      videoTitle: 'Fall Out Boy - THE PHOENIX (Kinetic Typography Lyrics)',
      videoAuthor: 'Kerry Paulazzo'),
  Youtube(
      videoId: '_PBlykN4KIY',
      videoTitle: 'The Score - Unstoppable (Lyric Video)',
      videoAuthor: 'The Score'),
  Youtube(
      videoId: 'aJ5IzGBnWAc',
      videoTitle: 'The Score - Born For This (Official Audio)',
      videoAuthor: 'The Score'),
  Youtube(
      videoId: 'nZFNut0RGlQ',
      videoTitle:
          '''Blackway & Black Caviar - "What's Up Danger" (Spider-Man: Into the Spider-Verse)''',
      videoAuthor: 'Republic Records'),
  Youtube(
      videoId: 'gOsM-DYAEhY',
      videoTitle: 'Imagine Dragons - Whatever It Takes (Official Music Video)',
      videoAuthor: 'ImagineDragons'),
  Youtube(
      videoId: 'D9G1VOjN_84',
      videoTitle:
          'Imagine Dragons x J.I.D - Enemy (from the series Arcane League of Legends)',
      videoAuthor: 'ImagineDragons'),
];

List<String> _tipsList = [
  "10 pushups now!",
  "Do yoga or stretching.",
  "Leave your room and go for a walk.",
  "Clean the house/apartment/room.",
  "Do not mindlessly surf the internet because you will eventually click on a trigger.",
  "Go to bed only when you are about to sleep. And Get out of bed immediately after waking.",
  "Remember why you are doing this."
      "Take cold shower or simply wash your face with cold water.",
  'Fall down. Get up.',
  'Fall down. Get up.',
  'Fall down. Get up. Stay up. Help others.',
  "Just tire your body until you don't feel like you need to fap. Urges actually will get stronger as you go on, but so will your self discipline increase if you don't give up. You will get better at dealing with it."
];
