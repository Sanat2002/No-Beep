import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';
import 'package:neep/app/ui/home/controller/badge_controller.dart';
import 'package:neep/app/ui/home/home_badge.dart';
import 'package:vibration/vibration.dart';
import '../../services/analytics_service.dart';
import '../emergency/emergency_controller.dart';

class NewBadgePage extends HookWidget {
  const NewBadgePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FocusNode focusNode = FocusNode();
    final _confettiController = ConfettiController();
    final Color bgColor = Color.fromARGB(255, 91, 92, 186);

    BadgeModel? badge;

    useMemoized(() {
      _confettiController.duration = Duration(seconds: 5);
      _confettiController.play();
      // _createRewardedAd();

      if (Get.arguments != null && Get.arguments['badge'] != null) {
        badge = badgeMap[Get.arguments['badge']];
      } else {
        badge = badgeMap['kid'];
      }
    });

    return Scaffold(
        extendBodyBehindAppBar: true,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent, // <-- SEE HERE
            statusBarIconBrightness:
                Brightness.dark, //<-- For Android SEE HERE (dark icons)
            statusBarBrightness:
                Brightness.light, //<-- For iOS SEE HERE (dark icons)
          ),
          title: Text(
            "NEW BADGE ACHIEVED!! 🙌",
            style: GoogleFonts.openSans(
                fontSize: 15, color: Colors.white, letterSpacing: 3),
          ),
          backgroundColor: Colors.transparent,
          centerTitle: true,
          elevation: 0.0,
          automaticallyImplyLeading: false,
        ),
        floatingActionButton: SizedBox(
          width: MediaQuery.of(context).size.width - 200,
          child: FloatingActionButton(
            shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.all(Radius.circular(10))), // isExtended: true,
            child: Text("BACK",
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 15,
                    letterSpacing: 2,
                    fontWeight: FontWeight.w600)),

            backgroundColor: bgColor,
            onPressed: () {
              AnalyticsService().logButtonTapped(buttonName: NEW_BADGE_BACK);

              Vibration.vibrate(duration: 50);
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.1, 0.96],
              colors: [
                bgColor,
                Colors.black,
              ],
            ),
          ),
          child: ShaderMask(
            shaderCallback: (Rect bounds) {
              return LinearGradient(
                colors: [Colors.white, Colors.white.withOpacity(0.02)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.93, 1],
                tileMode: TileMode.mirror,
              ).createShader(bounds);
            },
            child: SingleChildScrollView(
              child: Stack(
                children: [
                  Column(
                    children: [
                      SizedBox(height: kToolbarHeight + 60),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Material(
                            elevation: 5,
                            child: BadgeCardWidget(
                              badge: badge!,
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: BadgeWidget(
                          gifLink: getRandomFromList(badge?.gifList) ??
                              badge!.badgeImgUrl ??
                              'https://media.tenor.com/rOOFTXXw5QEAAAAC/loading-gun-loading.gif',
                        ),
                      ),
                      SizedBox(
                        height: 200,
                      )
                    ],
                  ),
                  Center(
                    child: ConfettiWidget(
                      confettiController: _confettiController,
                      blastDirection: -pi / 2,
                      numberOfParticles: 13,
                      emissionFrequency: 0.1,
                      blastDirectionality: BlastDirectionality.explosive,
                      colors: [
                        Color(0xffac7e3e),
                        Colors.orangeAccent,
                        Colors.white,
                        Colors.red,
                        bgColor
                      ],
                      gravity: 0.1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ) //C Container(

        );
  }
}

class BadgeCardWidget extends StatelessWidget {
  const BadgeCardWidget({Key? key, required this.badge}) : super(key: key);
  final BadgeModel badge;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color(0xffD5D8D3),
        image: DecorationImage(
            fit: BoxFit.cover,
            filterQuality: FilterQuality.low,
            image: CachedNetworkImageProvider(
              'https://images.unsplash.com/photo-1601662528567-526cd06f6582?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1015&q=80',
            )),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(8),
            color: Color.fromARGB(255, 91, 92, 186).withOpacity(0.2),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                "${badge.badgeDisplay}",
                style: GoogleFonts.dellaRespira(
                    fontSize: 18,
                    color: Color(0xffDAA520),
                    fontWeight: FontWeight.w600,
                    letterSpacing: 10),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Align(
            child: Text(
              getDateString(badge: badge),
              style: GoogleFonts.raleway(
                  fontSize: 15,
                  color: Color(0xffDAA520),
                  fontWeight: FontWeight.w500,
                  letterSpacing: 3),
            ),
          )
        ],
      ),
    );
  }
}

// class AntiGravityUfo extends StatefulWidget {
//   @override
//   _AntiGravityUfoState createState() => _AntiGravityUfoState();
// }

// class _AntiGravityUfoState extends State<AntiGravityUfo>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<Offset> _animation;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: Duration(seconds: 2),
//       vsync: this,
//     )..repeat(reverse: true);
//     _animation = Tween<Offset>(
//       begin: Offset(0, 0),
//       end: Offset(0, -0.05),
//     ).animate(CurvedAnimation(
//       parent: _controller,
//       curve: Curves.easeInOut,
//     ));
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SlideTransition(
//       position: _animation,
//       child: Material(elevation: 6, child: BadgeCardWidget()),
//     );
//   }
// }
