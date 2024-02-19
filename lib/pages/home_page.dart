import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/pages/settings_page.dart';

import '../providers/user_provider.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(builder: (context) {
          return GestureDetector(
            onTap: () => Scaffold.of(context).openDrawer(),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundImage:
                    NetworkImage(ref.watch(userProvider).user.profilePic),
              ),
            ),
          );
        }),
        title: const Text("Home Page"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Text(ref.watch(userProvider).user.email),
          Text(ref.watch(userProvider).user.name),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            Image.network(ref.watch(userProvider).user.profilePic),
            ListTile(
              title: Text(
                "Hello: ${ref.watch(userProvider).user.name}",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
                title: const Text("Settings"),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const SettingsPage(),
                    ),
                  );
                }),
            ListTile(
                title: const Text("Sign Out"),
                onTap: () {
                  FirebaseAuth.instance.signOut();
                  ref.read(userProvider.notifier).signout();
                })
          ],
        ),
      ),
    );
  }
}
