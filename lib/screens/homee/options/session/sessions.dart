import 'package:civil_project/constants/constantdecorations.dart';
import 'package:civil_project/logic/login_cubit/login_cubit.dart';
import 'package:civil_project/logic/session_cubit/session_cubit.dart';
import 'package:civil_project/screens/homee/home_items.dart';
import 'package:civil_project/widgets/boxes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SessionDialog extends StatefulWidget {
  final String title;
  final String descript;
  final List sessionItemsList;
  final bool addOrupdate;
  final int itemId;

  SessionDialog(
      {this.title,
      this.descript,
      this.sessionItemsList,
      this.addOrupdate,
      this.itemId});
  @override
  _SessionDialogState createState() => _SessionDialogState();
}

class _SessionDialogState extends State<SessionDialog> {
  final TextEditingController _title = TextEditingController();
  final TextEditingController _descript = TextEditingController();
  final TextEditingController _sessionItem = TextEditingController();
  List sessionItems = [];
  @override
  void initState() {
    super.initState();
    if (widget.addOrupdate == true) {
      _title.text = widget.title;
      _descript.text = widget.descript;
      sessionItems = widget.sessionItemsList;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _title.dispose();
    _descript.dispose();
    _sessionItem.dispose();
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
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                BlocListener<SessionCubit, SessionState>(
                  listener: (context, state) {
                    if (state is AddedSession) {
                      _title.clear();
                      _descript.clear();
                      _sessionItem.clear();
                      setState(() {
                        sessionItems = [];
                      });
                      Navigator.pop(context);
                    }
                    if (state is UpdatedSession) {
                      _title.clear();
                      _descript.clear();
                      _sessionItem.clear();
                      setState(() {
                        sessionItems = [];
                      });
                      Navigator.pop(context);
                    }
                  },
                  child: Container(),
                ),
                _textFields(height * 0.08, width,
                    hintText: "عنوان", controller: _title),
                _textFields(height * 0.24, width,
                    hintText: "توضیحات", controller: _descript),
                Row(
                  children: [
                    Expanded(
                        flex: 3,
                        child: _textFields(height * 0.09, width,
                            hintText: "حاضرین", controller: _sessionItem)),
                    Expanded(
                      child: RaisedButton(
                          shape: CircleBorder(),
                          child: Icon(Icons.add),
                          onPressed: () {
                            setState(() {
                              sessionItems.add(_sessionItem.text);
                              print(sessionItems);
                            });
                            _sessionItem.clear();
                          }),
                    ),
                  ],
                ),
                SizedBox(
                  height: height * 0.2,
                  child: ListView.separated(
                      itemBuilder: (context, index) => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(sessionItems[index]),
                              IconButton(
                                icon: Icon(Icons.cancel_outlined),
                                onPressed: () {
                                  setState(() {
                                    sessionItems.removeAt(index);
                                  });
                                },
                              )
                            ],
                          ),
                      separatorBuilder: (context, index) => Divider(),
                      itemCount: sessionItems.length),
                ),
                BlocBuilder<SessionCubit, SessionState>(
                  builder: (context, state) {
                    if (state is AddingSession) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (state is UpdatingSession) {
                      return Center(child: CircularProgressIndicator());
                    } else {
                      return Container(
                        height: height * 0.08,
                        margin: EdgeInsets.symmetric(
                            horizontal: width * 0.01, vertical: height * 0.05),
                        child: RaisedButton(
                          onPressed: () async {
                            if (widget.addOrupdate == false) {
                              await BlocProvider.of<SessionCubit>(context)
                                  .addingSession(   token:
                                          BlocProvider.of<LoginCubit>(context)
                                              .token,
                                      projectId:
                                          BlocProvider.of<LoginCubit>(context)
                                              .projectId,
                                      activityId:
                                          BlocProvider.of<LoginCubit>(context)
                                              .activityId,
                                      titleOf: _title.text,
                                      descriptionOf: _descript.text,
                                      sessionItems: sessionItems);
                            }
                            if (widget.addOrupdate == true) {
                              await BlocProvider.of<SessionCubit>(context)
                                  .updatingSession(   token:
                                          BlocProvider.of<LoginCubit>(context)
                                              .token,
                                      projectId:
                                          BlocProvider.of<LoginCubit>(context)
                                              .projectId,
                                      activityId:
                                          BlocProvider.of<LoginCubit>(context)
                                              .activityId,
                                      itemId: widget.itemId,
                                      titleOf: _title.text,
                                      descriptionOf: _descript.text,
                                      sessionItems: sessionItems);
                            }
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
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class Session extends StatefulWidget {
  @override
  _SessionState createState() => _SessionState();
}

class _SessionState extends State<Session> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<SessionCubit>(context).gettingSession(   token:
                                          BlocProvider.of<LoginCubit>(context)
                                              .token,
                                      projectId:
                                          BlocProvider.of<LoginCubit>(context)
                                              .projectId,
                                      activityId:
                                          BlocProvider.of<LoginCubit>(context)
                                              .activityId,);
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("جلسات"),
      ),
      floatingActionButton: FloatingActionButton.extended(
          icon: Icon(Icons.add),
          onPressed: () async {
            await showDialog(
                context: context,
                useRootNavigator: false,
                builder: (_) {
                  return BlocProvider.value(
                      value: context.read<SessionCubit>(),
                      child: SessionDialog(
                        addOrupdate: false,
                      ));
                });
          },
          label: Text("اضافه کردن")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        textDirection: TextDirection.rtl,
        children: [
          BlocListener<SessionCubit, SessionState>(
            listener: (context, state) {
              if (state is DeletedSession) {
                if (state.success == false) {
                  Scaffold.of(context)
                    ..removeCurrentSnackBar()
                    ..showSnackBar(SnackBar(content: Text("مشکلی پیش آمده")));
                } else {
                  Scaffold.of(context).showSnackBar(
                      SnackBar(content: Text("فعالیت با موفقیت حذف شد")));
                }
              }
              if (state is AddedSession) {
                if (state.success == false) {
                  Scaffold.of(context)
                    ..removeCurrentSnackBar()
                    ..showSnackBar(SnackBar(content: Text("مشکلی پیش آمده")));
                } else {
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text("فعالیت با موفقیت اضافه شد"),
                    duration: Duration(seconds: 1),
                  ));
                }
              }
              if (state is UpdatedSession) {
                if (state.success == false) {
                  Scaffold.of(context)
                    ..removeCurrentSnackBar()
                    ..showSnackBar(SnackBar(content: Text("مشکلی پیش آمده")));
                } else {
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text("فعالیت با بروز اضافه شد"),
                    duration: Duration(seconds: 1),
                  ));
                }
              }
              if (state is FailedAddingSession) {
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text("مشکلی  پیش آمده"),
                  duration: Duration(seconds: 1),
                ));
              }
              if (state is FailedDeletingSession) {
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text("مشکلی  پیش آمده"),
                  duration: Duration(seconds: 1),
                ));
              }
              if (state is FailedUpdatingSession) {
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text("مشکلی  پیش آمده"),
                  duration: Duration(seconds: 1),
                ));
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
          BlocBuilder<SessionCubit, SessionState>(
            builder: (context, state) {
              if (state is LoadingSession) {
                return Center(child: CircularProgressIndicator());
              }
              if (state is LoadedSession) {
                if (state.sessions['data'] == null) {
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
                                        "${state.sessions['data'][index]['title']}",
                                        overflow: TextOverflow.fade,
                                      ),
                                      Divider(),
                                      Expanded(
                                                                              child: ConstrainedBox(
                                          constraints: BoxConstraints(
                                              maxWidth: width * 0.1),
                                          child: Text(
                                            "${state.sessions['data'][index]['description']}",
                                            maxLines: 5,
                                            overflow: TextOverflow.visible,
                                            textDirection: TextDirection.rtl,
                                          ),
                                        ),
                                      ),
                                      Divider(),
                                      state.sessions['data'][index]
                                                  ['confirms'] ==
                                              null
                                          ? Text("تاییدی وجود ندارد")
                                          : SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Row(
                                                children: (state.sessions[
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
                                VerticalDivider(endIndent: 65,),
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
                                                        await BlocProvider.of<
                                                                    SessionCubit>(
                                                                context)
                                                            .deletingSession(   token:
                                          BlocProvider.of<LoginCubit>(context)
                                              .token,
                                      projectId:
                                          BlocProvider.of<LoginCubit>(context)
                                              .projectId,
                                      activityId:
                                          BlocProvider.of<LoginCubit>(context)
                                              .activityId,
                                                                itemId: state
                                                                            .sessions[
                                                                        'data'][
                                                                    index]['id']);
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
                                                      .read<SessionCubit>(),
                                                  child: SessionDialog(
                                                    addOrupdate: true,
                                                    itemId:
                                                        state.sessions['data']
                                                            [index]['id'],
                                                    title:
                                                        state.sessions['data']
                                                            [index]['title'],
                                                    descript: state
                                                            .sessions['data']
                                                        [index]['description'],
                                                    sessionItemsList:
                                                        state.sessions['data']
                                                            [index]['items'],
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
                      itemCount: state.sessions['data'].length),
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
