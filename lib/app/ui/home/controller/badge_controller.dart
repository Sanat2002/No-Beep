import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import '../../../hive/hive_boxes.dart';
import '../../../streak_controller.dart';

String getDateString({required BadgeModel badge}) {
  int? badgeLL = badge.badgeLowerBound;
  int? badgeUL = badge.badgeUpperBound;

  if (badgeLL != null && badgeUL != null) {
    return 'DAYS ${badgeLL + 1}-${badgeUL}';
  } else if (badgeLL != null && badgeUL == null) {
    return 'DAY ${badgeLL}';
  } else if (badgeLL == null && badgeUL != null) {
    return 'DAYS ${badgeUL}+';
  } else {
    return '';
  }
}

class BadgeController extends GetxController {
  final streakController = Get.put(StreakController());
  final streakDuration = Get.put(StreakController()).streakDuration;
  var resetReasonTextController = TextEditingController();
  final resetBox = HiveBoxes.getResetDataBox();
  final userDataBox = HiveBoxes.getUserHiveBox();
  final RxMap<DateTime, int> heatDataSet = RxMap();

  final currentBadge = Rxn<BadgeModel>();

  BadgeModel? setBadge() {
    final int currentDay = streakDuration.value.inDays;
    badgeMap.values.forEach((element) {
      int? badgeLL = element.badgeLowerBound;
      int? badgeUL = element.badgeUpperBound;

      if (badgeLL != null && badgeUL != null) {
        if (currentDay >= badgeLL && currentDay < badgeUL) {
          currentBadge.value = element;
        }
      } else if (badgeLL != null && badgeUL == null) {
        if (currentDay >= badgeLL) {
          currentBadge.value = element;
        }
      } else if (badgeLL == null && badgeUL != null) {
        if (currentDay >= badgeUL) {
          currentBadge.value = element;
        }
      }
    });

    return currentBadge.value;
  }

  int getBadgeIndex() {
    if (currentBadge.value == null) {
      return 0;
    }
    int index = badgeMap.values.toList().indexWhere(
        (element) => element.badgeId == currentBadge.value!.badgeId);

    return index;
  }
}

class BadgeModel {
  final String badgeId;
  final String badgeDisplay;
  final String badgeImgUrl;
  final List<String>? gifList;
  final int? badgeLowerBound;
  final int? badgeUpperBound;

  BadgeModel(
      {required this.badgeId,
      required this.badgeImgUrl,
      this.gifList,
      required this.badgeDisplay,
      this.badgeLowerBound,
      this.badgeUpperBound});
}

