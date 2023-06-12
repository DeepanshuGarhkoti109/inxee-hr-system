// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inxee_hr_application/resources/auth_methods.dart';
import 'package:inxee_hr_application/screens/GetEmailOtp.dart';
import 'package:inxee_hr_application/widgets/button_input.dart';
import 'package:inxee_hr_application/widgets/text_field_input.dart';

class OtpPage extends StatefulWidget {
  const OtpPage({super.key});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final TextEditingController _emailController = TextEditingController();

  void navigateGetOtpScreen({required String email}) async {
    await AuthMethods().forgotPassword(email: email);
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => GetEmailOtp(),
        ),
        (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 25),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 25,
                ),

                //

                Image.asset(
                  'lib/images/pngwing.com (3).png',
                  height: 300,
                ),
                SizedBox(
                  height: 25,
                ),

                //

                Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white70),
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.white54),
                  width: 350,
                  child: Column(
                    children: [
                      //

                      Container(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 8),
                          child: Text(
                            "Forgot \nPassword?",
                            style: GoogleFonts.robotoMono(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ),

                      //

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Text(
                          "Dont't worry! It happens. Please enter the address associated wirh your account.",
                          style: GoogleFonts.lato(
                            fontSize: 16,
                          ),
                        ),
                      ),

                      SizedBox(
                        height: 15,
                      ),

                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: TextFieldInput(
                          hintText: 'Enter your Email',
                          textEditingController: _emailController,
                          textInputType: TextInputType.emailAddress,
                        ),
                      ),

                      //

                      SizedBox(
                        height: 15,
                      ),

                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: ButtonInput(
                          text: 'GET OTP',
                          onTap: () => navigateGetOtpScreen(
                              email: _emailController.text),
                        ),
                      )
                    ],
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
