class Comment {
  String commentId;
  String photoMemoId; // Firestore auto generate id
  String comment; //
  DateTime timestamp;
  String createdBy; // created by the commentor
  String sharedWith; // shared with owner of the photomemo

  // key for Firestore Docs
  static const PHOTOMEMOID = 'photomemoId';
  static const COMMENT = 'comment';
  static const TIMESTAMP = 'timestamp';
  static const CREATEDBY = 'createdBy';
  static const SHAREDWITH = 'sharedWith';

  Comment({
    this.commentId,
    this.photoMemoId,
    this.comment,
    this.timestamp,
    this.createdBy,
    this.sharedWith,
  });

  Comment.clone(Comment c) {
    this.photoMemoId = c.photoMemoId;
    this.comment = c.comment;
    this.timestamp = c.timestamp;
    this.createdBy = c.createdBy;
    this.sharedWith = c.sharedWith;
  }

  void assign(Comment c) {
    this.photoMemoId = c.photoMemoId;
    this.comment = c.comment;
    this.timestamp = c.timestamp;
    this.createdBy = c.createdBy;
    this.sharedWith = c.sharedWith;
  }

  // From Dart object to Firestore Docs
  Map<String, dynamic> serialize() {
    return <String, dynamic>{
      PHOTOMEMOID: this.photoMemoId,
      COMMENT: this.comment,
      TIMESTAMP: this.timestamp,
      CREATEDBY: this.createdBy,
      SHAREDWITH: this.sharedWith,
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
    );
  }

  static String validateComment(String value) {
    if (value == null || value.length < 1)
      return 'Add some comments';
    else
      return null;
  }
}
