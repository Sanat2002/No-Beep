import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../hive/models/journal_local_model.dart';
import 'controller/journal_controller.dart';

class JournalInfoPage extends StatelessWidget {
  const JournalInfoPage(
      {Key? key, required this.journalDetail, required this.bgColor})
      : super(key: key);

  final JournalLocalModel journalDetail;
  final Color bgColor;
  @override
  Widget build(BuildContext context) {
    final journalController = Get.put(JournalController());

    return Scaffold(
      backgroundColor: Color(0xff0b0d0f),
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent, // <-- SEE HERE
          statusBarIconBrightness:
              Brightness.dark, //<-- For Android SEE HERE (dark icons)
          statusBarBrightness:
              Brightness.light, //<-- For iOS SEE HERE (dark icons)
        ),
        title: Hero(
          tag: journalDetail.key,
          child: Material(
            type: MaterialType.transparency, // likely needed

            child: Text(
                getJournalAppBarTitle(date: journalDetail.journalTimeStamp)
                    .toUpperCase(),
                style: Theme.of(context).textTheme.headlineMedium),
          ),
        ),
        centerTitle: true,
        elevation: 0.0,
        leading: BouncingWidget(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Icon(Icons.arrow_back)),
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: BouncingWidget(
              onPressed: () {
                journalController.deleteJournal(key: journalDetail.key);
                Navigator.of(context).pop();
              },
              child: Icon(Icons.delete_outline,
                  color: Colors.white.withOpacity(0.3)),
            ),
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(
              height: 40,
            ),
            Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.8,
                  width: double.infinity,
                  clipBehavior: Clip.hardEdge,
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Color(0xff0b0d0f),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        filterQuality: FilterQuality.low,
                        image: AssetImage('assets/journal_background.jpg')),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black,
                          offset: Offset(4, 4),
                          blurRadius: 10,
                          spreadRadius: 1),
                      BoxShadow(
                          color: Colors.red.withOpacity(0.1),
                          offset: Offset(-4, -4),
                          blurRadius: 5,
                          spreadRadius: 1)
                    ],
                  ),
                  child: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 40, horizontal: 16),
                            child: Text(
                              journalDetail.journalText,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                  color: Colors.white70,
                                  // shadows: <Shadow>[
                                  //   Shadow(
                                  //     offset: Offset(-2, -2),
                                  //     blurRadius: 3.0,
                                  //     color: Colors.black,
                                  //   ),
                                  //   Shadow(
                                  //       offset: Offset(2, 2),
                                  //       blurRadius: 10,
                                  //       color:
                                  //           Colors.redAccent.withOpacity(0.5)),
                                  // ],
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Positioned(
                //   top: 0,
                //   right: 40,
                //   child: BouncingWidget(
                //     onPressed: () {},
                //     duration: Duration(milliseconds: 100),
                //     child: Row(
                //       mainAxisAlignment: MainAxisAlignment.end,
                //       children: [
                //         Container(
                //           width: 30,
                //           child: Column(
                //             children: [
                //               Lottie.asset('assets/edit_animation.json',
                //                   reverse: true, repeat: false),
                //               Text(
                //                 "edit",
                //                 style: TextStyle(
                //                     fontSize: 12, color: Colors.black),
                //               )
                //             ],
                //           ),
                //           decoration: BoxDecoration(
                //             color: Colors.white.withOpacity(0.3),
                //             borderRadius: BorderRadius.only(
                //                 bottomLeft: Radius.circular(8),
                //                 bottomRight: Radius.circular(8)),
                //             boxShadow: [
                //               BoxShadow(
                //                   color: Colors.black,
                //                   offset: Offset(4, 4),
                //                   blurRadius: 15,
                //                   spreadRadius: 1),
                //               // BoxShadow(
                //               //     color: Colors.black.withOpacity(0.6),
                //               //     offset: Offset(-4, -4),
                //               //     blurRadius: 15,
                //               //     spreadRadius: 1)
                //             ],
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}

String getJournalAppBarTitle({required DateTime date}) {
  String month = monthAbbrevationMap[date.month]!;
  String timeText = DateFormat('hh:mm a').format(date);
  return "$month-${date.day}, ${timeText}";
}

Map<int, String> monthAbbrevationMap = {
  1: "JAN",
  2: "FEB",
  3: "MAR",
  4: "APR",
  5: "MAY",
  6: "JUN",
  7: "JUL",
  8: "AUG",
  9: "SEP",
  10: "OCT",
  11: "NOV",
  12: "DEC",
};
