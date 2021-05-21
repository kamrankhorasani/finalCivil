import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:civil_project/constants/constantdecorations.dart';
import 'package:civil_project/logic/inspection_cubit/inspection_cubit.dart';
import 'package:civil_project/logic/login_cubit/login_cubit.dart';
import 'package:civil_project/models/fileModel.dart';
import 'package:civil_project/models/imageView.dart';
import 'package:civil_project/models/pdfView.dart';
import 'package:civil_project/models/takePhoto.dart';
import 'package:civil_project/screens/homee/home_items.dart';
import 'package:civil_project/widgets/boxes.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InspectionDialog extends StatefulWidget {
  final bool addOrupdate;
  final String title;
  final String description;
  final String visitor;
  final List file;
  final int itemId;

  InspectionDialog(
      {this.addOrupdate,
      this.title,
      this.description,
      this.visitor,
      this.itemId,
      this.file});
  @override
  _InspectionDialogState createState() => _InspectionDialogState();
}

class _InspectionDialogState extends State<InspectionDialog> {
  final TextEditingController _title = TextEditingController();
  final TextEditingController _description = TextEditingController();
  final TextEditingController _visitor = TextEditingController();
  final TextEditingController _attachmenTitle = TextEditingController();
  List<FileModel> _pickedFiles = [];
  Image image;
  List _encodedFiles = [];
  String _data;
  File ss;
  String encoded;
  List<int> fileBytes;
  FilePickerResult result;
  @override
  void initState() {
    super.initState();
    if (widget.addOrupdate == true) {
      _title.text = widget.title;
      _description.text = widget.description;
      widget.file.forEach((element) {
        _pickedFiles.add(FileModel(
          title: element['title'],
          address: element["file"],
          image: element['file'].toString().contains("pdf")
              ? Image.asset("assets/images/pdf.png", height: 50)
              : Image.network(element['file'], height: 50),
        ));
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _description.dispose();
    _title.dispose();

    _attachmenTitle.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return SimpleDialog(
      children: [
        Directionality(
          textDirection: TextDirection.rtl,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: width * 0.05),
            child: Column(
              textDirection: TextDirection.rtl,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                BlocListener<InspectionCubit, InspectionState>(
                  listener: (context, state) {
                    if (state is AddedInspection) {
                      _title.clear();
                      _description.clear();
                      _attachmenTitle.clear();
                      setState(() {
                        _pickedFiles = [];
                        _encodedFiles = [];
                      });
                      Navigator.pop(context);
                    }
                    if (state is UpdatedInspection) {
                      _title.clear();
                      _description.clear();
                      _attachmenTitle.clear();
                      setState(() {
                        _pickedFiles = [];
                        _encodedFiles = [];
                      });
                      Navigator.pop(context);
                    }
                  },
                  child: Container(),
                ),
                _textFields(height * 0.08, width,
                    hintText: "عنوان ", controller: _title),
                _textFields(height * 0.2, width,
                    hintText: "توضیحات ", controller: _description),
                _textFields(height * 0.08, width,
                    hintText: "بازدیدکننده", controller: _visitor),
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
                                          contentPadding: EdgeInsets.symmetric(
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
                                                                      File(rst),
                                                                      height:
                                                                          height *
                                                                              0.15,
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
                                                          _encodedFiles.add({
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
                                                                type: FileType
                                                                    .custom,
                                                                allowedExtensions: [
                                                              'jpg',
                                                              'jpeg',
                                                              'png',
                                                              'pdf'
                                                            ]);
                                                        if (result != null) {
                                                          if (result
                                                                  .files
                                                                  .single
                                                                  .extension ==
                                                              "pdf") {
                                                            image = Image.asset(
                                                                "assets/images/pdf.png",
                                                                height: height *
                                                                    0.15);
                                                          } else {
                                                            image = Image.file(
                                                              File(result.files
                                                                  .single.path),
                                                              height:
                                                                  height * 0.15,
                                                            );
                                                          }
                                                          setState(() {
                                                            _pickedFiles.add(FileModel(
                                                                image: image,
                                                                format: result
                                                                    .files
                                                                    .single
                                                                    .extension,
                                                                address: result
                                                                    .files
                                                                    .single
                                                                    .path,
                                                                title:
                                                                    _attachmenTitle
                                                                        .text));
                                                          });

                                                          ss = File(result.files
                                                              .single.path);
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
                                                          _encodedFiles.add({
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
                            //scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return Stack(children: <Widget>[
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        if (_pickedFiles[index].format ==
                                            'pdf') {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => PDFView(
                                                      address:
                                                          _pickedFiles[index]
                                                              .address)));
                                        } else {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ImageView(
                                                          address: _pickedFiles[
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
                BlocBuilder<InspectionCubit, InspectionState>(
                  builder: (context, state) {
                    if (state is AddingInspection) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (state is UpdatingInspection) {
                      return Center(child: CircularProgressIndicator());
                    } else {
                      return Container(
                        height: height * 0.08,
                        margin: EdgeInsets.symmetric(
                            horizontal: width * 0.01, vertical: height * 0.05),
                        child: RaisedButton(
                          child: Text(
                            "ثبت",
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () async {
                            if (widget.addOrupdate == true) {
                              print("1");
                              for (int i = 0; i < _pickedFiles.length; i++) {
                                if (_pickedFiles[i].address.contains("omran")) {
                                  _encodedFiles.add({
                                    'title': _pickedFiles[i].title,
                                    'file': _pickedFiles[i].address
                                  });
                                }
                              }
                              print("2");
                              await BlocProvider.of<InspectionCubit>(context)
                                  .updatingInspection(
                                token:
                                    BlocProvider.of<LoginCubit>(context).token,
                                projectId: BlocProvider.of<LoginCubit>(context)
                                    .projectId,
                                activityId: BlocProvider.of<LoginCubit>(context)
                                    .activityId,
                                descriptionOf: _description.text,
                                titleOf: _title.text,
                                visitor: _visitor.text,
                                file: _encodedFiles,
                                itemId: widget.itemId,
                              );
                              print("3");
                            }
                            if (widget.addOrupdate == false) {
                              await BlocProvider.of<InspectionCubit>(context)
                                  .addingInspection(
                                token:
                                    BlocProvider.of<LoginCubit>(context).token,
                                projectId: BlocProvider.of<LoginCubit>(context)
                                    .projectId,
                                activityId: BlocProvider.of<LoginCubit>(context)
                                    .activityId,
                                descriptionOf: _description.text,
                                titleOf: _title.text,
                                visitor: _visitor.text,
                                file: _encodedFiles,
                              );
                            }
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          elevation: 10,
                          color: Colors.green,
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

////////////******************** */
class Inspection extends StatefulWidget {
  @override
  _InspectionState createState() => _InspectionState();
}

class _InspectionState extends State<Inspection> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<InspectionCubit>(context).gettingInspection(
      token: BlocProvider.of<LoginCubit>(context).token,
      projectId: BlocProvider.of<LoginCubit>(context).projectId,
      activityId: BlocProvider.of<LoginCubit>(context).activityId,
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("بازدید"),
      ),
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      floatingActionButton: FloatingActionButton.extended(
        label: Text("اضافه کردن"),
        icon: Icon(Icons.add),
        onPressed: () async {
          await showDialog(
              context: context,
              builder: (_) {
                return BlocProvider.value(
                    value: context.read<InspectionCubit>(),
                    child: InspectionDialog(
                      addOrupdate: false,
                    ));
              });
        },
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        textDirection: TextDirection.rtl,
        children: [
          BlocListener<InspectionCubit, InspectionState>(
            listener: (context, state) {
              if (state is DeletedInspection) {
                if (state.success == false) {
                  Scaffold.of(context).showSnackBar(
                      SnackBar(content: Text("فعالیت  متاسفانه حذف نشد")));
                } else {
                  Scaffold.of(context).showSnackBar(
                      SnackBar(content: Text("فعالیت با موفقیت حذف شد")));
                }
              }

              if (state is AddedInspection) {
                if (state.success == false) {
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text("فعالیت متاسفانه اضافه نشد"),
                    duration: Duration(seconds: 1),
                  ));
                } else {
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text("فعالیت با موفقیت اضافه شد"),
                    duration: Duration(seconds: 1),
                  ));
                }
              }
              if (state is UpdatedInspection) {
                if (state.success == false) {
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text("فعالیت متاسفانه بروز نشد"),
                    duration: Duration(seconds: 1),
                  ));
                } else {
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text("فعالیت با بروز اضافه شد"),
                    duration: Duration(seconds: 1),
                  ));
                }
              }
            },
            child: Row(
              children: [
                Expanded(
                    child: activityBox(height, width,
                        actvity: BlocProvider.of<LoginCubit>(context)
                            .activityTitle)),
                SizedBox(width: width * 0.03),
                Expanded(
                    child: dateBox(height, width,
                        date: globalDateController.text)),
              ],
            ),
          ),
          SizedBox(height: height * 0.06),
          BlocBuilder<InspectionCubit, InspectionState>(
            builder: (context, state) {
              if (state is LoadingInspection) {
                return Center(child: CircularProgressIndicator());
              }
              if (state is LoadedInspection) {
                if (state.inspections['data'] == null) {
                  return Center(child: Text("چیزی برای نمایش وجود ندارد"));
                }
                return Expanded(
                  child: ListView.separated(
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Directionality(
                          textDirection: TextDirection.rtl,
                          child: Container(
                            height: height * 0.5,
                            decoration: containerShadow,
                            margin:
                                EdgeInsets.symmetric(horizontal: width * 0.01),
                            padding: EdgeInsets.symmetric(
                                horizontal: width * 0.05,
                                vertical: height * 0.02),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                IntrinsicWidth(
                                  stepWidth: width * 0.6,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Text(
                                        "${state.inspections['data'][index]['title']}",
                                        overflow: TextOverflow.fade,
                                      ),
                                      Divider(),
                                      Expanded(
                                        child: ConstrainedBox(
                                          constraints: BoxConstraints(
                                              maxWidth: width * 0.1),
                                          child: Text(
                                            "${state.inspections['data'][index]['description']}",
                                            maxLines: 5,
                                            overflow: TextOverflow.visible,
                                            textDirection: TextDirection.rtl,
                                          ),
                                        ),
                                      ),
                                      Divider(),
                                      state.inspections['data'][index]
                                                  ['confirms'] ==
                                              null
                                          ? Text("تاییدی وجود ندارد")
                                          : SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Row(
                                                children: (state.inspections[
                                                            'data'][index]
                                                        ['confirms'] as List)
                                                    .map((e) => Row(
                                                          children: [
                                                            e['is_confirm'] == 1
                                                                ? Icon(
                                                                    Icons
                                                                        .thumb_up_alt,
                                                                    color: Colors
                                                                        .green)
                                                                : Icon(
                                                                    Icons
                                                                        .thumb_down_alt,
                                                                    color: Colors
                                                                        .red),
                                                            Text(
                                                                "${e["role"]}:"),
                                                            Text(
                                                                "${e['response']['msg']}"),
                                                            SizedBox(width: 7)
                                                          ],
                                                        ))
                                                    .toList(),
                                              ),
                                            )
                                    ],
                                  ),
                                ),
                                VerticalDivider(),
                                Column(
                                  children: [
                                    Expanded(
                                        child: IconButton(
                                      icon: Icon(
                                        Icons.cancel_outlined,
                                        color: Colors.red[400],
                                        size: width * 0.10,
                                      ),
                                      onPressed: () async {
                                        await showDialog(
                                            context: context,
                                            builder: (ctx) {
                                              return AlertDialog(
                                                title: Text(
                                                    "آیا از حذف مطمئن هستید؟"),
                                                actions: [
                                                  TextButton(
                                                      onPressed: () async {
                                                        Navigator.pop(context);
                                                        await BlocProvider.of<InspectionCubit>(context).deletingInspection(
                                                            token: BlocProvider
                                                                    .of<LoginCubit>(
                                                                        context)
                                                                .token,
                                                            projectId: BlocProvider
                                                                    .of<LoginCubit>(
                                                                        context)
                                                                .projectId,
                                                            activityId:
                                                                BlocProvider.of<LoginCubit>(
                                                                        context)
                                                                    .activityId,
                                                            itemId: state
                                                                    .inspections['data']
                                                                [index]['id']);
                                                      },
                                                      child: Text("تایید")),
                                                  TextButton(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              context),
                                                      child: Text("لغو")),
                                                ],
                                              );
                                            });
                                      },
                                    )),
                                    Expanded(
                                        child: IconButton(
                                      icon: Icon(
                                        Icons.edit,
                                        color: Colors.green[400],
                                        size: width * 0.12,
                                      ),
                                      onPressed: () async {
                                        await showDialog(
                                            context: context,
                                            builder: (_) => BlocProvider.value(
                                                  value: context
                                                      .read<InspectionCubit>(),
                                                  child: InspectionDialog(
                                                    addOrupdate: true,
                                                    itemId: state
                                                            .inspections['data']
                                                        [index]['id'],
                                                    title: state
                                                            .inspections['data']
                                                        [index]['title'],
                                                    description: state
                                                            .inspections['data']
                                                        [index]['description'],
                                                    visitor: state
                                                            .inspections['data']
                                                        [index]['visitor'],
                                                    file: state
                                                            .inspections['data']
                                                        [index]['pics'],
                                                  ),
                                                ));
                                      },
                                    )),
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => Divider(),
                      itemCount: state.inspections['data'].length),
                );
              }
              return Center(
                child: Text("چیزی برای نمایش وجود ندارد"),
              );
            },
          ),
        ],
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
