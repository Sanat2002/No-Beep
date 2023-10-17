import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neep/app/services/analytics_service.dart';
import 'package:neep/app/ui/widgets/ytplayer.dart';

class YouTubeVideoCard extends StatelessWidget {
  const YouTubeVideoCard(
      {Key? key,
      required this.videoID,
      required this.title,
      required this.author})
      : super(key: key);
  final String videoID;
  final String title;
  final String author;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: GestureDetector(
        onTap: () {
          AnalyticsService().logButtonTapped(buttonName: YT_VIDEO_TILE_TAPPED);
          Get.to(YTVideoPLayerScreen(
            videoID: videoID,
          ));
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 200,
              width: double.infinity,
              child: CachedNetworkImage(
                  fit: BoxFit.fitWidth,
                  imageUrl: "https://img.youtube.com/vi/${videoID}/0.jpg"),
            ),
            Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.normal,
                color: Colors.white.withOpacity(0.7),
              ),
            ),
            Text(author,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.openSans(
                    fontSize: 12, fontWeight: FontWeight.w400))
          ],
        ),
      ),
    );
  }
}
