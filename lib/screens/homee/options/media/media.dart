import 'dart:convert';
import 'dart:io';
import 'package:civil_project/logic/login_cubit/login_cubit.dart';
import 'package:video_player/video_player.dart';
import 'package:camera/camera.dart';
import 'package:civil_project/constants/constantdecorations.dart';
import 'package:civil_project/logic/media_cubit/media_cubit.dart';
import 'package:civil_project/models/fileModel.dart';
import 'package:civil_project/models/imageView.dart';
import 'package:civil_project/models/takePhoto.dart';
import 'package:civil_project/models/videoView.dart';
import 'package:civil_project/screens/homee/home_items.dart';
import 'package:civil_project/widgets/boxes.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MediaDialog extends StatefulWidget {
  final bool addOrupdate;

  final List file;
  final int itemId;

  MediaDialog({this.addOrupdate, this.file, this.itemId});
  @override
  _MediaDialogState createState() => _MediaDialogState();
}

class _MediaDialogState extends State<MediaDialog> {
  final TextEditingController _attachmenTitle = TextEditingController();
  List<FileModel> _pickedFiles = [];
  Image image;
  List<Map> _encodedFiles = [];
  String _data;
  File ss;
  String encoded;
  List<int> fileBytes;
  FilePickerResult result;

  whichType(String fileformat) {
    if (fileformat.contains("mp4") ||
        fileformat.contains("mpeg") ||
        fileformat.contains("ffmpeg")) {
      return Image.asset("assets/images/film.png", height: 50);
    }
    if (fileformat.contains("jpg") ||
        fileformat.contains("jpeg") ||
        fileformat.contains("png")) {
      return Image.network(fileformat, height: 50);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _attachmenTitle.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (widget.addOrupdate == true) {
      widget.file.forEach((element) {
        _pickedFiles.add(FileModel(
            title: element['title'],
            address: element["file"],
            image: whichType(element['file'])));
      });
    }
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
                BlocListener<MediaCubit, MediaState>(
                  listener: (context, state) {
                    if (state is AddedMedia) {
                      _attachmenTitle.clear();
                      setState(() {
                        _pickedFiles = [];
                        _encodedFiles = [];
                      });
                      Navigator.pop(context);
                    }
                    if (state is UpdatedMedia) {
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
                Container(
                  height: height * 0.25,
                  decoration: containerShadow,
                  margin: EdgeInsets.symmetric(
                      horizontal: width * 0.01, vertical: height * 0.01),
                  child: SizedBox(
                    height: height * 0.25,
                    width: double.maxFinite,
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
                                    if (_pickedFiles[index].format == "mpeg" ||
                                        _pickedFiles[index].format ==
                                            "ffmpeg" ||
                                        _pickedFiles[index].format == "mp4") {
                                      if (urlDetection(
                                              _pickedFiles[index].address) ==
                                          true) {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder:
                                                    (context) => ChewieListItem(
                                                          videoPlayerController:
                                                              VideoPlayerController
                                                                  .network(_pickedFiles[
                                                                          index]
                                                                      .address),
                                                        )));
                                      } else {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder:
                                                    (context) => ChewieListItem(
                                                          videoPlayerController:
                                                              VideoPlayerController.file(
                                                                  File(_pickedFiles[
                                                                          index]
                                                                      .address)),
                                                        )));
                                      }
                                    } else {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => ImageView(
                                                  address: _pickedFiles[index]
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
                        separatorBuilder: (context, index) => VerticalDivider(),
                        itemCount: _pickedFiles.length),
                  ),
                ),
                FloatingActionButton.extended(
                  label: Icon(Icons.add),
                  icon: Text("ضمیمه"),
                  onPressed: () async {
                    await showDialog(
                        context: context,
                        builder: (ctx) {
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
                                                              image: Image.file(
                                                                File(rst),
                                                                height: height *
                                                                    0.15,
                                                              ),
                                                              address: rst,
                                                              title:
                                                                  _attachmenTitle
                                                                      .text));
                                                    });
                                                    ss = File(rst);
                                                    fileBytes =
                                                        ss.readAsBytesSync();
                                                    encoded =
                                                        base64Encode(fileBytes);
                                                    _data =
                                                        "data:image/jpg;base64,$encoded";
                                                    _encodedFiles.add({
                                                      "title":
                                                          _attachmenTitle.text,
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
                                                  result = await FilePicker
                                                      .platform
                                                      .pickFiles(
                                                          allowMultiple: false,
                                                          type: FileType.custom,
                                                          allowedExtensions: [
                                                        'jpg',
                                                        'jpeg',
                                                        'png',
                                                        "mp4"
                                                      ]);
                                                  if (result != null) {
                                                    if (result.files.single
                                                            .extension ==
                                                        "mp4") {
                                                      image = Image.asset(
                                                          "assets/images/film.png",
                                                          height:
                                                              height * 0.15);
                                                      if (result.files.single.extension == "jpg" ||
                                                          result.files.single
                                                                  .extension ==
                                                              "png" ||
                                                          result.files.single
                                                                  .extension ==
                                                              'jpeg') {
                                                        image = Image.asset(
                                                            "assets/images/imagelogo.png",
                                                            height:
                                                                height * 0.15);
                                                      }
                                                    } else {
                                                      image = Image.file(
                                                        File(result
                                                            .files.single.path),
                                                        height: height * 0.15,
                                                      );
                                                    }
                                                    setState(() {
                                                      _pickedFiles.add(FileModel(
                                                          image: image,
                                                          format: result.files
                                                              .single.extension,
                                                          address: result.files
                                                              .single.path,
                                                          title: _attachmenTitle
                                                              .text));
                                                    });

                                                    ss = File(result
                                                        .files.single.path);
                                                    fileBytes =
                                                        ss.readAsBytesSync();
                                                    encoded =
                                                        base64Encode(fileBytes);
                                                    if (result.files.single
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
                                                          _attachmenTitle.text,
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
                BlocBuilder<MediaCubit, MediaState>(
                  builder: (context, state) {
                    if (state is AddingMedia) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (state is UpdatingMedia) {
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
                              for (int i = 0; i < _pickedFiles.length; i++) {
                                if (_pickedFiles[i].address.contains("omran")) {
                                  _encodedFiles.add({
                                    'title': _pickedFiles[i].title,
                                    'file': _pickedFiles[i].address
                                  });
                                }
                              }
                              await BlocProvider.of<MediaCubit>(context)
                                  .updatingMedia(
                                      token:
                                          BlocProvider.of<LoginCubit>(context)
                                              .token,
                                      projectId:
                                          BlocProvider.of<LoginCubit>(context)
                                              .projectId,
                                      activityId:
                                          BlocProvider.of<LoginCubit>(context)
                                              .activityId,
                                      itemId: widget.itemId,
                                      file: _encodedFiles);
                            }
                            if (widget.addOrupdate == false) {
                              await BlocProvider.of<MediaCubit>(context)
                                  .addingMedia(
                                      token:
                                          BlocProvider.of<LoginCubit>(context)
                                              .token,
                                      projectId:
                                          BlocProvider.of<LoginCubit>(context)
                                              .projectId,
                                      activityId:
                                          BlocProvider.of<LoginCubit>(context)
                                              .activityId,
                                      file: _encodedFiles);
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

class Media extends StatefulWidget {
  @override
  _MediaState createState() => _MediaState();
}

class _MediaState extends State<Media> {
  List pickedfile;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<MediaCubit>(context).gettingMedia(
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
        title: Text("تصویر و فیلم"),
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: Text("اضافه کردن"),
        icon: Icon(Icons.add),
        onPressed: () async {
          await showDialog(
              context: context,
              builder: (_) {
                return BlocProvider.value(
                    value: context.read<MediaCubit>(),
                    child: MediaDialog(addOrupdate: false));
              });
        },
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        textDirection: TextDirection.rtl,
        children: [
          Row(
            children: [
              Expanded(
                  child: activityBox(height, width,
                      actvity:
                          BlocProvider.of<LoginCubit>(context).activityTitle)),
              SizedBox(width: width * 0.03),
              Expanded(
                  child:
                      dateBox(height, width, date: globalDateController.text)),
            ],
          ),
          BlocListener<MediaCubit, MediaState>(
            listener: (context, state) {
              if (state is FailedLoadingMedia) {
                Scaffold.of(context)
                  ..removeCurrentSnackBar()
                  ..showSnackBar(SnackBar(content: Text("مشکلی پیش آمده")));
              }
              if (state is FailedAddingMedia) {
                Scaffold.of(context)
                  ..removeCurrentSnackBar()
                  ..showSnackBar(SnackBar(content: Text("مشکلی پیش آمده")));
              }
              if (state is FailedDeletingMedia) {
                Scaffold.of(context)
                  ..removeCurrentSnackBar()
                  ..showSnackBar(SnackBar(content: Text("مشکلی پیش آمده")));
              }
              if (state is FailedUpdatingMedia) {
                Scaffold.of(context)
                  ..removeCurrentSnackBar()
                  ..showSnackBar(SnackBar(content: Text("مشکلی پیش آمده")));
              }
              if (state is AddedMedia) {
                if (state.success == false) {
                  Scaffold.of(context)
                    ..removeCurrentSnackBar()
                    ..showSnackBar(SnackBar(content: Text("مشکلی پیش آمده")));
                } else {
                  Scaffold.of(context)
                    ..removeCurrentSnackBar()
                    ..showSnackBar(
                        SnackBar(content: Text("با موفقیت اضافه شد")));
                }
                if (state is UpdatedMedia) {
                  if (state.success == false) {
                    Scaffold.of(context)
                      ..removeCurrentSnackBar()
                      ..showSnackBar(SnackBar(content: Text("مشکلی پیش آمده")));
                  } else {
                    Scaffold.of(context)
                      ..removeCurrentSnackBar()
                      ..showSnackBar(
                          SnackBar(content: Text("با موفقیت بروز شد")));
                  }
                  if (state is DeletedMedia) {
                    if (state.success == false) {
                      Scaffold.of(context)
                        ..removeCurrentSnackBar()
                        ..showSnackBar(
                            SnackBar(content: Text("مشکلی پیش آمده")));
                    } else {
                      Scaffold.of(context)
                        ..removeCurrentSnackBar()
                        ..showSnackBar(
                            SnackBar(content: Text("با موفقیت حذف شد")));
                    }
                  }
                }
              }
            },
            child: SizedBox(height: height * 0.04),
          ),
          BlocBuilder<MediaCubit, MediaState>(
            builder: (context, state) {
              if (state is LoadingMedia) {
                return Center(child: CircularProgressIndicator());
              }
              if (state is LoadedMedia) {
                if (state.medis['data'] == null) {
                  return Center(child: Text("چیزی برای نمایش وجود ندارد"));
                } else {
                  return Expanded(
                    child: ListView.separated(
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          pickedfile = [];
                          state.medis['data'][index]['pics'].forEach((e) {
                            pickedfile.add(FileModel(
                                title: e['title'],
                                address: e["file"],
                                image: (e['file'] as String).contains("mp4")
                                    ? Image.asset("asstes/images/film.png")
                                    : Image.asset("asstes/images/nomage.png")));
                          });

                          return Directionality(
                            textDirection: TextDirection.rtl,
                            child: Container(
                              height: height * 0.3,
                              decoration: containerShadow,
                              margin: EdgeInsets.symmetric(
                                  horizontal: width * 0.01),
                              padding: EdgeInsets.symmetric(
                                  horizontal: width * 0.05,
                                  vertical: height * 0.02),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Expanded(
                                    child: BlocBuilder<MediaCubit, MediaState>(
                                      builder: (context, state) {
                                        if (state is LoadedMedia) {
                                          return ListView.separated(
                                              physics: ScrollPhysics(),
                                              scrollDirection: Axis.horizontal,
                                              itemBuilder: (context, idx) {
                                                return Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    GestureDetector(
                                                        onTap: () {
                                                          if ((state.medis['data']
                                                                          [
                                                                          index]
                                                                      [
                                                                      'pics'][idx]
                                                                  [
                                                                  'file'] as String)
                                                              .contains('mp4')) {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            ChewieListItem(
                                                                              videoPlayerController: VideoPlayerController.network(state.medis['data'][index]['pics'][idx]['file']),
                                                                            )));
                                                          } else {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (context) =>
                                                                        ImageView(
                                                                            address:
                                                                                state.medis['data'][index]['pics'][idx]['file'])));
                                                          }
                                                        },
                                                        child: Padding(
                                                            padding: EdgeInsets.all(
                                                                10),
                                                            child: (state.medis['data'][index]['pics'][idx]
                                                                            ['file']
                                                                        as String)
                                                                    .contains(
                                                                        'mp4')
                                                                ? Image.asset(
                                                                    "assets/images/film.png",height: height*0.1,)
                                                                : Image.network(state.medis['data']
                                                                            [index]
                                                                        ['pics'][idx]
                                                                    ['file'],height: height*0.1,))),
                                                    Text(state.medis['data']
                                                            [index]['pics'][idx]
                                                        ['title'])
                                                  ],
                                                );
                                              },
                                              separatorBuilder:
                                                  (context, idx) =>
                                                      VerticalDivider(),
                                              itemCount: (state.medis['data']
                                                      [index]['pics'] as List)
                                                  .length);
                                        }
                                        return Container();
                                      },
                                    ),
                                  ),
                                  Divider(),
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
                                                          Navigator.pop(
                                                              context);
                                                          await BlocProvider.of<MediaCubit>(context).deletingMedia(
                                                              token: BlocProvider
                                                                      .of<LoginCubit>(
                                                                          context)
                                                                  .token,
                                                              projectId:
                                                                  BlocProvider.of<LoginCubit>(
                                                                          context)
                                                                      .projectId,
                                                              activityId:
                                                                  BlocProvider.of<LoginCubit>(
                                                                          context)
                                                                      .activityId,
                                                              itemId: state
                                                                      .medis['data']
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
                                            useRootNavigator: false,
                                            context: context,
                                            builder: (_) => BlocProvider.value(
                                              value: MediaCubit(),
                                              child: MediaDialog(
                                                addOrupdate: true,
                                                itemId: state.medis['data']
                                                    [index]['id'],
                                                file: state.medis['data'][index]
                                                        ['pics'] ??
                                                    [],
                                              ),
                                            ),
                                          );
                                        },
                                      ))
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) => Divider(),
                        itemCount: state.medis['data'].length),
                  );
                }
              }

              return Container();
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
    margin: EdgeInsets.all(width * 0.02),
    padding: EdgeInsets.only(right: width * 0.02),
    height: height * 0.15,
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
// Container(
//   height: height * 0.3,
//   margin: EdgeInsets.symmetric(vertical: height * 0.03),
//   padding: EdgeInsets.symmetric(
//       vertical: height * 0.02, horizontal: width * 0.02),
//   decoration: containerShadow,
//   child: Column(
//     children: [
//       Expanded(
//           child: _textFields(height, width, hintText: "توضیحات")),
//       SizedBox(
//         height: height * 0.01,
//       ),
//       //*Capture Video Button
//       // Container(
//       //   height: height * 0.1,
//       //   child: RaisedButton.icon(
//       //     onPressed: () {},
//       //     elevation: 10,
//       //     shape: RoundedRectangleBorder(
//       //         borderRadius: BorderRadius.circular(12)),
//       //     color: Colors.blueGrey.shade300,
//       //     icon: Icon(Icons.videocam),
//       //     label: Text(
//       //       "ضبط فیلم",
//       //       textAlign: TextAlign.end,
//       //     ),
//       //   ),
//       // )
//     ],
//   ),
// ),