Map<String, BadgeModel> badgeMap = {
  'newbie': BadgeModel(
      badgeDisplay: 'NEWBIE',
      badgeId: 'newbie',
      badgeImgUrl:
          'https://media.tenor.com/Du3ZrK0bApgAAAAd/luka-doncic-thumbs-up.gif',
      badgeLowerBound: 0,
      gifList: [
        'https://media.tenor.com/Du3ZrK0bApgAAAAd/luka-doncic-thumbs-up.gif',
        'https://media.tenor.com/o-oTrubLXw8AAAAC/the-chosen-thaddeus.gif'
      ]),
  'kid': BadgeModel(
      badgeDisplay: 'KID',
      badgeId: 'kid',
      badgeImgUrl: 'https://media.tenor.com/ImZq6E5pZ9QAAAAd/haltere.gif',
      badgeLowerBound: 1,
      gifList: [
        'https://media.tenor.com/ImZq6E5pZ9QAAAAd/haltere.gif',
        'https://media.tenor.com/RoH8J3BzQSEAAAAd/excited-hockey.gif',
        'https://media.tenor.com/dU8VyARy7PMAAAAd/church.gif'
      ]),
  'intern': BadgeModel(
      badgeDisplay: 'INTERN',
      badgeId: 'intern',
      badgeImgUrl:
          'https://media.tenor.com/DwyZ0JvXGqwAAAAC/im-ryan-the-intern.gif',
      badgeLowerBound: 2,
      gifList: [
        'https://media.tenor.com/2c0911F9SqkAAAAd/andy-office.gif',
        'https://media.tenor.com/DwyZ0JvXGqwAAAAC/im-ryan-the-intern.gif'
      ]),
  'beliver': BadgeModel(
    badgeDisplay: 'BELIVER',
    badgeId: 'beliver',
    badgeImgUrl:
        'https://media.tenor.com/yS-KqSGuH2QAAAAC/okayokay-this-is-alin.gif',
    badgeLowerBound: 3,
  ),
  'cool_kid': BadgeModel(
    badgeDisplay: 'COOL KID',
    badgeId: 'cool_kid',
    badgeImgUrl: 'https://media.tenor.com/_vC1o_iqduAAAAAC/kid-cool.gif',
    badgeLowerBound: 4,
  ),
  'recruit': BadgeModel(
    badgeDisplay: 'RECRUIT',
    badgeId: 'recruit',
    badgeImgUrl:
        'https://media.tenor.com/bMorSSFEsPgAAAAC/nightcrawler-gyllenhaal.gif',
    badgeLowerBound: 5,
  ),
  'member': BadgeModel(
    badgeDisplay: 'MEMBER',
    badgeId: 'member',
    badgeImgUrl:
        'https://media.tenor.com/ubgtCAokOz0AAAAd/nightcrawler-jake.gif',
    badgeLowerBound: 6,
  ),
  'weak_2_week': BadgeModel(
    badgeDisplay: 'WEAK 2 WEEK',
    badgeId: 'weak_2_week',
    badgeImgUrl: 'https://media.tenor.com/qkQ2g4UBf7gAAAAd/nandor-wwdits.gif',
    badgeLowerBound: 7,
  ),
  'eighth_wonder': BadgeModel(
    badgeDisplay: '8th WONDER',
    badgeId: 'eighth_wonder',
    badgeImgUrl:
        'https://media.tenor.com/T42cqp6YKEEAAAAd/damn-damn-damn-damn.gif',
    badgeLowerBound: 8,
  ),
  'iron_will': BadgeModel(
    badgeDisplay: 'IRON WILL',
    badgeId: 'iron_will',
    badgeImgUrl:
        'https://media.tenor.com/5TbsqjFKK5gAAAAd/chris-evans-captain-america.gif',
    badgeLowerBound: 9,
  ),
  'badass': BadgeModel(
      badgeDisplay: 'BADASS',
      badgeId: 'badass',
      badgeImgUrl:
          'https://media.tenor.com/2M0tgmbQxiwAAAAd/elon-musk-badass.gif',
      badgeLowerBound: 9,
      badgeUpperBound: 14),
  'wolf': BadgeModel(
      badgeDisplay: 'WOLF',
      badgeId: 'wolf',
      badgeImgUrl: 'https://media.tenor.com/J5nDMXrbse4AAAAC/wolf-of.gif',
      badgeLowerBound: 14,
      badgeUpperBound: 21),
  'badass_master': BadgeModel(
      badgeDisplay: 'BADASS MASTER',
      badgeId: 'badass_master',
      badgeImgUrl:
          'https://media.tenor.com/tN18csBAIZAAAAAC/thats-some-badass.gif',
      badgeLowerBound: 21,
      badgeUpperBound: 30),
  'champion': BadgeModel(
      badgeDisplay: 'CHAMP',
      badgeId: 'champion',
      badgeImgUrl: 'https://media.tenor.com/Z_IV0-4w2vEAAAAC/yes-winning.gif',
      badgeLowerBound: 30,
      badgeUpperBound: 45),
  'conqueror': BadgeModel(
      badgeDisplay: 'CONQUEROR',
      badgeId: 'conqueror',
      badgeImgUrl:
          'https://media.tenor.com/bhdgSqq_AGQAAAAC/wwe-paul-heyman.gif',
      badgeLowerBound: 45,
      badgeUpperBound: 65),
  'legend': BadgeModel(
      badgeDisplay: 'LEGEND',
      badgeId: 'legend',
      badgeImgUrl:
          'https://media.tenor.com/9hWPHjVtkmYAAAAd/slow-motion-legend.gif',
      badgeLowerBound: 65,
      badgeUpperBound: 90),
  'sensei': BadgeModel(
      badgeDisplay: 'Sensei',
      badgeId: 'sensei',
      badgeImgUrl: 'https://media.tenor.com/g_smSrfkoLcAAAAd/goku-bowing.gif',
      badgeLowerBound: 90,
      badgeUpperBound: 120),
  'king': BadgeModel(
      badgeDisplay: 'KING',
      badgeId: 'king',
      badgeImgUrl:
          'https://media.tenor.com/QQbGhGC4E2YAAAAC/should-we-bow-yea-hes-a-king-don-cheadle.gif',
      badgeLowerBound: 120,
      badgeUpperBound: 150),
  'elite': BadgeModel(
      badgeDisplay: 'ELITE',
      badgeId: 'elite',
      badgeImgUrl:
          'https://media.tenor.com/8Pc46MYSyKQAAAAd/vergilsmile-vergil.gif',
      badgeLowerBound: 150,
      badgeUpperBound: 200),
  'godlike': BadgeModel(
      badgeDisplay: 'GODLIKE',
      badgeId: 'godlike',
      badgeImgUrl: 'https://media.tenor.com/hTNrdc3qX0YAAAAd/perun-perkun.gif',
      badgeLowerBound: 200,
      badgeUpperBound: 300),
  'escaped_matrix': BadgeModel(
    badgeDisplay: 'ESCAPED MATRIX',
    badgeId: 'escaped_matrix',
    badgeImgUrl: 'https://media.tenor.com/ZClNLDlvpjAAAAAd/neo-matrix.gif',
    badgeUpperBound: 300,
  ),
};
