
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:homework_five/leaderboard_page.dart';
import 'package:homework_five/sign_in_up_form.dart';

class SignedInDetector extends StatelessWidget {
  const SignedInDetector({super.key});

  void function() {}

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          //GoRouter.of(context).go('/sign_in_up');
          return const SignInUpForm();
        }
        if(snapshot.connectionState == ConnectionState.active) {
          if(snapshot.data == null) {
            //GoRouter.of(context).go('/sign_in_up');
            return const SignInUpForm();
          }
          //GoRouter.of(context).go('/leaderboard');
          return const LeaderboardPage();
          //return Text('Yay! You\'re signed in as ${snapshot.data!.email}');
        }
        //return const Text('error! snapshot has no data!');
        return const CircularProgressIndicator();
      },
    );
  }
}
