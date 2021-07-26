import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:civil_project/logic/activity_cubit/activity_cubit.dart';
import 'package:civil_project/logic/login_cubit/login_cubit.dart';
import 'package:civil_project/models/fileModel.dart';
import 'package:civil_project/models/imageView.dart';
import 'package:civil_project/models/pdfView.dart';
import 'package:civil_project/models/takePhoto.dart';
import 'package:civil_project/widgets/boxes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:civil_project/constants/constantdecorations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../home_items.dart';

////////////******************** */
class Activity extends StatefulWidget {
  @override
  _ActivityState createState() => _ActivityState();
}

class _ActivityState extends State<Activity> {
  final TextEditingController _description = TextEditingController();
  double percentage = 0;

  @override
  void dispose() {
    super.dispose();
    _description.dispose();
  }

  @override
  void initState() {
    super.initState();
    BlocProvider.of<ActivityCubit>(context)
        .getActivities(
      token: BlocProvider.of<LoginCubit>(context).token,
      projectId: BlocProvider.of<LoginCubit>(context).projectId,
      activityId: BlocProvider.of<LoginCubit>(context).activityId,
    )
        .then((value) {
      percentage = BlocProvider.of<ActivityCubit>(context).precent;
      _description.text = BlocProvider.of<ActivityCubit>(context).description;
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      resizeToAvoidBottomPadding: true,
      appBar: AppBar(
        title: Text("فعالیتها"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: width * 0.05),
        child: Column(
          textDirection: TextDirection.rtl,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            BlocListener<ActivityCubit, ActivityState>(
              listener: (context, state) {
                if (state is ActivityUpdated) {
                  if (state.succes == true) {
                    Scaffold.of(context)
                      ..removeCurrentSnackBar()
                      ..showSnackBar(
                          SnackBar(content: Text("با موفقیت ثبت شد")));
                  } else {
                    Scaffold.of(context)
                      ..removeCurrentSnackBar()
                      ..showSnackBar(
                          SnackBar(content: Text("متاسفانه ثبت نشد")));
                  }
                }
              },
              child: Container(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BlocBuilder<ActivityCubit, ActivityState>(
                  builder: (context, state) {
                    if (state is LoadingActivity) {
                      return Center(child: CircularProgressIndicator());
                    }

                    return Text(
                      "${percentage.toInt()}% ",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                    );
                  },
                ),
                Text("    :درصد پیشرفت کار",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15))
              ],
            ),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                  trackHeight: 7.0,
                  thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
                  overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0)),
              child: Slider(
                value: percentage,
                min: 0.0,
                max: 100.0,
                divisions: 100,
                activeColor: Colors.amber[500],
                inactiveColor: Colors.grey[600],
                onChanged: (double newValue) {
                  setState(() {
                    percentage = newValue;
                  });
                },
              ),
            ),
            _textFields(height * 0.2, width,
                hintText: "توضیحات ", controller: _description),
            BlocBuilder<ActivityCubit, ActivityState>(
              builder: (context, state) {
                if (state is UpdatingActivity) {
                  return Center(child: CircularProgressIndicator());
                }
                return Container(
                  height: height * 0.08,
                  margin: EdgeInsets.symmetric(
                      horizontal: width * 0.01, vertical: height * 0.05),
                  child: RaisedButton(
                    onPressed: () async {
                      await BlocProvider.of<ActivityCubit>(context)
                          .updateActivity(
                              token: BlocProvider.of<LoginCubit>(context).token,
                              projectId: BlocProvider.of<LoginCubit>(context)
                                  .projectId,
                              activityId: BlocProvider.of<LoginCubit>(context)
                                  .activityId,
                              percentVal: percentage.toInt(),
                              description: _description.text);
                    },
                    child: Text(
                      "ثبت",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    elevation: 10,
                    color: Colors.green,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

_textFields(double height, double width,
    {TextEditingController controller, String hintText}) {
  return Container(
    height: height,
    width: width,
    margin: EdgeInsets.all(width * 0.02),
    padding: EdgeInsets.only(right: width * 0.02),
    child: Directionality(
      textDirection: TextDirection.rtl,
      child: TextField(
        controller: controller,
        textDirection: TextDirection.rtl,
        keyboardType: TextInputType.multiline,
        maxLines: null,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
        ),
      ),
    ),
    decoration: containerShadow,
  );
}
// class  ActivityDialog extends StatefulWidget {
//   final bool addOrupdate;

//   final String title;
//   final String description;
//   final List file;
//   final int itemId;

//   ActivityDialog(
//       {this.addOrupdate, this.title, this.description, this.itemId, this.file});
//   @override
//   _ActivityDialogState createState() => _ActivityDialogState();
// }

// class _ActivityDialogState extends State<ActivityDialog> {
//   final TextEditingController _title = TextEditingController();
//   final TextEditingController _description = TextEditingController();
//   final TextEditingController _attachmenTitle = TextEditingController();
//   List<FileModel> _pickedFiles = [];
//   Image image;
//   List _encodedFiles = [];
//   String _data;
//   File ss;
//   String encoded;
//   List<int> fileBytes;
//   FilePickerResult result;
//   @override
//   void initState() {
//     super.initState();
//     if (widget.addOrupdate == true) {
//       _title.text = widget.title;
//       _description.text = widget.description;
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
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _description.dispose();
//     _title.dispose();
//     _attachmenTitle.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final height = MediaQuery.of(context).size.height;
//     final width = MediaQuery.of(context).size.width;
//     return SimpleDialog(
//       children: [
//         Directionality(
//           textDirection: TextDirection.rtl,
//           child: Container(
//             width: double.maxFinite,
//             child: SingleChildScrollView(
//               padding: EdgeInsets.symmetric(horizontal: width * 0.05),
//               child: Column(
//                 textDirection: TextDirection.rtl,
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   BlocListener<ActivityCubit, ActivityState>(
//                     listener: (context, state) {
//                       if (state is ActivityAdded) {
//                         _title.clear();
//                         _description.clear();
//                         _attachmenTitle.clear();
//                         setState(() {
//                           _pickedFiles = [];
//                           _encodedFiles = [];
//                         });
//                         Navigator.pop(context);
//                       }
//                       if (state is ActivityUpdated) {
//                         _title.clear();
//                         _description.clear();
//                         _attachmenTitle.clear();
//                         setState(() {
//                           _pickedFiles = [];
//                           _encodedFiles = [];
//                         });
//                         Navigator.pop(context);
//                       }
//                     },
//                     child: Container(),
//                   ),
//                   _textFields(height * 0.08, width,
//                       hintText: "عنوان ", controller: _title),
//                   _textFields(height * 0.2, width,
//                       hintText: "توضیحات ", controller: _description),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       Expanded(
//                         flex: 1,
//                         child: FloatingActionButton.extended(
//                           label: Icon(Icons.add),
//                           icon: Text("ضمیمه"),
//                           onPressed: () async {
//                             await showDialog(
//                                 context: context,
//                                 builder: (context) {
//                                   return Container(
//                                     height: height * 0.3,
//                                     padding: EdgeInsets.symmetric(
//                                         horizontal: 20, vertical: 10),
//                                     child: SingleChildScrollView(
//                                       child: Column(
//                                         children: [
//                                           SimpleDialog(
//                                             title: Text("اضافه کردن فایل"),
//                                             contentPadding: EdgeInsets.symmetric(
//                                                 horizontal: width * 0.1,
//                                                 vertical: height * 0.05),
//                                             children: [
//                                               SizedBox(
//                                                   height: 70,
//                                                   width: 200,
//                                                   child: _textFields(
//                                                       height * 0.09, width,
//                                                       hintText: "عنوان ضمیمه",
//                                                       controller:
//                                                           _attachmenTitle)),
//                                               Row(
//                                                 mainAxisAlignment:
//                                                     MainAxisAlignment
//                                                         .spaceBetween,
//                                                 children: [
//                                                   Expanded(
//                                                     child: RaisedButton(
//                                                         shape: CircleBorder(),
//                                                         child: Icon(
//                                                             Icons.camera_alt),
//                                                         onPressed: () async {
//                                                           final cameras =
//                                                               await availableCameras();
//                                                           final firstCamera =
//                                                               cameras.first;
//                                                           final rst = await Navigator.push(
//                                                               context,
//                                                               MaterialPageRoute(
//                                                                   builder: (context) =>
//                                                                       TakePictureScreen(
//                                                                           camera:
//                                                                               firstCamera)));

//                                                           if (rst == null) {
//                                                             print("Oh NO");
//                                                           } else {
//                                                             setState(() {
//                                                               _pickedFiles.add(
//                                                                   FileModel(
//                                                                       image: Image
//                                                                           .file(
//                                                                         File(rst),
//                                                                         height:
//                                                                             height *
//                                                                                 0.15,
//                                                                       ),
//                                                                       address:
//                                                                           rst,
//                                                                       title: _attachmenTitle
//                                                                           .text));
//                                                             });
//                                                             ss = File(rst);
//                                                             fileBytes = ss
//                                                                 .readAsBytesSync();
//                                                             encoded =
//                                                                 base64Encode(
//                                                                     fileBytes);
//                                                             _data =
//                                                                 "data:image/jpg;base64,$encoded";
//                                                             _encodedFiles.add({
//                                                               "title":
//                                                                   _attachmenTitle
//                                                                       .text,
//                                                               "file": _data
//                                                             });
//                                                             Navigator.pop(
//                                                                 context);
//                                                           }
//                                                         }),
//                                                   ),
//                                                   Expanded(
//                                                     child: RaisedButton(
//                                                         child: Text("انتخاب"),
//                                                         onPressed: () async {
//                                                           result = await FilePicker
//                                                               .platform
//                                                               .pickFiles(
//                                                                   allowMultiple:
//                                                                       false,
//                                                                   type: FileType
//                                                                       .custom,
//                                                                   allowedExtensions: [
//                                                                 'jpg',
//                                                                 'jpeg',
//                                                                 'png',
//                                                                 'pdf'
//                                                               ]);
//                                                           if (result != null) {
//                                                             if (result
//                                                                     .files
//                                                                     .single
//                                                                     .extension ==
//                                                                 "pdf") {
//                                                               image = Image.asset(
//                                                                   "assets/images/pdf.png",
//                                                                   height: height *
//                                                                       0.15);
//                                                             } else {
//                                                               image = Image.file(
//                                                                 File(result.files
//                                                                     .single.path),
//                                                                 height:
//                                                                     height * 0.15,
//                                                               );
//                                                             }
//                                                             setState(() {
//                                                               _pickedFiles.add(FileModel(
//                                                                   image: image,
//                                                                   format: result
//                                                                       .files
//                                                                       .single
//                                                                       .extension,
//                                                                   address: result
//                                                                       .files
//                                                                       .single
//                                                                       .path,
//                                                                   title:
//                                                                       _attachmenTitle
//                                                                           .text));
//                                                             });

//                                                             ss = File(result.files
//                                                                 .single.path);
//                                                             fileBytes = ss
//                                                                 .readAsBytesSync();
//                                                             encoded =
//                                                                 base64Encode(
//                                                                     fileBytes);
//                                                             if (result
//                                                                     .files
//                                                                     .single
//                                                                     .extension ==
//                                                                 "pdf") {
//                                                               _data =
//                                                                   "data:application/pdf/${result.files.single.extension};base64,$encoded";
//                                                             } else {
//                                                               _data =
//                                                                   "data:image/${result.files.single.extension};base64,$encoded";
//                                                             }
//                                                             _encodedFiles.add({
//                                                               "title":
//                                                                   _attachmenTitle
//                                                                       .text,
//                                                               "file": _data
//                                                             });
//                                                             Navigator.pop(
//                                                                 context);
//                                                           } else {
//                                                             print("no");
//                                                           }
//                                                         }),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ],
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   );
//                                 });
//                           },
//                         ),
//                       ),
//                       Expanded(
//                         flex: 2,
//                         child: SizedBox(
//                           height: height * 0.25,
//                           child: ListView.separated(
//                               physics: ScrollPhysics(),
//                               itemBuilder: (context, index) {
//                                 return Stack(children: <Widget>[
//                                   Column(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       GestureDetector(
//                                         onTap: () {
//                                           if (_pickedFiles[index].format ==
//                                               'pdf') {
//                                             Navigator.push(
//                                                 context,
//                                                 MaterialPageRoute(
//                                                     builder: (context) => PDFView(
//                                                         address:
//                                                             _pickedFiles[index]
//                                                                 .address)));
//                                           } else {
//                                             Navigator.push(
//                                                 context,
//                                                 MaterialPageRoute(
//                                                     builder: (context) =>
//                                                         ImageView(
//                                                             address: _pickedFiles[
//                                                                     index]
//                                                                 .address)));
//                                           }
//                                         },
//                                         child: Padding(
//                                             padding: EdgeInsets.all(10),
//                                             child: _pickedFiles[index].image),
//                                       ),
//                                       Text(_pickedFiles[index].title)
//                                     ],
//                                   ),
//                                   Positioned(
//                                     height: 56,
//                                     width: 25,
//                                     top: -1,
//                                     right: -10,
//                                     child: IconButton(
//                                         icon: Icon(
//                                           Icons.cancel,
//                                           size: 30,
//                                           color: Colors.pinkAccent[400],
//                                         ),
//                                         onPressed: () {
//                                           setState(() {
//                                             _pickedFiles.removeAt(index);
//                                           });
//                                         }),
//                                   )
//                                 ]);
//                               },
//                               separatorBuilder: (context, index) =>
//                                   VerticalDivider(),
//                               itemCount: _pickedFiles.length),
//                         ),
//                       ),
//                     ],
//                   ),
//                   BlocBuilder<ActivityCubit, ActivityState>(
//                     builder: (context, state) {
//                       if (state is AddingActivity) {
//                         return Center(child: CircularProgressIndicator());
//                       }
//                       if (state is UpdatingActivity) {
//                         return Center(child: CircularProgressIndicator());
//                       } else {
//                         return Container(
//                           height: height * 0.08,
//                           margin: EdgeInsets.symmetric(
//                               horizontal: width * 0.01, vertical: height * 0.05),
//                           child: RaisedButton(
//                             child: Text(
//                               "ثبت",
//                               style: TextStyle(color: Colors.white),
//                             ),
//                             onPressed: () async {
//                               if (widget.addOrupdate == true) {
//                                 print("1");
//                                 for (int i = 0; i < _pickedFiles.length; i++) {
//                                   if (_pickedFiles[i].address.contains("omran")) {
//                                     _encodedFiles.add({
//                                       'title': _pickedFiles[i].title,
//                                       'file': _pickedFiles[i].address
//                                     });
//                                   }
//                                 }
//                                 print("2");
//                                 await BlocProvider.of<ActivityCubit>(context)
//                                     .updateActivity(
//                                   token:
//                                       BlocProvider.of<LoginCubit>(context).token,
//                                   projectId: BlocProvider.of<LoginCubit>(context)
//                                       .projectId,
//                                   activityId: BlocProvider.of<LoginCubit>(context)
//                                       .activityId,
//                                   description: _description.text,
//                                 );
//                                 print("3");
//                               }
//                               if (widget.addOrupdate == false) {
//                                 await BlocProvider.of<ActivityCubit>(context)
//                                     .addActivity(
//                                         token:
//                                             BlocProvider.of<LoginCubit>(context)
//                                                 .token,
//                                         projectId:
//                                             BlocProvider.of<LoginCubit>(context)
//                                                 .projectId,
//                                         activityId:
//                                             BlocProvider.of<LoginCubit>(context)
//                                                 .activityId,
//                                         description: _description.text,
//                                         title: _title.text,
//                                         files: _encodedFiles);
//                               }
//                             },
//                             shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(10)),
//                             elevation: 10,
//                             color: Colors.green,
//                           ),
//                         );
//                       }
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
