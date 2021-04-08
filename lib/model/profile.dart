class Profile {
  String profileID;
  String name;
  String profilePhotoURL;
  String profilePhotoFilename;
  String createdBy;
  String bioDescription;
  bool admin;
  Map<dynamic, dynamic> commentsCount;

  static const NAME = 'name';
  static const PROFILE_PHOTO_URL = 'profilePhotoURL';
  static const PROFILE_PHOTO_FILENAME = 'profilePhotoFilename';
  static const CREATED_BY = 'createdBy';
  static const BIO_DESCRIPTION = 'bioDescription';
  static const ADMIN = 'admin';
  static const COMMENTS_COUNT = 'commentsCount';

  Profile({
    this.profileID,
    this.name,
    this.profilePhotoURL,
    this.profilePhotoFilename,
    this.createdBy,
    this.bioDescription,
    this.admin,
    this.commentsCount,
  }) {
    this.commentsCount ??= {};
  }

  Profile.clone(Profile p) {
    this.profileID = p.profileID;
    this.name = p.name;
    this.profilePhotoURL = p.profilePhotoURL;
    this.profilePhotoFilename = p.profilePhotoFilename;
    this.createdBy = p.createdBy;
    this.bioDescription = p.bioDescription;
    this.admin = p.admin;
    this.commentsCount = {};
    this.commentsCount = p.commentsCount;
  }

  void assign(Profile p) {
    this.profileID = p.profileID;
    this.name = p.name;
    this.profilePhotoURL = p.profilePhotoURL;
    this.profilePhotoFilename = p.profilePhotoFilename;
    this.createdBy = p.createdBy;
    this.bioDescription = p.bioDescription;
    this.admin = p.admin;
    this.commentsCount = p.commentsCount;
  }

  Map<String, dynamic> serialize() {
    return <String, dynamic>{
      NAME: this.name,
      PROFILE_PHOTO_URL: this.profilePhotoURL,
      PROFILE_PHOTO_FILENAME: this.profilePhotoFilename,
      CREATED_BY: this.createdBy,
      BIO_DESCRIPTION: this.bioDescription,
      ADMIN: this.admin,
      COMMENTS_COUNT: this.commentsCount,
    };
  }

  static Profile deserialize(
    Map<String, dynamic> doc,
    String docId,
  ) {
    return Profile(
      profileID: docId,
      name: doc[NAME],
      profilePhotoURL: doc[PROFILE_PHOTO_URL],
      profilePhotoFilename: doc[PROFILE_PHOTO_FILENAME],
      createdBy: doc[CREATED_BY],
      bioDescription: doc[BIO_DESCRIPTION],
      admin: doc[ADMIN],
      commentsCount: doc[COMMENTS_COUNT],
    );
  }

  String validateName(String value) {
    if (value == null || value.length < 1)
      return 'Enter your name';
    else if (value.length >= 20)
      return 'Name too long';
    else
      return null;
  }
}
