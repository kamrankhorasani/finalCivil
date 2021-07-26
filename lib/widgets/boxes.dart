import 'package:civil_project/constants/constantdecorations.dart';
import 'package:flutter/material.dart';

dateBox(double height, double width, {String date = "تاریخ"}) => Container(
      height: width * 0.1,
      width: width*0.5,
      margin: EdgeInsets.symmetric(horizontal: width*0.01),

      decoration: containerShadow,
      child: Center(
        child: Text(
          date,
          textDirection: TextDirection.rtl,
          textAlign: TextAlign.center,
           style: TextStyle(fontSize: width*0.04),
        ),
      ),
    );

activityBox(double height, double width, {String actvity = ""}) => Container(
      height: width * 0.1,
     width: width*0.5,
     margin: EdgeInsets.symmetric(horizontal: width*0.01,vertical: width*0.02),
      decoration: containerShadow,
      child: Center(
        child: Text(
          "$actvity",
          textDirection: TextDirection.rtl,
          textAlign: TextAlign.center,
        style: TextStyle(fontSize: width*0.04),
        ),
      ),
    );
