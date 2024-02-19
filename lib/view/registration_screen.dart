import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:otp_auth/constants/border_radius.dart';
import 'package:otp_auth/constants/sizedbox.dart';
import 'package:otp_auth/controller/auth_provider.dart';
import 'package:otp_auth/controller/internet_connectivity_provider.dart';
import 'package:otp_auth/controller/phonenumber_provider.dart';
import 'package:otp_auth/helper/colors.dart';
import 'package:otp_auth/services/firebase_services.dart';
import 'package:otp_auth/widget/custom_button.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Provider.of<InternetConnectivityProvider>(context, listen: false)
        .getInternetConnectivity(context);
    final data = Provider.of<PhoneProvider>(context, listen: false);
    // final value = Provider.of<GoogleAuthProvider>(context, listen: false);
    data.phoneController.selection = TextSelection.fromPosition(
      TextPosition(
        offset: data.phoneController.text.length,
      ),
    );
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Consumer<PhoneProvider>(
            builder: (context, data, child) {
              return Center(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 25, horizontal: 35),
                  child: Column(
                    children: [
                      Container(
                        width: 200,
                        height: 200,
                        padding: const EdgeInsets.all(20.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: cPurpleColorShade50,
                        ),
                        child: Image.asset(
                          "assets/image2.png",
                        ),
                      ),
                      cHeight20,
                      const Text(
                        "Register",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      cHeight10,
                      const Text(
                        "Add your phone number. We'll send you a verification code",
                        style: TextStyle(
                          fontSize: 14,
                          color: cBlackColor38,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      cHeight20,
                      TextFormField(
                        cursorColor: cPurpleColor,
                        controller: data.phoneController,
                        keyboardType: TextInputType.phone,
                        maxLength: 10,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        onChanged: (value) {
                          data.setPhone(value);
                        },
                        decoration: InputDecoration(
                          hintText: "Enter phone number",
                          hintStyle: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                            color: cGreyColorShade600,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: cBlackColor12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: cBlackColor12),
                          ),
                          prefixIcon: Container(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () {
                                showCountryPicker(
                                    context: context,
                                    countryListTheme:
                                        const CountryListThemeData(
                                      bottomSheetHeight: 550,
                                    ),
                                    onSelect: (value) {
                                      data.setSelectedCountry(value);
                                    });
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(top: 3),
                                child: Text(
                                  "${data.selectedCountry.flagEmoji} + ${data.selectedCountry.phoneCode}",
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: cBlackColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          suffixIcon: data.phoneController.text.length > 9
                              ? Container(
                                  height: 30,
                                  width: 30,
                                  margin: const EdgeInsets.all(10.0),
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: cGreenColor,
                                  ),
                                  child: const Icon(
                                    Icons.done,
                                    color: cWhiteColor,
                                    size: 20,
                                  ),
                                )
                              : null,
                        ),
                      ),
                      cHeight20,
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: CustomButton(
                          text: "Login",
                          onpressed: () {
                            sendPhoneNumber(context);
                          },
                        ),
                      ),
                      cHeight100,
                      Row(
                        children: [
                          Expanded(
                            child: Divider(
                                thickness: 0.5, color: cGreyColorShade400),
                          ),
                          cWidth15,
                          const Text('Or'),
                          cWidth15,
                          cHeight25,
                          Expanded(
                            child: Divider(
                                thickness: 0.5, color: cGreyColorShade400),
                          ),
                        ],
                      ),
                      cHeight15,
                      // GestureDetector(
                      //   onTap: () {
                      //     // data.signInWithGoogle();
                      //     FirebaseServices().signInWithGoogle();
                      //   },
                      //   child: Container(
                      //     height: 60,
                      //     width: double.infinity,
                      //     decoration: BoxDecoration(
                      //       borderRadius: cRadius10,
                      //       color: cBlueColorShade,
                      //     ),
                      //     child: Row(
                      //       mainAxisAlignment: MainAxisAlignment.center,
                      //       children: [
                      //         Image.asset(
                      //           "assets/google_icon.png",
                      //         ),
                      //         const Text("Sign in with Google")
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      cHeight25,
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Don't have an account?"),
                          Text(
                            "Signup",
                            style: TextStyle(
                              color: cBlueColor,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void sendPhoneNumber(BuildContext context) {
    final value = Provider.of<AuthProvider>(context, listen: false);
    final data = Provider.of<PhoneProvider>(context, listen: false);
    String phoneNumber = data.phoneController.text.trim();
    value.signInWithPhone(
        context, "+${data.selectedCountry.phoneCode}$phoneNumber");
  }
}
