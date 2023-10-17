import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neep/app/hive/models/timeline_yt_local_model.dart';
import 'package:neep/app/ui/widgets/youtube_video_card.dart';

class YTVideoListScreen extends StatelessWidget {
  const YTVideoListScreen({Key? key, required this.videoList})
      : super(key: key);
  final List<Youtube> videoList;

  @override
  Widget build(BuildContext context) {
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
            Text('PLAYLIST', style: Theme.of(context).textTheme.headlineMedium),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Color(0xff0b0d0f),
        automaticallyImplyLeading: false,
        leading: BouncingWidget(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Icon(Icons.arrow_back)),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 28, bottom: 20),
              child: Text('FEED',
                  style: GoogleFonts.openSans(
                      fontSize: 15,
                      color: Color(0xffEE4D37).withOpacity(0.5),
                      letterSpacing: 2)),
            ),
            for (int i = 0; i < videoList.length; i++)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: YouTubeVideoCard(
                  author: videoList[i].videoAuthor ?? '',
                  title: videoList[i].videoTitle!,
                  videoID: videoList[i].videoId!,
                ),
              )
          ],
        ),
      ),
    );
  }
}
