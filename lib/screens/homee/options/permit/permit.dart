import 'package:civil_project/constants/constantdecorations.dart';
import 'package:civil_project/logic/configur_cubit/configur_cubit.dart';
import 'package:civil_project/logic/login_cubit/login_cubit.dart';
import 'package:civil_project/logic/permit_cubit/permit_cubit.dart';
import 'package:civil_project/screens/homee/home_items.dart';
import 'package:civil_project/widgets/boxes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PermitDialog extends StatefulWidget {
  final String title;
  final String description;
  final int choice;
  final bool addOrupdate;
  final int itemId;

  PermitDialog(
      {this.title,
      this.description,
      this.choice,
      this.addOrupdate,
      this.itemId});
  @override
  _PermitDialogState createState() => _PermitDialogState();
}

class _PermitDialogState extends State<PermitDialog> {
  final TextEditingController _title = TextEditingController();
  final TextEditingController _descript = TextEditingController();
  int choose;

  _dropDownButtons(double height, double width,
      {String hint = "", List items}) {
    return Container(
      decoration: containerShadow,
      padding: EdgeInsets.symmetric(
          horizontal: hint == "تاریخ" ? width * 0.09 : width * 0.02),
      margin: EdgeInsets.symmetric(
          horizontal: width * 0.02, vertical: height * 0.02),
      child: DropdownButton(
        value: choose,
        isExpanded: true,
        underline: Divider(
          color: Colors.transparent,
        ),
        hint: Text(hint),
        items: items
            .map((e) => DropdownMenuItem(
                value: e['id'],
                child: Text(e["firstName"] + " " + e['lastName'],
                    textDirection: TextDirection.rtl)))
            .toList(),
        onChanged: (value) {
          setState(() {
            choose = value;
          });
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    if (widget.addOrupdate == true) {
      _title.text = widget.title;
      _descript.text = widget.description;
      choose = widget.choice;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _title.dispose();
    _descript.dispose();
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
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                BlocListener<PermitCubit, PermitState>(
                  listener: (context, state) {
                    if (state is AddedPermit) {
                      _title.clear();
                      _descript.clear();
                      setState(() {
                        choose = null;
                      });
                      Navigator.pop(context);
                    }
                    if (state is UpdatedPermit) {
                      _title.clear();
                      _descript.clear();
                      setState(() {
                        choose = null;
                      });
                      Navigator.pop(context);
                    }
                  },
                  child: Container(),
                ),
                _textFields(height * 0.080, width,
                    hintText: "عنوان", controller: _title),
                _dropDownButtons(height, width,
                    hint: "پرمیت از",
                    items: BlocProvider.of<ConfigurCubit>(context).users),
                _textFields(height * 0.15, width,
                    hintText: "توضیحات", controller: _descript),
                BlocBuilder<PermitCubit, PermitState>(
                  builder: (context, state) {
                    if (state is AddingPermit) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (state is UpdatingPermit) {
                      return Center(child: CircularProgressIndicator());
                    }
                    return Container(
                      height: height * 0.08,
                      margin: EdgeInsets.symmetric(
                          horizontal: width * 0.01, vertical: height * 0.05),
                      child: RaisedButton(
                        onPressed: () async {
                          if (widget.addOrupdate == false) {
                            await BlocProvider.of<PermitCubit>(context)
                                .addingPermit(
                                    token: BlocProvider.of<LoginCubit>(context)
                                        .token,
                                    projectId:
                                        BlocProvider.of<LoginCubit>(context)
                                            .projectId,
                                    activityId:
                                        BlocProvider.of<LoginCubit>(context)
                                            .activityId,
                                    titleOf: _title.text,
                                    descriptionOf: _descript.text,
                                    permitFrom: choose);
                          }
                          if (widget.addOrupdate == true) {
                            await BlocProvider.of<PermitCubit>(context)
                                .updatingPermit(
                                    token: BlocProvider.of<LoginCubit>(context)
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
                                    permitFrom: choose);
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
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

//*************************** */
class Permit extends StatefulWidget {
  @override
  _PermitState createState() => _PermitState();
}

class _PermitState extends State<Permit> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<PermitCubit>(context).gettingPermit(
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
        title: Text("پرمیت"),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await showDialog(
            context: context,
            useRootNavigator: true,
            builder: (_) {
              return BlocProvider.value(
                  value: PermitCubit(),
                  child: PermitDialog(addOrupdate: false));
            },
          );
        },
        label: Text("اضافه کردن"),
        icon: Icon(Icons.add),
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
          BlocListener<PermitCubit, PermitState>(
            listener: (context, state) {
              if (state is FailedAddingPermit) {
                Scaffold.of(context)
                  ..removeCurrentSnackBar()
                  ..showSnackBar(SnackBar(content: Text("مشکلی پیش آمده")));
              }
              if (state is FailedUpdatingPermit) {
                Scaffold.of(context)
                  ..removeCurrentSnackBar()
                  ..showSnackBar(SnackBar(content: Text("مشکلی پیش آمده")));
              }
              if (state is AddedPermit) {
                if (state.success == true) {
                  Scaffold.of(context)
                      .showSnackBar(SnackBar(content: Text(" اضافه شد")));
                } else {
                  Scaffold.of(context)
                      .showSnackBar(SnackBar(content: Text("مشکلی پیش آمده")));
                }
              }
              if (state is UpdatedPermit) {
                if (state.success == false) {
                  Scaffold.of(context)
                    ..removeCurrentSnackBar()
                    ..showSnackBar(SnackBar(content: Text("مشکلی پیش آمده")));
                } else {
                  Scaffold.of(context)
                    ..removeCurrentSnackBar()
                    ..showSnackBar(SnackBar(content: Text("جلسه بروز شد")));
                }
              }
              if (state is DeletedPermit) {
                if (state.success == false) {
                  Scaffold.of(context)
                    ..removeCurrentSnackBar()
                    ..showSnackBar(SnackBar(content: Text("مشکلی پیش آمده")));
                } else {
                  Scaffold.of(context)
                    ..removeCurrentSnackBar()
                    ..showSnackBar(SnackBar(content: Text(" حذف شد")));
                }
              }
            },
            child: SizedBox(height: height * 0.04),
          ),
          BlocBuilder<PermitCubit, PermitState>(
            builder: (context, state) {
              if (state is LoadingPermit) {
                return Center(child: CircularProgressIndicator());
              }
              if (state is LoadedPermit) {
                if (state.permits['data'] == null) {
                  return Center(child: Text("چیزی برای نمایش وجود ندارد"));
                } else {
                  return Expanded(
                    child: ListView.separated(
                        shrinkWrap: true,
                        separatorBuilder: (context, index) => Divider(),
                        itemCount: (state.permits['data'] as List).length,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  IntrinsicWidth(
                                    stepWidth: width * 0.6,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        ConstrainedBox(
                                          constraints: BoxConstraints(
                                              maxWidth: double.minPositive),
                                          child: Text(
                                            "${state.permits['data'][index]['title']}  ${state.permits['data'][index]['permit_from']}  ",
                                          ),
                                        ),
                                        Divider(),
                                        Expanded(
                                          child: ConstrainedBox(
                                            constraints: BoxConstraints(
                                                maxWidth: width * 0.1),
                                            child: Text(
                                              state.permits['data'][index]
                                                      ['description']
                                                  .toString(),
                                              maxLines: 5,
                                              overflow: TextOverflow.visible,
                                              textDirection: TextDirection.rtl,
                                            ),
                                          ),
                                        ),
                                        Divider(),
                                        state.permits['data'][index]
                                                    ['confirms'] ==
                                                null
                                            ? Text("تاییدی وجود ندارد")
                                            : SingleChildScrollView(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                child: Row(
                                                  children: (state.permits[
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
                                              )
                                      ],
                                    ),
                                  ),
                                  VerticalDivider(endIndent: 65),
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
                                                          await BlocProvider.of<PermitCubit>(context).deletingPermit(
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
                                                                      .permits['data']
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
                                              value:
                                                  context.read<PermitCubit>(),
                                              child: PermitDialog(
                                                addOrupdate: true,
                                                itemId: state.permits['data']
                                                    [index]['id'],
                                                title: state.permits['data']
                                                    [index]['title'],
                                                description:
                                                    state.permits['data'][index]
                                                        ['description'],
                                              ),
                                            ),
                                          );
                                        },
                                      )),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        }),
                  );
                }
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
