// ignore_for_file: use_build_context_synchronously
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/pages/signup_page.dart';
import 'package:twitter_clone/providers/user_provider.dart';

class SigninPage extends ConsumerStatefulWidget {
  const SigninPage({super.key});

  @override
  ConsumerState<SigninPage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<SigninPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _signInKey = GlobalKey();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final RegExp emailValid = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/-=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _signInKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 20.0),
            const Image(
              width: 100,
              image: AssetImage('assets/twitter_logo.png'),
            ),
            const Text(
              "Log in to Twitter",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(30.0)),
              child: TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Enter an Email",
                    contentPadding: EdgeInsets.all(15)),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter an Email.";
                  } else if (!emailValid.hasMatch(value)) {
                    return "Please enter a Valid Email.";
                  }

                  return null;
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(30.0)),
              child: TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Enter a Password",
                    contentPadding: EdgeInsets.all(15)),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter a password.";
                  } else if (value.length < 6) {
                    return "Password must be atleast 6 characters.";
                  }
                  return null;
                },
              ),
            ),
            Container(
              width: 250.0,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(30),
              ),
              child: TextButton(
                  onPressed: () async {
                    if (_signInKey.currentState!.validate()) {
                      try {
                        await _auth.signInWithEmailAndPassword(
                            email: _emailController.text,
                            password: _passwordController.text);
                        await ref
                            .read(userProvider.notifier)
                            .signIn(_emailController.text);
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              e.toString(),
                            ),
                          ),
                        );
                      }
                    }
                  },
                  child: const Text("Log In",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ))),
            ),
            TextButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const SignupPage(),
                  ));
                },
                child: const Text("Dont have an account? Sign up here",
                    style: TextStyle(color: Colors.blue)))
          ],
        ),
      ),
    );
  }
}
