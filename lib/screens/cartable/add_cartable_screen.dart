import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:civil_project/constants/constantdecorations.dart';
import 'package:civil_project/logic/cartable_cubit/cartable_cubit.dart';
import 'package:civil_project/logic/configur_cubit/configur_cubit.dart';
import 'package:civil_project/logic/login_cubit/login_cubit.dart';
import 'package:civil_project/models/fileModel.dart';
import 'package:civil_project/models/imageView.dart';
import 'package:civil_project/models/pdfView.dart';
import 'package:civil_project/models/takePhoto.dart';
// ignore: unused_import
import 'package:civil_project/screens/homee/home_items.dart';
// ignore: unused_import
import 'package:civil_project/widgets/boxes.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddCartableScreen extends StatefulWidget {
  @override
  _AddCartableScreenState createState() => _AddCartableScreenState();
}

class _AddCartableScreenState extends State<AddCartableScreen> {
  final TextEditingController _title = TextEditingController();
  final TextEditingController _descript = TextEditingController();
  final TextEditingController _attachmenTitle = TextEditingController();
  List<FileModel> _pickedFiles = [];
  Image image;
  List<Map> _encodedFiles = [];
  int itemId;
  String _data;
  File ss;
  String encoded;
  List<int> fileBytes;
  FilePickerResult result;

