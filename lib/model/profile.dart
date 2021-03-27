class Profile {
  String profileID;
  String name;
  String profilePhotoURL;
  String profilePhotoFilename;
  String createdBy;
  String bioDescription;

  static const NAME = 'name';
  static const PROFILE_PHOTO_URL = 'profilePhotoURL';
  static const PROFILE_PHOTO_FILENAME = 'profilePhotoFilename';
  static const CREATED_BY = 'createdBy';
  static const BIO_DESCRIPTION = 'bioDescription';

  Profile({
    this.profileID,
    this.name,
    this.profilePhotoURL,
    this.profilePhotoFilename,
    this.createdBy,
    this.bioDescription,
  });

  Profile.clone(Profile p) {
    this.profileID = p.profileID;
    this.name = p.name;
    this.profilePhotoURL = p.profilePhotoURL;
    this.profilePhotoFilename = p.profilePhotoFilename;
    this.createdBy = p.createdBy;
    this.bioDescription = p.bioDescription;
  }

  void assign(Profile p) {
    this.profileID = p.profileID;
    this.name = p.name;
    this.profilePhotoURL = p.profilePhotoURL;
    this.profilePhotoFilename = p.profilePhotoFilename;
    this.createdBy = p.createdBy;
    this.bioDescription = p.bioDescription;
  }

  Map<String, dynamic> serialize() {
    return <String, dynamic>{
      NAME: this.name,
      PROFILE_PHOTO_URL: this.profilePhotoURL,
      PROFILE_PHOTO_FILENAME: this.profilePhotoFilename,
      CREATED_BY: this.createdBy,
      BIO_DESCRIPTION: this.bioDescription,
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
    );
  }
}
