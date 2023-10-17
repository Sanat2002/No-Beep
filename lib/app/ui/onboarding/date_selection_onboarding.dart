import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:neep/app/services/analytics_service.dart';
import 'package:neep/app/services/routes_service.dart';
import 'package:neep/app/ui/onboarding/onboarding_motive_page.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:vibration/vibration.dart';
import '../../streak_controller.dart';
import '../widgets/no_beep_title.dart';
import 'controller/onboarding_controller.dart';

class OnboardingDateSelectionPage extends HookWidget {
  const OnboardingDateSelectionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final storeController = Get.put(OnboardingController());
    final FocusNode focusNode = FocusNode();
    final streakController = Get.put(StreakController());

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Theme.of(context).backgroundColor,
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
      floatingActionButton: Wrap(
        crossAxisAlignment: WrapCrossAlignment.end,
        direction: Axis.vertical,
        children: [
          FloatingActionButton.extended(
            heroTag: 'btn1',
            elevation: 0,
            label: Row(
              children: [
                Text(
                  "No, I'll pick a date.",
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

            backgroundColor:
                Theme.of(context).colorScheme.primary.withOpacity(0.4),
            onPressed: () {
              AnalyticsService()
                  .logButtonTapped(buttonName: START_STREAK_PICK_DATE);
              showMaterialModalBottomSheet(
                bounce: true,
                context: context,
                builder: (context) => SingleChildScrollView(
                  controller: ModalScrollController.of(context),
                  child: Container(
                    height: MediaQuery.of(context).size.height / 2,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 16, right: 12, top: 4),
                          child: storeController.hide.value
                              ? SizedBox()
                              : Text("What's your current day count?",
                                  style:
                                      Theme.of(context).textTheme.bodyMedium),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 16, right: 12, top: 12),
                          child: TextField(
                            controller: storeController
                                .onboardingCustomDayCountEditingController,
                            keyboardType: TextInputType.number,
                            maxLength: 4,
                            maxLines: 1,
                            autofocus: true,
                            focusNode: focusNode,
                            style: Theme.of(context)
                                .inputDecorationTheme
                                .labelStyle,
                            decoration: InputDecoration(
                                hintText: '15?',
                                counterStyle: Theme.of(context)
                                    .inputDecorationTheme
                                    .hintStyle
                                    ?.copyWith(fontSize: 12),
                                border: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xff8081DB),
                                  ),
                                ),
                                hintStyle: Theme.of(context)
                                    .inputDecorationTheme
                                    .hintStyle),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: BouncingWidget(
                            onPressed: () {
                              AnalyticsService().logButtonTapped(
                                  buttonName: ONBOARD_STREAK_CUSTOM_DAY_DONE);

                              if (storeController
                                  .onboardingCustomDayCountEditingController
                                  .value
                                  .text
                                  .isNotEmpty) {
                                bool isSucess =
                                    streakController.setStreakDurationByDays(
                                        numberOfDays: storeController
                                            .onboardingCustomDayCountEditingController
                                            .value
                                            .text);
                                if (isSucess) {
                                  Navigator.of(context).pop();
                                } else {
                                  Get.snackbar(
                                    "BEEP BEEP!",
                                    "Please enter a valid number without '.' or ','.\nThe days should be less than 500.\nEg: 32",
                                    snackPosition: SnackPosition.TOP,
                                    backgroundColor: Color(0xff8081DB),
                                    borderRadius: 15,
                                    margin: EdgeInsets.all(15),
                                    colorText: Colors.white,
                                    duration: Duration(seconds: 4),
                                    isDismissible: true,
                                    dismissDirection:
                                        DismissDirection.horizontal,
                                    forwardAnimationCurve: Curves.bounceIn,
                                  );
                                }
                              } else {}
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
                                padding: EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 8),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // Obx(() => CircularPercentIndicator(
                                    //       radius: 20,
                                    //       lineWidth: 4,
                                    //       restartAnimation: true,
                                    //       animation: true,
                                    //       animateFromLastPercent: true,
                                    //       animationDuration: 1200,
                                    //       percent:
                                    //           storeController.getStreakPercent(),
                                    //       center: Text(
                                    //           storeController
                                    //               .streakDuration.value.inSeconds
                                    //               .toString(),
                                    //           style: GoogleFonts.poppins(
                                    //               fontSize: 16,
                                    //               fontWeight: FontWeight.bold)),
                                    //       backgroundColor:
                                    //           Colors.white.withOpacity(0.3),
                                    //       circularStrokeCap:
                                    //           CircularStrokeCap.round,
                                    //       progressColor: Colors.white,
                                    //     )),
                                    storeController
                                            .onboardingCustomDayCountEditingController
                                            .value
                                            .text
                                            .isNotEmpty
                                        ? Text(
                                            "${storeController.onboardingCustomDayCountEditingController.value.text} days 🔥",
                                            style: GoogleFonts.poppins(
                                                color: Colors.white,
                                                fontSize: 20),
                                          )
                                        : Text(
                                            "Enter day count.",
                                            style: GoogleFonts.poppins(
                                                color: Colors.white,
                                                fontSize: 20),
                                          ),
                                    Visibility(
                                      visible: storeController
                                          .onboardingCustomDayCountEditingController
                                          .value
                                          .text
                                          .trim()
                                          .isNotEmpty,
                                      child: SizedBox(
                                        width: 20,
                                      ),
                                    ),
                                    Visibility(
                                      visible: storeController
                                          .onboardingCustomDayCountEditingController
                                          .value
                                          .text
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
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: FloatingActionButton.extended(
              heroTag: 'btn2',

              label: Row(
                children: [
                  Text(
                    "Yes, start my streak now!",
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: Theme.of(context).backgroundColor),
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Icon(
                    Icons.arrow_right_alt,
                    color: Theme.of(context).backgroundColor,
                  ),
                ],
              ),

              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                      Radius.circular(1))), // isExtended: true,

              backgroundColor: Theme.of(context).colorScheme.primary,
              onPressed: () {
                Vibration.vibrate(duration: 50);

                AnalyticsService()
                    .logButtonTapped(buttonName: START_STREAK_NOW);

                Get.toNamed(RoutesClass.onboardingMotivepage);
              },
            ),
          ),
        ],
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
            child: Stack(
              children: [
                Lottie.asset('assets/blue-waves-animations.json',
                    reverse: true),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: kToolbarHeight + 32,
                    ),
                    Obx(() => Center(
                          child: CircularPercentIndicator(
                            radius: 80,
                            lineWidth: 8,
                            restartAnimation: true,
                            animation: true,
                            animateFromLastPercent: true,
                            animationDuration: 1200,
                            percent: streakController.getStreakPercent(),
                            center: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  streakController
                                      .getStreakCounterValue()
                                      .toString(),
                                  style: GoogleFonts.oswald(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                                Text(
                                    streakController.getStreakCounterSubtitle(),
                                    style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff98999B)
                                            .withOpacity(0.3))),
                              ],
                            ),
                            backgroundColor: Color(0xff8081DB).withOpacity(0.2),
                            circularStrokeCap: CircularStrokeCap.round,
                            progressColor: Color(0xff8081DB),
                          ),
                        )),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: kToolbarHeight + 32,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12),
                                    child: Text("Start your streak from day 0?",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 16, right: 12, top: 4),
                                    child: storeController.hide.value
                                        ? SizedBox()
                                        : Text(
                                            "Do you wish to start your streak from day 0? \nThis can be changed later in the app.",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium,
                                          ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 400,
                        )
                        // Align(
                        //   alignment: Alignment.centerRight,
                        //   child: BouncingWidget(
                        //     onPressed: () {
                        //       AnalyticsService().logButtonTapped(
                        //           buttonName: START_STREAK_PICK_DATE);
                        //       showMaterialModalBottomSheet(
                        //         bounce: true,
                        //         context: context,
                        //         builder: (context) => SingleChildScrollView(
                        //           controller: ModalScrollController.of(context),
                        //           child: Container(
                        //             height:
                        //                 MediaQuery.of(context).size.height / 2,
                        //             child: Column(
                        //               mainAxisSize: MainAxisSize.min,
                        //               crossAxisAlignment:
                        //                   CrossAxisAlignment.start,
                        //               children: [
                        //                 Padding(
                        //                   padding: const EdgeInsets.only(
                        //                       left: 16, right: 12, top: 4),
                        //                   child: storeController.hide.value
                        //                       ? SizedBox()
                        //                       : Text(
                        //                           "What's your current day count?",
                        //                           style: Theme.of(context)
                        //                               .textTheme
                        //                               .bodyMedium),
                        //                 ),
                        //                 Padding(
                        //                   padding: const EdgeInsets.only(
                        //                       left: 16, right: 12, top: 12),
                        //                   child: TextField(
                        //                     controller: storeController
                        //                         .onboardingCustomDayCountEditingController,
                        //                     keyboardType: TextInputType.number,
                        //                     maxLength: 4,
                        //                     maxLines: 1,
                        //                     autofocus: true,
                        //                     focusNode: focusNode,
                        //                     style: Theme.of(context)
                        //                         .inputDecorationTheme
                        //                         .labelStyle,
                        //                     decoration: InputDecoration(
                        //                         hintText: '15?',
                        //                         counterStyle: Theme.of(context)
                        //                             .inputDecorationTheme
                        //                             .hintStyle
                        //                             ?.copyWith(fontSize: 12),
                        //                         border: UnderlineInputBorder(
                        //                           borderSide: BorderSide(
                        //                             color: Color(0xff8081DB),
                        //                           ),
                        //                         ),
                        //                         hintStyle: Theme.of(context)
                        //                             .inputDecorationTheme
                        //                             .hintStyle),
                        //                   ),
                        //                 ),
                        //                 SizedBox(
                        //                   height: 20,
                        //                 ),
                        //                 Align(
                        //                   alignment: Alignment.bottomRight,
                        //                   child: BouncingWidget(
                        //                     onPressed: () {
                        //                       AnalyticsService().logButtonTapped(
                        //                           buttonName:
                        //                               ONBOARD_STREAK_CUSTOM_DAY_DONE);

                        //                       if (storeController
                        //                           .onboardingCustomDayCountEditingController
                        //                           .value
                        //                           .text
                        //                           .isNotEmpty) {
                        //                         bool isSucess = streakController
                        //                             .setStreakDurationByDays(
                        //                                 numberOfDays:
                        //                                     storeController
                        //                                         .onboardingCustomDayCountEditingController
                        //                                         .value
                        //                                         .text);
                        //                         if (isSucess) {
                        //                           Navigator.of(context).pop();
                        //                         } else {
                        //                           Get.snackbar(
                        //                             "BEEP BEEP!",
                        //                             "Please enter a valid number without '.' or ','.\nThe days should be less than 500.\nEg: 32",
                        //                             snackPosition:
                        //                                 SnackPosition.TOP,
                        //                             backgroundColor:
                        //                                 Color(0xff8081DB),
                        //                             borderRadius: 15,
                        //                             margin: EdgeInsets.all(15),
                        //                             colorText: Colors.white,
                        //                             duration:
                        //                                 Duration(seconds: 4),
                        //                             isDismissible: true,
                        //                             dismissDirection:
                        //                                 DismissDirection
                        //                                     .horizontal,
                        //                             forwardAnimationCurve:
                        //                                 Curves.bounceIn,
                        //                           );
                        //                         }
                        //                       } else {}
                        //                       // storeController.switchHide();
                        //                     },
                        //                     duration:
                        //                         Duration(milliseconds: 50),
                        //                     child: Container(
                        //                       decoration: BoxDecoration(
                        //                           gradient: LinearGradient(
                        //                               begin: Alignment.topLeft,
                        //                               end: Alignment.topRight,
                        //                               colors: [
                        //                             Color(0xff8081DB),
                        //                             Color(0xff8081DB),
                        //                           ])),
                        //                       child: Padding(
                        //                         padding: EdgeInsets.symmetric(
                        //                             vertical: 12,
                        //                             horizontal: 8),
                        //                         child: Row(
                        //                           mainAxisSize:
                        //                               MainAxisSize.min,
                        //                           children: [
                        //                             // Obx(() => CircularPercentIndicator(
                        //                             //       radius: 20,
                        //                             //       lineWidth: 4,
                        //                             //       restartAnimation: true,
                        //                             //       animation: true,
                        //                             //       animateFromLastPercent: true,
                        //                             //       animationDuration: 1200,
                        //                             //       percent:
                        //                             //           storeController.getStreakPercent(),
                        //                             //       center: Text(
                        //                             //           storeController
                        //                             //               .streakDuration.value.inSeconds
                        //                             //               .toString(),
                        //                             //           style: GoogleFonts.poppins(
                        //                             //               fontSize: 16,
                        //                             //               fontWeight: FontWeight.bold)),
                        //                             //       backgroundColor:
                        //                             //           Colors.white.withOpacity(0.3),
                        //                             //       circularStrokeCap:
                        //                             //           CircularStrokeCap.round,
                        //                             //       progressColor: Colors.white,
                        //                             //     )),
                        //                             storeController
                        //                                     .onboardingCustomDayCountEditingController
                        //                                     .value
                        //                                     .text
                        //                                     .isNotEmpty
                        //                                 ? Text(
                        //                                     "${storeController.onboardingCustomDayCountEditingController.value.text} days 🔥",
                        //                                     style: GoogleFonts
                        //                                         .poppins(
                        //                                             color: Colors
                        //                                                 .white,
                        //                                             fontSize:
                        //                                                 20),
                        //                                   )
                        //                                 : Text(
                        //                                     "Enter day count.",
                        //                                     style: GoogleFonts
                        //                                         .poppins(
                        //                                             color: Colors
                        //                                                 .white,
                        //                                             fontSize:
                        //                                                 20),
                        //                                   ),
                        //                             Visibility(
                        //                               visible: storeController
                        //                                   .onboardingCustomDayCountEditingController
                        //                                   .value
                        //                                   .text
                        //                                   .trim()
                        //                                   .isNotEmpty,
                        //                               child: SizedBox(
                        //                                 width: 20,
                        //                               ),
                        //                             ),
                        //                             Visibility(
                        //                               visible: storeController
                        //                                   .onboardingCustomDayCountEditingController
                        //                                   .value
                        //                                   .text
                        //                                   .trim()
                        //                                   .isNotEmpty,
                        //                               child: Icon(
                        //                                 Icons.arrow_right_alt,
                        //                                 color: Colors.white,
                        //                               ),
                        //                             )
                        //                           ],
                        //                         ),
                        //                       ),
                        //                     ),
                        //                   ),
                        //                 ),
                        //               ],
                        //             ),
                        //           ),
                        //         ),
                        //       );
                        //     },
                        //     duration: Duration(milliseconds: 50),
                        //     child: Container(
                        //       color: Theme.of(context)
                        //           .colorScheme
                        //           .primary
                        //           .withOpacity(0.3),
                        //       child: Padding(
                        //         padding: EdgeInsets.symmetric(
                        //             vertical: 12, horizontal: 8),
                        //         child: Row(
                        //           mainAxisSize: MainAxisSize.min,
                        //           children: [
                        //             Text(
                        //               "  No, I'll pick a date.",
                        //               style: GoogleFonts.poppins(
                        //                   color:
                        //                       Theme.of(context).backgroundColor,
                        //                   fontSize: 20),
                        //             ),
                        //             Visibility(
                        //               visible: storeController
                        //                   .onboardingCustomDayCountEditingController
                        //                   .value
                        //                   .text
                        //                   .trim()
                        //                   .isNotEmpty,
                        //               child: SizedBox(
                        //                 width: 20,
                        //               ),
                        //             ),
                        //             Visibility(
                        //               visible: storeController
                        //                   .onboardingCustomDayCountEditingController
                        //                   .value
                        //                   .text
                        //                   .trim()
                        //                   .isNotEmpty,
                        //               child: Icon(
                        //                 Icons.arrow_right_alt,
                        //                 color:
                        //                     Theme.of(context).backgroundColor,
                        //               ),
                        //             )
                        //           ],
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        // SizedBox(
                        //   height: 20,
                        // ),
                        // Align(
                        //   alignment: Alignment.centerRight,
                        //   child: Column(
                        //     crossAxisAlignment: CrossAxisAlignment.end,
                        //     children: [
                        //       BouncingWidget(
                        //         onPressed: () {
                        //           AnalyticsService().logButtonTapped(
                        //               buttonName: START_STREAK_NOW);

                        //           Get.toNamed(RoutesClass.onboardingMotivepage);
                        //         },
                        //         duration: Duration(milliseconds: 50),
                        //         child: Container(
                        //           color: Theme.of(context).colorScheme.primary,
                        //           child: Padding(
                        //             padding: EdgeInsets.symmetric(
                        //                 vertical: 12, horizontal: 8),
                        //             child: Row(
                        //               mainAxisSize: MainAxisSize.min,
                        //               children: [
                        //                 // Obx(() => CircularPercentIndicator(
                        //                 //       radius: 20,
                        //                 //       lineWidth: 4,
                        //                 //       restartAnimation: true,
                        //                 //       animation: true,
                        //                 //       animateFromLastPercent: true,
                        //                 //       animationDuration: 1200,
                        //                 //       percent:
                        //                 //           storeController.getStreakPercent(),
                        //                 //       center: Text(
                        //                 //           storeController
                        //                 //               .streakDuration.value.inSeconds
                        //                 //               .toString(),
                        //                 //           style: GoogleFonts.poppins(
                        //                 //               fontSize: 16,
                        //                 //               fontWeight: FontWeight.bold)),
                        //                 //       backgroundColor:
                        //                 //           Colors.white.withOpacity(0.3),
                        //                 //       circularStrokeCap:
                        //                 //           CircularStrokeCap.round,
                        //                 //       progressColor: Colors.white,
                        //                 //     )),
                        //                 Text(
                        //                   "  Yes, start my streak now!",
                        //                   style: GoogleFonts.poppins(
                        //                       color: Colors.white,
                        //                       fontSize: 20),
                        //                 ),
                        //                 Visibility(
                        //                   visible: storeController
                        //                       .onboardingCustomDayCountEditingController
                        //                       .value
                        //                       .text
                        //                       .trim()
                        //                       .isNotEmpty,
                        //                   child: SizedBox(
                        //                     width: 20,
                        //                   ),
                        //                 ),
                        //                 Visibility(
                        //                   visible: storeController
                        //                       .onboardingCustomDayCountEditingController
                        //                       .value
                        //                       .text
                        //                       .trim()
                        //                       .isNotEmpty,
                        //                   child: Icon(
                        //                     Icons.arrow_right_alt,
                        //                     color: Colors.white,
                        //                   ),
                        //                 )
                        //               ],
                        //             ),
                        //           ),
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // )
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
