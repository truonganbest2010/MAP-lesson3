class Follow {
  String docId;
  String follower;
  String following;
  bool pendingStatus;

  // key for Firestore Docs
  static const FOLLOWER = 'follower';
  static const FOLLOWING = 'following';
  static const PENDING_STATUS = 'pending_status';

  Follow({
    this.docId,
    this.follower,
    this.following,
    this.pendingStatus,
  });

  Follow.clone(Follow f) {
    this.follower = f.follower;
    this.following = f.following;
    this.pendingStatus = f.pendingStatus;
  }

  void assign(Follow f) {
    this.follower = f.follower;
    this.following = f.following;
    this.pendingStatus = f.pendingStatus;
  }

  // From Dart object to Firestore Docs
  Map<String, dynamic> serialize() {
    return <String, dynamic>{
      FOLLOWER: this.follower,
      FOLLOWING: this.following,
      PENDING_STATUS: this.pendingStatus,
    };
  }

  // From Firestore Docs to Dart object
  static Follow deserialize(Map<String, dynamic> doc, String docId) {
    return Follow(
      docId: docId,
      follower: doc[FOLLOWER],
      following: doc[FOLLOWING],
      pendingStatus: doc[PENDING_STATUS],
    );
  }
}
