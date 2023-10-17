import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lottie/lottie.dart';
import 'package:neep/app/ui/ads/controller/ads_controller.dart';

class BreathingScreen extends StatelessWidget {
  BreathingScreen({Key? key}) : super(key: key) {}

  @override
  Widget build(BuildContext context) {
    final adsController = Get.put(AdsController());
    late InterstitialAd interstitialAd =
        adsController.breathingPageInterstitialAd;

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
            Text('BREATHE', style: Theme.of(context).textTheme.headlineMedium),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Color(0xff0b0d0f),
        automaticallyImplyLeading: false,
        leading: BouncingWidget(
            onPressed: () {
              if (adsController.isBreathingPageAdLoaded) {
                interstitialAd.show();
              }
              Navigator.of(context).pop();
            },
            child: Icon(Icons.arrow_back)),
      ),
      body: WillPopScope(
        onWillPop: () {
          if (adsController.isBreathingPageAdLoaded) {
            interstitialAd.show();
          }
          return Future.value(true);
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/breathing_lottie.json',
            ),
          ],
        ),
      ),
    );
  }
}
