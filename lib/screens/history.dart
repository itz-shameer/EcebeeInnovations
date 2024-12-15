import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:example_shameer/authentication/log_in.dart';
import 'package:example_shameer/databases/firestore_service.dart';
import 'package:example_shameer/models/login_model.dart';
import 'package:example_shameer/utilities/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qr_flutter/qr_flutter.dart';

class History extends StatefulWidget {
  String mobile;
  History({super.key, required this.mobile});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  final Utilities _u = Utilities();
  FirestoreService _firestore = FirestoreService();
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: _u.black,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: _u.primary,
        actions: [
          TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LogIn(),
                    ));
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
          child: StreamBuilder<QuerySnapshot<Loginmodel>>(
            stream: _firestore.getLogInDetails(widget.mobile),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(
                    child:
                        Text('No login details found for ${widget.mobile}.'));
              }

              final loginDetails = snapshot.data!.docs;

              return ListView.builder(
                itemCount: loginDetails.length,
                itemBuilder: (context, index) {
                  final login = loginDetails[index].data();
                  String datetime = login.logTime;
                  List<String> dateParts = datetime.split("in");

                  String date = dateParts[0].trim();
                  String time = dateParts[1].trim();
                  return Padding(
                    padding: EdgeInsets.only(
                        top: 5.sp, bottom: 5.sp, right: 2.sp, left: 2.sp),
                    child: ListTile(
                      tileColor: Colors.white12,
                      trailing: QrImageView(
                        data: login.genNumb,
                        backgroundColor: _u.white,
                        foregroundColor: _u.black,
                        size: 40.h,
                      ),
                      title: Center(
                          child: Text(
                        date,
                        style: _u.customTextStyle(),
                      )),
                      subtitle: Text(
                        '$time\n'
                        'IP: ${login.ip}\n'
                        'Location: ${login.location}',
                        style: _u.customTextStyle(),
                      ),
                    ),
                  );
                },
              );
            },
          )),
    );
  }
}
