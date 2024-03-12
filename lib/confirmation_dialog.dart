import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:homework_five/firestore_service.dart';
import 'package:provider/provider.dart';

class ConfirmationDialog extends StatelessWidget {
  final String msg;
  final String type;
  const ConfirmationDialog({super.key, required this.msg, required this.type});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Confirm Action'),
      content: Text(msg),
      actions: [
        TextButton(
          onPressed: () {
            // Close the dialog
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            context.read<FirestoreService>().deleteData();
            // Close the dialog and return true
            Navigator.of(context).pop();
            GoRouter.of(context).go('/sign_in_up');
          },
          child: const Text('Confirm'),
        ),
      ],
    );
  }
}