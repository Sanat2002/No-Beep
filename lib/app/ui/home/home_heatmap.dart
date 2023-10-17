import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../emergency/emergency_page.dart';
import 'controller/heatmap_controller.dart';

class HomeHeatMap extends HookWidget {
  const HomeHeatMap({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final timeLineController = Get.put(HeatmapController());

    final dataSet = timeLineController.heatDataSet;

    useMemoized(() {
      timeLineController.fillHeatMap();
    });
    return Container(
      padding: EdgeInsets.all(12),
      width: double.infinity,
      decoration: containerNeumorphicDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "YOUR HEAT-MAP 📈",
                style: GoogleFonts.poppins(
                    letterSpacing: 3,
                    fontSize: 12,
                    color: Colors.redAccent.shade200.withOpacity(0.5)),
              ),
              Visibility(
                visible: false,
                child: Icon(
                  Icons.share,
                  color: Colors.greenAccent.shade200.withOpacity(0.5),
                  size: 20,
                ),
              )
            ],
          ),
          SizedBox(
            height: 12,
          ),
          Row(
            children: [
              Spacer(),
              Text(
                "STREAK",
                style: GoogleFonts.poppins(
                  letterSpacing: 3,
                  fontSize: 12,
                  color: Colors.green.shade300.withOpacity(0.6),
                ),
              ),
              SizedBox(
                width: 12,
              ),
              CircleAvatar(
                radius: 5,
                backgroundColor: Colors.green.shade300.withOpacity(0.6),
              ),
            ],
          ),
          SizedBox(
            height: 4,
          ),
          Row(
            children: [
              Spacer(),
              Text(
                "RELAPSE",
                style: GoogleFonts.poppins(
                    letterSpacing: 3,
                    fontSize: 12,
                    color: Colors.red.withOpacity(0.4)),
              ),
              SizedBox(
                width: 12,
              ),
              CircleAvatar(
                radius: 5,
                backgroundColor: Colors.redAccent.shade200.withOpacity(0.5),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Obx(() => (HeatMap(
                defaultColor: Colors.green.shade100.withOpacity(0.1),
                size: 28,
                fontSize: 16,
                textColor: Colors.white54,
                startDate: DateTime(2023, 1, 6),
                endDate: DateTime.now().add(Duration(days: 60)),
                colorMode: ColorMode.color,
                scrollable: true,
                showColorTip: false,
                showText: true,
                datasets: dataSet.value,
                colorsets: {
                  1: Colors.green.shade200.withOpacity(0.4),
                  2: Colors.green.shade300.withOpacity(0.6),
                  3: Colors.green.withOpacity(0.65),
                  4: Colors.green.withOpacity(0.8),
                  5: Colors.green,
                  6: Colors.red.withOpacity(0.5),
                },
                onClick: (value) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(value.toString())));
                },
              ))),
        ],
      ),
    );
  }
}
