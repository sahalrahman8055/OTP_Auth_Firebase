import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:otp_auth/model/user_model.dart';


class FirebaseServices {
  final CollectionReference firebaseUsers =
      FirebaseFirestore.instance.collection('users');

  Future<List<UserModel>> fetchUser() async {
    final snapshot = await firebaseUsers.get();
    return snapshot.docs.map((doc) {
      return UserModel.fromMap(doc.data() as Map<String, dynamic>);
    }).toList();
  }

  void updateUser(UserModel user) {
    final data = user.toMap();
    firebaseUsers.doc(user.uid).update(data);
  }


   ///// GOOGLE SIGN IN ////////
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        // Handle the case where the user cancels the sign-in process
        return null;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      // Return the UserCredential
      return userCredential;
    } catch (e) {
      // Handle any errors that occurred during the sign-in process
      debugPrint('Error signing in with Google: $e');
      return null;
    }
  }
}


