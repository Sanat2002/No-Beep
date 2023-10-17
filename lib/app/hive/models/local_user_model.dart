import 'package:hive/hive.dart';

import '../hive_type_ids.dart';

part 'local_user_model.g.dart';

@HiveType(typeId: HiveTypeID.localUserModelTypeId)
class LocalUserModel {
  LocalUserModel(
      {required this.firstName,
      required this.streakDurationInSeconds,
      required this.userMotive,
      required this.appOpenedDays,
      required this.effectiveAppDurationInSeconds,
      required this.lastAppOpenedDate,
      required this.streakStartDate,
      required this.appInitDate,
      this.customQuote,
      this.currentBadge});
  @HiveField(0)
  String firstName;
  @HiveField(1)
  int streakDurationInSeconds;
  @HiveField(2)
  String userMotive;
  @HiveField(3)
  int effectiveAppDurationInSeconds;
  @HiveField(4)
  int appOpenedDays;
  @HiveField(5)
  DateTime lastAppOpenedDate;
  @HiveField(6)
  String? customQuote;
  @HiveField(7)
  DateTime streakStartDate;
  @HiveField(8)
  DateTime appInitDate;
  @HiveField(9)
  String? currentBadge;

  LocalUserModel copyWith(
      {String? firstName,
      int? streakDurationInSeconds,
      int? appOpenedDays,
      int? effectiveAppDurationInSeconds,
      String? userMotive,
      String? customQuote,
      DateTime? lastAppOpenedDate,
      DateTime? appInitDate,
      DateTime? streakStartDate,
      String? currentBadge}) {
    return LocalUserModel(
        firstName: firstName ?? this.firstName,
        streakDurationInSeconds:
            streakDurationInSeconds ?? this.streakDurationInSeconds,
        userMotive: userMotive ?? this.userMotive,
        appOpenedDays: appOpenedDays ?? this.appOpenedDays,
        effectiveAppDurationInSeconds:
            effectiveAppDurationInSeconds ?? this.effectiveAppDurationInSeconds,
        lastAppOpenedDate: lastAppOpenedDate ?? this.lastAppOpenedDate,
        customQuote: customQuote ?? this.customQuote,
        streakStartDate: streakStartDate ?? this.streakStartDate,
        appInitDate: appInitDate ?? this.appInitDate,
        currentBadge: currentBadge ?? this.currentBadge);
  }
}
