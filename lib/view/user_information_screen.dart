import 'package:flutter/material.dart';
import 'package:otp_auth/constants/sizedbox.dart';
import 'package:otp_auth/controller/auth_provider.dart';
import 'package:otp_auth/controller/internet_connectivity_provider.dart';
import 'package:otp_auth/controller/phonenumber_provider.dart';
import 'package:otp_auth/helper/colors.dart';
import 'package:otp_auth/model/user_model.dart';
import 'package:otp_auth/view/home_screen.dart';
import 'package:otp_auth/widget/custom_button.dart';
import 'package:otp_auth/widget/snackbar.dart';
import 'package:otp_auth/widget/textfield.dart';
import 'package:provider/provider.dart';

class UserInformationScreen extends StatefulWidget {
  const UserInformationScreen({super.key});

  @override
  State<UserInformationScreen> createState() => _UserInformationScreenState();
}

class _UserInformationScreenState extends State<UserInformationScreen> {
  // File? image;

  @override
  void dispose() {
    super.dispose();
    final value = Provider.of<PhoneProvider>(context, listen: false);
    value.nameController.dispose();
    value.emailController.dispose();
    value.bioController.dispose();
  }

  // for selecting image
  // void selectImage() async {
  //   image = await pickImage(context);
  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    Provider.of<InternetConnectivityProvider>(context, listen: false)
        .getInternetConnectivity(context);
    final fullWidth = MediaQuery.of(context).size.width;
    final isLoading =
        Provider.of<AuthProvider>(context, listen: true).isLoading;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add User"),
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
                child: Consumer<PhoneProvider>(
                  builder: (context, value, child) {
                    return  Center(
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () async{
                           await value.selectImage(context);
                          },
                          child: value.image == null
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
                                  backgroundImage: FileImage(value.image!),
                                  radius: 50,
                                ),
                        ),
                        Container(
                          width: fullWidth,
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 15),
                          margin: const EdgeInsets.only(top: 20),
                          child: Column(
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
                          ),
                        ),
                        cHeight20,
                        SizedBox(
                          height: 50,
                          width: fullWidth * 0.90,
                          child: CustomButton(
                            text: "Continue",
                            onpressed: () => storeData(),
                          ),
                        ),
                      ],
                    ),
                  );
                  },
                ),
              ),
      ),
    );
  }

// store user data to database
  void storeData() {
    final data = Provider.of<AuthProvider>(context, listen: false);
    final value = Provider.of<PhoneProvider>(context, listen: false);
    UserModel userModel = UserModel(
      name: value.nameController.text.trim(),
      email: value.emailController.text.trim(),
      bio: value.bioController.text.trim(),
      profilePic: "",
      createdAt: "",
      phoneNumber: "",
      uid: "",
    );
    if (value.image != null) {
      data.saveUserDataToFirebase(
        context: context,
        userModel: userModel,
        profilePic: value.image!,
        onSuccess: () {
          data.saveUserDataToSP().then((value) => data.setSignIn().then(
                (value) => Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>  const HomeScreen(),
                    ),
                    (route) => false),
              ));
        },
      );
    } else {
      showSnackBar(context, "Please upload your profile photo");
    }
  }
}
