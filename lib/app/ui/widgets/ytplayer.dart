import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'home_counter_widget.dart';

class YTVideoPLayerScreen extends StatefulWidget {
  const YTVideoPLayerScreen({Key? key, required this.videoID})
      : super(key: key);
  final String videoID;

  @override
  State<YTVideoPLayerScreen> createState() => _YTVideoPLayerScreenState();
}

class _YTVideoPLayerScreenState extends State<YTVideoPLayerScreen> {
  final videoURL = 'https://www.youtube.com/watch?v=YMx8Bbev6T4';
  late YoutubePlayerController _controller;

  @override
  void initState() {
    _controller = YoutubePlayerController(initialVideoId: widget.videoID);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      // appBar: AppBar(
      //   title:
      //       Text('PLAYER', style: Theme.of(context).textTheme.headlineMedium),
      //   centerTitle: true,
      //   elevation: 0.0,
      //   backgroundColor: Colors.black,
      //   automaticallyImplyLeading: false,
      //   leading: BouncingWidget(
      //     onPressed: () {
      //       Navigator.of(context).pop();
      //     },
      //     child: Icon(
      //       Icons.arrow_back_ios,
      //       color: Colors.white.withOpacity(0.2),
      //     ),
      //   ),
      // ),
      body: YoutubePlayerBuilder(
          player: YoutubePlayer(
            controller: _controller,
          ),
          builder: (context, player) {
            return Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 20,
                      ),
                      child: BouncingWidget(
                          child: Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          }),
                    ),
                    Expanded(
                      flex: 8,
                      child: Center(
                        child: Text('PLAYER',
                            style: Theme.of(context).textTheme.headlineMedium),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                player,
              ],
            );
          }),
    );

    // return Scaffold(
    //   backgroundColor: Colors.black,
    //   body: Column(
    //     children: [
    //       YoutubePlayer(
    //         controller: _controller,
    //         showVideoProgressIndicator: true,

    //       )
    //     ],
    //   ),
    // );
  }
}
