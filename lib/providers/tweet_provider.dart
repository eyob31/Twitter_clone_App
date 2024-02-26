import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/models/tweets.dart';
import 'package:twitter_clone/providers/user_provider.dart';

final feedProvider = StreamProvider.autoDispose<List<Tweet>>((ref) {
  return FirebaseFirestore.instance
      .collection("Tweets")
      .orderBy(
        "postTime",
        descending: true,
      )
      .snapshots()
      .map((event) {
    List<Tweet> tweets = [];

    for (int i = 0; i < event.docs.length; i++) {
      tweets.add(Tweet.fromMap(event.docs[i].data()));
    }
    return tweets;
  });
});

final tweetProvider = Provider<TweetApi>((ref) {
  return TweetApi(ref);
});

class TweetApi {
  TweetApi(this.ref);
  final Ref ref;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<void> postTweet(String tweet) async {
    LocalUser currentUser = ref.read(userProvider);
    await _firestore.collection("Tweets").add(
          Tweet(
            uid: currentUser.id,
            name: currentUser.user.name,
            profilePic: currentUser.user.profilePic,
            tweet: tweet,
            postTime: Timestamp.now(),
          ).toMap(),
        );
  }
}
