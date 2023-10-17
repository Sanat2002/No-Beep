import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../streak_controller.dart';

class HomeCounterWidgetPrimary extends StatelessWidget {
  const HomeCounterWidgetPrimary({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final streakController = Get.put(StreakController());

    final purple = Color(0xff535556).withOpacity(0.2);
    final green = Color(0xff66B7AD);
    final red = Color(0xffF09C9B);
    final yellow = Color(0xffEFC14F);

    return Center(
      child: Obx(() => Row(
            children: [
              Center(
                child: CircularPercentIndicator(
                  radius: 100,
                  lineWidth: 10,
                  restartAnimation: true,
                  animation: true,
                  animateFromLastPercent: true,
                  animationDuration: 1000,
                  maskFilter: MaskFilter.blur(BlurStyle.solid, 2),
                  percent: streakController.getStreakPercentInDays(),
                  backgroundColor: purple,
                  circularStrokeCap: CircularStrokeCap.round,
                  progressColor: Color(0xffEE4D37),
                  center: CircularPercentIndicator(
                    radius: 90,
                    lineWidth: 10,
                    restartAnimation: true,
                    animation: true,
                    animateFromLastPercent: true,
                    animationDuration: 1000,
                    percent: streakController.getStreakPercentInHours(),
                    maskFilter: MaskFilter.blur(BlurStyle.solid, 2),
                    backgroundColor: purple,
                    circularStrokeCap: CircularStrokeCap.round,
                    progressColor: Color(0xffF3F1EB),
                    center: CircularPercentIndicator(
                      radius: 80,
                      lineWidth: 10,
                      restartAnimation: true,
                      animation: true,
                      animateFromLastPercent: true,
                      animationDuration: 1000,
                      percent: streakController.getStreakPercentInMinutes(),
                      backgroundColor: purple,
                      circularStrokeCap: CircularStrokeCap.round,
                      progressColor: Color(0xffF3F1EB).withOpacity(0.5),
                      center: CircularPercentIndicator(
                        radius: 70,
                        lineWidth: 10,
                        restartAnimation: true,
                        animation: true,

                        animateFromLastPercent: true,
                        animationDuration: 1000,
                        percent: streakController.getStreakPercentInSeconds(),
                        backgroundColor: purple,
                        circularStrokeCap: CircularStrokeCap.round,

                        progressColor: Color(0xff8081DB).withOpacity(0.9),
                        center: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                streakController
                                    .getStreakCounterValueInDays()
                                    .toString()
                                    .padLeft(2, '0'),
                                style: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 36,
                                    letterSpacing: 2,
                                    color: Color(0xffF3F1EB)),
                              ),
                              Text(
                                "DAYS",
                                style: GoogleFonts.montserrat(
                                    color: Color(0xffEE4D37),
                                    fontSize: 12,
                                    letterSpacing: 4),
                              ),
                            ],
                          ),
                        ),
                        // center: Lottie.network(
                        //     'https://assets9.lottiefiles.com/packages/lf20_7iux5gpv.json',
                        //     width: 80,
                        //     repeat: true),
                      ),
                    ),
                  ),
                ),
              ),
              Spacer(),
              SizedBox(
                height: 200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _InnerTextWidget(
                      color: Color(0xffF3F1EB),
                      number: _getShortForm(
                          streakController.getStreakCounterValueInHours()),
                      label: "HOURS",
                    ),
                    _InnerTextWidget(
                      color: Color(0xffF3F1EB).withOpacity(0.5),
                      number: _getShortForm(
                          streakController.getStreakCounterValueInMinutes()),
                      label: "MINUTES",
                    ),
                    _InnerTextWidget(
                      color: Color(0xff8081DB).withOpacity(0.5),
                      number: _getShortForm(
                          streakController.getStreakCounterValueInSeconds()),
                      label: "SECONDS",
                    ),
                  ],
                ),
              )
            ],
          )),
    );
  }
}

class _InnerTextWidget extends StatelessWidget {
  const _InnerTextWidget(
      {Key? key,
      required this.color,
      required this.number,
      required this.label})
      : super(key: key);
  final Color color;
  final String number;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 5,
          backgroundColor: color,
        ),
        SizedBox(
          width: 20,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              number,
              style: GoogleFonts.montserrat(
                  fontSize: 20, color: Colors.white, letterSpacing: 2),
            ),
            Text(
              label,
              style: GoogleFonts.montserrat(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 12,
                  letterSpacing: 3),
            ),
          ],
        )
      ],
    );
  }
}

_getShortForm(var number) {
  var f = NumberFormat.compact(locale: "en_US");
  return f.format(number).toString().padLeft(2, '0');
}
