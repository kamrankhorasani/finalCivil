import 'package:flutter/material.dart';

BoxDecoration containerShadow = BoxDecoration(
  color: Colors.grey[600],
  borderRadius: BorderRadius.all(Radius.circular(5)),
  boxShadow: [
    BoxShadow(
      color: Colors.grey[800],
      spreadRadius: 0.5,
      blurRadius: 0.5,
      offset: Offset(0.5, 1), // changes position of shadow
    ),
  ],
);
bool urlDetection(String address) {
  RegExp regExp = new RegExp(
    r"(http|ftp|https):\/\/([\w_-]+(?:(?:\.[\w_-]+)+))([\w.,@?^=%&:\/~+#-]*[\w@?^=%&\/~+#-])?",
    caseSensitive: false,
    multiLine: false,
  );
  return regExp.hasMatch(address);

}


// persianConverter(String string) {
//   const persianNumbers = ["۰", "۱", "۲", "۳", "۴", "۵", "۶", "۷", "۸", "۹"];
//   const arabicNumbers = ["٠", "١", "٢", "٣", "٤", "٥", "٦", "٧", "٨", "٩"];
//   const englishNumbers = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"];

//   for (int i = 0; i < 10; i++)
//     string = string
//         .replaceAll(englishNumbers[i], persianNumbers[i].toString())
//         .replaceAll(englishNumbers[i], arabicNumbers[i].toString());
//   return string;
// }
