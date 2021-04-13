class PhotoMemo {
  String docId; // Firestore auto generate id
  String createdBy;
  String title;
  String memo;
  String photoFilename; // stored at Storage
  String photoURL;
  DateTime timestamp;
  List<dynamic> sharedWith; // list of email
  List<dynamic> imageLables; // image identified by ML

  bool sharedWithMyFollowers;
  List<dynamic> likeList;
  List<dynamic> grantedPermission;
  bool suspendedStatus;

  // key for Firestore Docs
  static const TITLE = 'title';
  static const MEMO = 'memo';
  static const CREATED_BY = 'createdBy';
  static const PHOTO_URL = 'photoURL';
  static const PHOTO_FILENAME = 'photoFilename';
  static const TIMESTAMP = 'timestamp';
  static const SHARED_WITH = 'sharedWith';
  static const IMAGE_LABELS = 'imageLabels';
  static const SHARED_WITH_ALL_FOLLOWERS = 'sharedWithMyFollowers';
  static const LIKE_LIST = 'likeList';
  static const GRANTED_PERMISSION = 'grantedPermission';
  static const SUSPENDED_STATUS = 'suspendedStatus';

  PhotoMemo({
    this.docId,
    this.createdBy,
    this.memo,
    this.photoFilename,
    this.photoURL,
    this.timestamp,
    this.title,
    this.sharedWith,
    this.imageLables,
    this.sharedWithMyFollowers,
    this.likeList,
    this.grantedPermission,
    this.suspendedStatus,
  }) {
    this.sharedWith ??= [];
    this.imageLables ??= [];
    this.likeList ??= [];
    this.grantedPermission ??= [];
  }

  PhotoMemo.clone(PhotoMemo p) {
    this.docId = p.docId;
    this.createdBy = p.createdBy;
    this.memo = p.memo;
    this.photoFilename = p.photoFilename;
    this.photoURL = p.photoURL;
    this.timestamp = p.timestamp;
    this.title = p.title;
    this.sharedWith = [];
    this.sharedWith.addAll(p.sharedWith);
    this.imageLables = [];
    this.imageLables.addAll(p.imageLables);
    this.sharedWithMyFollowers = p.sharedWithMyFollowers;
    this.likeList = [];
    this.likeList.addAll(p.likeList);
    this.grantedPermission = [];
    this.grantedPermission.addAll(p.grantedPermission);
    this.suspendedStatus = p.suspendedStatus;
  }

  // a = b ==> a.assign(b)
  void assign(PhotoMemo p) {
    this.docId = p.docId;
    this.createdBy = p.createdBy;
    this.memo = p.memo;
    this.photoFilename = p.photoFilename;
    this.photoURL = p.photoURL;
    this.timestamp = p.timestamp;
    this.title = p.title;
    this.sharedWith.clear();
    this.sharedWith.addAll(p.sharedWith);
    this.imageLables.clear();
    this.imageLables.addAll(p.imageLables);
    this.sharedWithMyFollowers = p.sharedWithMyFollowers;
    this.likeList.clear();
    this.likeList.addAll(p.likeList);
    this.grantedPermission = [];
    this.grantedPermission.addAll(p.grantedPermission);
    this.suspendedStatus = p.suspendedStatus;
  }

// From Dart Object to Firestore Docs
  Map<String, dynamic> serialize() {
    return <String, dynamic>{
      TITLE: this.title,
      CREATED_BY: this.createdBy,
      MEMO: this.memo,
      PHOTO_FILENAME: this.photoFilename,
      PHOTO_URL: this.photoURL,
      TIMESTAMP: this.timestamp,
      SHARED_WITH: this.sharedWith,
      IMAGE_LABELS: this.imageLables,
      SHARED_WITH_ALL_FOLLOWERS: this.sharedWithMyFollowers,
      LIKE_LIST: this.likeList,
      GRANTED_PERMISSION: this.grantedPermission,
      SUSPENDED_STATUS: this.suspendedStatus,
    };
  }

  static PhotoMemo deserialize(Map<String, dynamic> doc, String docId) {
    return PhotoMemo(
      docId: docId,
      createdBy: doc[CREATED_BY],
      title: doc[TITLE],
      memo: doc[MEMO],
      photoFilename: doc[PHOTO_FILENAME],
      photoURL: doc[PHOTO_URL],
      sharedWith: doc[SHARED_WITH],
      imageLables: doc[IMAGE_LABELS],
      timestamp: doc[TIMESTAMP] == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(doc[TIMESTAMP].millisecondsSinceEpoch),
      sharedWithMyFollowers: doc[SHARED_WITH_ALL_FOLLOWERS],
      likeList: doc[LIKE_LIST],
      grantedPermission: doc[GRANTED_PERMISSION],
      suspendedStatus: doc[SUSPENDED_STATUS],
    );
  }

  static String validateTitle(String value) {
    if (value == null || value.length < 3)
      return 'too short';
    else
      return null;
  }

  static String validateMemo(String value) {
    if (value == null || value.length < 5)
      return 'too short';
    else
      return null;
  }

  static String validateSharedWith(String value) {
    if (value == null || value.trim().length == 0) return null;

    List<String> emailList = value.split(RegExp('(,| )+')).map((e) => e.trim()).toList();
    for (String email in emailList) {
      if (email.contains('@') && email.contains('.'))
        continue;
      else
        return 'comma(,) or space separated email list';
    }
    return null;
  }
}
