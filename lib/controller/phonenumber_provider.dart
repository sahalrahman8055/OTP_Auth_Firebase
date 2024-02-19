import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:otp_auth/model/user_model.dart';
import 'package:otp_auth/services/firebase_services.dart';
import 'package:otp_auth/widget/snackbar.dart';

class PhoneProvider extends ChangeNotifier {
  File? image;

  final TextEditingController _phoneController = TextEditingController();
  TextEditingController get phoneController => _phoneController;

  String _otpCode = '';
  String get otpCode => _otpCode;

  List<UserModel> users = [];

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final bioController = TextEditingController();

  Country selectedCountry = Country(
    phoneCode: "91",
    countryCode: "IN",
    e164Sc: 0,
    geographic: true,
    level: 1,
    name: "India",
    example: "India",
    displayName: "India",
    displayNameNoCountryCode: "IN",
    e164Key: "",
  );

  void setSelectedCountry(Country country) {
    selectedCountry = country;
    notifyListeners();
  }

  void setPhone(String value) {
    _phoneController.text = value;
    notifyListeners();
  }

  // Future pickImage(BuildContext context) async {
  //   _image = await pickImage(context);
  //   notifyListeners();
  // }

  // Image? _image;

  // Image? get image => _image;

  Future<void> selectImage(BuildContext context) async {
    image = await pickImage(context);
    notifyListeners();
  }


  set otpCode(String value) {
    _otpCode = value;
    notifyListeners();
  }

  /////////// FIREBASE EDIT //////////////
  final FirebaseServices firebaseServices = FirebaseServices();

  Future<void> fetchTasks() async {
    users = await firebaseServices.fetchUser();
    notifyListeners();
  }

  void updateTask(String docId) async {
    // final user = UserModel(
    //   name: nameController.text,
    //   email: emailController.text,
    //   bio: bioController.text,
    //   profilePic: "",
    //   createdAt: docId,
    //    phoneNumber: "",
    //    uid: "",
    //    );
    FirebaseFirestore.instance.collection('users').doc(docId).update({
      'name': nameController.text,
      'email': emailController.text,
      'bio': bioController.text,
      'profilePic': image,
      'createdAt': docId,
      'phoneNumber': phoneController.text,
    });
    // firebaseServices.updateUser(user);
    await fetchTasks();
    notifyListeners();
  }

  //////// GOOGLE SIGN IN ///////
  // Future<UserCredential> signInWithGoogle() async {
  //   final result = await firebaseServices.signInWithGoogle();
  //   return result;
  // }
}
