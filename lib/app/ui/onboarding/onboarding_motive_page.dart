import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';
import 'package:lottie/lottie.dart';
import 'package:vibration/vibration.dart';

import '../../services/analytics_service.dart';
import '../../services/notification_service.dart';
import '../../services/routes_service.dart';
import '../bottom_nav_bar/bottom_nav_bar.dart';
import '../home/home_page.dart';
import '../widgets/no_beep_title.dart';
import 'controller/onboarding_controller.dart';

class OnboardingMotivePage extends StatelessWidget {
  const OnboardingMotivePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final storeController = Get.put(OnboardingController());
    final FocusNode focusNode = FocusNode();

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Color(0xffE0E3EB),
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent, // <-- SEE HERE
          statusBarIconBrightness:
              Brightness.dark, //<-- For Android SEE HERE (dark icons)
          statusBarBrightness:
              Brightness.light, //<-- For iOS SEE HERE (dark icons)
        ),
        title: NoBeepTitle(),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.transparent,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'btn2',

        label: Row(
          children: [
            Text(
              "Let's go 💪",
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Theme.of(context).backgroundColor),
            ),
            // SizedBox(
            //   width: 20,
            // ),
            // Icon(
            //   Icons.arrow_right_alt,
            //   color: Theme.of(context).backgroundColor,
            // ),
          ],
        ),

        shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.all(Radius.circular(1))), // isExtended: true,

        backgroundColor: Theme.of(context).colorScheme.primary,
        onPressed: () async {
          if (storeController.onboardingMotiveEditingController.value.text
              .trim()
              .isEmpty) {
            AnalyticsService().logButtonTapped(buttonName: ONBOARD_MOTIVE_HELP);

            Get.snackbar("Simply write down your goal.",
                "Something like--> I am doing this for saving time and energy to start a business",
                duration: Duration(seconds: 5));
            focusNode.requestFocus();
          } else {
            Vibration.vibrate(duration: 50);

            AnalyticsService()
                .logButtonTapped(buttonName: ONBOARD_MOTIVE_LETS_GO);

            await storeController.saveOnboardingDataInHive();
            Get.offAllNamed(RoutesClass.bottomNav,
                arguments: {'showFireAnimation': true});
          }
        },
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                  Theme.of(context).backgroundColor,
                  Theme.of(context).dialogBackgroundColor,
                ])),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  children: [
                    Lottie.asset('assets/blue-waves-animations.json',
                        reverse: true),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: kToolbarHeight + 32,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              "Your Motiv?🔥",
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 16, right: 12, top: 12),
                            child: TextField(
                              controller: storeController
                                  .onboardingMotiveEditingController,
                              keyboardType: TextInputType.multiline,
                              maxLength: 200,
                              maxLines: 10,
                              autofocus: true,
                              focusNode: focusNode,
                              style: Theme.of(context)
                                  .inputDecorationTheme
                                  .labelStyle,
                              decoration: InputDecoration(
                                  counter: SizedBox(),
                                  hintText:
                                      "What's your goal?\nWhy have you decided to start this journey?\nWriting it down will increase your chance of sucess.\nDont think too much. It can be changed later in the app :)",
                                  counterStyle: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: Color(0xff8081DB),
                                      fontWeight: FontWeight.normal),
                                  border: InputBorder.none,

                                  // border: UnderlineInputBorder(
                                  //   borderSide: BorderSide(
                                  //     color: Color(0xff8081DB),
                                  //   ),
                                  // ),
                                  hintStyle: GoogleFonts.poppins(
                                      fontSize: 20,
                                      color: Color(0xff98999B),
                                      fontWeight: FontWeight.normal)),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 500,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: BouncingWidget(
                    onPressed: () async {
                      if (storeController
                          .onboardingMotiveEditingController.value.text
                          .trim()
                          .isEmpty) {
                        AnalyticsService()
                            .logButtonTapped(buttonName: ONBOARD_MOTIVE_HELP);

                        Get.snackbar("Simply write down your goal.",
                            "Something like--> I am doing this for saving time and energy to start a business",
                            duration: Duration(seconds: 5));
                        focusNode.requestFocus();
                      } else {
                        AnalyticsService().logButtonTapped(
                            buttonName: ONBOARD_MOTIVE_LETS_GO);

                        await storeController.saveOnboardingDataInHive();

                        Get.offAllNamed(RoutesClass.bottomNav);
                      }
                      // storeController.switchHide();
                    },
                    duration: Duration(milliseconds: 50),
                    child: Container(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.topRight,
                              colors: [
                            Color(0xff8081DB),
                            Color(0xff8081DB),
                          ])),
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              storeController.onboardingMotiveEditingController
                                      .value.text
                                      .trim()
                                      .isNotEmpty
                                  ? "Let's go 💪"
                                  : "Help ?",
                              style: GoogleFonts.poppins(
                                  color: Colors.white, fontSize: 20),
                            ),
                            Visibility(
                              visible: storeController
                                  .onboardingMotiveEditingController.value.text
                                  .trim()
                                  .isNotEmpty,
                              child: SizedBox(
                                width: 20,
                              ),
                            ),
                            Visibility(
                              visible: storeController
                                  .onboardingMotiveEditingController.value.text
                                  .trim()
                                  .isNotEmpty,
                              child: Icon(
                                Icons.arrow_right_alt,
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),

            // Align(
            //   alignment: Alignment.centerRight,
            //   child: BouncingWidget(
            //     onPressed: () {
            //       storeController.switchHide();
            //     },
            //     duration: Duration(milliseconds: 50),
            //     child: Container(
            //       decoration: BoxDecoration(
            //           gradient: LinearGradient(
            //               begin: Alignment.topLeft,
            //               end: Alignment.topRight,
            //               colors: [
            //             Color(0xff8081DB),
            //             Color(0xff8081DB),
            //           ])),
            //       child: Padding(
            //         padding:
            //             EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            //         child: Row(
            //           mainAxisSize: MainAxisSize.min,
            //           children: [
            //             Text(
            //               "Invincible",
            //               style: GoogleFonts.poppins(
            //                   color: Colors.white, fontSize: 20),
            //             ),
            //             SizedBox(
            //               width: 20,
            //             ),
            //             Icon(
            //               Icons.arrow_right_alt,
            //               color: Colors.white,
            //             )
            //           ],
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
          ),
        ),
      ),
    );
  }
}
