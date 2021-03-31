class Comment {
  String commentId;
  String photoMemoId; // Firestore auto generate id
  String comment; //
  DateTime timestamp;
  String createdBy; // created by the commentor
  String sharedWith; // shared with owner of the photomemo
  String profilePicURL;

  // key for Firestore Docs
  static const PHOTOMEMOID = 'photomemoId';
  static const COMMENT = 'comment';
  static const TIMESTAMP = 'timestamp';
  static const CREATEDBY = 'createdBy';
  static const SHAREDWITH = 'sharedWith';
  static const PROFILE_PIC_URL = 'profilePicURL';

  Comment({
    this.commentId,
    this.photoMemoId,
    this.comment,
    this.timestamp,
    this.createdBy,
    this.sharedWith,
    this.profilePicURL,
  });

  Comment.clone(Comment c) {
    this.photoMemoId = c.photoMemoId;
    this.comment = c.comment;
    this.timestamp = c.timestamp;
    this.createdBy = c.createdBy;
    this.sharedWith = c.sharedWith;
    this.profilePicURL = c.profilePicURL;
  }

  void assign(Comment c) {
    this.photoMemoId = c.photoMemoId;
    this.comment = c.comment;
    this.timestamp = c.timestamp;
    this.createdBy = c.createdBy;
    this.sharedWith = c.sharedWith;
    this.profilePicURL = c.profilePicURL;
  }

  // From Dart object to Firestore Docs
  Map<String, dynamic> serialize() {
    return <String, dynamic>{
      PHOTOMEMOID: this.photoMemoId,
      COMMENT: this.comment,
      TIMESTAMP: this.timestamp,
      CREATEDBY: this.createdBy,
      SHAREDWITH: this.sharedWith,
      PROFILE_PIC_URL: this.profilePicURL,
    };
  }

  // From Firestore Docs to Dart object
  static Comment deserialize(Map<String, dynamic> doc, String commentId) {
    return Comment(
      commentId: commentId,
      photoMemoId: doc[PHOTOMEMOID],
      comment: doc[COMMENT],
      timestamp: doc[TIMESTAMP] == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(doc[TIMESTAMP].millisecondsSinceEpoch),
      createdBy: doc[CREATEDBY],
      sharedWith: doc[SHAREDWITH],
      profilePicURL: doc[PROFILE_PIC_URL],
    );
  }

  static String validateComment(String value) {
    if (value == null || value.length < 1)
      return 'Add some comments';
    else
      return null;
  }
}
