import 'package:floor/floor.dart';
import 'package:homework_five/floor_model/emotion_event_entity.dart';

@dao
abstract class EmotionEventDao {
  @insert
  Future<void> addOneEmotionEvent(EmotionEventEntity emotionEvent);

  @Query('SELECT * FROM EmotionEvents WHERE id = :id')
  Future<EmotionEventEntity?> getOneEmotionEvent(int id);

  @Query('SELECT * FROM EmotionEvents')
  Future<List<EmotionEventEntity>> getAllEmotionEvents();

  // Delete one emotion event entry by ID
  @Query('DELETE FROM EmotionEvents WHERE id = :id')
  Future<void> deleteOneEmotionEventById(int id);

  // Delete all emotion event entries
  @Query('DELETE FROM EmotionEvents')
  Future<void> deleteAllEmotionEvents();
}