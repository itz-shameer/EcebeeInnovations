import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Utilities {
  //Colors....
  Color? primary = Colors.purple[900];
  Color? black = Colors.black;
  Color? whiteGrey = Colors.grey[600];
  Color white = Colors.white;
  Color? blue = Colors.blue[500];

  //textfield
  customTextField(TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
          filled: true,
          enabled: true,
          fillColor: primary,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.r))),
    );
  }

  customTextStyle() {
    return TextStyle(color: white, fontSize: 15.sp);
  }

  customButtonStyle() {
    return ButtonStyle(
        shape: WidgetStatePropertyAll(
            ContinuousRectangleBorder(borderRadius: BorderRadius.zero)),
        fixedSize: WidgetStatePropertyAll(Size(250.w, 25.h)),
        backgroundColor: WidgetStatePropertyAll(whiteGrey),
        foregroundColor: WidgetStatePropertyAll(white));
  }

  formatDate(DateTime date) {
    DateFormat format = DateFormat("MMMM dd in hh:mm:a");
    return format.format(date);
  }
}
