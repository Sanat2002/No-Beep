import 'package:hive/hive.dart';

import '../hive_type_ids.dart';

part 'local_reset_model.g.dart';

@HiveType(typeId: HiveTypeID.reset_data_model)
class ResetLocalModel {
  ResetLocalModel({
    required this.reason,
    required this.realapseDay,
    required this.relapseTimeStamp,
  });
  @HiveField(0)
  String reason;
  @HiveField(1)
  String realapseDay;
  @HiveField(2)
  DateTime relapseTimeStamp;
}
