class Constant {
  static const DEV = true;

//arguments
  static const ARG_USER = 'user';
  static const ARG_PHOTOMEMOLIST = 'photomemo_list';
  static const ARG_ONE_PHOTOMEMO = 'one_photomemo';
  static const ARG_COMMENTLIST = 'comment_list';
  static const ARG_ONE_PROFILE = 'one_profile';
  static const ARG_PROFILE_LIST = 'profile_list';
  static const ARG_FOLLOWING_LIST = 'following_list';
  static const ARG_FOLLOWER_LIST = 'follower_list';
  static const ARG_PENDING_REQUEST_LIST = 'pending_request_list';
  static const ARG_COMMENTS_COUNT = 'comments_count';

// menu
  static const SRC_CAMERA = 'Camera';
  static const SRC_GALLERY = 'Gallery';

  static const SRC_SELECT_PROFILE_PHOTO = 'selectProfilePhoto';
  static const SRC_REMOVE_PROFILE_PHOTO = 'removeProfilePhoto';

  static const SRC_FOLLOWERS = 'My Followers';
  static const SRC_ONLY_WITH = 'Only With ...';
  static const SRC_ONLY_ME = 'Only Me';

// firebase storage
  static const PHOTOIMAGE_FOLDER = 'photo_images';
  static const PROFILE_PIC_FOLDER = 'profile_pics';

// firebase firestore
  static const PHOTOMEMO_COLLECTION = 'photoMemos';
  static const COMMENT_COLLECTION = 'commentSections';
  static const PROFILE_DATABASE = 'profileDatabase';
  static const FOLLOW_DATABASE = 'followDatabase';
  static const REPORT_DATABASE = 'reportDatabase';

  static const ARG_DOWNLOADURL = 'downloadurl';
  static const ARG_FILENAME = 'filename';

// machine learning
  static const MIN_ML_CONFIDENCE = 0.7;
}
