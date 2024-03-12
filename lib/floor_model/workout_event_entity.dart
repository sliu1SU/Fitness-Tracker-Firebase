import 'package:floor/floor.dart';

@Entity(tableName: "WorkoutEvents")
class WorkoutEventEntity {
  @primaryKey
  final int? id;
  final String workout;
  final int unit;
  final int date;
  final int point;

  WorkoutEventEntity(this.id, this.workout, this.unit, this.date, this.point);
}