import 'package:flutter/material.dart';
import 'package:twitter_clone/signup_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        home: MyHomePage(), debugShowCheckedModeBanner: false,);
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
            const Image(
              width: 100,
              image: AssetImage('assets/twitter_logo.png'),
            ),
            const SizedBox(height: 20.0),
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
                  onPressed: () {
                    if (_signInKey.currentState!.validate()) {
                      debugPrint(_emailController.text);
                      debugPrint(_passwordController.text);
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
