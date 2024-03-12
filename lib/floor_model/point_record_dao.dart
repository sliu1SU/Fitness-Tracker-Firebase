import 'package:floor/floor.dart';
import 'package:homework_five/floor_model/point_record_entity.dart';

@dao
abstract class PointRecordDao {
  @insert
  Future<void> addOnePointRecord(PointRecordEntity pointRecord);

  @Query('SELECT * FROM PointRecord ORDER BY lastTimeUpdate DESC LIMIT 1')
  Future<PointRecordEntity?> getLastPointRecord();

  @Query('SELECT * FROM PointRecord ORDER BY lastTimeUpdate')
  Future<List<PointRecordEntity>> getAllPointRecords();

  @Query('UPDATE PointRecord SET point = :point, lvl = :lvl, lastType = :lastType, lastTimeUpdate = :lastTimeUpdate WHERE id = :id')
  Future<void> updateOnePointRecord(int id, int point, int lvl, String lastType, int lastTimeUpdate);

  // Delete one point record entry by ID
  @Query('DELETE FROM PointRecord WHERE id = :id')
  Future<void> deleteOnePointRecordById(int id);

  // Delete all point record entries
  @Query('DELETE FROM PointRecord')
  Future<void> deleteAllPointRecords();

  @Query('SELECT COUNT(*) FROM PointRecord')
  Future<int?> getCountOfPointRecords();
}