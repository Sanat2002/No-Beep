import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:logger/logger.dart';

class AdsController extends GetxController {
  bool showAds = true;

  late BannerAd homePageBannerAd;
  late BannerAd statPageBannerAd;
  late BannerAd journalPageBannerAd;

  late InterstitialAd breathingPageInterstitialAd;

  final isHomePageBannerAdLoaded = false.obs;
  final isStatPageBannerAdLoaded = false.obs;
  final isJournalPageBannerAdLoaded = false.obs;

  bool isBreathingPageAdLoaded = false;

  initHomePageBannerAd() {
    homePageBannerAd = BannerAd(
        size: AdSize.fullBanner,
        adUnitId: dotenv.get("ADMOB_HOME_BANNER_UNIT", fallback: ''),
        listener: BannerAdListener(
          onAdLoaded: (ad) {
            isHomePageBannerAdLoaded.value = showAds ? true : false;
          },
        ),
        request: AdRequest());
    homePageBannerAd.load();
  }

  initStatPageBannerAd() {
    statPageBannerAd = BannerAd(
        size: AdSize.fullBanner,
        adUnitId: dotenv.get("ADMOB_PROFILE_BANNER_UNIT", fallback: ''),
        listener: BannerAdListener(
          onAdLoaded: (ad) {
            isStatPageBannerAdLoaded.value = showAds ? true : false;
          },
        ),
        request: AdRequest());
    statPageBannerAd.load();
  }

  initJournalPageBannerAd() {
    journalPageBannerAd = BannerAd(
        size: AdSize.fullBanner,
        adUnitId: dotenv.get("ADMOB_BANNER_UNIT", fallback: ''),
        listener: BannerAdListener(
          onAdLoaded: (ad) {
            isJournalPageBannerAdLoaded.value = showAds ? true : false;
          },
        ),
        request: AdRequest());
    journalPageBannerAd.load();
  }

  void breathingInterstitialAd() {
    InterstitialAd.load(
        adUnitId: dotenv.get("ADMOB_INTERSITIAL_UNIT", fallback: ''),
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(onAdLoaded: (ad) {
          breathingPageInterstitialAd = ad;
          isBreathingPageAdLoaded = showAds ? true : false;
        }, onAdFailedToLoad: ((error) {
          Logger().wtf(error);
        })));
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    initHomePageBannerAd();
    breathingInterstitialAd();
  }
}
