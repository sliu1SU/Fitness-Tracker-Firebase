import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:homework_five/display_point_info.dart';

class Home extends StatefulWidget {
  final Widget child;
  // constructor
  const Home({super.key, required this.child});

  @override
  State<Home> createState() => _Home();
}

class _Home extends State<Home> {
  int currentIndex = 0; // Set the initial tab index

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text("Homework 3 Demo"),
        backgroundColor: Colors.lightBlueAccent,
      ),

      // body: widget.child,

      body: Column(
        children: [
          const DisplayPointInfo(),
          Expanded(
            child: widget.child,
          ),
          //widget.child, // is it because the child is scaffold?
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // This is all you need!
        selectedItemColor: Colors.green,
        currentIndex: currentIndex,
        onTap: (int index) {
          setState(() {
            currentIndex = index;
          });
          if (index == 0) {
            GoRouter.of(context).go('/');
          } else if (index == 1) {
            GoRouter.of(context).go('/diet');
          } else if (index == 2) {
            GoRouter.of(context).go('/workout');
          } else {
            GoRouter.of(context).go('/sign_in_detector');
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_emotions_sharp),
            label: 'Emotion',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.food_bank_sharp),
            label: 'Diet',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center_sharp),
            label: 'Workout',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.table_chart),
            label: 'Leaderboard',
          ),
        ],
      ),
    );
  }
}