  @override
  void initState() {
    super.initState();
    itemId = BlocProvider.of<ConfigurCubit>(context).itemId;
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
            horizontal: width * 0.05, vertical: height * 0.1),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          textDirection: TextDirection.rtl,
          children: [
            SizedBox(height: height * 0.015),
            //*Middle Container
            Container(
              height: height * 0.8,
              padding: EdgeInsets.symmetric(
                  horizontal: width * 0.03, vertical: height * 0.015),
              decoration: containerShadow,
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Column(
                  textDirection: TextDirection.rtl,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: height * 0.03,
                    ),
                    _dropDownButtons(height, width,
                        hint: "به",
                        items: BlocProvider.of<ConfigurCubit>(context).users),
                    _textFields(height * 0.08, width,
                        hintText: "عنوان", controller: _title),
                    _textFields(height * 0.24, width,
                        hintText: "توضیحات", controller: _descript),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 1,
                          child: FloatingActionButton.extended(
                           label: Icon(Icons.add),
                        icon: Text("ضمیمه"),
                            onPressed: () async {
                              await showDialog(
                                  context: context,
                                  builder: (context) {
                                    return Container(
                                      height: height * 0.3,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 10),
                                      child: SingleChildScrollView(
                                        child: Column(
                                          children: [
                                            SimpleDialog(
                                              title: Text("اضافه کردن فایل"),
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      horizontal: width * 0.1,
                                                      vertical: height * 0.05),
                                              children: [
                                                SizedBox(
                                                    height: 70,
                                                    width: 200,
                                                    child: _textFields(
                                                        height * 0.09, width,
                                                        hintText: "عنوان ضمیمه",
                                                        controller:
                                                            _attachmenTitle)),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      child: RaisedButton(
                                                          shape: CircleBorder(),
                                                          child: Icon(
                                                              Icons.camera_alt),
                                                          onPressed: () async {
                                                            final cameras =
                                                                await availableCameras();
                                                            final firstCamera =
                                                                cameras.first;
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
                                                                _pickedFiles.add(
                                                                    FileModel(
                                                                        image: Image
                                                                            .file(
                                                                          File(
                                                                              rst),
                                                                          height:
                                                                              height * 0.15,
                                                                        ),
                                                                        address:
                                                                            rst,
                                                                        title: _attachmenTitle
                                                                            .text));
                                                              });
                                                              ss = File(rst);
                                                              fileBytes = ss
                                                                  .readAsBytesSync();
                                                              encoded =
                                                                  base64Encode(
                                                                      fileBytes);
                                                              _data =
                                                                  "data:image/jpg;base64,$encoded";
                                                              _encodedFiles
                                                                  .add({
                                                                "title":
                                                                    _attachmenTitle
                                                                        .text,
                                                                "file": _data
                                                              });
                                                              Navigator.pop(
                                                                  context);
                                                            }
                                                          }),
                                                    ),
                                                    Expanded(
                                                      child: RaisedButton(
                                                          child: Text("انتخاب"),
                                                          onPressed: () async {
                                                            result = await FilePicker
                                                                .platform
                                                                .pickFiles(
                                                                    allowMultiple:
                                                                        false,
                                                                    type: FileType.custom,
                                                                    allowedExtensions: [
                                                                  'jpg',
                                                                  'jpeg',
                                                                  'png',
                                                                  'pdf'
                                                                ]);
                                                            if (result !=
                                                                null) {
                                                              if (result
                                                                      .files
                                                                      .single
                                                                      .extension ==
                                                                  "pdf") {
                                                                image = Image.asset(
                                                                    "assets/images/pdf.png",
                                                                    height:
                                                                        height *
                                                                            0.15);
                                                              } else {
                                                                image =
                                                                    Image.file(
                                                                  File(result
                                                                      .files
                                                                      .single
                                                                      .path),
                                                                  height:
                                                                      height *
                                                                          0.15,
                                                                );
                                                              }
                                                              setState(() {
                                                                _pickedFiles.add(FileModel(
                                                                    image:
                                                                        image,
                                                                    format: result
                                                                        .files
                                                                        .single
                                                                        .extension,
                                                                    address: result
                                                                        .files
                                                                        .single
                                                                        .path,
                                                                    title: _attachmenTitle
                                                                        .text));
                                                              });

                                                              ss = File(result
                                                                  .files
                                                                  .single
                                                                  .path);
                                                              fileBytes = ss
                                                                  .readAsBytesSync();
                                                              encoded =
                                                                  base64Encode(
                                                                      fileBytes);
                                                              if (result
                                                                      .files
                                                                      .single
                                                                      .extension ==
                                                                  "pdf") {
                                                                _data =
                                                                    "data:application/pdf/${result.files.single.extension};base64,$encoded";
                                                              } else {
                                                                _data =
                                                                    "data:image/${result.files.single.extension};base64,$encoded";
                                                              }
                                                              _encodedFiles
                                                                  .add({
                                                                "title":
                                                                    _attachmenTitle
                                                                        .text,
                                                                "file": _data
                                                              });
                                                              Navigator.pop(
                                                                  context);
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
                        ),
                        Expanded(
                          flex: 2,
                          child: SizedBox(
                            height: height * 0.25,
                            child: ListView.separated(
                                physics: ScrollPhysics(),

                                itemBuilder: (context, index) {
                                  return Stack(children: <Widget>[
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            if (_pickedFiles[index].format ==
                                                'pdf') {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          PDFView(
                                                              address:
                                                                  _pickedFiles[
                                                                          index]
                                                                      .address)));
                                            } else {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ImageView(
                                                              address:
                                                                  _pickedFiles[
                                                                          index]
                                                                      .address)));
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
                                      top: -1,
                                      right: -10,
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
                                separatorBuilder: (context, index) =>
                                    VerticalDivider(),
                                itemCount: _pickedFiles.length),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            //*End of middle Container
            BlocConsumer<CartableCubit, CartableState>(
              listener: (context, state) {
                if (state is AddedCartable) {
                  if (state.success == false) {
                    Scaffold.of(context)
                      ..removeCurrentSnackBar()
                      ..showSnackBar(
                          SnackBar(content: Text('متاسفانه اضافه نشد')));
                  } else {
                    Scaffold.of(context)
                      ..removeCurrentSnackBar()
                      ..showSnackBar(
                          SnackBar(content: Text('کارتابل اضافه شد')));
                    _title.clear();
                    _descript.clear();
                    setState(() {
                      _encodedFiles = [];
                    });
                    Navigator.pop(context);
                  }
                }
                if (state is FailedAddingCartable) {
                  Scaffold.of(context)
                    ..removeCurrentSnackBar()
                    ..showSnackBar(SnackBar(content: Text('کارتابل حذف شد')));
                }
              },
              builder: (context, state) {
                if (state is AddingCartable) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return Container(
                  height: height * 0.08,
                  margin: EdgeInsets.symmetric(
                      horizontal: width * 0.01, vertical: height * 0.04),
                  child: RaisedButton(
                    onPressed: () async {
                      BlocProvider.of<CartableCubit>(context).addCartable(
                        token: BlocProvider.of<LoginCubit>(context).token,
                          titleOf: _title.text,
                          msgType: 'msg',
                          itemId: 0,
                          description: _descript.text,
                          toRole: 0,
                          toUser: itemId,
                          file: _encodedFiles);
                    },
                    child: Text(
                      "ثبت",
                      style: TextStyle(color: Colors.white),
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    elevation: 10,
                    color: Colors.green,
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }

  _dropDownButtons(double height, double width,
      {String hint = "", List items}) {
    return Container(
      decoration: containerShadow,
      padding: EdgeInsets.symmetric(horizontal: width * 0.02),
      margin: EdgeInsets.symmetric(
          horizontal: width * 0.02, vertical: height * 0.02),
      child: DropdownButton(
        isExpanded: true,
        value: itemId,
        underline: Divider(
          color: Colors.transparent,
        ),
        hint: Text(hint),
        items: items
            .map((e) => DropdownMenuItem(
                  child: Text(e['firstName'] + e['lastName']),
                  value: e['id'],
                ))
            .toList(),
        onChanged: (value) {
          setState(() {
            itemId = value;
          });
        },
      ),
    );
  }
}

_textFields(double height, double width,
    {TextEditingController controller, String hintText}) {
  return Container(
    margin: EdgeInsets.all(width * 0.02),
    padding: EdgeInsets.only(right: width * 0.02),
    height: height,
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
