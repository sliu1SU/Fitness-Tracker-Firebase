import 'package:floor/floor.dart';

@Entity(tableName: "EmotionEvents")
class EmotionEventEntity {
  @primaryKey
  final int? id;
  final String emoji;
  final int date;
  final int point;

  EmotionEventEntity(this.id, this.emoji, this.date, this.point);
}