import 'package:hive/hive.dart';
import 'package:neep/app/hive/models/journal_local_model.dart';
import 'package:neep/app/hive/models/timeline_local_model.dart';
import 'models/local_reset_model.dart';
import 'models/local_user_model.dart';
import 'models/quotes_hive_model.dart';

class HiveBoxes {
  static Box<LocalUserModel> getUserHiveBox() {
    return Hive.box<LocalUserModel>('local_user');
  }

  static Box<QuotesLocalModel> getQuotesLocalBox() {
    return Hive.box<QuotesLocalModel>('local_quotes');
  }

  static Box<QuotesLocalModel> getRelapseQuotesLocalBox() {
    return Hive.box<QuotesLocalModel>('relapse_local_quotes');
  }

  static Box<TimeLineData> getTimelineLocalBox() {
    return Hive.box<TimeLineData>('local_timeline');
  }

  static Box<ResetLocalModel> getResetDataBox() {
    return Hive.box<ResetLocalModel>('local_reset');
  }

  static Box<JournalLocalModel> getLocalJournalBox() {
    return Hive.box<JournalLocalModel>('local_journal');
  }
}
