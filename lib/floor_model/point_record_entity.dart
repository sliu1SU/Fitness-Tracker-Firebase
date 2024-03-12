import 'package:floor/floor.dart';

@Entity(tableName: "PointRecord")
class PointRecordEntity {
  @primaryKey
  final int? id;
  int point;
  int lvl;
  String lastType;
  int lastTimeUpdate;

  PointRecordEntity(
      this.id, this.point, this.lvl, this.lastType, this.lastTimeUpdate);
}

