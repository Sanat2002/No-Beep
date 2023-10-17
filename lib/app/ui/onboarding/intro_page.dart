import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:neep/app/services/analytics_service.dart';
import 'package:vibration/vibration.dart';
import '../../services/routes_service.dart';
import '../widgets/no_beep_title.dart';

class AppIntroPage extends HookWidget {
  const AppIntroPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent, // <-- SEE HERE
          statusBarIconBrightness:
              Brightness.dark, //<-- For Android SEE HERE (dark icons)
          statusBarBrightness:
              Brightness.light, //<-- For iOS SEE HERE (dark icons)
        ),
        title: NoBeepTitle(),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.transparent,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'btn2',

        label: Row(
          children: [
            Text(
              "Invincible",
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Theme.of(context).backgroundColor),
            ),
            SizedBox(
              width: 20,
            ),
            Icon(
              Icons.arrow_right_alt,
              color: Theme.of(context).backgroundColor,
            ),
          ],
        ),

        shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.all(Radius.circular(1))), // isExtended: true,

        backgroundColor: Theme.of(context).colorScheme.primary,
        onPressed: () {
          Vibration.vibrate(duration: 50);
          AnalyticsService().setUserProperties();
          Get.toNamed(RoutesClass.getOnboardingDateSelectionPage());
        },
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                  Theme.of(context).backgroundColor,
                  Theme.of(context).dialogBackgroundColor,
                ])),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Lottie.asset('assets/blue-waves-animations.json',
                    reverse: true),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        "Not just a streak counter.",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 16, right: 12, top: 4),
                      child: Text(
                        "No Beep uses scientifically proven ways to build mental toughness and break habits.\n\nIt stays with you after that to make to feel...",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    SizedBox(
                      height: 300,
                    )
                  ],
                ),

                // Align(
                //   alignment: Alignment.centerRight,
                //   child: BouncingWidget(
                //     onPressed: () {
                //       AnalyticsService().setUserProperties();
                //       Get.toNamed(RoutesClass.getOnboardingDateSelectionPage());
                //     },
                //     duration: Duration(milliseconds: 50),
                //     child: Container(
                //       color: Theme.of(context).colorScheme.primary,
                //       child: Padding(
                //         padding:
                //             EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                //         child: Row(
                //           mainAxisSize: MainAxisSize.min,
                //           children: [
                //             Text(
                //               "Invincible",
                //               style: Theme.of(context)
                //                   .textTheme
                //                   .bodyMedium
                //                   ?.copyWith(
                //                       color: Theme.of(context).backgroundColor),
                //             ),
                //             SizedBox(
                //               width: 20,
                //             ),
                //             Icon(
                //               Icons.arrow_right_alt,
                //               color: Theme.of(context).backgroundColor,
                //             )
                //           ],
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
