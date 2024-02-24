import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Tweet {
  final String uid;
  final String name;
  final String profilePic;
  final String tweet;
  final Timestamp postTime;

  Tweet({
    required this.uid,
    required this.name,
    required this.profilePic,
    required this.tweet,
    required this.postTime,
  });

  Tweet copyWith({
    String? uid,
    String? name,
    String? profilePic,
    String? tweet,
    Timestamp? postTime,
  }) {
    return Tweet(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      profilePic: profilePic ?? this.profilePic,
      tweet: tweet ?? this.tweet,
      postTime: postTime ?? this.postTime,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'profilePic': profilePic,
      'tweet': tweet,
      'postTime': postTime,
    };
  }

  factory Tweet.fromMap(Map<String, dynamic> map) {
    return Tweet(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      profilePic: map['profilePic'] ?? '',
      tweet: map['tweet'] ?? '',
      postTime: map['postTime'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Tweet.fromJson(String source) => Tweet.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Tweet(uid: $uid, name: $name, profilePic: $profilePic, tweet: $tweet, postTime: $postTime)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Tweet &&
        other.uid == uid &&
        other.name == name &&
        other.profilePic == profilePic &&
        other.tweet == tweet &&
        other.postTime == postTime;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        name.hashCode ^
        profilePic.hashCode ^
        tweet.hashCode ^
        postTime.hashCode;
  }
}
