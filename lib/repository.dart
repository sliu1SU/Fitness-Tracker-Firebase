// this is an interface! it only defines the signatures of
// functions. The functions implementations are in floor_repo

import 'package:homework_five/diet_event.dart';
import 'package:homework_five/emotion_event.dart';
import 'package:homework_five/point_record.dart';
import 'package:homework_five/workout_event.dart';

abstract class Repository {
  // emotion recorder functions
  Future<void> addOneEmotionEvent(EmotionEvent event);
  //Future<EmotionEvent> getOneEmotionEvent(int id);
  Future<List<EmotionEvent>> getAllEmotionEvents();
  Future<void> deleteOneEmotionEventById(int id);
  //Future<void> deleteAllEmotionEvents();

  // diet recorder functions
  Future<void> addOneDietEvent(DietEvent event);
  //Future<DietEvent> getOneDietEvent(int id);
  Future<List<DietEvent>> getAllDietEvents();
  Future<void> updateOneDietEvent(int id, int unit);
  Future<void> deleteOneDietEventById(int id);
  //Future<void> deleteAllDietEvents();

  // workout recorder functions
  Future<void> addOneWorkoutEvent(WorkoutEvent event);
  //Future<WorkoutEvent> getOneWorkoutEvent(int id);
  Future<List<WorkoutEvent>> getAllWorkoutEvents();
  Future<void> deleteOneWorkoutEventById(int id);
  //Future<void> deleteAllWorkoutEvents();

  // point record functions
  Future<void> addOnePointRecord(PointRecord record);
  Future<PointRecord?> getLastPointRecord();
  //Future<List<PointRecord>> getAllPointRecords();
  Future<void> updateOnePointRecord(int id, int point, int lvl, String lastType, DateTime curTime);
  //Future<void> deleteOnePointRecordById(int id);
  //Future<void> deleteAllPointRecords();
  Future<int> getCountOfPointRecords();
  // int computePointEarn(int curTime, int lastTimeUpdate);
  // int computeNewLvl(int point);
}