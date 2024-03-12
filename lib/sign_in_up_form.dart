
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:homework_five/firestore_service.dart';
import 'package:homework_five/floor_model/user_model.dart';
import 'package:provider/provider.dart';

class SignInUpForm extends StatefulWidget {
  const SignInUpForm({super.key});

  @override
  State<SignInUpForm> createState() => _SignInUpFormState();
}

class _SignInUpFormState extends State<SignInUpForm> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _firebaseErrorCode;
  String? _signupMsg;
  final String msg = 'By signing up, you are agree to share your '
      'Recording Points with other users';

  void _showAgreementDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('User Agreement'),
          content: Text(msg),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                _onSignUp();
                Navigator.of(context).pop();
              },
              child: const Text('Accept'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _firebaseErrorCode = 'Agreement declined!';
                });
                Navigator.of(context).pop();
              },
              child: const Text('Decline'),
            ),
          ],
        );
      },
    );
  }

  _onSignUp() async {
    if (_formKey.currentState!.validate()) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _usernameController.text,
          password: _passwordController.text,
        );
        setState(() {
          _firebaseErrorCode = null;
          _signupMsg = 'Sign up success! Your account has been created!';
        });
        // create a new doc in the leaderboard collection
        UserModel newUser = UserModel(
            userCredential.user!.uid,
            _usernameController.text,
            0,
            0,
        );
        if (context.mounted) await context.read<FirestoreService>().createUser(newUser);
        GoRouter.of(context).go('/leaderboard');
      } on FirebaseAuthException catch (ex) {
        print("error during sign up! --- ${ex.code}");
        print("error during sign up! --- ${ex.message}");
        setState(() {
          _firebaseErrorCode = ex.code;
          _signupMsg = null;
        });
      }
      //_formKey.currentState!.reset();
    }
  }

  _onSignIn() async {
    if (_formKey.currentState!.validate()) {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _usernameController.text,
        password: _passwordController.text,
      );
      FirebaseAuth auth = FirebaseAuth.instance;
      User? user = auth.currentUser;
      if (context.mounted && user != null) {
        GoRouter.of(context).go('/leaderboard');
      } else {
        setState(() {
          _firebaseErrorCode = 'Sign in failed! Please enter the correct email and password.';
        });
      }
      _formKey.currentState!.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: 'Enter an email...',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      // clear the text box
                      _usernameController.clear();
                    },
                  ),
                ),
                validator: (newValue) {
                  if (_usernameController.text.isEmpty) {
                    return "email cannot be empty!";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: 'Enter a password...',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      // clear the text box
                      _passwordController.clear();
                    },
                  ),
                ),
                validator: (newValue) {
                  if (_passwordController.text.isEmpty) {
                    return "password cannot be empty!";
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _showAgreementDialog(context);
                  }
                },
                child: const Text('Sign up'),
              ),
              ElevatedButton(
                onPressed: _onSignIn,
                child: const Text('Sign in'),
              ),
              if (_firebaseErrorCode != null)
                Text(
                  _firebaseErrorCode!,
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                )
              else if (_signupMsg != null)
                Text(
                  _signupMsg!,
                  style: const TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                )
            ]
        ),
      )
    );
  }
}
