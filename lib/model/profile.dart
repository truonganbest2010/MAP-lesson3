class Profile {
  String profileID;
  String name;
  String profilePhotoURL;
  String profilePhotoFilename;
  String createdBy;
  String bioDescription;
  bool admin;

  static const NAME = 'name';
  static const PROFILE_PHOTO_URL = 'profilePhotoURL';
  static const PROFILE_PHOTO_FILENAME = 'profilePhotoFilename';
  static const CREATED_BY = 'createdBy';
  static const BIO_DESCRIPTION = 'bioDescription';
  static const ADMIN = 'admin';

  Profile({
    this.profileID,
    this.name,
    this.profilePhotoURL,
    this.profilePhotoFilename,
    this.createdBy,
    this.bioDescription,
    this.admin,
  });

  Profile.clone(Profile p) {
    this.profileID = p.profileID;
    this.name = p.name;
    this.profilePhotoURL = p.profilePhotoURL;
    this.profilePhotoFilename = p.profilePhotoFilename;
    this.createdBy = p.createdBy;
    this.bioDescription = p.bioDescription;
    this.admin = p.admin;
  }

  void assign(Profile p) {
    this.profileID = p.profileID;
    this.name = p.name;
    this.profilePhotoURL = p.profilePhotoURL;
    this.profilePhotoFilename = p.profilePhotoFilename;
    this.createdBy = p.createdBy;
    this.bioDescription = p.bioDescription;
    this.admin = p.admin;
  }

  Map<String, dynamic> serialize() {
    return <String, dynamic>{
      NAME: this.name,
      PROFILE_PHOTO_URL: this.profilePhotoURL,
      PROFILE_PHOTO_FILENAME: this.profilePhotoFilename,
      CREATED_BY: this.createdBy,
      BIO_DESCRIPTION: this.bioDescription,
      ADMIN: this.admin,
    };
  }

  static Profile deserialize(Map<String, dynamic> doc, String docId) {
    return Profile(
      profileID: docId,
      name: doc[NAME],
      profilePhotoURL: doc[PROFILE_PHOTO_URL],
      profilePhotoFilename: doc[PROFILE_PHOTO_FILENAME],
      createdBy: doc[CREATED_BY],
      bioDescription: doc[BIO_DESCRIPTION],
      admin: doc[ADMIN],
    );
  }

  String validateName(String value) {
    if (value == null || value.length < 1)
      return 'Enter your name';
    else
      return null;
  }
}
