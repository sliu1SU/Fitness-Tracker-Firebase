// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  PointRecordDao? _pointRecordDaoInstance;

  EmotionEventDao? _emotionEventDaoInstance;

  DietEventDao? _dietEventDaoInstance;

  WorkoutEventDao? _workoutEventDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `PointRecord` (`id` INTEGER, `point` INTEGER NOT NULL, `lvl` INTEGER NOT NULL, `lastType` TEXT NOT NULL, `lastTimeUpdate` INTEGER NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `EmotionEvents` (`id` INTEGER, `emoji` TEXT NOT NULL, `date` INTEGER NOT NULL, `point` INTEGER NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `DietEvents` (`id` INTEGER, `diet` TEXT NOT NULL, `unit` INTEGER NOT NULL, `date` INTEGER NOT NULL, `point` INTEGER NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `WorkoutEvents` (`id` INTEGER, `workout` TEXT NOT NULL, `unit` INTEGER NOT NULL, `date` INTEGER NOT NULL, `point` INTEGER NOT NULL, PRIMARY KEY (`id`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  PointRecordDao get pointRecordDao {
    return _pointRecordDaoInstance ??=
        _$PointRecordDao(database, changeListener);
  }

  @override
  EmotionEventDao get emotionEventDao {
    return _emotionEventDaoInstance ??=
        _$EmotionEventDao(database, changeListener);
  }

  @override
  DietEventDao get dietEventDao {
    return _dietEventDaoInstance ??= _$DietEventDao(database, changeListener);
  }

  @override
  WorkoutEventDao get workoutEventDao {
    return _workoutEventDaoInstance ??=
        _$WorkoutEventDao(database, changeListener);
  }
}

class _$PointRecordDao extends PointRecordDao {
  _$PointRecordDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _pointRecordEntityInsertionAdapter = InsertionAdapter(
            database,
            'PointRecord',
            (PointRecordEntity item) => <String, Object?>{
                  'id': item.id,
                  'point': item.point,
                  'lvl': item.lvl,
                  'lastType': item.lastType,
                  'lastTimeUpdate': item.lastTimeUpdate
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<PointRecordEntity> _pointRecordEntityInsertionAdapter;

  @override
  Future<PointRecordEntity?> getLastPointRecord() async {
    return _queryAdapter.query(
        'SELECT * FROM PointRecord ORDER BY lastTimeUpdate DESC LIMIT 1',
        mapper: (Map<String, Object?> row) => PointRecordEntity(
            row['id'] as int?,
            row['point'] as int,
            row['lvl'] as int,
            row['lastType'] as String,
            row['lastTimeUpdate'] as int));
  }

  @override
  Future<List<PointRecordEntity>> getAllPointRecords() async {
    return _queryAdapter.queryList(
        'SELECT * FROM PointRecord ORDER BY lastTimeUpdate',
        mapper: (Map<String, Object?> row) => PointRecordEntity(
            row['id'] as int?,
            row['point'] as int,
            row['lvl'] as int,
            row['lastType'] as String,
            row['lastTimeUpdate'] as int));
  }

  @override
  Future<void> updateOnePointRecord(
    int id,
    int point,
    int lvl,
    String lastType,
    int lastTimeUpdate,
  ) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE PointRecord SET point = ?2, lvl = ?3, lastType = ?4, lastTimeUpdate = ?5 WHERE id = ?1',
        arguments: [id, point, lvl, lastType, lastTimeUpdate]);
  }

  @override
  Future<void> deleteOnePointRecordById(int id) async {
    await _queryAdapter.queryNoReturn('DELETE FROM PointRecord WHERE id = ?1',
        arguments: [id]);
  }

  @override
  Future<void> deleteAllPointRecords() async {
    await _queryAdapter.queryNoReturn('DELETE FROM PointRecord');
  }

  @override
  Future<int?> getCountOfPointRecords() async {
    return _queryAdapter.query('SELECT COUNT(*) FROM PointRecord',
        mapper: (Map<String, Object?> row) => row.values.first as int);
  }

  @override
  Future<void> addOnePointRecord(PointRecordEntity pointRecord) async {
    await _pointRecordEntityInsertionAdapter.insert(
        pointRecord, OnConflictStrategy.abort);
  }
}

class _$EmotionEventDao extends EmotionEventDao {
  _$EmotionEventDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _emotionEventEntityInsertionAdapter = InsertionAdapter(
            database,
            'EmotionEvents',
            (EmotionEventEntity item) => <String, Object?>{
                  'id': item.id,
                  'emoji': item.emoji,
                  'date': item.date,
                  'point': item.point
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<EmotionEventEntity>
      _emotionEventEntityInsertionAdapter;

  @override
  Future<EmotionEventEntity?> getOneEmotionEvent(int id) async {
    return _queryAdapter.query('SELECT * FROM EmotionEvents WHERE id = ?1',
        mapper: (Map<String, Object?> row) => EmotionEventEntity(
            row['id'] as int?,
            row['emoji'] as String,
            row['date'] as int,
            row['point'] as int),
        arguments: [id]);
  }

  @override
  Future<List<EmotionEventEntity>> getAllEmotionEvents() async {
    return _queryAdapter.queryList('SELECT * FROM EmotionEvents',
        mapper: (Map<String, Object?> row) => EmotionEventEntity(
            row['id'] as int?,
            row['emoji'] as String,
            row['date'] as int,
            row['point'] as int));
  }

  @override
  Future<void> deleteOneEmotionEventById(int id) async {
    await _queryAdapter.queryNoReturn('DELETE FROM EmotionEvents WHERE id = ?1',
        arguments: [id]);
  }

  @override
  Future<void> deleteAllEmotionEvents() async {
    await _queryAdapter.queryNoReturn('DELETE FROM EmotionEvents');
  }

  @override
  Future<void> addOneEmotionEvent(EmotionEventEntity emotionEvent) async {
    await _emotionEventEntityInsertionAdapter.insert(
        emotionEvent, OnConflictStrategy.abort);
  }
}

class _$DietEventDao extends DietEventDao {
  _$DietEventDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _dietEventEntityInsertionAdapter = InsertionAdapter(
            database,
            'DietEvents',
            (DietEventEntity item) => <String, Object?>{
                  'id': item.id,
                  'diet': item.diet,
                  'unit': item.unit,
                  'date': item.date,
                  'point': item.point
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<DietEventEntity> _dietEventEntityInsertionAdapter;

  @override
  Future<DietEventEntity?> getOneDietEvent(int id) async {
    return _queryAdapter.query('SELECT * FROM DietEvents WHERE id = ?1',
        mapper: (Map<String, Object?> row) => DietEventEntity(
            row['id'] as int?,
            row['diet'] as String,
            row['unit'] as int,
            row['date'] as int,
            row['point'] as int),
        arguments: [id]);
  }

  @override
  Future<List<DietEventEntity>> getAllDietEvents() async {
    return _queryAdapter.queryList('SELECT * FROM DietEvents',
        mapper: (Map<String, Object?> row) => DietEventEntity(
            row['id'] as int?,
            row['diet'] as String,
            row['unit'] as int,
            row['date'] as int,
            row['point'] as int));
  }

  @override
  Future<void> updateOneDietEvent(
    int id,
    int unit,
  ) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE DietEvents SET unit = ?2 WHERE id = ?1',
        arguments: [id, unit]);
  }

  @override
  Future<void> deleteOneDietEventById(int id) async {
    await _queryAdapter
        .queryNoReturn('DELETE FROM DietEvents WHERE id = ?1', arguments: [id]);
  }

  @override
  Future<void> deleteAllDietEvents() async {
    await _queryAdapter.queryNoReturn('DELETE FROM DietEvents');
  }

  @override
  Future<void> addOneDietEvent(DietEventEntity dietEvent) async {
    await _dietEventEntityInsertionAdapter.insert(
        dietEvent, OnConflictStrategy.abort);
  }
}

class _$WorkoutEventDao extends WorkoutEventDao {
  _$WorkoutEventDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _workoutEventEntityInsertionAdapter = InsertionAdapter(
            database,
            'WorkoutEvents',
            (WorkoutEventEntity item) => <String, Object?>{
                  'id': item.id,
                  'workout': item.workout,
                  'unit': item.unit,
                  'date': item.date,
                  'point': item.point
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<WorkoutEventEntity>
      _workoutEventEntityInsertionAdapter;

  @override
  Future<WorkoutEventEntity?> getOneWorkoutEvent(int id) async {
    return _queryAdapter.query('SELECT * FROM WorkoutEvents WHERE id = ?1',
        mapper: (Map<String, Object?> row) => WorkoutEventEntity(
            row['id'] as int?,
            row['workout'] as String,
            row['unit'] as int,
            row['date'] as int,
            row['point'] as int),
        arguments: [id]);
  }

  @override
  Future<List<WorkoutEventEntity>> getAllWorkoutEvents() async {
    return _queryAdapter.queryList('SELECT * FROM WorkoutEvents',
        mapper: (Map<String, Object?> row) => WorkoutEventEntity(
            row['id'] as int?,
            row['workout'] as String,
            row['unit'] as int,
            row['date'] as int,
            row['point'] as int));
  }

  @override
  Future<void> deleteOneWorkoutEventById(int id) async {
    await _queryAdapter.queryNoReturn('DELETE FROM WorkoutEvents WHERE id = ?1',
        arguments: [id]);
  }

  @override
  Future<void> deleteAllWorkoutEvents() async {
    await _queryAdapter.queryNoReturn('DELETE FROM WorkoutEvents');
  }

  @override
  Future<void> addOneWorkoutEvent(WorkoutEventEntity workoutEvent) async {
    await _workoutEventEntityInsertionAdapter.insert(
        workoutEvent, OnConflictStrategy.abort);
  }
}
