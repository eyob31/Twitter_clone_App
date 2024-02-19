import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/pages/home_page.dart';
import 'package:twitter_clone/pages/signin_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:twitter_clone/providers/user_provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              ref.read(userProvider.notifier).signIn(snapshot.data!.email!);
              return const HomePage();
            } else {
              return const SigninPage();
            }
          }),
      debugShowCheckedModeBanner: false,
    );
  }
}
