import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:neep/app/ui/home/controller/badge_controller.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../emergency/emergency_controller.dart';
import '../emergency/emergency_page.dart';

class BadgeWidget extends HookWidget {
  ItemScrollController? scrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();
  final String? gifLink;

  BadgeWidget({Key? key, this.gifLink}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final badgeController = Get.put(BadgeController());
    final currentBadge = badgeController.currentBadge;

    int badgeIndex = 0;
    useMemoized(() {
      badgeController.setBadge();
      badgeIndex = badgeController.getBadgeIndex();
      Timer(Duration(seconds: 2), () {
        if (scrollController?.isAttached ?? false) {
          scrollController!.scrollTo(
              index: badgeIndex,
              duration: Duration(seconds: 1),
              curve: Curves.easeIn);
        }
      });

      // itemPositionsListener.itemPositions.addListener(() {
      //   Timer(Duration(seconds: 2), () {
      //     if (scrollController?.isAttached ?? false) {
      //       scrollController!.scrollTo(
      //           index: badgeIndex,
      //           duration: Duration(seconds: 1),
      //           curve: Curves.easeIn);
      //     }
      //   });
      // });
    });

    return Obx(
      (() => Container(
            clipBehavior: Clip.hardEdge,
            width: double.infinity,
            decoration: containerNeumorphicDecoration(
                backgroundColor: Color(0xff0b0d0f)),
            child: currentBadge.value == null
                ? SizedBox()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                if (scrollController?.isAttached ?? false) {
                                  scrollController!.scrollTo(
                                      index: 13,
                                      duration: Duration(seconds: 1),
                                      curve: Curves.easeIn);
                                }
                              },
                              child: Text(
                                "YOUR BADGE ----->",
                                style: GoogleFonts.poppins(
                                    letterSpacing: 2,
                                    fontSize: 12,
                                    color: Colors.redAccent.shade200
                                        .withOpacity(0.5)),
                              ),
                            ),
                            Spacer(),
                            Container(
                              padding: EdgeInsets.all(2),
                              color: Colors.green,
                              child: Text(
                                "${currentBadge.value?.badgeDisplay}",
                                style: GoogleFonts.poppins(
                                    letterSpacing: 3,
                                    fontSize: 12,
                                    color: Colors.white.withOpacity(0.9)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: 100,
                        child: ScrollablePositionedList.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: badgeMap.length,
                          initialScrollIndex: 0,
                          itemBuilder: (context, i) {
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 16),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: badgeMap.values.toList()[i].badgeId ==
                                          currentBadge.value?.badgeId
                                      ? Colors.green.withOpacity(0.7)
                                      : Colors.red.withOpacity(0.2),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                  boxShadow: badgeMap.values
                                              .toList()[i]
                                              .badgeId ==
                                          currentBadge.value?.badgeId
                                      ? [
                                          BoxShadow(
                                              color: badgeMap.values
                                                          .toList()[i]
                                                          .badgeId ==
                                                      currentBadge
                                                          .value?.badgeId
                                                  ? Colors.green
                                                      .withOpacity(0.5)
                                                  : Colors.black,
                                              offset: Offset(4, 4),
                                              blurRadius: 10,
                                              spreadRadius: 1),
                                          BoxShadow(
                                              color:
                                                  Colors.white.withOpacity(0.1),
                                              offset: Offset(-4, -4),
                                              blurRadius: 5,
                                              spreadRadius: 1)
                                        ]
                                      : null,
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                child: Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        badgeMap.values
                                            .toList()[i]
                                            .badgeDisplay,
                                        style: GoogleFonts.poppins(
                                            letterSpacing: 2,
                                            fontSize: 12,
                                            color: badgeMap.values
                                                        .toList()[i]
                                                        .badgeId ==
                                                    currentBadge.value?.badgeId
                                                ? Colors.white.withOpacity(0.9)
                                                : Colors.red.withOpacity(0.4)),
                                      ),
                                      Text(
                                        getDateString(
                                            badge: badgeMap.values.toList()[i]),
                                        style: GoogleFonts.poppins(
                                            letterSpacing: 2,
                                            fontSize: 10,
                                            color:
                                                Colors.white.withOpacity(0.4)),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                          // itemPositionsListener: itemPositionsListener,
                          itemScrollController: scrollController,
                        ),
                      ),

                      // SingleChildScrollView(
                      //   scrollDirection: Axis.horizontal,
                      //   child: Row(
                      //     children: [
                      //       for (int i = 0; i < badgeDummyList.length; i++)
                      //         Padding(
                      //           padding: EdgeInsets.symmetric(
                      //               horizontal: 12, vertical: 16),
                      //           child: Container(
                      //             decoration: BoxDecoration(
                      //               color: Color(0xff0b0d0f),
                      //               borderRadius:
                      //                   BorderRadius.all(Radius.circular(8)),
                      //               boxShadow: [
                      //                 BoxShadow(
                      //                     color: badgeDummyList[i].badgeId ==
                      //                             currentBadge.value?.badgeId
                      //                         ? Colors.red.shade800
                      //                             .withOpacity(0.5)
                      //                         : Colors.black,
                      //                     offset: Offset(4, 4),
                      //                     blurRadius: 10,
                      //                     spreadRadius: 1),
                      //                 BoxShadow(
                      //                     color: Colors.white.withOpacity(0.1),
                      //                     offset: Offset(-4, -4),
                      //                     blurRadius: 5,
                      //                     spreadRadius: 1)
                      //               ],
                      //             ),
                      //             padding: EdgeInsets.all(8),
                      //             child: Center(
                      //               child: Text(
                      //                 badgeDummyList[i].badgeDisplay,
                      //                 style: GoogleFonts.poppins(
                      //                     letterSpacing: 2,
                      //                     fontSize: 12,
                      //                     color: badgeDummyList[i].badgeId ==
                      //                             currentBadge.value?.badgeId
                      //                         ? Colors.redAccent
                      //                             .withOpacity(0.9)
                      //                         : Colors.red.withOpacity(0.4)),
                      //               ),
                      //             ),
                      //           ),
                      //         )
                      //     ],
                      //   ),
                      // ),

                      SizedBox(
                        height: 40,
                      ),
                      SizedBox(
                          width: double.infinity,
                          child: CachedNetworkImage(
                            imageUrl: gifLink ??
                                currentBadge.value?.badgeImgUrl ??
                                'https://media.tenor.com/rOOFTXXw5QEAAAAC/loading-gun-loading.gif',
                            fit: BoxFit.cover,
                          )),
                    ],
                  ),
          )),
    );
  }
}
