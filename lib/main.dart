/*
Homework 5
Sizhe Liu
The formula of point calculation is:
- between 0-10s since the last action = +1 point
- between 10-20s since the last action = +5 points
- more than 20s since the last action = +10 points
 */

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:homework_five/firestore_service.dart';
import 'package:homework_five/floor_model/database.dart';
import 'package:homework_five/floor_model/floor_repository.dart';
import 'package:homework_five/router.dart';
import 'package:homework_five/view_model.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  print('firebase init success!');
  AppDatabase db = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
  runApp(MyApp(db));
}

class MyApp extends StatelessWidget {
  final AppDatabase db;
  const MyApp(this.db, {super.key}); // ctor here

  // This widget is the root of your application.
  @override
  // original build method
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ViewModel(FloorRepository(db)),
        ),
        Provider(
            create: (context) => FirestoreService(),
        ),
      ],
      child: MaterialApp.router(
        routerConfig: router,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
      ),
    );
  }
}