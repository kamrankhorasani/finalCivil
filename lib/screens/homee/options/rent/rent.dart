// import 'dart:convert';
// import 'dart:io';

// import 'package:camera/camera.dart';
// import 'package:civil_project/constants/constantdecorations.dart';
// import 'package:civil_project/logic/login_cubit/login_cubit.dart';
// import 'package:civil_project/logic/rent_cubit/rent_cubit.dart';
// import 'package:civil_project/models/fileModel.dart';
// import 'package:civil_project/models/imageView.dart';
// import 'package:civil_project/models/pdfView.dart';
// import 'package:civil_project/models/takePhoto.dart';
// import 'package:civil_project/widgets/boxes.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:persian_datepicker/persian_datepicker.dart';

// import '../../home_items.dart';

// class RentDialog extends StatefulWidget {
//   final bool addOrupdate;
//   final String title;
//   final String price;
//   final String dateStart;
//   final String dateEnd;
//   final String description;
//   final String timeStart;
//   final String timeEnd;
//   final int itemId;
//   final List file;
//   RentDialog(
//       {this.addOrupdate,
//       this.description,
//       this.title,
//       this.price,
//       this.dateStart,
//       this.dateEnd,
//       this.timeStart,
//       this.timeEnd,
//       this.file,
//       this.itemId});
//   @override
//   _RentDialogState createState() => _RentDialogState();
// }

// class _RentDialogState extends State<RentDialog> {
//   final TextEditingController _title = TextEditingController();
//   final TextEditingController _descript = TextEditingController();
//   final TextEditingController _price = TextEditingController();
//   final TextEditingController _startDate = TextEditingController();
//   final TextEditingController _endDate = TextEditingController();
//   final TextEditingController fromTime = TextEditingController(text: "از ساعت");
//   final TextEditingController toTime = TextEditingController(text: "تا ساعت");
//   TimeOfDay _selectedTime;
//   PersianDatePickerWidget fromDatePicker;
//   PersianDatePickerWidget toDatePicker;

//   final TextEditingController _attachmenTitle = TextEditingController();
//   List<FileModel> _pickedFiles = [];
//   Image image;
//   List<Map> _encodedFiles = [];
//   String _data;
//   File ss;
//   String encoded;
//   List<int> fileBytes;
//   FilePickerResult result;
//   Future<void> _selectTime(String time, BuildContext context) async {
//     final TimeOfDay picked = await showTimePicker(
//         context: context,
//         initialTime: TimeOfDay.now(),
//         initialEntryMode: TimePickerEntryMode.input,
//         builder: (BuildContext context, Widget child) {
//           return MediaQuery(
//             data: MediaQuery.of(context).copyWith(
//               alwaysUse24HourFormat: true,
//             ),
//             child: child,
//           );
//         });

//     if (picked != null) {
//       setState(() {
//         _selectedTime = picked;
//         if (time == 'to') {
//           toTime.text = '${_selectedTime.hour}:${_selectedTime.minute}';
//         } else
//           fromTime.text = '${_selectedTime.hour}:${_selectedTime.minute}';
//       });
//     }
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _title.dispose();
//     _descript.dispose();
//     _startDate.dispose();
//     _endDate.dispose();
//     fromTime.dispose();
//     toTime.dispose();
//     _price.dispose();
//     _attachmenTitle.dispose();
//   }

