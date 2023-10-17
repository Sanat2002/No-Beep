import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import '../widgets/premium_banner.dart';

class SubscriptionPage extends HookWidget {
  const SubscriptionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Color(0xff0b0d0f),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: SizedBox(
          width: MediaQuery.of(context).size.width - 88,
          child: FloatingActionButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                    Radius.circular(15.0))), // isExtended: true,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("CONTINUE",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                        color: Colors.white,
                        fontSize: 18,
                        letterSpacing: 2,
                        fontWeight: FontWeight.w600)),

                Align(
                  alignment: Alignment.centerRight,
                  child: LottieBuilder.network(
                    "https://assets5.lottiefiles.com/packages/lf20_qax2mru7.json",
                    repeat: true,
                    reverse: true,
                  ),
                )
                // Icon(Icons.arrow_right_alt),
              ],
            ),

            backgroundColor: Colors.green,
            onPressed: () {},
          ),
        ),
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent, // <-- SEE HERE
            statusBarIconBrightness:
                Brightness.dark, //<-- For Android SEE HERE (dark icons)
            statusBarBrightness:
                Brightness.light, //<-- For iOS SEE HERE (dark icons)
          ),
          title: Text('GET PREMIUM',
              style: Theme.of(context).textTheme.headlineMedium),
          centerTitle: true,
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: kToolbarHeight + 32,
              ),
              Padding(
                  padding: EdgeInsets.all(12),
                  child: Hero(
                      tag: 'subscription_banner',
                      child: PremiumBannerPayment())),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                child: Container(
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
                  child: Visibility(
                    visible: true,
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Text("\$15 for 3 months",
                          //     textAlign: TextAlign.center,
                          //     style: GoogleFonts.montserrat(
                          //         color: Colors.black,
                          //         decoration: TextDecoration.lineThrough,
                          //         fontSize: 18,
                          //         letterSpacing: 1,
                          //         fontWeight: FontWeight.w500)),
                          // Padding(
                          //   padding: const EdgeInsets.all(8.0),
                          //   child: Text("NOW ONLY AT",
                          //       textAlign: TextAlign.center,
                          //       style: GoogleFonts.montserrat(
                          //           color: Colors.white,
                          //           fontSize: 12,
                          //           letterSpacing: 1,
                          //           fontWeight: FontWeight.w500)),
                          // ),
                          Text(
                              "You pay less than a dollor for a month."
                                  .toUpperCase(),
                              textAlign: TextAlign.center,
                              style: GoogleFonts.montserrat(
                                  color: Colors.white,
                                  fontSize: 18,
                                  letterSpacing: 2,
                                  fontWeight: FontWeight.w600)),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                              "This will go a long way in ensuring that NoBeep remains a high-quality platform and help other NoBeepers for years to come ❤️",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.montserrat(
                                  color: Colors.black,
                                  fontSize: 18,
                                  letterSpacing: 1,
                                  fontWeight: FontWeight.w400)),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                              "As a thank you for your support, we're offering a special discounted rate.💰",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.montserrat(
                                  color: Colors.black,
                                  fontSize: 18,
                                  letterSpacing: 1,
                                  fontWeight: FontWeight.w500)),

                          SizedBox(
                            height: 20,
                          ),
                          Text(
                              "It's fine if you don't want to. We have kept all the features unlocked. We Wish you an amazing journey 😊",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400)),

                          SizedBox(
                            height: 250,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
