import 'dart:developer';

import 'package:example_shameer/authentication/dashboard.dart';
import 'package:example_shameer/location_ip.dart';
import 'package:example_shameer/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final Utilities _u = Utilities();
  final LocationIp _li = LocationIp();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  String _verificationId = '';
  bool otpSent = false;

  Future<void> _verifyPhone() async {
    FirebaseAuth _firebase = FirebaseAuth.instance;

    String phoneNumber = _phoneController.text.trim();
    if (phoneNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter a valid phone number.")),
      );
      return;
    }

    await _firebase.verifyPhoneNumber(
      phoneNumber: phoneNumber, // Pass the phone number
      verificationCompleted: (PhoneAuthCredential credentials) async {
        await _firebase.signInWithCredential(credentials);
        log("Log in success");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Logged in successful")),
        );
      },
      verificationFailed: (error) {
        log("Verification failed $error");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Verification failed: ${error.message}')),
        );
      },
      codeSent: (verificationId, forceResendingToken) {
        setState(() {
          _verificationId = verificationId;
          otpSent = true;
        });
        log('OTP sent to mobile');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("OTP sent successfully.")),
        );
      },
      codeAutoRetrievalTimeout: (verificationId) {
        log("Timeout, verification Id: $verificationId");
        _verificationId = verificationId;
      },
    );
  }

  Future<void> _verifyOTP() async {
    FirebaseAuth _firebase = FirebaseAuth.instance;

    String otpCode = _otpController.text.trim();
    if (otpCode.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter the OTP.")),
      );
      return;
    }

    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: _verificationId,
      smsCode: otpCode,
    );

    try {
      await _firebase.signInWithCredential(credential);
      log('Phone number verified with OTP: $otpCode');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Phone number verified successfully!")),
      );
    } catch (e) {
      log('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error verifying OTP. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: _u.primary,
        appBar: AppBar(
          backgroundColor: _u.primary,
          actions: [
            TextButton(
                onPressed: () async {
                  DateTime lastLogin = DateTime.now();
                  final location = await _li.getLocationDetails();
                  final String ip = await _li.ipAdreess(context);
                  log('City: ${location['city']}, State: ${location['state']}');
                  log('The IP Address is : $ip');

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Dashboard(
                          lastLogin: lastLogin,
                        ),
                      ));
                },
                child: Text('LogIn'))
          ],
        ),
        body: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.r),
              topRight: Radius.circular(20.r),
            ),
          ),
          child: Center(
            child: SizedBox(
              height: height * 0.5,
              width: width * 0.8,
              child: Card(
                color: _u.black,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 10.h),
                      child: Text(
                        "Phone Number",
                        style: _u.customTextStyle(),
                      ),
                    ),
                    _u.customTextField(_phoneController),
                    Padding(
                      padding: EdgeInsets.only(top: 30.h, bottom: 10.h),
                      child: Text(
                        "OTP [One Time Password]",
                        style: _u.customTextStyle(),
                      ),
                    ),
                    _u.customTextField(_otpController),
                    Padding(
                      padding: EdgeInsets.only(top: 30.h, bottom: 10.h),
                      child: Center(
                        child: ElevatedButton(
                          onPressed: () {
                            _verifyPhone();
                          },
                          style: _u.customButtonStyle(),
                          child: Text("SEND OTP"),
                        ),
                      ),
                    ),
                    otpSent
                        ? Padding(
                            padding: EdgeInsets.only(top: 10.h, bottom: 10.h),
                            child: Center(
                              child: ElevatedButton(
                                onPressed: () {
                                  _verifyOTP();
                                },
                                style: _u.customButtonStyle(),
                                child: Text("LOGIN"),
                              ),
                            ),
                          )
                        : SizedBox(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
