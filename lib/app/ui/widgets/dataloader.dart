import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
// import 'package:nimbus2k23/utils/colors.dart';

class DataLoader extends StatelessWidget {
  const DataLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: LoadingAnimationWidget.staggeredDotsWave(
            color: Colors.white, size: 40));
  }
}
