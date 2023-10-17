import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neep/app/ui/widgets/image_circular_loader.dart';
import 'package:vibration/vibration.dart';

import '../../services/analytics_service.dart';
import '../emergency/emergency_controller.dart';
import 'controller/reset_controller.dart';

class ResetPage extends HookWidget {
  const ResetPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FocusNode focusNode = FocusNode();
    final resetController = Get.put(ResetController());

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
          title:
              Text('RESET', style: Theme.of(context).textTheme.headlineMedium),
          centerTitle: true,
          elevation: 0.0,
          leading: BouncingWidget(
              onPressed: () {
                Get.back(result: false);
              },
              child: Icon(Icons.arrow_back)),
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: SizedBox(
          width: MediaQuery.of(context).size.width - 200,
          child: FloatingActionButton(
            shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.all(Radius.circular(10))), // isExtended: true,
            child: Text("RESET",
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 15,
                    letterSpacing: 2,
                    fontWeight: FontWeight.w600)),

            backgroundColor: Color(0xff8081DB).withOpacity(0.3),
            onPressed: () {
              AnalyticsService().logButtonTapped(buttonName: RESET_PAGE_DONE);
              // if (resetController
              //     .resetReasonTextController.value.text.isEmpty) {
              //   Get.snackbar(
              //     "Please type the reason for relapse first.",
              //     "Learn from mistakes 💪",
              //     snackPosition: SnackPosition.TOP,
              //     backgroundColor: Colors.red,
              //     borderRadius: 15,
              //     margin: EdgeInsets.all(15),
              //     colorText: Colors.white,
              //     duration: Duration(seconds: 5),
              //     isDismissible: true,
              //     dismissDirection: DismissDirection.horizontal,
              //     forwardAnimationCurve: Curves.bounceIn,
              //   );
              //   return;
              // }
              Vibration.vibrate(duration: 50);
              resetController.reset();
              Get.back(result: true);
            },
          ),
        ),
        body: CustomScrollView(
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
                      imageUrl:
                          "https://media.tenor.com/NpWx4DgpgP8AAAAd/jimchi-jim-chi-asmr.gif",
                      fit: BoxFit.fill,
                      placeholder: (context, url) =>
                          ImagePlaceHolder()) //Images.network
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
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 20),
                child: Column(
                  children: [
                    Text(
                      "LEARN FROM MISTAKES",
                      style: GoogleFonts.openSans(
                          fontSize: 12,
                          color: Color(0xff8081DB).withOpacity(0.6),
                          letterSpacing: 3),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 16, right: 12, top: 12),
                      child: TextField(
                        controller: resetController.resetReasonTextController,
                        keyboardType: TextInputType.text,
                        autofocus: true,
                        cursorColor: Colors.white,
                        style: GoogleFonts.montserrat(color: Colors.white),
                        decoration: InputDecoration(
                            hintText: 'START TYPING THE REASON FOR RESET....',
                            hintStyle: GoogleFonts.openSans(
                                fontSize: 12,
                                color: Color(0xffEE4D37).withOpacity(0.9),
                                letterSpacing: 2)),
                      ),
                    ),
                    SizedBox(
                      height: 200,
                    ),
                    // Align(
                    //   alignment: Alignment.bottomRight,
                    //   child: BouncingWidget(
                    //     onPressed: () {
                    //       AnalyticsService()
                    //           .logButtonTapped(buttonName: RESET_PAGE_DONE);
                    //       if (resetController
                    //           .resetReasonTextController.value.text.isEmpty) {
                    //         Get.snackbar(
                    //           "Enter a reason for relapse",
                    //           "Learn from mistakes",
                    //           snackPosition: SnackPosition.TOP,
                    //           backgroundColor: Color(0xff8081DB),
                    //           borderRadius: 15,
                    //           margin: EdgeInsets.all(15),
                    //           colorText: Colors.white,
                    //           duration: Duration(seconds: 3),
                    //           isDismissible: true,
                    //           dismissDirection: DismissDirection.horizontal,
                    //           forwardAnimationCurve: Curves.bounceIn,
                    //         );
                    //         return;
                    //       }
                    //       resetController.reset();
                    //       Navigator.of(context).pop();
                    //     },
                    //     child: Container(
                    //       width: 200,
                    //       height: 50,
                    //       decoration: BoxDecoration(
                    //         color: Color(0xff0b0d0f),
                    //         borderRadius: BorderRadius.only(
                    //             topLeft: Radius.circular(8),
                    //             topRight: Radius.circular(8)),
                    //         boxShadow: [
                    //           BoxShadow(
                    //               color: Colors.black,
                    //               offset: Offset(4, 4),
                    //               blurRadius: 10,
                    //               spreadRadius: 1),
                    //           BoxShadow(
                    //               color: Colors.white.withOpacity(0.1),
                    //               offset: Offset(-4, -4),
                    //               blurRadius: 5,
                    //               spreadRadius: 1)
                    //         ],
                    //       ),
                    //       child: Row(
                    //         mainAxisAlignment: MainAxisAlignment.center,
                    //         children: [
                    //           Text("RESET"),
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ], //<Widget>[]
        ) //C Container(

        );
  }
}

class JournalModel {
  final int day;
  final String title;

  JournalModel({required this.day, required this.title});
}

List<JournalModel> journalDummy = [
  JournalModel(day: 43, title: 'Hello how are you all?'),
  JournalModel(
      day: 03, title: 'I am feeling great tbh. Had a great day today :'),
  JournalModel(
      day: 02,
      title: 'Today was a lame day. Eren. Chutiya Eren. Why mikasa man!'),
  JournalModel(day: 01, title: 'I am feeling great tbh. Had a great day today ')
];

class EmptyJournalWidget extends StatelessWidget {
  const EmptyJournalWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '''“Journal writing, when it becomes a ritual for transformation, is not only life-changing but life-expanding.” – Jen Williamson''',
              style: GoogleFonts.poppins(
                fontSize: 20,
                color: Colors.white.withOpacity(0.4),
              ),
            ),
          ),
          SizedBox(
            height: 200,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Tap the "+" button',
              style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Color(0xffEE4D37).withOpacity(0.8),
                  letterSpacing: 3),
            ),
          ),
        ],
      ),
    );
  }
}
