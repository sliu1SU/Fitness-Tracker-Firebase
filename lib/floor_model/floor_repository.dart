import 'package:homework_five/diet_event.dart';
import 'package:homework_five/floor_model/database.dart';
import 'package:homework_five/floor_model/diet_event_entity.dart';
import 'package:homework_five/floor_model/emotion_event_entity.dart';
import 'package:homework_five/floor_model/point_record_entity.dart';
import 'package:homework_five/floor_model/workout_event_entity.dart';
import 'package:homework_five/point_record.dart';
import 'package:homework_five/workout_event.dart';
import '../repository.dart';
import 'package:homework_five/emotion_event.dart';
import 'package:homework_five/firestore_service.dart';
import 'package:http/http.dart' as http;

class FloorRepository implements Repository {
  // need to have database here
  final AppDatabase _database;
  // ctor here
  FloorRepository(this._database);

  @override
  Future<void> addOneDietEvent(DietEvent event) async {
    final pr = await getLastPointRecord();
    PointRecord record;
    int ptEarn = 1;
    if (pr != null) {
      ptEarn = computePointEarn(event.date, pr.lastTimeUpdate);
      int newPt = pr.point + ptEarn;
      int lvl = computeNewLvl(newPt);
      record = createOnePointRecord(newPt, lvl, "diet", event.date);
    } else {
      record = createOnePointRecord(1, 1, "diet", event.date);
    }
    DietEventEntity entity = DietEventEntity(
        null,
        event.diet,
        event.unit,
        event.date.millisecondsSinceEpoch,
        ptEarn
    );
    addOnePointRecord(record);
    await _database.dietEventDao.addOneDietEvent(entity);
    // check if anyone is login
    String id = FirestoreService().getCurrentUid();
    if (id != '') {
      // there is a user currently sign in!
      print('there is a user sign in! Adding event!');
      //await FirestoreService().updateUserProfile();
      await updateLeaderboard(id, event.date.millisecondsSinceEpoch);
    }
  }

  @override
  Future<void> addOneEmotionEvent(EmotionEvent event) async {
    final pr = await getLastPointRecord();
    PointRecord record;
    int ptEarn = 1;
    if (pr != null) {
      ptEarn = computePointEarn(event.date, pr.lastTimeUpdate);
      int newPt = pr.point + ptEarn;
      int lvl = computeNewLvl(newPt);
      record = createOnePointRecord(newPt, lvl, "emotion", event.date);
    } else {
      record = createOnePointRecord(1, 1, "emotion", event.date);
    }
    EmotionEventEntity entity = EmotionEventEntity(
        null,
        event.emoji,
        event.date.millisecondsSinceEpoch,
        ptEarn
    );
    addOnePointRecord(record);
    await _database.emotionEventDao.addOneEmotionEvent(entity);
    // check if anyone is login
    String id = FirestoreService().getCurrentUid();
    if (id != '') {
      // there is a user currently sign in!
      print('there is a user sign in! Adding event!');
      //await FirestoreService().updateUserProfile();
      await updateLeaderboard(id, event.date.millisecondsSinceEpoch);
    }
  }

  @override
  Future<void> addOnePointRecord(PointRecord record) async {
    PointRecordEntity entity = PointRecordEntity(
        null,
        record.point,
        record.lvl,
        record.lastType,
        record.lastTimeUpdate.millisecondsSinceEpoch
    );
    await _database.pointRecordDao.addOnePointRecord(entity);
  }

  @override
  Future<void> addOneWorkoutEvent(WorkoutEvent event) async {
    final pr = await getLastPointRecord();
    PointRecord record;
    int ptEarn = 1;
    if (pr != null) {
      ptEarn = computePointEarn(event.date, pr.lastTimeUpdate);
      int newPt = pr.point + ptEarn;
      int lvl = computeNewLvl(newPt);
      record = createOnePointRecord(newPt, lvl, "workout", event.date);
      addOnePointRecord(record);
    } else {
      record = createOnePointRecord(1, 1, "workout", event.date);
    }
    WorkoutEventEntity entity = WorkoutEventEntity(
        null,
        event.workout,
        event.unit,
        event.date.millisecondsSinceEpoch,
        ptEarn
    );
    addOnePointRecord(record);
    await _database.workoutEventDao.addOneWorkoutEvent(entity);
    // check if anyone is login
    String id = FirestoreService().getCurrentUid();
    if (id != '') {
      // there is a user currently sign in!
      print('there is a user sign in! Adding event!');
      //await FirestoreService().updateUserProfile();
      await updateLeaderboard(id, event.date.millisecondsSinceEpoch);
    }
  }

