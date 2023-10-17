import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/image_circular_loader.dart';
import 'controller/history_controller.dart';

class HistoryPage extends HookWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final resetController = Get.put(HistoryController());
    final isLoading = resetController.isLoading;
    final historyList = resetController.resetList;

    useMemoized(() {
      resetController.fillResetList();
    });

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
          title: Text('HISTORY',
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
        body: Obx(() => CustomScrollView(
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
                        imageUrl: historyList.isEmpty
                            ? "https://media.tenor.com/nzQxTmT6eygAAAAC/jensen-ackles.gif"
                            : "https://media.tenor.com/BkMcsAWMVR4AAAAd/disney-lion-king.gif",
                        fit: BoxFit.fill,
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
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "RELAPSE HISTORY",
                          style: GoogleFonts.openSans(
                              fontSize: 12,
                              color: Color(0xffEE4D37).withOpacity(0.8),
                              letterSpacing: 3),
                        ),
                        Text(
                          "TOTAL : ${isLoading.value ? '..' : historyList.length}",
                          style: GoogleFonts.openSans(
                              fontSize: 12,
                              color: Color(0xffEE4D37).withOpacity(0.5),
                              letterSpacing: 3),
                        ),
                      ],
                    ),
                  ),
                ),
                historyList.length == 0
                    ? SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 22),
                          child: Container(
                              child: Column(
                            children: [
                              Text(
                                "AWESOME!!",
                                style: GoogleFonts.roboto(
                                    fontSize: 20,
                                    color: Colors.green.withOpacity(0.5),
                                    letterSpacing: 2),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                "N0 R3L4P5ES🔥.",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  letterSpacing: 4,
                                  color: Color(0xffF3F1EB),
                                ),
                              ),
                            ],
                          )),
                        ),
                      )
                    : SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) => Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            child: HistoryCard(
                              reason: historyList[index].reason,
                              relapseDay: historyList[index].realapseDay,
                            ),
                          ),
                          childCount: historyList.length,
                        ),
                      )
              ], //<Widget>[]
            )));
  }
}

class HistoryCard extends StatelessWidget {
  const HistoryCard({Key? key, required this.reason, required this.relapseDay})
      : super(key: key);
  final String reason;
  final String relapseDay;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Color(0xff0b0d0f),
          borderRadius: BorderRadius.all(Radius.circular(8)),
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
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 6,
                backgroundColor: Colors.redAccent.withOpacity(0.3),
                child: CircleAvatar(
                  radius: 2,
                  backgroundColor: Color(0xff0b0d0f),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "DAY ",
                style: GoogleFonts.openSans(
                    fontSize: 12,
                    color: Color(0xffEE4D37).withOpacity(0.4),
                    letterSpacing: 2),
              ),
              Text(
                relapseDay,
                style: GoogleFonts.openSans(
                    fontSize: 40,
                    color: Color(0xffF3F1EB),
                    fontWeight: FontWeight.bold),
              ),
              Text(
                reason,
                style: GoogleFonts.poppins(fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
    ;
  }
}
