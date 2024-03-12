import 'package:flutter/cupertino.dart';
import 'package:homework_five/point_record.dart';
import 'package:homework_five/repository.dart';
import 'package:homework_five/workout_event.dart';
import 'package:homework_five/diet_event.dart';
import 'package:homework_five/emotion_event.dart';

class ViewModel with ChangeNotifier {
  final Repository _repository;
  ViewModel(this._repository);

  // define all functions that clients can call
  // emotion functions
  Future<void> addOneEmotionEvent(EmotionEvent event) async {
    await _repository.addOneEmotionEvent(event);
    notifyListeners();
  }

  Future<List<EmotionEvent>> getAllEmotionEvents() async {
    return await _repository.getAllEmotionEvents();
  }

  Future<void> deleteOneEmotionEventById(int id) async {
    await _repository.deleteOneEmotionEventById(id);
    notifyListeners();
  }

  // diet functions
  Future<void> addOneDietEvent(DietEvent event) async {
    await _repository.addOneDietEvent(event);
    notifyListeners();
  }

  Future<List<DietEvent>> getAllDietEvents() async {
    return await _repository.getAllDietEvents();
  }

  Future<void> updateOneDietEvent(int id, int unit) async {
    await _repository.updateOneDietEvent(id, unit);
    notifyListeners();
  }

  Future<void> deleteOneDietEventById(int id) async {
    await _repository.deleteOneDietEventById(id);
    notifyListeners();
  }

  // workout functions
  Future<void> addOneWorkoutEvent(WorkoutEvent event) async {
    await _repository.addOneWorkoutEvent(event);
    notifyListeners();
  }

  Future<List<WorkoutEvent>> getAllWorkoutEvents() async {
    return await _repository.getAllWorkoutEvents();
  }

  Future<void> deleteOneWorkoutEventById(int id) async {
    await _repository.deleteOneWorkoutEventById(id);
    notifyListeners();
  }

  // point record functions
  Future<void> addOnePointRecord(PointRecord record) async {
    await _repository.addOnePointRecord(record);
    notifyListeners();
  }

  Future<PointRecord?> getLastPointRecord() async {
    return await _repository.getLastPointRecord();
  }

  Future<void> updateOnePointRecord(int id, int point, int lvl, String lastType, DateTime lastTimeUpdate) async {
    await _repository.updateOnePointRecord(id, point, lvl, lastType, lastTimeUpdate);
    notifyListeners();
  }

  Future<int> getCountOfPointRecords() async {
    return await _repository.getCountOfPointRecords();
  }
}