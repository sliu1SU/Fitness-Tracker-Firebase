import 'package:flutter/material.dart';
import 'package:homework_five/point_record.dart';
import 'package:homework_five/view_model.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DisplayPointInfo extends StatelessWidget {
  const DisplayPointInfo({super.key});

  @override
  Widget build(BuildContext context) {
    // fetch data from db to populate diet history
    Future<PointRecord?> futurePointRecord = context.select<ViewModel, Future<PointRecord?>>(
            (viewModel) => viewModel.getLastPointRecord());
    return Center(
        child: FutureBuilder(
          future: futurePointRecord,
          builder: (context, snapshot) {
            if(snapshot.hasData) {
              final pointRecord = snapshot.data!;
              return Wrap(
                children: [
                  Text("Point: ${pointRecord.point} "),
                  Text("Level: ${pointRecord.lvl} "),
                  Text("Type: ${pointRecord.lastType} "),
                  Text("Date: ${DateFormat().format(pointRecord.lastTimeUpdate)}"),
                ],
              );
            } else if (snapshot.hasError) {
              return const Text('An error occurred trying to load your data and we have no idea what to do about it. Sorry.');
            } else {
              // display "-" for everything if no data returned
              return const Wrap(
                children: [
                  Text("Point: - "),
                  Text("Level: - "),
                  Text("Type: - "),
                  Text("Date: -"),
                ],
              );
            }
          }
        )
    );
  }
}