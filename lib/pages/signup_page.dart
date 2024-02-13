import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<SignupPage> {
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
            const FaIcon(FontAwesomeIcons.twitter,
                color: Colors.blue, size: 90.0),
            const SizedBox(height: 20.0),
            const Text(
              "Sign up to Twitter",
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
                      await _auth.signInWithEmailAndPassword(
                          email: _emailController.text,
                          password: _passwordController.text);
                    }
                  },
                  child: const Text("Sign Up",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ))),
            ),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Already have an account? Log in",
                    style: TextStyle(color: Colors.blue)))
          ],
        ),
      ),
    );
  }
}
