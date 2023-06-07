// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inxee_hr_application/screens/login_page_employee.dart';
import 'package:inxee_hr_application/screens/otppage.dart';
import 'package:inxee_hr_application/widgets/button_input.dart';
import 'package:inxee_hr_application/widgets/square_tile.dart';
import 'package:inxee_hr_application/widgets/text_field_input.dart';

class LoginPageAdmin extends StatefulWidget {
  const LoginPageAdmin({super.key});

  @override
  State<LoginPageAdmin> createState() => _LoginPageAdminState();
}

class _LoginPageAdminState extends State<LoginPageAdmin> {
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailcontroller.dispose();
    _passwordcontroller.dispose();
  }

  void navigateToOtpPage() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const OtpPage(),
      ),
      (route) => false,
    );
  }

  void navigateToLoginPageEmployee() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginPage(),
      ),
    );
  }

  void navigateToForgotPassword() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OtpPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 32),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 100),

                //logo
                Image.asset(
                  'lib/images/unnamed.png',
                ),

                const SizedBox(height: 25),

//ADMIN LOGIN
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Container(
                      child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      'ADMIN LOGIN',
                      style: GoogleFonts.acme(
                        textStyle: TextStyle(
                          color: Colors.black,
                          letterSpacing: 1,
                          fontSize: 25,
                        ),
                      ),
                    ),
                  )),
                ),

                const SizedBox(height: 15),

                //email textfield
                TextFieldInput(
                    textEditingController: _emailcontroller,
                    hintText: 'Enter your email',
                    textInputType: TextInputType.emailAddress),

                const SizedBox(height: 25),

                //password textfield
                TextFieldInput(
                  textEditingController: _passwordcontroller,
                  hintText: "Enter your password",
                  textInputType: TextInputType.text,
                  isPass: true,
                ),

                const SizedBox(height: 15),

                //FORGOT PASSWORD

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: navigateToForgotPassword,
                        child: Text(
                          'Forgot Password',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 15),

                //NEXT BUTTON

                ButtonInput(
                  text: 'NEXT',
                  onTap: navigateToOtpPage,
                ),

                const SizedBox(height: 50),

//DIVIDER
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          'or LOGIN as',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 45),

                //employee login

                GestureDetector(
                  onTap: navigateToLoginPageEmployee,
                  child: Container(
                    child: SquareTile(
                      height: 45,
                      imagePath: 'lib/images/912318.png',
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
