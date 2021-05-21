import 'package:civil_project/constants/constantdecorations.dart';
import 'package:civil_project/logic/+workerrole_cubit/workerrole_cubit.dart';
import 'package:civil_project/logic/login_cubit/login_cubit.dart';
import 'package:civil_project/screens/homee/home_items.dart';
import 'package:civil_project/widgets/boxes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyDialog extends StatefulWidget {
  final String feedReport;
  final String fromTime;
  final String toTime;
  final int choose;
  final int itemId;
  final bool addORupdate;

  MyDialog(
      {this.feedReport,
      this.fromTime,
      this.toTime,
      this.choose,
      this.addORupdate,
      this.itemId});
  @override
  _MyDialogState createState() => _MyDialogState();
}

class _MyDialogState extends State<MyDialog> {
  final TextEditingController _feedReport = TextEditingController();
  final TextEditingController fromTime = TextEditingController(text: "از ساعت");
  final TextEditingController toTime = TextEditingController(text: "تا ساعت");
  int workerChoiceId;
  TimeOfDay _selectedTime;

  Future<void> _selectTime(String time, BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        initialEntryMode: TimePickerEntryMode.input,
        builder: (BuildContext context, Widget child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(
              alwaysUse24HourFormat: true,
            ),
            child: child,
          );
        });

    if (picked != null) {
      setState(() {
        _selectedTime = picked;
        if (time == 'to') {
          toTime.text = '${_selectedTime.hour}:${_selectedTime.minute}';
        } else
          fromTime.text = '${_selectedTime.hour}:${_selectedTime.minute}';
      });
    }
  }

  _dropDownButtons(double height, double width,
      {String hint = "", List items}) {
    print(items);
    return Container(
      decoration: containerShadow,
      padding: EdgeInsets.symmetric(horizontal: width * 0.02),
      margin: EdgeInsets.symmetric(
          horizontal: width * 0.02, vertical: height * 0.02),
      child: DropdownButton(
        disabledHint: Text(hint),
        hint: Text(hint),
        value: workerChoiceId,
        isExpanded: true,
        underline: Divider(
          color: Colors.transparent,
        ),
        items: items
            .map((e) => DropdownMenuItem(
                  child: Text(e['firstName'] + e['lastName']),
                  value: e['id'],
                ))
            .toList(),
        onChanged: (value) {
          setState(() {
            workerChoiceId = value;
          });
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    if (widget.addORupdate == true) {
      workerChoiceId = widget.choose;
      _feedReport.text = widget.feedReport;
      fromTime.text = widget.fromTime ?? "از ساعت";
      toTime.text = widget.toTime ?? "تا ساعت";
    }
  }

  @override
  void dispose() {
    super.dispose();
    _feedReport.dispose();
    fromTime.dispose();
    toTime.dispose();
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
            child: Column(
              textDirection: TextDirection.rtl,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                BlocBuilder<WorkerroleCubit, WorkerroleState>(
                  builder: (context, state) {
                    if (state is WorkerRoleLoading) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (state is WorkerRoleLoaded) {
                      return _dropDownButtons(height, width,
                          hint: "نیروها", items: state.humenResourceList);
                    }
                    return Container();
                  },
                ),
                GestureDetector(
                  onTap: () async => await _selectTime('from', context),
                  child: Container(
                    height: height * 0.06,
                    margin: EdgeInsets.symmetric(
                        vertical: height * 0.05, horizontal: width * 0.25),
                    padding: EdgeInsets.only(
                        top: height * 0.01, right: width * 0.01),
                    decoration: containerShadow,
                    child: Text(fromTime.text, textAlign: TextAlign.center),
                  ),
                ),
                BlocListener<WorkerroleCubit, WorkerroleState>(
                  listener: (context, state) {
                    if (state is AddedRole) {
                      _feedReport.clear();
                      fromTime.clear();
                      toTime.clear();
                      setState(() {
                        workerChoiceId = null;
                      });
                      Navigator.pop(context);
                    }
                    if (state is UpdatedRole) {
                      _feedReport.clear();
                      fromTime.clear();
                      toTime.clear();
                      setState(() {
                        workerChoiceId = null;
                      });
                      Navigator.pop(context);
                    }
                  },
                  child: GestureDetector(
                    onTap: () async => await _selectTime('to', context),
                    child: Container(
                      height: height * 0.06,
                      margin: EdgeInsets.symmetric(horizontal: width * 0.25),
                      padding: EdgeInsets.only(
                          top: height * 0.01, right: width * 0.01),
                      decoration: containerShadow,
                      child: Text(toTime.text, textAlign: TextAlign.center),
                    ),
                  ),
                ),
                _textFields(height * 0.15, width,
                    hintText: "گزارش کارکرد", controller: _feedReport),
                BlocBuilder<WorkerroleCubit, WorkerroleState>(
                  builder: (context, state) {
                    if (state is AddingRole) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (state is UpdatingRole) {
                      return Center(child: CircularProgressIndicator());
                    }
                    return Container(
                      height: height * 0.08,
                      margin: EdgeInsets.symmetric(
                          horizontal: width * 0.01, vertical: height * 0.05),
                      child: RaisedButton(
                        onPressed: () async {
                          if (widget.addORupdate == true) {
                            await BlocProvider.of<WorkerroleCubit>(context)
                                .updatingHumen(
                                    token: BlocProvider.of<LoginCubit>(context)
                                        .token,
                                    projectId:
                                        BlocProvider.of<LoginCubit>(context)
                                            .projectId,
                                    activityId:
                                        BlocProvider.of<LoginCubit>(context)
                                            .activityId,
                                    itemId: widget.itemId,
                                    descriptionWork: _feedReport.text,
                                    humanId: workerChoiceId,
                                    timeFor: fromTime.text,
                                    timeTo: toTime.text);
                          }
                          if (widget.addORupdate == false) {
                            await BlocProvider.of<WorkerroleCubit>(context)
                                .addingHumen(
                                    token: BlocProvider.of<LoginCubit>(context)
                                        .token,
                                    projectId:
                                        BlocProvider.of<LoginCubit>(context)
                                            .projectId,
                                    activityId:
                                        BlocProvider.of<LoginCubit>(context)
                                            .activityId,
                                    descriptionWork: _feedReport.text,
                                    humanId: workerChoiceId,
                                    fromTime: fromTime.text,
                                    toTime: toTime.text);
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

class WorkerRole extends StatefulWidget {
  @override
  _WorkerRoleState createState() => _WorkerRoleState();
}

class _WorkerRoleState extends State<WorkerRole> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<WorkerroleCubit>(context).getHumenResources(
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
        title: Text("کارکرد نیروها"),
      ),
      floatingActionButton: FloatingActionButton.extended(
          icon: Icon(Icons.add),
          label: Text("اضافه کردن"),
          onPressed: () async {
            await showDialog(
              useRootNavigator: false,
              context: context,
              builder: (_) {
                return BlocProvider.value(
                    value: context.read<WorkerroleCubit>(),
                    child: MyDialog(
                      addORupdate: false,
                    ));
              },
            );
          }),
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
          SizedBox(height: height * 0.04),
          BlocListener<WorkerroleCubit, WorkerroleState>(
            listener: (context, state) {
              if (state is AddedRole) {
                if (state.succes == false) {
                  Scaffold.of(context)
                    ..removeCurrentSnackBar()
                    ..showSnackBar(SnackBar(content: Text("مشکلی پیش آمده")));
                } else {
                  Scaffold.of(context).showSnackBar(
                      SnackBar(content: Text("دستور کار با موفقیت اضافه شد")));
                }
              }
              if (state is AddingFailedRole) {
                Scaffold.of(context).showSnackBar(
                    SnackBar(content: Text("مشکلی پیش آمده است")));
              }
              if (state is DeletedRole) {
                if (state.succes == false) {
                  Scaffold.of(context)
                    ..removeCurrentSnackBar()
                    ..showSnackBar(SnackBar(content: Text("مشکلی پیش آمده")));
                } else {
                  Scaffold.of(context).showSnackBar(
                      SnackBar(content: Text("گزارش با موفقیت حذف شد")));
                }
              }
              if (state is UpdatedRole) {
                if (state.succes == false) {
                  Scaffold.of(context)
                    ..removeCurrentSnackBar()
                    ..showSnackBar(SnackBar(content: Text("مشکلی پیش آمده")));
                } else {
                  Scaffold.of(context).showSnackBar(
                      SnackBar(content: Text("گزارش با موفقیت بروز شد")));
                }
              }
              if (state is WorkerRoleFailedLoading) {
                Scaffold.of(context).showSnackBar(
                    SnackBar(content: Text("مشکلی پیش آمده است")));
              }
              if (state is DeletingFailedRole) {
                Scaffold.of(context).showSnackBar(
                    SnackBar(content: Text("مشکلی پیش آمده است")));
              }
              if (state is UpdatingFailedRole) {
                Scaffold.of(context).showSnackBar(
                    SnackBar(content: Text("مشکلی پیش آمده است")));
              }
            },
            child: Container(),
          ),
          BlocBuilder<WorkerroleCubit, WorkerroleState>(
            builder: (context, state) {
              if (state is WorkerRoleLoading) {
                return Center(child: CircularProgressIndicator());
              }
              if (state is DeletingRole) {
                return Center(child: CircularProgressIndicator());
              }
              if (state is WorkerRoleLoaded) {
                if ((state.humenWorker['data'] as List) == null) {
                  return Center(child: Text("چیزی برای نمایش وجود ندارد"));
                } else
                  return Expanded(
                    child: ListView.separated(
                      shrinkWrap: true,
                      separatorBuilder: (context, index) => Divider(),
                      itemCount: (state.humenWorker['data'] as List).length,
                      itemBuilder: (context, index) {
                        return Container(
                          height: height * 0.5,
                          decoration: containerShadow,
                          margin:
                              EdgeInsets.symmetric(horizontal: width * 0.03),
                          padding: EdgeInsets.symmetric(
                              horizontal: width * 0.05,
                              vertical: height * 0.02),
                          child: Directionality(
                            textDirection: TextDirection.rtl,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                IntrinsicWidth(
                                  stepWidth: width * 0.60,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Text(
                                        "${state.humenWorker['data'][index]['person']}",
                                      ),
                                      SizedBox(width: width * 0.05),
                                      Text(
                                        "${state.humenWorker['data'][index]['timeFrom']}  -  ${state.humenWorker['data'][index]['timeTo']}",
                                      ),
                                      Divider(),
                                      Expanded(
                                        child: ConstrainedBox(
                                          constraints: BoxConstraints(
                                              maxWidth: width * 0.25),
                                          child: Text(
                                            "${state.humenWorker['data'][index]['description']}",
                                            maxLines: 5,
                                            overflow: TextOverflow.visible,
                                            textDirection: TextDirection.rtl,
                                          ),
                                        ),
                                      ),
                                      Divider(),
                                      state.humenWorker['data'][index]
                                                  ['confirms'] ==
                                              null
                                          ? Text("تاییدی وجود ندارد")
                                          : SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Expanded(
                                                flex: 2,
                                                child: Row(
                                                  children: (state.humenWorker[
                                                              'data'][index]
                                                          ['confirms'] as List)
                                                      .map((e) => Row(
                                                            children: [
                                                              e['is_confirm'] ==
                                                                      1
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
                                              ),
                                            )
                                    ],
                                  ),
                                ),
                                VerticalDivider(
                                  endIndent: 65,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        Icons.cancel_outlined,
                                        color: Colors.red[400],
                                        size: width * 0.1,
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
                                                        await BlocProvider.of<WorkerroleCubit>(context).deletingHumen(
                                                            token: BlocProvider.of<
                                                                        LoginCubit>(
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
                                                            dateIn:
                                                                globalDateController
                                                                    .text,
                                                            itemId: state
                                                                    .humenWorker['data']
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
                                    ),
                                    SizedBox(height: height * 0.15),
                                    IconButton(
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
                                                    .read<WorkerroleCubit>(),
                                                child: MyDialog(
                                                  addORupdate: true,
                                                  fromTime: state
                                                      .humenWorker['data']
                                                          [index]['timeFrom']
                                                      .toString()
                                                      .substring(0, 5),
                                                  toTime: state
                                                      .humenWorker['data']
                                                          [index]['timeTo']
                                                      .toString()
                                                      .substring(0, 5),
                                                  feedReport: state
                                                          .humenWorker['data']
                                                      [index]['description'],
                                                  itemId:
                                                      state.humenWorker['data']
                                                          [index]['id'],
                                                )));
                                      },
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
              }
              return Center(child: Text("چیزی برای نمایش وجود ندارد"));
            },
          )
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
