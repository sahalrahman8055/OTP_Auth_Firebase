// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:phonenumberauth/view/otp_screen/otp_screen.dart';
// import 'package:phonenumberauth/widget/snackbar.dart';

// class AuthServices {
//   final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

//   // SIGNIN
//   void signInWithPhone(BuildContext context, String phoneNumber) async {
//     try {
//       await _firebaseAuth.verifyPhoneNumber(
//           phoneNumber: phoneNumber,
//           verificationCompleted:
//               (PhoneAuthCredential phoneAuthCredential) async {
//             await _firebaseAuth.signInWithCredential(phoneAuthCredential);
//           },
//           verificationFailed: (error) {
//             throw Exception(error.message);
//           },
//           codeSent: (verificationId, forceResendingToken) {
//             Navigator.of(context).push(
//               MaterialPageRoute(
//                 builder: (context) => OtpScreen(verificationId: verificationId),
//               ),
//             );
//           },
//           codeAutoRetrievalTimeout: (verificationId) {});
//     } on FirebaseAuthException catch (e) {
//       // ignore: use_build_context_synchronously
//       showSnackBar(context, e.message.toString());
//     }
//   }
// }


