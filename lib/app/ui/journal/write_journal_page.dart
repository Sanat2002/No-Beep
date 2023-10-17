import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neep/app/ui/journal/controller/journal_controller.dart';
import '../../services/analytics_service.dart';
import '../bottom_nav_bar/bottom_nav_bar_controller.dart';
import '../reset/controller/reset_controller.dart';
import '../widgets/image_circular_loader.dart';

class WriteJournalPage extends StatelessWidget {
  const WriteJournalPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FocusNode focusNode = FocusNode();
    final resetController = Get.put(ResetController());
    final bottomNavController = Get.put(BottomNavController());

    final journalController = Get.put(JournalController());

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
          title: Text('JOURNAL',
              style: Theme.of(context).textTheme.headlineMedium),
          centerTitle: true,
          elevation: 0.0,
          leading: BouncingWidget(
              onPressed: () {
                bottomNavController.changeBottomNavIndex(index: 1);

                Navigator.of(context).pop();
              },
              child: Icon(Icons.arrow_back)),
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
        ),
        body: Stack(
          children: [
            CustomScrollView(
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
                            "https://res.cloudinary.com/dhupov40f/image/upload/v1676325657/journal_compressed_rjoaks.gif",
                        fit: BoxFit.cover,
                        placeholder: (context, url) => ImagePlaceHolder(),
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
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 20),
                    child: Column(
                      children: [
                        Text(
                          "“Writing eases my suffering . . . writing is my way of reaffirming my own existence.” – Gao Xingjian"
                              .toUpperCase(),
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.green.withOpacity(0.4),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 16, right: 12, top: 12),
                          child: TextField(
                            controller:
                                journalController.journalTextEditingController,
                            keyboardType: TextInputType.text,
                            autofocus: true,
                            focusNode: focusNode,
                            cursorColor: Color(0xffEE4D37).withOpacity(0.2),
                            style: GoogleFonts.montserrat(
                                color: Color(0xffEE4D37).withOpacity(0.5)),
                            decoration: InputDecoration(
                                hintText: 'TYPE..',
                                hintStyle: GoogleFonts.openSans(
                                    fontSize: 12,
                                    color: Color(0xffEE4D37).withOpacity(0.6),
                                    letterSpacing: 3)),
                          ),
                        ),
                        SizedBox(
                          height: 200,
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: BouncingWidget(
                            onPressed: () {
                              AnalyticsService().logButtonTapped(
                                  buttonName: JOURNAL_PAGE_DONE);
                              if (journalController.journalTextEditingController
                                  .value.text.isEmpty) {
                                return;
                              }
                              journalController.saveJournal();
                              bottomNavController.changeBottomNavIndex(
                                  index: 1);

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
                                  Text("DONE "),
                                  Icon(
                                    Icons.done,
                                    color: Colors.red,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ], //<Widget>[]
            ),
          ],
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