//   @override
//   void initState() {
//     super.initState();
//     if (widget.addOrupdate == true) {
//       _descript.text = widget.description;
//       _title.text = widget.title;
//       _startDate.text = widget.dateStart;
//       _endDate.text = widget.dateEnd;
//       _price.text = widget.price;
//       fromTime.text = widget.timeStart ?? "از ساعت";
//       toTime.text = widget.timeEnd ?? "تا ساعت";
//       widget.file.forEach((element) {
//         _pickedFiles.add(FileModel(
//           title: element['title'],
//           address: element["file"],
//           image: element['file'].toString().contains("pdf")
//               ? Image.asset("assets/images/pdf.png", height: 50)
//               : Image.network(element['file'], height: 50),
//         ));
//       });
//     }
//     fromDatePicker = PersianDatePicker(
//       controller: _startDate,
//       fontFamily: 'Vazir',
//       farsiDigits: true,
//       onChange: (oldText, newText) {
//         if (oldText != newText) {
//           Navigator.pop(context);
//         }
//       },
//     ).init();
//     toDatePicker = PersianDatePicker(
//       controller: _endDate,
//       fontFamily: 'Vazir',
//       farsiDigits: true,
//       onChange: (oldText, newText) {
//         if (oldText != newText) {
//           Navigator.pop(context);
//         }
//       },
//     ).init();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final height = MediaQuery.of(context).size.height;
//     final width = MediaQuery.of(context).size.width;
//     return SimpleDialog(
//       children: [
//         Directionality(
//           textDirection: TextDirection.rtl,
//           child: SingleChildScrollView(
//             padding: EdgeInsets.symmetric(horizontal: width * 0.05),
//             child: Column(
//               textDirection: TextDirection.rtl,
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 BlocListener<RentCubit, RentState>(
//                   listener: (context, state) {
//                     if (state is AddedRent) {
//                       _title.clear();
//                       _startDate.clear();
//                       _endDate.clear();
//                       _price.clear();
//                       _descript.clear();
//                       _attachmenTitle.clear();
//                       setState(() {
//                         _pickedFiles = [];
//                         _encodedFiles = [];
//                       });
//                       Navigator.pop(context);
//                     }
//                     if (state is UpdatedRent) {
//                       _title.clear();
//                       _startDate.clear();
//                       _endDate.clear();
//                       _price.clear();
//                       _descript.clear();
//                       _attachmenTitle.clear();
//                       setState(() {
//                         _pickedFiles = [];
//                         _encodedFiles = [];
//                       });

//                       Navigator.pop(context);
//                     }
//                   },
//                   child: Container(),
//                 ),
//                 _textFields(height * 0.08, width,
//                     hintText: "عنوان ", controller: _title),
//                 _textFields(height * 0.15, width,
//                     hintText: "توضیحات ", controller: _descript),
//                 _textFields(height * 0.08, width,
//                     hintText: "مبلغ ",
//                     controller: _price,
//                     keyboardType:
//                         TextInputType.numberWithOptions(decimal: true)),
//                 SizedBox(height: 5),
//                 GestureDetector(
//                   onTap: () async => await _selectTime('from', context),
//                   child: Container(
//                     height: height * 0.06,
//                     margin: EdgeInsets.symmetric(
//                         vertical: height * 0.05, horizontal: width * 0.25),
//                     padding: EdgeInsets.only(
//                         top: height * 0.01, right: width * 0.01),
//                     decoration: containerShadow,
//                     child: Text(fromTime.text, textAlign: TextAlign.center),
//                   ),
//                 ),
//                 GestureDetector(
//                   onTap: () async => await _selectTime('to', context),
//                   child: Container(
//                     height: height * 0.06,
//                     margin: EdgeInsets.symmetric(
//                         vertical: height * 0.05, horizontal: width * 0.25),
//                     padding: EdgeInsets.only(
//                         top: height * 0.01, right: width * 0.01),
//                     decoration: containerShadow,
//                     child: Text(toTime.text, textAlign: TextAlign.center),
//                   ),
//                 ),
//                 Container(
//                   decoration: containerShadow,
//                   margin: EdgeInsets.symmetric(horizontal: width * 0.12),
//                   child: TextField(
//                       textAlign: TextAlign.center,
//                       decoration: new InputDecoration.collapsed(hintText: 'از'),
//                       enableInteractiveSelection:
//                           false, // *** this is important to prevent user interactive selection ***
//                       onTap: () {
//                         FocusScope.of(context).requestFocus(
//                             new FocusNode()); // *** to prevent opening default keyboard
//                         showModalBottomSheet(
//                             isScrollControlled: true,
//                             context: context,
//                             builder: (BuildContext context) {
//                               return fromDatePicker;
//                             });
//                       },
//                       controller: _startDate),
//                 ),
//                 SizedBox(height: 10),
//                 Container(
//                   decoration: containerShadow,
//                   margin: EdgeInsets.symmetric(horizontal: width * 0.12),
//                   child: TextField(
//                       textAlign: TextAlign.center,
//                       decoration: new InputDecoration.collapsed(hintText: 'تا'),
//                       enableInteractiveSelection:
//                           false, // *** this is important to prevent user interactive selection ***
//                       onTap: () {
//                         FocusScope.of(context).requestFocus(
//                             FocusNode()); // *** to prevent opening default keyboard
//                         showModalBottomSheet(
//                             isScrollControlled: true,
//                             context: context,
//                             builder: (BuildContext context) {
//                               return toDatePicker;
//                             });
//                       },
//                       controller: _endDate),
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     Expanded(
//                       flex: 1,
//                       child: FloatingActionButton.extended(
//                         label: Icon(Icons.add),
//                         icon: Text("ضمیمه"),
//                         onPressed: () async {
//                           await showDialog(
//                               context: context,
//                               builder: (context) {
//                                 return Container(
//                                   height: height * 0.3,
//                                   padding: EdgeInsets.symmetric(
//                                       horizontal: 20, vertical: 10),
//                                   child: SingleChildScrollView(
//                                     child: Column(
//                                       children: [
//                                         SimpleDialog(
//                                           title: Text("اضافه کردن فایل"),
//                                           contentPadding: EdgeInsets.symmetric(
//                                               horizontal: width * 0.1,
//                                               vertical: height * 0.05),
//                                           children: [
//                                             SizedBox(
//                                                 height: 70,
//                                                 width: 200,
//                                                 child: _textFields(
//                                                     height * 0.09, width,
//                                                     hintText: "عنوان ضمیمه",
//                                                     controller:
//                                                         _attachmenTitle)),
//                                             Row(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment
//                                                       .spaceBetween,
//                                               children: [
//                                                 Expanded(
//                                                   child: RaisedButton(
//                                                       shape: CircleBorder(),
//                                                       child: Icon(
//                                                           Icons.camera_alt),
//                                                       onPressed: () async {
//                                                         final cameras =
//                                                             await availableCameras();
//                                                         final firstCamera =
//                                                             cameras.first;
//                                                         final rst = await Navigator.push(
//                                                             context,
//                                                             MaterialPageRoute(
//                                                                 builder: (context) =>
//                                                                     TakePictureScreen(
//                                                                         camera:
//                                                                             firstCamera)));

//                                                         if (rst == null) {
//                                                           print("Oh NO");
//                                                         } else {
//                                                           setState(() {
//                                                             _pickedFiles.add(
//                                                                 FileModel(
//                                                                     image: Image
//                                                                         .file(
//                                                                       File(rst),
//                                                                       height:
//                                                                           height *
//                                                                               0.15,
//                                                                     ),
//                                                                     address:
//                                                                         rst,
//                                                                     title: _attachmenTitle
//                                                                         .text));
//                                                           });
//                                                           ss = File(rst);
//                                                           fileBytes = ss
//                                                               .readAsBytesSync();
//                                                           encoded =
//                                                               base64Encode(
//                                                                   fileBytes);
//                                                           _data =
//                                                               "data:image/jpg;base64,$encoded";
//                                                           _encodedFiles.add({
//                                                             "title":
//                                                                 _attachmenTitle
//                                                                     .text,
//                                                             "file": _data
//                                                           });
//                                                           Navigator.pop(
//                                                               context);
//                                                         }
//                                                       }),
//                                                 ),
//                                                 Expanded(
//                                                   child: RaisedButton(
//                                                       child: Text("انتخاب"),
//                                                       onPressed: () async {
//                                                         result = await FilePicker
//                                                             .platform
//                                                             .pickFiles(
//                                                                 allowMultiple:
//                                                                     false,
//                                                                 type: FileType
//                                                                     .custom,
//                                                                 allowedExtensions: [
//                                                               'jpg',
//                                                               'jpeg',
//                                                               'png',
//                                                               'pdf'
//                                                             ]);
//                                                         if (result != null) {
//                                                           if (result
//                                                                   .files
//                                                                   .single
//                                                                   .extension ==
//                                                               "pdf") {
//                                                             image = Image.asset(
//                                                                 "assets/images/pdf.png",
//                                                                 height: height *
//                                                                     0.15);
//                                                           } else {
//                                                             image = Image.file(
//                                                               File(result.files
//                                                                   .single.path),
//                                                               height:
//                                                                   height * 0.15,
//                                                             );
//                                                           }
//                                                           setState(() {
//                                                             _pickedFiles.add(FileModel(
//                                                                 image: image,
//                                                                 format: result
//                                                                     .files
//                                                                     .single
//                                                                     .extension,
//                                                                 address: result
//                                                                     .files
//                                                                     .single
//                                                                     .path,
//                                                                 title:
//                                                                     _attachmenTitle
//                                                                         .text));
//                                                           });

//                                                           ss = File(result.files
//                                                               .single.path);
//                                                           fileBytes = ss
//                                                               .readAsBytesSync();
//                                                           encoded =
//                                                               base64Encode(
//                                                                   fileBytes);
//                                                           if (result
//                                                                   .files
//                                                                   .single
//                                                                   .extension ==
//                                                               "pdf") {
//                                                             _data =
//                                                                 "data:application/pdf/${result.files.single.extension};base64,$encoded";
//                                                           } else {
//                                                             _data =
//                                                                 "data:image/${result.files.single.extension};base64,$encoded";
//                                                           }
//                                                           _encodedFiles.add({
//                                                             "title":
//                                                                 _attachmenTitle
//                                                                     .text,
//                                                             "file": _data
//                                                           });
//                                                           Navigator.pop(
//                                                               context);
//                                                         } else {
//                                                           print("no");
//                                                         }
//                                                       }),
//                                                 ),
//                                               ],
//                                             ),
//                                           ],
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 );
//                               });
//                         },
//                       ),
//                     ),
//                     Expanded(
//                       flex: 2,
//                       child: SizedBox(
//                         height: height * 0.25,
//                         child: ListView.separated(
//                             physics: ScrollPhysics(),
//                             // scrollDirection: Axis.horizontal,
//                             itemBuilder: (context, index) {
//                               return Stack(children: <Widget>[
//                                 Column(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     GestureDetector(
//                                       onTap: () {
//                                         if (_pickedFiles[index].format ==
//                                             'pdf') {
//                                           Navigator.push(
//                                               context,
//                                               MaterialPageRoute(
//                                                   builder: (context) => PDFView(
//                                                       address:
//                                                           _pickedFiles[index]
//                                                               .address)));
//                                         } else {
//                                           Navigator.push(
//                                               context,
//                                               MaterialPageRoute(
//                                                   builder: (context) =>
//                                                       ImageView(
//                                                           address: _pickedFiles[
//                                                                   index]
//                                                               .address)));
//                                         }
//                                       },
//                                       child: Padding(
//                                           padding: EdgeInsets.all(10),
//                                           child: _pickedFiles[index].image),
//                                     ),
//                                     Text(_pickedFiles[index].title)
//                                   ],
//                                 ),
//                                 Positioned(
//                                   height: 56,
//                                   width: 25,
//                                   top: -1,
//                                   right: -10,
//                                   child: IconButton(
//                                       icon: Icon(
//                                         Icons.cancel,
//                                         size: 30,
//                                         color: Colors.pinkAccent[400],
//                                       ),
//                                       onPressed: () {
//                                         setState(() {
//                                           _pickedFiles.removeAt(index);
//                                         });
//                                       }),
//                                 )
//                               ]);
//                             },
//                             separatorBuilder: (context, index) =>
//                                 VerticalDivider(),
//                             itemCount: _pickedFiles.length),
//                       ),
//                     ),
//                   ],
//                 ),
//                 BlocBuilder<RentCubit, RentState>(
//                   builder: (context, state) {
//                     if (state is AddingRent) {
//                       return Center(child: CircularProgressIndicator());
//                     }
//                     if (state is UpdatingRent) {
//                       return Center(child: CircularProgressIndicator());
//                     } else {
//                       return Container(
//                         height: height * 0.08,
//                         margin: EdgeInsets.symmetric(
//                             horizontal: width * 0.01, vertical: height * 0.05),
//                         child: RaisedButton(
//                           child: Text(
//                             "ثبت",
//                             style: TextStyle(color: Colors.white),
//                           ),
//                           onPressed: () async {
//                             if (widget.addOrupdate == true) {
//                               print("1");
//                               for (int i = 0; i < _pickedFiles.length; i++) {
//                                 if (_pickedFiles[i].address.contains("omran")) {
//                                   _encodedFiles.add({
//                                     'title': _pickedFiles[i].title,
//                                     'file': _pickedFiles[i].address
//                                   });
//                                 }
//                               }
//                               print("2");
//                               await BlocProvider.of<RentCubit>(context)
//                                   .updatingRent(
//                                       token:
//                                           BlocProvider.of<LoginCubit>(context)
//                                               .token,
//                                       projectId:
//                                           BlocProvider.of<LoginCubit>(context)
//                                               .projectId,
//                                       activityId:
//                                           BlocProvider.of<LoginCubit>(context)
//                                               .activityId,
//                                       titleOf: _title.text,
//                                       descriptionOf: _descript.text,
//                                       price: _price.text,
//                                       itemId: widget.itemId,
//                                       dateEnd:
//                                           _endDate.text + " " + toTime.text,
//                                       dateStart:
//                                           _startDate.text + " " + fromTime.text,
//                                       file: _encodedFiles);
//                               print("3");
//                             }
//                             if (widget.addOrupdate == false) {
//                               await BlocProvider.of<RentCubit>(context)
//                                   .addingRent(
//                                       token:
//                                           BlocProvider.of<LoginCubit>(context)
//                                               .token,
//                                       projectId:
//                                           BlocProvider.of<LoginCubit>(context)
//                                               .projectId,
//                                       activityId: BlocProvider.of<
//                                               LoginCubit>(context)
//                                           .activityId,
//                                       titleOf: _title.text,
//                                       descriptionOf: _descript.text,
//                                       dateEnd:
//                                           _endDate.text + " " + toTime.text,
//                                       dateStart:
//                                           _startDate.text + " " + fromTime.text,
//                                       price: _price.text,
//                                       file: _encodedFiles);
//                             }
//                           },
//                           shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(10)),
//                           elevation: 10,
//                           color: Colors.green,
//                         ),
//                       );
//                     }
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

// class Rent extends StatefulWidget {
//   @override
//   _RentState createState() => _RentState();
// }

// class _RentState extends State<Rent> {
//   @override
//   void initState() {
//     super.initState();
//     BlocProvider.of<RentCubit>(context).gettingRent(
//       token: BlocProvider.of<LoginCubit>(context).token,
//       projectId: BlocProvider.of<LoginCubit>(context).projectId,
//       activityId: BlocProvider.of<LoginCubit>(context).activityId,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final height = MediaQuery.of(context).size.height;
//     final width = MediaQuery.of(context).size.width;

//     return Scaffold(
//       appBar: AppBar(
//         title: Text("اجاره"),
//       ),
//       floatingActionButton: FloatingActionButton.extended(
//           onPressed: () async {
//             await showDialog(
//                 useRootNavigator: false,
//                 context: context,
//                 builder: (_) {
//                   return BlocProvider.value(
//                       value: context.read<RentCubit>(),
//                       child: RentDialog(
//                         addOrupdate: false,
//                       ));
//                 });
//           },
//           label: Text("اضافه کردن"),
//           icon: Icon(Icons.add)),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         textDirection: TextDirection.rtl,
//         children: [
//           Row(
//             children: [
//               Expanded(
//                   child: activityBox(height, width,
//                       actvity:
//                           BlocProvider.of<LoginCubit>(context).activityTitle)),
//               SizedBox(width: width * 0.03),
//               Expanded(
//                   child:
//                       dateBox(height, width, date: globalDateController.text)),
//             ],
//           ),
//           BlocListener<RentCubit, RentState>(
//             listener: (context, state) {
//               if (state is AddedRent) {
//                 if (state.success == false) {
//                   Scaffold.of(context)
//                     ..removeCurrentSnackBar()
//                     ..showSnackBar(SnackBar(content: Text("مشکلی پیش آمده")));
//                 } else {
//                   Scaffold.of(context)
//                     ..removeCurrentSnackBar()
//                     ..showSnackBar(
//                         SnackBar(content: Text(" با موفقیت اضافه شد")));
//                 }
//               }
//               if (state is UpdatedRent) {
//                 if (state.success == false) {
//                   Scaffold.of(context)
//                     ..removeCurrentSnackBar()
//                     ..showSnackBar(SnackBar(content: Text("مشکلی پیش آمده")));
//                 } else {
//                   Scaffold.of(context).showSnackBar(
//                       SnackBar(content: Text(" با موفقیت بروز شد")));
//                 }
//               }
//               if (state is DeletedRent) {
//                 if (state.success == false) {
//                   Scaffold.of(context)
//                     ..removeCurrentSnackBar()
//                     ..showSnackBar(SnackBar(content: Text("مشکلی پیش آمده")));
//                 } else {
//                   Scaffold.of(context)
//                     ..removeCurrentSnackBar()
//                     ..showSnackBar(
//                         SnackBar(content: Text(" با موفقیت حذف شد")));
//                 }
//               }
//               if (state is FailedAddingRent) {
//                 Scaffold.of(context)
//                   ..removeCurrentSnackBar()
//                   ..showSnackBar(SnackBar(content: Text("مشکلی پیش آمده")));
//               }
//               if (state is FailedDeletingRent) {
//                 Scaffold.of(context)
//                   ..removeCurrentSnackBar()
//                   ..showSnackBar(SnackBar(content: Text("مشکلی پیش آمده")));
//               }
//               if (state is FailedDeletingRent) {
//                 Scaffold.of(context)
//                   ..removeCurrentSnackBar()
//                   ..showSnackBar(SnackBar(content: Text("مشکلی پیش آمده")));
//               }
//             },
//             child: Container(),
//           ),
//           SizedBox(height: height * 0.05),
//           BlocBuilder<RentCubit, RentState>(
//             builder: (context, state) {
//               if (state is LoadingRent) {
//                 return Center(child: CircularProgressIndicator());
//               }
//               if (state is LoadedRent) {
//                 if (state.rents['data'] == null) {
//                   return Center(child: Text("چیزی برای نمایش وجود ندارد"));
//                 }
//                 return Expanded(
//                   child: ListView.separated(
//                       shrinkWrap: true,
//                       itemBuilder: (context, index) {
//                         return Directionality(
//                           textDirection: TextDirection.rtl,
//                           child: Container(
//                             height: height * 0.5,
//                             decoration: containerShadow,
//                             margin:
//                                 EdgeInsets.symmetric(horizontal: width * 0.03),
//                             padding: EdgeInsets.symmetric(
//                                 horizontal: width * 0.05,
//                                 vertical: height * 0.02),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               crossAxisAlignment: CrossAxisAlignment.stretch,
//                               children: [
//                                 IntrinsicWidth(
//                                   stepWidth: width * 0.6,
//                                   child: Column(
//                                     mainAxisAlignment: MainAxisAlignment.start,
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.stretch,
//                                     children: [
//                                       ConstrainedBox(
//                                         constraints: BoxConstraints(
//                                             maxWidth: width * 0.1),
//                                         child: Text(
//                                           "${state.rents['data'][index]['title']}\t مبلغ:${state.rents['data'][index]['price']}",
//                                           maxLines: 1,
//                                           overflow: TextOverflow.visible,
//                                           textDirection: TextDirection.rtl,
//                                         ),
//                                       ),
//                                       Divider(),
//                                       Expanded(
//                                         child: ConstrainedBox(
//                                           constraints: BoxConstraints(
//                                               maxWidth: width * 0.25),
//                                           child: Text(
//                                             state.rents['data'][index]
//                                                     ['description']
//                                                 .toString(),
//                                             maxLines: 5,
//                                             overflow: TextOverflow.visible,
//                                             textDirection: TextDirection.rtl,
//                                           ),
//                                         ),
//                                       ),
//                                       Divider(),
//                                       state.rents['data'][index]['confirms'] ==
//                                               null
//                                           ? Text("تاییدی وجود ندارد")
//                                           : SingleChildScrollView(
//                                               scrollDirection: Axis.horizontal,
//                                               child: Row(
//                                                 children: (state.rents['data']
//                                                             [index]['confirms']
//                                                         as List)
//                                                     .map((e) => Row(
//                                                           children: [
//                                                             e['is_confirm'] == 1
//                                                                 ? Icon(
//                                                                     Icons
//                                                                         .thumb_up_alt,
//                                                                     color: Colors
//                                                                         .green)
//                                                                 : Icon(
//                                                                     Icons
//                                                                         .thumb_down_alt,
//                                                                     color: Colors
//                                                                         .red),
//                                                             Text(
//                                                                 "${e["role"]}:"),
//                                                             Text(
//                                                                 "${e['response']['msg']}"),
//                                                             SizedBox(width: 7)
//                                                           ],
//                                                         ))
//                                                     .toList(),
//                                               ),
//                                             )
//                                     ],
//                                   ),
//                                 ),
//                                 VerticalDivider(),
//                                 Column(
//                                   children: [
//                                     Expanded(
//                                         child: IconButton(
//                                       icon: Icon(
//                                         Icons.cancel_outlined,
//                                         color: Colors.red[400],
//                                         size: width * 0.10,
//                                       ),
//                                       onPressed: () async {
//                                         await showDialog(
//                                             context: context,
//                                             builder: (ctx) {
//                                               return AlertDialog(
//                                                 title: Text(
//                                                     "آیا از حذف مطمئن هستید؟"),
//                                                 actions: [
//                                                   TextButton(
//                                                       onPressed: () async {
//                                                         Navigator.pop(context);
//                                                         await BlocProvider.of<RentCubit>(context).deletingRent(
//                                                             token: BlocProvider
//                                                                     .of<LoginCubit>(
//                                                                         context)
//                                                                 .token,
//                                                             projectId: BlocProvider
//                                                                     .of<LoginCubit>(
//                                                                         context)
//                                                                 .projectId,
//                                                             activityId:
//                                                                 BlocProvider.of<LoginCubit>(
//                                                                         context)
//                                                                     .activityId,
//                                                             itemId: state
//                                                                     .rents['data']
//                                                                 [index]['id']);
//                                                       },
//                                                       child: Text("تایید")),
//                                                   TextButton(
//                                                       onPressed: () =>
//                                                           Navigator.pop(
//                                                               context),
//                                                       child: Text("لغو")),
//                                                 ],
//                                               );
//                                             });
//                                       },
//                                     )),
//                                     Expanded(
//                                         child: IconButton(
//                                       icon: Icon(
//                                         Icons.edit,
//                                         color: Colors.green[400],
//                                         size: width * 0.12,
//                                       ),
//                                       onPressed: () async {
//                                         await showDialog(
//                                           useRootNavigator: false,
//                                           context: context,
//                                           builder: (_) => BlocProvider.value(
//                                             value: RentCubit(),
//                                             child: RentDialog(
//                                               addOrupdate: true,
//                                               title: state.rents['data'][index]
//                                                   ['title'],
//                                               price: state.rents['data'][index]
//                                                       ['price']
//                                                   .toString(),
//                                               dateEnd: state.rents['data']
//                                                       [index]['endDate']
//                                                   .toString()
//                                                   .substring(0, 10),
//                                               timeEnd: state.rents['data']
//                                                       [index]['endDate']
//                                                   .toString()
//                                                   .substring(11),
//                                               dateStart: state.rents['data']
//                                                       [index]['startDate']
//                                                   .toString()
//                                                   .substring(0, 10),
//                                               timeStart: state.rents['data']
//                                                       [index]['startDate']
//                                                   .toString()
//                                                   .substring(11),
//                                               itemId: state.rents['data'][index]
//                                                   ['id'],
//                                               description: state.rents['data']
//                                                   [index]['description'],
//                                               file: state.rents['data'][index]
//                                                   ['files'],
//                                             ),
//                                           ),
//                                         );
//                                       },
//                                     )),
//                                   ],
//                                 )
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                       separatorBuilder: (context, index) => Divider(),
//                       itemCount: state.rents['data'].length),
//                 );
//               }

//               return Container();
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }

// _textFields(double height, double width,
//     {TextEditingController controller,
//     String hintText,
//     TextInputType keyboardType = TextInputType.multiline}) {
//   return Container(
//     margin: EdgeInsets.all(width * 0.02),
//     padding: EdgeInsets.only(right: width * 0.02),
//     height: height,
//     child: Directionality(
//       textDirection: TextDirection.rtl,
//       child: TextField(
//         controller: controller,
//         textDirection: TextDirection.rtl,
//         keyboardType: keyboardType,
//         maxLines: null,
//         decoration: InputDecoration(
//           border: InputBorder.none,
//           hintText: hintText,
//         ),
//       ),
//     ),
//     decoration: containerShadow,
//   );
// }
