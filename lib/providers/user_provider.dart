// ignore_for_file: avoid_print

import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:riverpod/riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:twitter_clone/models/users.dart';

final userProvider = StateNotifierProvider<UserNotifier, LocalUser>((ref) {
  return UserNotifier();
});
  
class LocalUser {
  final String id;
  final FirebaseUser user;

  const LocalUser({required this.id, required this.user});

  LocalUser copyWith({
    String? id,
    FirebaseUser? user,
  }) {
    return LocalUser(
      id: id ?? this.id,
      user: user ?? this.user,
    );
  }
}

class UserNotifier extends StateNotifier<LocalUser> {
  UserNotifier()
      : super(
          const LocalUser(
            id: "defaultId",
            user: FirebaseUser(
                email: "defaulEmail",
                name: "defaultName",
                profilePic: "defaultPic"),
          ),
        );
  // SignIN Function
  Future<void> signIn(String userEmail) async {
    QuerySnapshot response = await _firestore
        .collection("Users")
        .where('email', isEqualTo: userEmail)
        .get();
    if (response.docs.isEmpty) {
      print("No User data is associated with the email: $userEmail");
      return;
    }
    if (response.docs.length != 1) {
      print(
          "More than One Firestore User associated with the email: $userEmail");
      return;
    }
    state = LocalUser(
        id: response.docs[0].id,
        user: FirebaseUser.fromMap(
            response.docs[0].data() as Map<String, dynamic>));
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  //  SignUP Function
  Future<void> signup(String userEmail) async {
    DocumentReference response = await _firestore.collection("Users").add(
        FirebaseUser(
                email: userEmail,
                name: "No Name",
                profilePic: 'http://www.gravatar.com/avatar/?d=mp')
            .toMap());
    DocumentSnapshot snapshot = await response.get();
    state = LocalUser(
        id: response.id,
        user: FirebaseUser.fromMap(snapshot.data() as Map<String, dynamic>));
  }

  // Update Username Function
  Future<void> updateUserName(String newUserName) async {
    await _firestore
        .collection("Users")
        .doc(state.id)
        .update({'name': newUserName});
    state = state.copyWith(user: state.user.copyWith(name: newUserName));
  }

  // Update Profile Picture
  Future<void> updatePhoto(File image) async {
    Reference ref = _storage.ref().child("Users").child(state.id);
    TaskSnapshot snapshot = await ref.putFile(image);
    String profilePicURL = await snapshot.ref.getDownloadURL();
    await _firestore
        .collection("Users")
        .doc(state.id)
        .update({'profilePic': profilePicURL});
    state =
        state.copyWith(user: state.user.copyWith(profilePic: profilePicURL));
  }

//  Signout Function
  void signout() {
    state = const LocalUser(
      id: "defaultId",
      user: FirebaseUser(
          email: "defaulEmail", name: "defaultName", profilePic: "defaultPic"),
    );
  }
}
