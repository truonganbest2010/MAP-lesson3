class Follow {
  String docId;
  String follower;
  String following;

  // key for Firestore Docs
  static const FOLLOWER = 'follower';
  static const FOLLOWING = 'following';

  Follow({
    this.docId,
    this.follower,
    this.following,
  });

  Follow.clone(Follow f) {
    this.follower = f.follower;
    this.following = f.following;
  }

  void assign(Follow f) {
    this.follower = f.follower;
    this.following = f.following;
  }

  // From Dart object to Firestore Docs
  Map<String, dynamic> serialize() {
    return <String, dynamic>{
      FOLLOWER: this.follower,
      FOLLOWING: this.following,
    };
  }

  // From Firestore Docs to Dart object
  static Follow deserialize(Map<String, dynamic> doc, String docId) {
    return Follow(
      docId: docId,
      follower: doc[FOLLOWER],
      following: doc[FOLLOWING],
    );
  }
}
