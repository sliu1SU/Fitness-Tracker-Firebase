// required package imports
import 'dart:async';
import 'package:floor/floor.dart';
import 'package:homework_five/floor_model/diet_event_dao.dart';
import 'package:homework_five/floor_model/diet_event_entity.dart';
import 'package:homework_five/floor_model/emotion_event_dao.dart';
import 'package:homework_five/floor_model/emotion_event_entity.dart';
import 'package:homework_five/floor_model/workout_event_dao.dart';
import 'package:homework_five/floor_model/workout_event_entity.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'point_record_entity.dart';
import 'point_record_dao.dart';

part 'database.g.dart';

@Database(
    version: 1,
    entities: [
      PointRecordEntity,
      EmotionEventEntity,
      DietEventEntity,
      WorkoutEventEntity
    ])
abstract class AppDatabase extends FloorDatabase {
  PointRecordDao get pointRecordDao;
  EmotionEventDao get emotionEventDao;
  DietEventDao get dietEventDao;
  WorkoutEventDao get workoutEventDao;
}