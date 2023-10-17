// import 'package:bouncing_widget/bouncing_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:percent_indicator/circular_percent_indicator.dart';

// import 'controller/onboarding_controller.dart';

// class OnboardingThemeSelectionPage extends StatelessWidget {
//   const OnboardingThemeSelectionPage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final storeController = Get.put(OnboardingController());
//     final FocusNode focusNode = FocusNode();

//     return Obx(() => Scaffold(
//           extendBodyBehindAppBar: true,
//           backgroundColor: Color(0xffE0E3EB),
//           appBar: AppBar(
//             systemOverlayStyle: SystemUiOverlayStyle(
//               statusBarColor: Colors.transparent, // <-- SEE HERE
//               statusBarIconBrightness:
//                   Brightness.dark, //<-- For Android SEE HERE (dark icons)
//               statusBarBrightness:
//                   Brightness.light, //<-- For iOS SEE HERE (dark icons)
//             ),
//             title: Text('NOBEEP',
//                 style: GoogleFonts.poppins(
//                     color: Color(0xff98999B), letterSpacing: 3, fontSize: 18)),
//             centerTitle: true,
//             elevation: 0.0,
//             backgroundColor: Colors.transparent,
//           ),
//           body: SingleChildScrollView(
//             child: Center(
//               child: Container(
//                 width: double.infinity,
//                 height: MediaQuery.of(context).size.height,
//                 decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                         begin: Alignment.topCenter,
//                         end: Alignment.bottomCenter,
//                         colors: [
//                       Color(0xffFEFEFE),
//                       Color(0xffE0E3EB),
//                     ])),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.max,
//                   children: [
//                     Container(
//                       height: MediaQuery.of(context).size.height / 1.3,
//                       child: Stack(
//                         children: [
//                           Column(
//                             children: [
//                               SizedBox(
//                                 height: kToolbarHeight + 32,
//                               ),
//                               Obx(
//                                 () => Center(
//                                   child: CircularPercentIndicator(
//                                     radius: 80,
//                                     lineWidth: 8,
//                                     restartAnimation: true,
//                                     animation: true,
//                                     animateFromLastPercent: true,
//                                     animationDuration: 1200,
//                                     percent: storeController.getStreakPercent(),
//                                     center: Column(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.center,
//                                       children: [
//                                         Text(
//                                             storeController
//                                                 .getStreakCounterValue()
//                                                 .toString(),
//                                             style: GoogleFonts.oswald(
//                                                 fontSize: 24,
//                                                 fontWeight: FontWeight.bold,
//                                                 color: storeController
//                                                     .accentColor.value)),
//                                         Text(
//                                             storeController
//                                                 .getStreakCounterSubtitle(),
//                                             style: GoogleFonts.poppins(
//                                                 fontSize: 12,
//                                                 fontWeight: FontWeight.bold,
//                                                 color: storeController
//                                                     .accentColor.value
//                                                     .withOpacity(0.4))),
//                                       ],
//                                     ),
//                                     backgroundColor: storeController
//                                         .accentColor.value
//                                         .withOpacity(0.2),
//                                     circularStrokeCap: CircularStrokeCap.round,
//                                     progressColor:
//                                         storeController.accentColor.value,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           SingleChildScrollView(
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 for (var i = 0; i < colorList.length; i++)
//                                   Padding(
//                                     padding: const EdgeInsets.symmetric(
//                                         vertical: 20, horizontal: 16),
//                                     child: GestureDetector(
//                                       onTap: () {
//                                         storeController.selectedColorCode =
//                                             colorList[i].title;
//                                         storeController.changeAccentColor(
//                                             newAccentColor: colorList[i].color);
//                                       },
//                                       child: Container(
//                                         decoration: BoxDecoration(
//                                             border: colorList[i].title ==
//                                                     storeController
//                                                         .selectedColorCode
//                                                 ? Border.all(
//                                                     color: Colors.white,
//                                                     width: 5)
//                                                 : null,
//                                             gradient: RadialGradient(
//                                                 center: Alignment(0.6, -0.3),
//                                                 focal: Alignment(0.3, -0.1),
//                                                 colors: [
//                                                   colorList[i]
//                                                       .color
//                                                       .withOpacity(0.5),
//                                                   colorList[i].color,
//                                                 ])),
//                                         height: colorList[i].title ==
//                                                 storeController
//                                                     .selectedColorCode
//                                             ? 130
//                                             : 100,
//                                         width: colorList[i].title ==
//                                                 storeController
//                                                     .selectedColorCode
//                                             ? 130
//                                             : 100,
//                                         child: Center(
//                                           child: Text(
//                                             colorList[i].title,
//                                             style: GoogleFonts.poppins(
//                                                 color: Colors.white,
//                                                 fontSize: 16),
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Container(
//                       color: Colors.black.withOpacity(0.8),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         mainAxisAlignment: MainAxisAlignment.end,
//                         mainAxisSize: MainAxisSize.max,
//                         children: [
//                           // SingleChildScrollView(
//                           //   scrollDirection: Axis.horizontal,
//                           //   child: Row(
//                           //     mainAxisAlignment: MainAxisAlignment.center,
//                           //     children: [
//                           //       for (var i = 0; i < colorList.length; i++)
//                           //         Padding(
//                           //           padding: const EdgeInsets.symmetric(
//                           //               vertical: 20, horizontal: 16),
//                           //           child: GestureDetector(
//                           //             onTap: () {
//                           //               storeController.selectedColorCode =
//                           //                   colorList[i].title;
//                           //               storeController.changeAccentColor(
//                           //                   newAccentColor: colorList[i].color);
//                           //             },
//                           //             child: Container(
//                           //               decoration: BoxDecoration(
//                           //                   border: colorList[i].title ==
//                           //                           storeController
//                           //                               .selectedColorCode
//                           //                       ? Border.all(
//                           //                           color: Colors.white,
//                           //                           width: 5)
//                           //                       : null,
//                           //                   gradient: RadialGradient(
//                           //                       center: Alignment(0.6, -0.3),
//                           //                       focal: Alignment(0.3, -0.1),
//                           //                       colors: [
//                           //                         colorList[i]
//                           //                             .color
//                           //                             .withOpacity(0.5),
//                           //                         colorList[i].color,
//                           //                       ])),
//                           //               height: colorList[i].title ==
//                           //                       storeController
//                           //                           .selectedColorCode
//                           //                   ? 130
//                           //                   : 100,
//                           //               width: colorList[i].title ==
//                           //                       storeController
//                           //                           .selectedColorCode
//                           //                   ? 130
//                           //                   : 100,
//                           //               child: Center(
//                           //                 child: Text(
//                           //                   colorList[i].title,
//                           //                   style: GoogleFonts.poppins(
//                           //                       color: Colors.white,
//                           //                       fontSize: 16),
//                           //                 ),
//                           //               ),
//                           //             ),
//                           //           ),
//                           //         ),
//                           //     ],
//                           //   ),
//                           // ),

//                           SizedBox(
//                             height: 100,
//                           ),
//                           // Padding(
//                           //   padding: const EdgeInsets.symmetric(horizontal: 12),
//                           //   child: Text(
//                           //     "As Cold as blue 🔥",
//                           //     style: GoogleFonts.poppins(
//                           //         fontSize: 40,
//                           //         color: Colors.white,
//                           //         fontWeight: FontWeight.w500),
//                           //   ),
//                           // ),
//                           // SizedBox(
//                           //   height: 100,
//                           // ),
//                           Align(
//                             alignment: Alignment.centerRight,
//                             child: BouncingWidget(
//                               onPressed: () {
//                                 // storeController.switchHide();
//                               },
//                               duration: Duration(milliseconds: 50),
//                               child: Container(
//                                 decoration: BoxDecoration(
//                                     gradient: LinearGradient(
//                                         begin: Alignment.topLeft,
//                                         end: Alignment.topRight,
//                                         colors: [
//                                       storeController.accentColor.value,
//                                       storeController.accentColor.value,
//                                     ])),
//                                 child: Padding(
//                                   padding: EdgeInsets.symmetric(
//                                       vertical: 12, horizontal: 8),
//                                   child: Row(
//                                     mainAxisSize: MainAxisSize.min,
//                                     children: [
//                                       // Obx(() => CircularPercentIndicator(
//                                       //       radius: 20,
//                                       //       lineWidth: 4,
//                                       //       restartAnimation: true,
//                                       //       animation: true,
//                                       //       animateFromLastPercent: true,
//                                       //       animationDuration: 1200,
//                                       //       percent:
//                                       //           storeController.getStreakPercent(),
//                                       //       center: Text(
//                                       //           storeController
//                                       //               .streakDuration.value.inSeconds
//                                       //               .toString(),
//                                       //           style: GoogleFonts.poppins(
//                                       //               fontSize: 16,
//                                       //               fontWeight: FontWeight.bold)),
//                                       //       backgroundColor:
//                                       //           Colors.white.withOpacity(0.3),
//                                       //       circularStrokeCap:
//                                       //           CircularStrokeCap.round,
//                                       //       progressColor: Colors.white,
//                                       //     )),

//                                       Text(
//                                         "  Yes, start my streak now!",
//                                         style: GoogleFonts.poppins(
//                                             color: Colors.white, fontSize: 20),
//                                       ),
//                                       Visibility(
//                                         visible: storeController
//                                             .onboardingCustomDayCountEditingController
//                                             .value
//                                             .text
//                                             .trim()
//                                             .isNotEmpty,
//                                         child: SizedBox(
//                                           width: 20,
//                                         ),
//                                       ),
//                                       Visibility(
//                                         visible: storeController
//                                             .onboardingCustomDayCountEditingController
//                                             .value
//                                             .text
//                                             .trim()
//                                             .isNotEmpty,
//                                         child: Icon(
//                                           Icons.arrow_right_alt,
//                                           color: Colors.white,
//                                         ),
//                                       )
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           )
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),

