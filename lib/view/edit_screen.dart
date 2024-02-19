import 'dart:io';

import 'package:flutter/material.dart';
import 'package:otp_auth/constants/sizedbox.dart';
import 'package:otp_auth/controller/auth_provider.dart';
import 'package:otp_auth/controller/internet_connectivity_provider.dart';
import 'package:otp_auth/controller/phonenumber_provider.dart';
import 'package:otp_auth/helper/colors.dart';
import 'package:otp_auth/widget/custom_button.dart';
import 'package:otp_auth/widget/snackbar.dart';
import 'package:otp_auth/widget/textfield.dart';
import 'package:provider/provider.dart';

class EditScreen extends StatefulWidget {
  const EditScreen({super.key});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  File? image;

  // @override
  // void dispose() {
  //   super.dispose();
  //   final value = Provider.of<PhoneProvider>(context, listen: false);
  //   value.nameController.dispose();
  //   value.emailController.dispose();
  //   value.bioController.dispose();
  // }

  // for selecting image
  void selectImage() async {
    image = await pickImage(context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<InternetConnectivityProvider>(context, listen: false)
        .getInternetConnectivity(context);
    final fullWidth = MediaQuery.of(context).size.width;
    final isLoading =
        Provider.of<AuthProvider>(context, listen: true).isLoading;
    final value = Provider.of<PhoneProvider>(context,listen: false);
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    value.nameController.text = args['name'];
    value.emailController.text = args['email'];
    value.bioController.text = args['bio'];
    value.phoneController.text = args['phoneNumber'];
    final docId = args['createdAt'];
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit User"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: isLoading == true
            ? const Center(
                child: CircularProgressIndicator(
                  color: cPurpleColor,
                ),
              )
            : SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(vertical: 25.0, horizontal: 5.0),
                child: Center(
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () => selectImage(),
                        child: image == null
                            ? const CircleAvatar(
                                backgroundColor: cPurpleColor,
                                radius: 50,
                                child: Icon(
                                  Icons.account_circle,
                                  size: 50,
                                  color: cWhiteColor,
                                ),
                              )
                            : CircleAvatar(
                                backgroundImage: FileImage(image!),
                                radius: 50,
                              ),
                      ),
                      Container(
                        width: fullWidth,
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 15),
                        margin: const EdgeInsets.only(top: 20),
                        child: Consumer<PhoneProvider>(
                          builder: (context, value, child) {
                            return Column(
                              children: [
                                // name field
                                textField(
                                  hintText: "Enter name",
                                  icon: Icons.account_circle,
                                  inputType: TextInputType.name,
                                  maxLines: 1,
                                  controller: value.nameController,
                                ),

                                // email
                                textField(
                                  hintText: "Enter your email",
                                  icon: Icons.email,
                                  inputType: TextInputType.emailAddress,
                                  maxLines: 1,
                                  controller: value.emailController,
                                ),

                                // bio
                                textField(
                                  hintText: "Enter your bio here...",
                                  icon: Icons.edit,
                                  inputType: TextInputType.name,
                                  maxLines: 2,
                                  controller: value.bioController,
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      cHeight20,
                      SizedBox(
                        height: 50,
                        width: fullWidth * 0.90,
                        child: CustomButton(
                          text: "Update",
                          onpressed: () {
                            value.nameController;
                            value.emailController;
                            value.bioController;
                            value.phoneController;
                            value.updateTask(docId);
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
