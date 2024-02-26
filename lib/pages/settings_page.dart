import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:twitter_clone/providers/user_provider.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    LocalUser currentUser = ref.watch(userProvider);
    _nameController.text = currentUser.user.name;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: () async {
                final ImagePicker picker = ImagePicker();
                final XFile? pickedImage = await picker.pickImage(
                    source: ImageSource.gallery, requestFullMetadata: false);

                if (pickedImage != null) {
                  ref
                      .read(userProvider.notifier)
                      .updatePhoto(File(pickedImage.path));
                }
              },
              child: CircleAvatar(
                radius: 100,
                foregroundImage: NetworkImage(currentUser.user.profilePic),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Center(child: Text("Tap Image to change")),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                  labelText: "Enter your new Name",
                  labelStyle: TextStyle(color: Colors.blue)),
            ),
            TextButton(
                onPressed: () {
                  ref
                      .read(userProvider.notifier)
                      .updateUserName(_nameController.text)
                      .whenComplete(
                        () => ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Name updated Successfully"),
                          ),
                        ),
                      );
                  // Navigator.of(context).pop();
                },
                child: const Text("Update Name"))
          ],
        ),
      ),
    );
  }
}