//                 // Align(
//                 //   alignment: Alignment.centerRight,
//                 //   child: BouncingWidget(
//                 //     onPressed: () {
//                 //       storeController.switchHide();
//                 //     },
//                 //     duration: Duration(milliseconds: 50),
//                 //     child: Container(
//                 //       decoration: BoxDecoration(
//                 //           gradient: LinearGradient(
//                 //               begin: Alignment.topLeft,
//                 //               end: Alignment.topRight,
//                 //               colors: [
//                 //             storeController.accentColor.value,
//                 //             storeController.accentColor.value,
//                 //           ])),
//                 //       child: Padding(
//                 //         padding:
//                 //             EdgeInsets.symmetric(vertical: 12, horizontal: 8),
//                 //         child: Row(
//                 //           mainAxisSize: MainAxisSize.min,
//                 //           children: [
//                 //             Text(
//                 //               "Invincible",
//                 //               style: GoogleFonts.poppins(
//                 //                   color: Colors.white, fontSize: 20),
//                 //             ),
//                 //             SizedBox(
//                 //               width: 20,
//                 //             ),
//                 //             Icon(
//                 //               Icons.arrow_right_alt,
//                 //               color: Colors.white,
//                 //             )
//                 //           ],
//                 //         ),
//                 //       ),
//                 //     ),
//                 //   ),
//                 // ),
//               ),
//             ),
//           ),
//         ));
//   }
// }

// class CustomAccentColorListClass {
//   final Color color;
//   final String title;
//   final bool isLocked;
//   final String colorCode;

//   CustomAccentColorListClass({
//     required this.color,
//     required this.title,
//     required this.isLocked,
//     required this.colorCode,
//   });
// }

// List<CustomAccentColorListClass> colorList = [
//   CustomAccentColorListClass(
//       color: Color(0xff8081DB),
//       isLocked: false,
//       title: 'Light',
//       colorCode: "red"),
//   CustomAccentColorListClass(
//       color: Color(0xffFCB79C),
//       isLocked: false,
//       title: 'Eren',
//       colorCode: "green"),
//   CustomAccentColorListClass(
//       color: Color(0xffF86C86),
//       isLocked: false,
//       title: 'Levi',
//       colorCode: "red"),
//   CustomAccentColorListClass(
//       color: Color(0xff59CAA0),
//       isLocked: false,
//       title: 'Goku',
//       colorCode: "red"),
//   CustomAccentColorListClass(
//       color: Color(0xff8081DB), isLocked: false, title: '', colorCode: "red"),
//   CustomAccentColorListClass(
//       color: Color(0xff8081DB), isLocked: false, title: '', colorCode: "red"),
// ];
