import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:homework_five/confirmation_dialog.dart';
import 'package:homework_five/firestore_service.dart';
import 'package:homework_five/floor_model/user_model.dart';
import 'package:provider/provider.dart';

class LeaderboardPage extends StatelessWidget {
  final String msg = 'Are you sure you want to perform this action? '
      'This will delete your account and remove your point record from'
      ' the leaderboard permanently.';
  const LeaderboardPage({super.key});

  Future<void> logoutFn(context) async {
    await FirebaseAuth.instance.signOut();
    GoRouter.of(context).go('/sign_in_up');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text(
                'Leaderboard',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold
                ),
              ),
              Text(
                'Current Account: ${context.read<FirestoreService>().getCurrentUserEmail()}',
                style: const TextStyle(
                  backgroundColor: Colors.green,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return ConfirmationDialog(msg: msg, type: 'delete',);
                          }
                      );
                    },
                    child: const Text('delete my data'),
                  ),
                  const SizedBox(width: 10,),
                  ElevatedButton(
                      onPressed: () {
                        logoutFn(context);
                      },
                      child: const Text('logout'),
                  ),
                ],
              ),
              // display data from firebase
              StreamBuilder(
                  stream: context.read<FirestoreService>().getAll(),
                  builder: (context, streamSnapshot) {
                    if(streamSnapshot.hasData) {
                      // this is the data from firebase
                      final queryResults = streamSnapshot.data!;
                      if (queryResults.isEmpty) {
                        // if empty collection is returned...
                        return const Text('You have nothing to do. Go make work for yourself.');
                      } else {
                        // sort the result before rendering
                        queryResults.sort((UserModel a, UserModel b) {
                          return b.point.compareTo(a.point);
                        });
                        return Column(
                          children: queryResults.map<ListTile>((doc) {
                            // highlight the tile of current user
                            Color? tileColor;
                            IconData? myIcon;
                            if (doc.email == context.read<FirestoreService>().getCurrentUserEmail()) {
                              tileColor = Colors.cyan.withOpacity(0.5);
                              myIcon = Icons.star;
                            } else {
                              tileColor = null;
                              myIcon = null;
                            }

                            return ListTile(
                              title: Text(doc.email),
                              subtitle: Text('Point: ${doc.point}'),
                              tileColor: tileColor,
                              trailing: Icon(myIcon),
                            );
                          }).toList(),
                        );
                      }
                    }
                    return const CircularProgressIndicator();
                  }
              ),
            ],
          ),
        )
    );
  }
}