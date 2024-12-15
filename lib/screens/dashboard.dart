import 'dart:math';
import 'dart:developer';
import 'package:example_shameer/authentication/log_in.dart';
import 'package:example_shameer/databases/firestore_service.dart';
import 'package:example_shameer/models/login_model.dart';
import 'package:example_shameer/screens/history.dart';
import 'package:example_shameer/utilities/utilities.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Dashboard extends StatefulWidget {
  String mobile;
  DateTime lastLogin;
  String location;
  String ip;
  Dashboard(
      {super.key,
      required this.lastLogin,
      required this.mobile,
      required this.location,
      required this.ip});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final FirestoreService _firestore = FirestoreService();
  final Utilities _u = Utilities();
  String lastLogin = '';
  String randomNumber = "";
  @override
  void initState() {
    randomNumb();
    setState(() {
      randomNumber = randomNumb();
      lastLogin = _u.formatDate(widget.lastLogin);
    });
    super.initState();
  }

  @override
  String randomNumb() {
    Random _rand = Random();
    print("${9999 + _rand.nextInt(99999)}");
    return "${9999 + _rand.nextInt(99999)}";
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
          automaticallyImplyLeading: false,
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LogIn()));
                },
                child: Text(
                  'LogOut',
                  style: _u.customTextStyle(),
                ))
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
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 20.sp, bottom: 20.sp),
                child: QrImageView(
                  data: randomNumber,
                  version: QrVersions.auto,
                  size: 150.h,
                  backgroundColor: _u.white,
                  foregroundColor: _u.black,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 5.sp, bottom: 10.sp),
                child: Text(
                  "Generated Number : ",
                  style: TextStyle(
                      fontSize: 20.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w500),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 5.sp),
                child: Text(
                  randomNumber,
                  style: TextStyle(
                      fontSize: 25.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Spacer(),
              Padding(
                padding: EdgeInsets.only(top: 10.h, bottom: 10.h),
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => History(
                                  mobile: widget.mobile,
                                )));
                  },
                  style: ButtonStyle(
                      shape: WidgetStatePropertyAll(ContinuousRectangleBorder(
                          borderRadius: BorderRadius.zero)),
                      foregroundColor: WidgetStatePropertyAll(_u.white)),
                  child: Text("Last log in at: $lastLogin"),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.h, bottom: 10.h),
                child: Center(
                    child: ElevatedButton(
                  onPressed: () {
                    Loginmodel _login = Loginmodel(
                      mobile: widget.mobile,
                      genNumb: randomNumber,
                      logTime: lastLogin,
                      ip: widget.ip,
                      location: widget.location,
                    );
                    _firestore.addLogindetails(_login);
                  },
                  style: _u.customButtonStyle(),
                  child: Text("SAVE"),
                )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
