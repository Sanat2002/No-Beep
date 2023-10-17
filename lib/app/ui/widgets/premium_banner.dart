import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

import '../emergency/emergency_page.dart';

class PremiumBanner extends StatelessWidget {
  const PremiumBanner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: containerNeumorphicDecoration(),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Color(0xff0b0d0f),
              borderRadius: BorderRadius.all(Radius.circular(10)),
              image: DecorationImage(
                  fit: BoxFit.cover,
                  filterQuality: FilterQuality.low,
                  image: CachedNetworkImageProvider(
                    "https://images.unsplash.com/photo-1618397746666-63405ce5d015?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1674&q=80",
                  )),
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
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text("GET",
                      style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: 12,
                          letterSpacing: 2,
                          fontWeight: FontWeight.w400)),
                  Text(
                    "NOBEEP",
                    style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: 20,
                        letterSpacing: 4,
                        fontWeight: FontWeight.w400),
                  ),
                  Text("PREMIUM",
                      style: GoogleFonts.montserrat(
                          color: Colors.black,
                          fontSize: 28,
                          letterSpacing: 4,
                          fontWeight: FontWeight.w500)),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Color(0xff0b0d0f),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          filterQuality: FilterQuality.low,
                          image: CachedNetworkImageProvider(
                            "https://images.unsplash.com/photo-1617042375876-a13e36732a04?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1770&q=80",
                          )),
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
                      child: Center(
                        child: Text("SUPPORT DEVELOPERS",
                            style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 20,
                                letterSpacing: 4,
                                fontWeight: FontWeight.w400)),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class PremiumBannerPayment extends StatelessWidget {
  const PremiumBannerPayment({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: containerNeumorphicDecoration(),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Color(0xff0b0d0f),
              borderRadius: BorderRadius.all(Radius.circular(10)),
              image: DecorationImage(
                  fit: BoxFit.cover,
                  filterQuality: FilterQuality.low,
                  image: CachedNetworkImageProvider(
                    "https://images.unsplash.com/photo-1618397746666-63405ce5d015?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1674&q=80",
                  )),
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
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text("WE HATE TO SHOW ADS",
                      style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 18,
                          letterSpacing: 2,
                          fontWeight: FontWeight.w500)),
                  SizedBox(
                    height: 12,
                  ),
                  // Text(
                  //   "BUT ADS ARE THE ONLY WAY BY WHICH WE CAN KEEP NO-BEEP GOING.😩",
                  //   textAlign: TextAlign.center,
                  //   style: GoogleFonts.poppins(
                  //       color: Colors.black
                  //       fontSize: 15,
                  //       letterSpacing: 2,
                  //       fontWeight: FontWeight.w400),
                  // ),
                  // SizedBox(
                  //   height: 12,
                  // ),
                  Text(
                      "Help us keep NoBeep going without ads by subscribing today.\n\nYour support will not only help us maintain NoBeep, but it will also enhance your overall experience on our platform :)",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.montserrat(
                          color: Colors.black,
                          fontSize: 18,
                          letterSpacing: 1,
                          fontWeight: FontWeight.w500)),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          filterQuality: FilterQuality.low,
                          image: CachedNetworkImageProvider(
                            "https://images.unsplash.com/photo-1618397746666-63405ce5d015?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1674&q=80",
                          )),
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
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 8),
                      child: Center(
                        child: Text("JUST AT \$2.99\n\nVALID FOR 3 MONTHS 🔥",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.montserrat(
                                color: Colors.black,
                                fontSize: 18,
                                letterSpacing: 2,
                                fontWeight: FontWeight.w600)),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
