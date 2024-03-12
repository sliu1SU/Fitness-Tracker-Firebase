import 'package:floor/floor.dart';

@Entity(tableName: "DietEvents")
class DietEventEntity {
  @primaryKey
  final int? id;
  final String diet;
  final int unit;
  final int date;
  final int point;

  DietEventEntity(this.id, this.diet, this.unit, this.date, this.point);
}