import 'package:floor/floor.dart';
import 'package:homework_five/floor_model/diet_event_entity.dart';

@dao
abstract class DietEventDao {
  @insert
  Future<void> addOneDietEvent(DietEventEntity dietEvent);

  @Query('SELECT * FROM DietEvents WHERE id = :id')
  Future<DietEventEntity?> getOneDietEvent(int id);

  @Query('SELECT * FROM DietEvents')
  Future<List<DietEventEntity>> getAllDietEvents();

  @Query('UPDATE DietEvents SET unit = :unit WHERE id = :id')
  Future<void> updateOneDietEvent(int id, int unit);

  // Delete one diet event entry by ID
  @Query('DELETE FROM DietEvents WHERE id = :id')
  Future<void> deleteOneDietEventById(int id);

  // Delete all diet event entries
  @Query('DELETE FROM DietEvents')
  Future<void> deleteAllDietEvents();
}