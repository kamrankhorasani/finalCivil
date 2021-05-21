import 'package:civil_project/constants/constantdecorations.dart';
import 'package:flutter/material.dart';

dateBox(double height, double width, {String date = "تاریخ"}) => Container(
      height: height * 0.08,
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(
          horizontal: width * 0.03, vertical: height * 0.015),
      decoration: containerShadow,
      child: Text(
        date,
        textDirection: TextDirection.rtl,
      ),
    );

activityBox(double height, double width, {String actvity = ""}) => Container(
      height: height * 0.08,
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(
          horizontal: width * 0.03, vertical: height * 0.015),
      decoration: containerShadow,
      child: Text(
        "$actvity",
        textDirection: TextDirection.rtl,
      ),
    );
