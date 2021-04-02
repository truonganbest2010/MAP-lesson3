import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:lesson3/model/constant.dart';
import 'package:lesson3/model/follow.dart';
import 'package:lesson3/model/photomemo.dart';
import 'package:lesson3/model/comment.dart';
import 'package:lesson3/model/profile.dart';

class FirebaseController {
  static Future<User> signIn({@required String email, @required String password}) async {
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential.user;
  }

  static Future<void> createAccount(
      {@required String email, @required String password}) async {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  static Future<String> createProfile(Profile profile) async {
    var ref = await FirebaseFirestore.instance
        .collection(Constant.PROFILE_DATABASE)
        .add(profile.serialize());
    return ref.id;
  }

  static Future<Profile> getOneProfileDatabase({@required String email}) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(Constant.PROFILE_DATABASE)
        .where(Profile.CREATED_BY, isEqualTo: email)
        .limit(1)
        .get();

    Profile result = Profile.deserialize(
      querySnapshot.docs[0].data(),
      querySnapshot.docs[0].id,
    );
    return result;
  }

  static Future<List<Profile>> getProfileListForSearch({@required String email}) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(Constant.PROFILE_DATABASE)
        .where(Profile.CREATED_BY, isNotEqualTo: email)
        .get();
    var result = <Profile>[];
    querySnapshot.docs.forEach((doc) {
      result.add(Profile.deserialize(
        doc.data(),
        doc.id,
      ));
    });
    return result;
  }

  static Future<List<Follow>> getFollowingList({@required String email}) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(Constant.FOLLOW_DATABASE)
        .where(Follow.FOLLOWER, isEqualTo: email)
        .get();
    var result = <Follow>[];
    querySnapshot.docs.forEach((doc) {
      result.add(Follow.deserialize(doc.data(), doc.id));
    });
    return result;
  }

  static Future<List<Follow>> getFollowerList({@required String email}) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(Constant.FOLLOW_DATABASE)
        .where(Follow.FOLLOWING, isEqualTo: email)
        .where(Follow.PENDING_STATUS, isEqualTo: false)
        .get();
    var result = <Follow>[];
    querySnapshot.docs.forEach((doc) {
      result.add(Follow.deserialize(doc.data(), doc.id));
    });
    return result;
  }

  static Future<List<Follow>> getPendingRequestList({@required String email}) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(Constant.FOLLOW_DATABASE)
        .where(Follow.FOLLOWING, isEqualTo: email)
        .where(Follow.PENDING_STATUS, isEqualTo: true)
        .get();
    var result = <Follow>[];
    querySnapshot.docs.forEach((doc) {
      result.add(Follow.deserialize(doc.data(), doc.id));
    });
    return result;
  }

  static Future<void> acceptPendingRequest({@required Follow f}) async {
    f.pendingStatus = false;
    await FirebaseFirestore.instance
        .collection(Constant.FOLLOW_DATABASE)
        .doc(f.docId)
        .update(f.serialize());
  }

  static Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  static Future uploadPhotoFile({
    @required File photo,
    String filename,
    @required String uid,
    @required Function listener,
  }) async {
    filename ??= '${Constant.PHOTOIMAGE_FOLDER}/$uid/${DateTime.now()}';
    UploadTask task = FirebaseStorage.instance.ref(filename).putFile(photo);
    task.snapshotEvents.listen((TaskSnapshot event) {
      double progress = event.bytesTransferred / event.totalBytes;
      // print('======= $progress');

      if (event.bytesTransferred == event.totalBytes) progress = null;
      listener(progress);
    });
    await task;
    String downloadURL = await FirebaseStorage.instance.ref(filename).getDownloadURL();
    return <String, String>{
      Constant.ARG_DOWNLOADURL: downloadURL,
      Constant.ARG_FILENAME: filename,
    };
  }

  static Future uploadProfilePicFile({
    @required File photo,
    String filename,
    @required String uid,
    @required Function listener,
  }) async {
    filename ??= '${Constant.PROFILE_PIC_FOLDER}/$uid/${DateTime.now()}';
    UploadTask task = FirebaseStorage.instance.ref(filename).putFile(photo);
    task.snapshotEvents.listen((TaskSnapshot event) {
      double progress = event.bytesTransferred / event.totalBytes;
      // print('======= $progress');

      if (event.bytesTransferred == event.totalBytes) progress = null;
      listener(progress);
    });
    await task;
    String downloadURL = await FirebaseStorage.instance.ref(filename).getDownloadURL();
    return <String, String>{
      Constant.ARG_DOWNLOADURL: downloadURL,
      Constant.ARG_FILENAME: filename,
    };
  }

  static Future<String> addPhotoMemo(PhotoMemo photoMemo) async {
    var ref = await FirebaseFirestore.instance
        .collection(Constant.PHOTOMEMO_COLLECTION)
        .add(photoMemo.serialize());
    return ref.id;
  }

  static Future<String> addComment(Comment c) async {
    var ref = await FirebaseFirestore.instance
        .collection(Constant.COMMENT_COLLECTION)
        .add(c.serialize());
    return ref.id;
  }

  static Future<String> follow(Follow f) async {
    var ref = await FirebaseFirestore.instance
        .collection(Constant.FOLLOW_DATABASE)
        .add(f.serialize());
    return ref.id;
  }

  static Future<List<PhotoMemo>> getPhotoMemoList({@required String email}) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(Constant.PHOTOMEMO_COLLECTION)
        .where(PhotoMemo.CREATED_BY, isEqualTo: email)
        .orderBy(PhotoMemo.TIMESTAMP, descending: true)
        .get();
    var result = <PhotoMemo>[];
    querySnapshot.docs.forEach((doc) {
      result.add(PhotoMemo.deserialize(doc.data(), doc.id));
    });
    return result;
  }

  static Future<List<Comment>> getCommentList({@required String photomemoId}) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(Constant.COMMENT_COLLECTION)
        .where(Comment.PHOTOMEMOID, isEqualTo: photomemoId)
        .orderBy(Comment.TIMESTAMP, descending: true)
        .get();

    var result = <Comment>[];
    querySnapshot.docs.forEach((comment) {
      result.add(Comment.deserialize(comment.data(), comment.id));
    });
    return result;
  }

  static Future<List<dynamic>> getImageLabels({@required File photoFile}) async {
    final FirebaseVisionImage visionImage = FirebaseVisionImage.fromFile(photoFile);
    final ImageLabeler cloudLabeler = FirebaseVision.instance.cloudImageLabeler();
    final List<ImageLabel> cloudLabels = await cloudLabeler.processImage(visionImage);

    List<dynamic> labels = <dynamic>[];
    for (ImageLabel label in cloudLabels) {
      if (label.confidence >= Constant.MIN_ML_CONFIDENCE)
        labels.add(label.text.toLowerCase());
    }
    return labels;
  }

  static Future<void> updatePhotoMemos(
      String docId, Map<String, dynamic> updateInfo) async {
    await FirebaseFirestore.instance
        .collection(Constant.PHOTOMEMO_COLLECTION)
        .doc(docId)
        .update(updateInfo);
  }

  static Future<void> updateProfile(Profile p) async {
    await FirebaseFirestore.instance
        .collection(Constant.PROFILE_DATABASE)
        .doc(p.profileID)
        .update(p.serialize());
  }

  static Future<List<PhotoMemo>> getPhotoMemoSharedWithMe(
      {@required String email}) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(Constant.PHOTOMEMO_COLLECTION)
        .where(PhotoMemo.SHARED_WITH, arrayContains: email)
        .orderBy(PhotoMemo.TIMESTAMP, descending: true)
        .get();

    var result = <PhotoMemo>[];
    querySnapshot.docs.forEach((doc) {
      result.add(PhotoMemo.deserialize(doc.data(), doc.id));
    });
    return result;
  }

  static Future<void> deletePhotoMemo(PhotoMemo p) async {
    await FirebaseFirestore.instance
        .collection(Constant.PHOTOMEMO_COLLECTION)
        .doc(p.docId)
        .delete();
    await FirebaseStorage.instance.ref().child(p.photoFilename).delete();
  }

  static Future<void> deleteComment(String photoMemoId) async {
    await FirebaseFirestore.instance
        .collection(Constant.COMMENT_COLLECTION)
        .where(Comment.PHOTOMEMOID, isEqualTo: photoMemoId)
        .get()
        .then((value) {
      for (var doc in value.docs) {
        doc.reference.delete();
      }
    });
  }

  static Future<void> deleteProfilePic(Profile p) async {
    await FirebaseStorage.instance.ref().child(p.profilePhotoFilename).delete();
    p.profilePhotoFilename = null;
    p.profilePhotoURL = null;
    await FirebaseFirestore.instance
        .collection(Constant.PROFILE_DATABASE)
        .doc(p.profileID)
        .update(p.serialize());
  }

  static Future<void> unfollow(String followerEmail, String followingEmail) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(Constant.FOLLOW_DATABASE)
        .where(Follow.FOLLOWER, isEqualTo: followerEmail)
        .where(Follow.FOLLOWING, isEqualTo: followingEmail)
        .limit(1)
        .get();
    var f = Follow.deserialize(querySnapshot.docs[0].data(), querySnapshot.docs[0].id);
    await FirebaseFirestore.instance
        .collection(Constant.FOLLOW_DATABASE)
        .doc(f.docId)
        .delete();
  }

  static Future<List<PhotoMemo>> searchImage({
    @required String createdBy,
    @required List<String> searchLabels,
  }) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(Constant.PHOTOMEMO_COLLECTION)
        .where(PhotoMemo.CREATED_BY, isEqualTo: createdBy)
        .where(PhotoMemo.IMAGE_LABELS, arrayContainsAny: searchLabels)
        .orderBy(PhotoMemo.TIMESTAMP, descending: true)
        .get();
    var results = <PhotoMemo>[];
    querySnapshot.docs.forEach((doc) {
      results.add(PhotoMemo.deserialize(doc.data(), doc.id));
    });
    return results;
  }

  static Future<Map<dynamic, dynamic>> retriveCommentsCountOfPhotoMemoList(
      List<String> photoMemoIdList) async {
    var result = <dynamic, dynamic>{};
    for (var pid in photoMemoIdList) {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection(Constant.COMMENT_COLLECTION)
          .where(Comment.PHOTOMEMOID, isEqualTo: pid)
          .get();
      var totalComment = querySnapshot.docs.length;
      result.putIfAbsent(pid, () => totalComment);
    }
    return result;
  }

  static Future<void> deleteAnAccount({
    @required String email,
    @required String password,
    @required Profile p,
    @required List<PhotoMemo> photoMemoList,
  }) async {
    for (var pf in photoMemoList) {
      await deleteComment(pf.docId); // delete comments
    }

    for (var pf in photoMemoList) {
      await deletePhotoMemo(pf); // delete photo memos
    }

    await FirebaseFirestore.instance
        .collection(Constant.FOLLOW_DATABASE)
        .where(Follow.FOLLOWER, isEqualTo: email)
        .get()
        .then(
          (value) => value.docs.forEach((doc) {
            doc.reference.delete(); // delete following
          }),
        );

    await FirebaseFirestore.instance
        .collection(Constant.FOLLOW_DATABASE)
        .where(Follow.FOLLOWING, isEqualTo: email)
        .get()
        .then(
          (value) => value.docs.forEach((doc) {
            doc.reference.delete(); // delete follower
          }),
        );

    if (p.profilePhotoFilename != null) {
      await FirebaseStorage.instance
          .ref()
          .child(p.profilePhotoFilename)
          .delete(); // delete profile photo in storage
    }
    await FirebaseFirestore.instance
        .collection(Constant.PROFILE_DATABASE)
        .doc(p.profileID)
        .delete(); // delete profile database

    var user = FirebaseAuth.instance.currentUser;
    AuthCredential credential =
        EmailAuthProvider.credential(email: email, password: password);
    var result = await user.reauthenticateWithCredential(credential);
    await result.user.delete(); // delete user account
  }
}