  @override
  Future<void> deleteOneDietEventById(int id) async {
    await _database.dietEventDao.deleteOneDietEventById(id);
  }

  @override
  Future<void> deleteOneEmotionEventById(int id) async {
    await _database.emotionEventDao.deleteOneEmotionEventById(id);
  }

  @override
  Future<void> deleteOneWorkoutEventById(int id) async {
    await _database.workoutEventDao.deleteOneWorkoutEventById(id);
  }

  @override
  Future<List<DietEvent>> getAllDietEvents() async {
    final rtn = await _database.dietEventDao.getAllDietEvents();
    return rtn.map((e) {
      return DietEvent(
          e.id,
          e.diet,
          e.unit,
          DateTime.fromMillisecondsSinceEpoch(e.date),
          e.point
      );
    }).toList();
  }

  @override
  Future<List<EmotionEvent>> getAllEmotionEvents() async {
    final rtn = await _database.emotionEventDao.getAllEmotionEvents();
    return rtn.map((e) {
      return EmotionEvent(
          e.id,
          e.emoji,
          DateTime.fromMillisecondsSinceEpoch(e.date),
          e.point
      );
    }).toList();
  }

  @override
  Future<List<WorkoutEvent>> getAllWorkoutEvents() async {
    final rtn = await _database.workoutEventDao.getAllWorkoutEvents();
    return rtn.map((e) => WorkoutEvent(
        e.id,
        e.workout,
        e.unit,
        DateTime.fromMillisecondsSinceEpoch(e.date),
        e.point
    )).toList();
  }

  @override
  Future<PointRecord?> getLastPointRecord() async {
    final rtn = await _database.pointRecordDao.getLastPointRecord();
    if (rtn != null) {
      // return an pr object
      return PointRecord(
          rtn.id,
          rtn.point,
          rtn.lvl,
          rtn.lastType,
          DateTime.fromMillisecondsSinceEpoch(rtn.lastTimeUpdate)
      );
    }
    return null;
  }

  @override
  Future<void> updateOneDietEvent(int id, int unit) async {
    await _database.dietEventDao.updateOneDietEvent(id, unit);
  }

  @override
  Future<void> updateOnePointRecord(int id, int point, int lvl, String lastType, DateTime curTime) async {
    await _database.pointRecordDao.updateOnePointRecord(id, point, lvl, lastType, curTime.millisecondsSinceEpoch);
  }

  @override
  Future<int> getCountOfPointRecords() async {
    int? count = await _database.pointRecordDao.getCountOfPointRecords();
    return count ?? 0;
  }

  // local in memory helper functions, no need to access database
  int computeNewLvl(int point) {
    int lvl = (point / 10).floor();
    if (lvl > 99) {
      return 99;
    }
    return lvl;
  }

  int computePointEarn(DateTime curTime, DateTime lastTimeUpdate) {
    int diff = curTime.difference(lastTimeUpdate).inSeconds;
    //int diff = curTime - lastTimeUpdate;
    int point = 0;
    if (diff < 10) {
      point = 1;
    } else if (10 <= diff && diff <= 20) {
      point = 5;
    } else {
      point = 10;
    }
    return point;
  }

  // this async function will call the cloud function via http
  Future<void> updateLeaderboard(String id, int newLastTimeUpdate) async {
    try {
      // Define the URL of your Cloud Function
      const url = 'https://updateleaderboard-5ly4yjpiwq-uc.a.run.app';

      // Define the request body
      final body = {'id': id, 'newLastTimeUpdate': newLastTimeUpdate.toString()};

      // Make a POST request to the Cloud Function
      final response = await http.post(Uri.parse(url), body: body);

      // Check if the request was successful
      if (response.statusCode == 200) {
        print('Document with ID $id updated successfully.');
      } else {
        print('Failed to update document with ID $id. Error: ${response.body}');
      }
    } catch (error) {
      print('Error updating document: $error');
    }
  }

  PointRecord createOnePointRecord(int point, int lvl, String lastType, DateTime lastTimeUpdate) {
    return PointRecord(null, point, lvl, lastType, lastTimeUpdate);
  }
}