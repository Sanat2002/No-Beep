import 'package:get/route_manager.dart';
import 'package:neep/app/ui/posts/add_post_page.dart';
import 'package:neep/app/ui/posts/post_page.dart';
import 'package:neep/app/ui/profile/login_page.dart';
import 'package:neep/app/ui/profile/register_page.dart';
import 'package:neep/app/ui/profile/signup_page.dart';
import '../ui/bottom_nav_bar/bottom_nav_bar.dart';
import '../ui/emergency/breathing_screen.dart';
import '../ui/emergency/emergency_page.dart';
import '../ui/history/history_page.dart';
import '../ui/home/new_badge.dart';
import '../ui/journal/write_journal_page.dart';
import '../ui/onboarding/date_selection_onboarding.dart';
import '../ui/onboarding/intro_page.dart';
import '../ui/onboarding/onboarding_motive_page.dart';
import '../ui/reset/reset_page.dart';
import '../ui/subscription/subscription_page.dart';

class RoutesClass {
  static String intro = '/';
  static String onboardingDateSelection = '/onboarding/dateSelection';
  static String onboardingMotivepage = '/onboarding/motivePage';
  static String bottomNav = '/bottomNav';
  static String post = '/post';
  static String signUp = '/signUp';
  static String login = '/login';
  static String register = '/register';
  static String addpost = '/addpost';

  static String emergencyBreathing = '/bottomNav/breathingScreen';
  static String resetPage = '/bottomNav/reset';
  static String emergencyPage = '/bottomNav/emergency';
  static String resetHistory = '/bottomNav/resetHistory';
  static String writeJournal = '/bottomNav/writeJournal';
  static String subscriptionPage = '/bottomNav/subscriptionPage';
  static String newBagePage = '/bottomNav/newBagePage';

  static String getIntroPageRoute() => intro;
  static String getOnboardingDateSelectionPage() => onboardingDateSelection;
  static String getOnboardingMotivePage() => onboardingMotivepage;
  static String getBottomnavPageRoute() => bottomNav;
  static String getPostPageRoute() => post;
  static String getSignUpPageRoute() => signUp;
  static String getLoginPageRoute() => login;
  static String getRegisterPageRoute() => register;
  static String getaddPostPageRoute() => addpost;
  static String getEmergencyBreathingRoute() => emergencyBreathing;
  static String getEmergencyPageRoute() => emergencyPage;

  static String getResetPageRoute() => resetPage;
  static String getResetHistoryPageRoute() => resetHistory;
  static String getWriteJournalPageRoute() => writeJournal;
  static String getSubscriptionPagePageRoute() => subscriptionPage;
  static String getNewBadePageRoute() => newBagePage;

  static List<GetPage> routes = [
    GetPage(name: intro, page: () => AppIntroPage()),
    GetPage(
        name: onboardingDateSelection,
        page: () => OnboardingDateSelectionPage(),
        transition: Transition.fade,
        transitionDuration: Duration(milliseconds: 200)),
    GetPage(
        name: onboardingMotivepage,
        page: () => OnboardingMotivePage(),
        transition: Transition.fade,
        transitionDuration: Duration(milliseconds: 200)),
    GetPage(
        name: post,
        page: () => PostPage(),
        transition: Transition.fade,
        transitionDuration: Duration(milliseconds: 200)),
    GetPage(
        name: signUp,
        page: () => SignUp(),
        transition: Transition.fade,
        transitionDuration: Duration(milliseconds: 200)),
    GetPage(
        name: login,
        page: () => LoginScreen(),
        transition: Transition.fade,
        transitionDuration: Duration(milliseconds: 200)),
    GetPage(
        name: register,
        page: () => RegisterPage(),
        transition: Transition.fade,
        transitionDuration: Duration(milliseconds: 200)),
    GetPage(
        name: addpost,
        page: () => AddPost(),
        transition: Transition.fade,
        transitionDuration: Duration(milliseconds: 200)),
    GetPage(
        name: bottomNav,
        page: () => BottomNavScreen(),
        arguments: Get.arguments,
        transition: Transition.fade,
        transitionDuration: Duration(milliseconds: 200)),
    GetPage(name: emergencyBreathing, page: () => BreathingScreen()),
    GetPage(name: resetPage, page: () => ResetPage()),
    GetPage(name: emergencyPage, page: () => EmergencyPage()),
    GetPage(name: resetHistory, page: () => HistoryPage()),
    GetPage(name: writeJournal, page: () => WriteJournalPage()),
    GetPage(name: subscriptionPage, page: () => SubscriptionPage()),
    GetPage(
        name: newBagePage,
        arguments: Get.arguments,
        page: () => NewBadgePage()),
  ];
}
