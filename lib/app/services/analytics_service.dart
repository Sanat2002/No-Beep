import 'dart:math';

import 'package:amplitude_flutter/amplitude.dart';
import '../../constants.dart';

class AnalyticsService {
  final Amplitude _amplitudeAnalytics =
      Amplitude.getInstance(instanceName: ANDROID_APP_ID);

  initAmplitude() {
    _amplitudeAnalytics.init("b4d17e819fd52ed5b6db4f10c4d0e5b8");
    _amplitudeAnalytics.trackingSessionEvents(true);
  }

  Future setUserProperties() async {
    var timeStamp = DateTime.now();

    await _amplitudeAnalytics
        .setUserProperties({"name": "user_type", "value": "test"});
    await _amplitudeAnalytics
        .setUserId("user" + getRandomString() + timeStamp.toIso8601String());
  }

  Future setPaidUserProperty(bool isPaid) async {
    await _amplitudeAnalytics.setUserProperties({"isPaid": isPaid.toString()});
  }

  Future logTabName({required String tabName}) async {
    await _amplitudeAnalytics
        .logEvent("tab_tapped", eventProperties: {"tab_name": tabName});
  }

  Future logNotificationTappedAction({required String actionName}) async {
    await _amplitudeAnalytics.logEvent("notification_tapped",
        eventProperties: {"action_name": actionName});
  }

  Future logBottomNavTappedAction({required String navItemName}) async {
    await _amplitudeAnalytics.logEvent("bottom_nav_item_tapped",
        eventProperties: {"bottom_name_item_name": navItemName});
  }

  Future logFaqQuestionExpanded({required String questionText}) async {
    await _amplitudeAnalytics.logEvent("faq_expanded",
        eventProperties: {"question_text": questionText});
  }

  Future logFaqQuestionCollapsed({required String questionText}) async {
    await _amplitudeAnalytics.logEvent("faq_collapsed",
        eventProperties: {"question_text": questionText});
  }

  Future logButtonAction({required String buttonFunction}) async {
    await _amplitudeAnalytics.logEvent("button_action",
        eventProperties: {"button_function": buttonFunction});
  }

  Future logButtonTapped(
      {required String buttonName, String? patientId}) async {
    if (patientId != null) {
      await _amplitudeAnalytics.logEvent("button_tapped", eventProperties: {
        "button_name": buttonName,
        "patient_id": patientId
      });
    } else {
      await _amplitudeAnalytics.logEvent("button_tapped",
          eventProperties: {"button_name": buttonName});
    }
  }

  Future logCardVisible({required String cardName}) async {
    await _amplitudeAnalytics.logEvent("card_visibility_gained",
        eventProperties: {"card_name": cardName});
  }

  Future logCardInvisible({required String cardName}) async {
    await _amplitudeAnalytics.logEvent("card_visibility_lost",
        eventProperties: {"card_name": cardName});
  }

  Future logNavigation({required String routename}) async {
    await _amplitudeAnalytics.logEvent("new_screen_opned",
        eventProperties: {"route_name": routename});
  }

  String getRandomString() {
    const chars = "abcdefghijklmnopqrstuvwxyz0123456789";
    final random = Random();
    String result = "";
    for (int i = 0; i < 5; i++) {
      result += chars[random.nextInt(chars.length)];
    }
    return result;
  }
}

//Button taps--->
const String START_STREAK_NOW = 'onboard_start_streak_now';
const String START_STREAK_PICK_DATE = 'onboard_start_streak_pick_date';
const String ONBOARD_STREAK_CUSTOM_DAY_DONE = 'onboard_streak_custom_day_done';
const String ONBOARD_MOTIVE_HELP = 'onboard_motive_help';
const String ONBOARD_MOTIVE_LETS_GO = 'onboard_motive_lets_go';

const String SCROLL_BUTTON_HOME = 'scroll_button_home';

const String RESET_HOME = 'reset_home';
const String EMERGENCY_HOME = 'emergency_home';
const String HOME_QUOTES = 'home_quotes';
const String HOME_TIMELINE = 'home_timeline';
const String HOME_JOURNAL = 'home_journal';
const String HOME_PROGRESS = 'home_progress';
const String HOME_CHANGE_START_DATE = 'home_change_start_date';
const String HOME_RELAPSE_HISTORY = 'home_relapse_history';
const String HOME_IMPROVE_NEEP = 'home_improve_neep';

const String JOURNAL_ADD_FAB = 'journal_add_fab';
const String JOURAL_TILE = 'journal_tile';

const String RESET_PAGE_DONE = 'reset_page_done';
const String JOURNAL_PAGE_DONE = 'journal_page_done';

const String QUOTES_TAP = 'quotes_tap';
const String CUSTOM_QUOTE_EDIT_TAP = 'quotes_edit_tap';
const String CUSTOM_QUOTE_EDIT_SUCESS = 'quotes_edit_sucess';
const String QUOTES_AD_TAP = 'quotes_ad_tap';

const String TIMELINE_DAY_PLUS = 'time_line_day_plus';
const String TIMELINE_DAY_MINUS = 'time_line_day_minus';
const String TIMELINE_SHOW_AD = 'timeline_show_ad';

const String EMERGENCY_MOTIVE_EDIT = 'emergency_motive_edit';
const String EMERGENCY_MOTIVE_EDIT_SUCCESS = 'emergency_motive_edit_success';
const String EMERGENCY_LOOK_MIRROR = 'emergency_look_mirror';
const String EMERGENCY_LISTEN_MUSIC = 'emergency_listen_music';
const String EMERGENCY_BREATING_EXERCISE = 'emergency_breating_exercise';
const String EMeRGENCY_URGE_REASON = 'emergency_urge_reason';

const String NEEP_PREMIUM_BANNER_TIMELINE_PAGE =
    'neep_premium_banner_timeline_page';
const String NEEP_PREMIUM_BANNER_BADGE_PAGE = 'neep_premium_banner_badge_page';

const String YT_VIDEO_TILE_TAPPED = 'youtube_video_tile';

const String NEW_BADGE_BACK = 'badge_page_back';
const String POST_RELAPSE_DIALOG = 'post_relapse_button';

///Card Names -----:
const String HOME_QUOTES_CARD = 'home_quotes_card';
const String HOME_TIMELINE_CARD = 'home_timeline_card';
const String HOME_JOURNAL_CARD = 'home_journal_card';
const String HOME_BADGE_CARD = 'home_badge_card';
const String HOME_CHANGE_DATE_CARD = 'home_change_date_card';
const String HOME_HISTORY_CARD = 'home_history_card';

const String BADGE_CARD = 'badge_card';
const String BADGE_AD_CARD = 'badge_ad_card';

const String TIMELINE_PREMIUM_CARD = 'timeline_premium_card';

const String EMERGENCY_BREATING_CARD = 'emergency_breathing_card';
const String EMERGENCY_ACTIONABLE_STEPS_CARD =
    'emergency_actionable_steps_card';
