import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inxee_hr_application/screens/password_reset_page.dart';
import 'package:inxee_hr_application/widgets/button_input.dart';
import 'package:pinput/pinput.dart';

class GetEmailOtp extends StatefulWidget {
  const GetEmailOtp({super.key});

  @override
  State<GetEmailOtp> createState() => _GetEmailOtpState();
}

class _GetEmailOtpState extends State<GetEmailOtp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: SingleChildScrollView(
            child: Container(
          child: Column(
            children: [
              SizedBox(
                height: 1,
              ),

              //

              Center(
                child: Image.asset(
                  'lib/images/43-removebg.png',
                  height: 300,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.white10),
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
                            horizontal: 20, vertical: 8),
                        child: Text(
                          'Enter OTP',
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
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "An 4 digit code has been sent to",
                          style: GoogleFonts.lato(
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(
                      height: 25,
                    ),

                    //

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: SizedBox(
                        width: double.infinity,
                        child: Pinput(
                          length: 4,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          defaultPinTheme: PinTheme(
                            height: 64,
                            width: 64,
                            textStyle: GoogleFonts.urbanist(
                                fontSize: 30,
                                color: Colors.black87,
                                fontWeight: FontWeight.w700),
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black87.withOpacity(1),
                                ),
                                borderRadius: BorderRadius.circular(12),
                                shape: BoxShape.rectangle),
                          ),
                          pinputAutovalidateMode:
                              PinputAutovalidateMode.onSubmit,
                        ),
                      ),
                    ),

                    SizedBox(
                      height: 5,
                    ),

                    //

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                                onPressed: () {},
                                child: Text(
                                  'Resend Code',
                                  style: GoogleFonts.actor(
                                    fontSize: 17,
                                  ),
                                )),
                          ]),
                    ),

                    //

                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 15),
                      child: ButtonInput(
                        text: 'Submit',
                        onTap: () {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PasswordReset(),
                              ),
                              (route) => false);
                        },
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        )),
      ),
    );
  }
}
