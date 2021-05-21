import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:civil_project/constants/constantdecorations.dart';
import 'package:civil_project/logic/worker_cubit/worker_cubit.dart';
import 'package:civil_project/models/fileModel.dart';
import 'package:civil_project/models/imageView.dart';
import 'package:civil_project/models/pdfView.dart';
import 'package:civil_project/models/takePhoto.dart';
import 'package:civil_project/screens/homee/options/subcontractor/workers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Attachments extends StatefulWidget {
  @override
  _AttachmentsState createState() => _AttachmentsState();
}

class _AttachmentsState extends State<Attachments> {
  //var _title;
  final TextEditingController _attachmenTitle = TextEditingController();
  List<FileModel> _pickedFiles = [];
  Image image;
  //List<Map> _encodedFiles = [];
  String _data;
  File ss;
  String encoded;
  List<int> fileBytes;
  FilePickerResult result;
  @override
  void dispose() {
    super.dispose();
    _attachmenTitle.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Column(
        textDirection: TextDirection.rtl,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: height * 0.05,
          ),
          FloatingActionButton.extended(
            label: Icon(Icons.add),
            icon: Text("ضمیمه"),
            onPressed: () async {
              await showDialog(
                  context: context,
                  builder: (_) {
                    return Container(
                      height: height * 0.3,
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            SimpleDialog(
                              title: Text("اضافه کردن فایل"),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: width * 0.1,
                                  vertical: height * 0.05),
                              children: [
                                SizedBox(
                                    height: 70,
                                    width: 200,
                                    child: _textFields(height * 0.09, width,
                                        hintText: "عنوان ضمیمه",
                                        controller: _attachmenTitle)),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: RaisedButton(
                                          shape: CircleBorder(),
                                          child: Icon(Icons.camera_alt),
                                          onPressed: () async {
                                            final cameras =
                                                await availableCameras();
                                            final firstCamera = cameras.first;
                                            final rst = await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        TakePictureScreen(
                                                            camera:
                                                                firstCamera)));

                                            if (rst == null) {
                                              print("Oh NO");
                                            } else {
                                              setState(() {
                                                _pickedFiles.add(FileModel(
                                                    image: Image.file(
                                                      File(rst),
                                                      height: height * 0.15,
                                                    ),
                                                    address: rst,
                                                    title:
                                                        _attachmenTitle.text));
                                              });
                                              ss = File(rst);
                                              fileBytes = ss.readAsBytesSync();
                                              encoded = base64Encode(fileBytes);
                                              _data =
                                                  "data:image/jpg;base64,$encoded";
                                              BlocProvider.of<WorkerCubit>(
                                                      context)
                                                  .encodedfiles
                                                  .add({
                                                "title": _attachmenTitle.text,
                                                "file": _data
                                              });
                                              Navigator.pop(context);
                                            }
                                          }),
                                    ),
                                    Expanded(
                                      child: RaisedButton(
                                          child: Text("انتخاب"),
                                          onPressed: () async {
                                            result = await FilePicker.platform
                                                .pickFiles(
                                                    allowMultiple: false,
                                                    type: FileType.custom,
                                                    allowedExtensions: [
                                                  'jpg',
                                                  'jpeg',
                                                  'png',
                                                  'pdf'
                                                ]);
                                            if (result != null) {
                                              if (result
                                                      .files.single.extension ==
                                                  "pdf") {
                                                image = Image.asset(
                                                    "assets/images/pdf.png",
                                                    height: height * 0.15);
                                              } else {
                                                image = Image.file(
                                                  File(
                                                      result.files.single.path),
                                                  height: height * 0.15,
                                                );
                                              }
                                              setState(() {
                                                _pickedFiles.add(FileModel(
                                                    image: image,
                                                    format: result
                                                        .files.single.extension,
                                                    address: result
                                                        .files.single.path,
                                                    title:
                                                        _attachmenTitle.text));
                                              });

                                              ss = File(
                                                  result.files.single.path);
                                              fileBytes = ss.readAsBytesSync();
                                              encoded = base64Encode(fileBytes);
                                              if (result
                                                      .files.single.extension ==
                                                  "pdf") {
                                                _data =
                                                    "data:application/pdf/${result.files.single.extension};base64,$encoded";
                                              } else {
                                                _data =
                                                    "data:image/${result.files.single.extension};base64,$encoded";
                                              }
                                              BlocProvider.of<WorkerCubit>(
                                                      context)
                                                  .encodedfiles
                                                  .add({
                                                "title": _attachmenTitle.text,
                                                "file": _data
                                              });
                                              Navigator.pop(context);
                                            } else {
                                              print("no");
                                            }
                                          }),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  });
            },
          ),
          Expanded(
                      child: ListView.separated(
                physics: ScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Stack(children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (_pickedFiles[index].format == 'pdf') {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PDFView(
                                          address:
                                              _pickedFiles[index].address)));
                            } else {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ImageView(
                                          address:
                                              _pickedFiles[index].address)));
                            }
                          },
                          child: Padding(
                              padding: EdgeInsets.all(10),
                              child: _pickedFiles[index].image),
                        ),
                        Text(_pickedFiles[index].title)
                      ],
                    ),
                    Positioned(
                      height: 56,
                      width: 25,
                      top: 0,
                      right: 0,
                      child: IconButton(
                          icon: Icon(
                            Icons.cancel,
                            size: 30,
                            color: Colors.pinkAccent[400],
                          ),
                          onPressed: () {
                            setState(() {
                              _pickedFiles.removeAt(index);
                            });
                          }),
                    )
                  ]);
                },
                separatorBuilder: (context, index) => VerticalDivider(),
                itemCount: _pickedFiles.length),
          ),
          Expanded(
                      child: ListView.separated(
                physics: ScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Stack(children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            if ((mediaList[index]['file'] as String)
                                .contains('pdf')) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PDFView(
                                          address: mediaList[index]
                                              ['file'])));
                            } else {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ImageView(
                                          address: mediaList[index]
                                              ['file'])));
                            }
                          },
                          child: Padding(
                              padding: EdgeInsets.all(10),
                              child: (mediaList[index]['file'] as String)
                                      .contains('pdf')
                                  ? Image.asset(
                                      'assets/images/pdf.png',
                                      height: height * 0.15,
                                    )
                                  : Image.network(mediaList[index]['file'],
                                      height: height * 0.15)),
                        ),
                        Text(mediaList[index]["title"])
                      ],
                    ),
                    Positioned(
                      height: 56,
                      width: 25,
                      top: 0,
                      right: 0,
                      child: IconButton(
                          icon: Icon(
                            Icons.cancel,
                            size: 30,
                            color: Colors.pinkAccent[400],
                          ),
                          onPressed: () {
                            setState(() {
                              mediaList.removeAt(index);
                            });
                          }),
                    )
                  ]);
                },
                separatorBuilder: (context, index) => VerticalDivider(),
                itemCount: mediaList.length),
          ),
        ],
      ),
    );
  }

  _textFields(double height, double width,
      {TextEditingController controller,
      String hintText,
      TextInputType inputType = TextInputType.name}) {
    return Container(
      margin: EdgeInsets.all(width * 0.02),
      padding: EdgeInsets.only(right: width * 0.02),
      height: height,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: TextField(
          controller: controller,
          textDirection: TextDirection.rtl,
          keyboardType: inputType,
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
}
