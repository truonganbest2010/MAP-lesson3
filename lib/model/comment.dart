class Comment {
  String commentId;
  String photoMemoId; // Firestore auto generate id
  String comment; //
  DateTime timestamp;
  String createdBy; // created by the commentor
  String sharedWith; // shared with owner of the photomemo

  List<dynamic> grantedPermission;

  // key for Firestore Docs
  static const PHOTOMEMOID = 'photomemoId';
  static const COMMENT = 'comment';
  static const TIMESTAMP = 'timestamp';
  static const CREATEDBY = 'createdBy';
  static const SHAREDWITH = 'sharedWith';
  static const GRANTED_PERMISSION = 'grantedPermission';

  Comment({
    this.commentId,
    this.photoMemoId,
    this.comment,
    this.timestamp,
    this.createdBy,
    this.sharedWith,
    this.grantedPermission,
  }) {
    this.grantedPermission ??= [];
  }

  Comment.clone(Comment c) {
    this.photoMemoId = c.photoMemoId;
    this.comment = c.comment;
    this.timestamp = c.timestamp;
    this.createdBy = c.createdBy;
    this.sharedWith = c.sharedWith;
    this.grantedPermission = [];
    this.grantedPermission.addAll(c.grantedPermission);
  }

  void assign(Comment c) {
    this.photoMemoId = c.photoMemoId;
    this.comment = c.comment;
    this.timestamp = c.timestamp;
    this.createdBy = c.createdBy;
    this.sharedWith = c.sharedWith;
    this.grantedPermission = [];
    this.grantedPermission.addAll(c.grantedPermission);
  }

  // From Dart object to Firestore Docs
  Map<String, dynamic> serialize() {
    return <String, dynamic>{
      PHOTOMEMOID: this.photoMemoId,
      COMMENT: this.comment,
      TIMESTAMP: this.timestamp,
      CREATEDBY: this.createdBy,
      SHAREDWITH: this.sharedWith,
      GRANTED_PERMISSION: this.grantedPermission,
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
      grantedPermission: doc[GRANTED_PERMISSION],
    );
  }

  static String validateComment(String value) {
    if (value == null || value.length < 1)
      return 'Add some comments';
    else
      return null;
  }
}
