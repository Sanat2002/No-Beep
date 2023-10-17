import 'package:hive/hive.dart';
import '../hive_type_ids.dart';
part 'journal_local_model.g.dart';

@HiveType(typeId: HiveTypeID.journal_data_model)
class JournalLocalModel {
  JournalLocalModel(
      {required this.journalText,
      required this.journalDay,
      required this.tag,
      required this.journalTimeStamp,
      required this.key});
  @HiveField(0)
  String journalText;
  @HiveField(1)
  int journalDay;
  @HiveField(2)
  String tag;
  @HiveField(3)
  DateTime journalTimeStamp;
  @HiveField(4)
  String key;

  JournalLocalModel copyWith({
    String? journalText,
    int? journalDay,
    String? tag,
    String? customQuote,
    DateTime? journalTimeStamp,
    String? key,
  }) {
    return JournalLocalModel(
      journalText: journalText ?? this.journalText,
      journalDay: journalDay ?? this.journalDay,
      tag: tag ?? this.tag,
      key: key ?? this.key,
      journalTimeStamp: journalTimeStamp ?? this.journalTimeStamp,
    );
  }
}
