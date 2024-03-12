import 'package:flutter/foundation.dart';

class PointRecord with ChangeNotifier {
  final int? id;
  int point;
  int lvl;
  String lastType;
  DateTime lastTimeUpdate;

  PointRecord(this.id, this.point, this.lvl, this.lastType, this.lastTimeUpdate);
}