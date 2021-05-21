import 'package:civil_project/constants/constantdecorations.dart';
import 'package:civil_project/logic/login_cubit/login_cubit.dart';
import 'package:civil_project/logic/machinary_cubit/machinary_cubit.dart';
import 'package:civil_project/widgets/boxes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../home_items.dart';

class MachinaryDialog extends StatefulWidget {
  final String amounT;
  final String description;
  final int choose;
  final int itemId;
  final bool addOrupdate;
  final String type;

  MachinaryDialog(
      {this.amounT,
      this.description,
      this.type,
      this.choose,
      this.itemId,
      this.addOrupdate});
  @override
  _MachinaryDialogState createState() => _MachinaryDialogState();
}

class _MachinaryDialogState extends State<MachinaryDialog> {
  final TextEditingController _amount = TextEditingController();
  final TextEditingController _descript = TextEditingController();
  int choiceMachinary;
  @override
  void dispose() {
    super.dispose();
    _amount.dispose();
    _descript.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (widget.addOrupdate == true) {
      _amount.text = widget.amounT;
      _descript.text = widget.description;
      choiceMachinary = widget.choose;
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
          child: Column(
            textDirection: TextDirection.rtl,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                decoration: containerShadow,
                padding: EdgeInsets.symmetric(horizontal: width * 0.02),
                margin: EdgeInsets.all(width * 0.02),
                child: BlocBuilder<MachinaryCubit, MachinaryState>(
                  builder: (context, state) {
                    if (state is LoadingMachinary) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (state is LoadedMachinary) {
                      return DropdownButtonHideUnderline(
                        child: DropdownButton(
                          disabledHint: Text("نوع"),
                          value: choiceMachinary,
                          underline: Divider(
                            color: Colors.white,
                          ),
                          hint: Text("نوع"),
                          items: (state.machines['data']['items'] as List)
                              .map((e) => DropdownMenuItem(
                                    child: Text(e['title']),
                                    value: e['id'],
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              choiceMachinary = value;
                            });
                          },
                        ),
                      );
                    }
                    return Container();
                  },
                ),
              ),
              BlocListener<MachinaryCubit, MachinaryState>(
                listener: (context, state) {
                  if (state is MachinaryAdded) {
                    _amount.clear();
                    _descript.clear();
                    setState(() {
                      choiceMachinary = null;
                    });
                    Navigator.pop(context);
                  }
                  if (state is UpdatedMachinary) {
                    _amount.clear();
                    _descript.clear();
                    setState(() {
                      choiceMachinary = null;
                    });
                    Navigator.pop(context);
                  }
                },
                child: SizedBox(
                  height: height * 0.03,
                ),
              ),
              _textFields(height, width,
                  hintText: "مقدار",
                  controller: _amount,
                  keyboardtype: TextInputType.numberWithOptions()),
              _textFields(height * 1.5, width,
                  hintText: "توضیحات", controller: _descript),
            ],
          ),
        ),
        BlocBuilder<MachinaryCubit, MachinaryState>(
          builder: (context, state) {
            if (state is AddingMachinary) {
              return Center(child: CircularProgressIndicator());
            }
            if (state is UpdatingMachinary) {
              return Center(child: CircularProgressIndicator());
            } else {
              return Container(
                height: height * 0.08,
                margin: EdgeInsets.symmetric(
                    horizontal: width * 0.01, vertical: height * 0.05),
                child: RaisedButton(
                  onPressed: () async {
                    if (widget.addOrupdate == false) {
                      await BlocProvider.of<MachinaryCubit>(context)
                          .addMachinary(   token:
                                          BlocProvider.of<LoginCubit>(context)
                                              .token,
                                      projectId:
                                          BlocProvider.of<LoginCubit>(context)
                                              .projectId,
                                      activityId:
                                          BlocProvider.of<LoginCubit>(context)
                                              .activityId,
                        amount: _amount.text,
                        itemId: choiceMachinary,
                        info: _descript.text,
                      );
                    }
                    if (widget.addOrupdate == true) {
                      await BlocProvider.of<MachinaryCubit>(context)
                          .updatingMachinary(   token:
                                          BlocProvider.of<LoginCubit>(context)
                                              .token,
                                      projectId:
                                          BlocProvider.of<LoginCubit>(context)
                                              .projectId,
                                      activityId:
                                          BlocProvider.of<LoginCubit>(context)
                                              .activityId,
                        amount: _amount.text,
                        itemId: choiceMachinary,
                        description: _descript.text,
                      );
                    }
                  },
                  child: Text("ثبت", style: TextStyle(color: Colors.white)),
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
    );
  }
}

class Machinarys extends StatefulWidget {
  @override
  _MachinarysState createState() => _MachinarysState();
}

class _MachinarysState extends State<Machinarys> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<MachinaryCubit>(context).getMachines(   token:
                                          BlocProvider.of<LoginCubit>(context)
                                              .token,
                                      projectid:
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
        title: Text("ماشین آلات"),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await showDialog(
            context: context,
            builder: (_) => BlocProvider.value(
              value: context.read<MachinaryCubit>(),
              child: MachinaryDialog(
                addOrupdate: false,
              ),
            ),
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
                      actvity: BlocProvider.of<LoginCubit>(context)
                          .activityTitle)),
              SizedBox(width: width * 0.03),
              Expanded(
                  child: dateBox(height, width,
                      date: globalDateController.text)),
            ],
          ),
          BlocListener<MachinaryCubit, MachinaryState>(
            listener: (context, state) {
              if (state is MachinaryAdded) {
                if (state.succes == false) {
                  Scaffold.of(context)
                    ..removeCurrentSnackBar()
                    ..showSnackBar(
                        SnackBar(content: Text("متاسفانه اضافه نشد")));
                } else {
                  Scaffold.of(context)
                    ..removeCurrentSnackBar()
                    ..showSnackBar(
                        SnackBar(content: Text("با موفقیت اضافه شد")));
                }
                if (state is DeletedMachinary) {
                  if (state.succes == false) {
                    Scaffold.of(context)
                      ..removeCurrentSnackBar()
                      ..showSnackBar(
                          SnackBar(content: Text("متاسفانه حذف نشد")));
                  } else {
                    Scaffold.of(context)
                      ..removeCurrentSnackBar()
                      ..showSnackBar(
                          SnackBar(content: Text("با موفقیت حذف شد")));
                  }
                  if (state is UpdatedMachinary) {
                    if (state.succes == false) {
                      Scaffold.of(context)
                        ..removeCurrentSnackBar()
                        ..showSnackBar(
                            SnackBar(content: Text("متاسفانه بروز نشد")));
                    } else {
                      Scaffold.of(context)
                        ..removeCurrentSnackBar()
                        ..showSnackBar(
                            SnackBar(content: Text("با موفقیت بروز شد")));
                    }
                    if (state is FailedDeletingMachinary) {
                      Scaffold.of(context)
                        ..removeCurrentSnackBar()
                        ..showSnackBar(
                            SnackBar(content: Text("مشکلی پیش آمده است")));
                    }
                    if (state is FailedUpdatingMachinary) {
                      Scaffold.of(context)
                        ..removeCurrentSnackBar()
                        ..showSnackBar(
                            SnackBar(content: Text("مشکلی پیش آمده است")));
                    }
                    if (state is AddingMachinaryFailed) {
                      Scaffold.of(context)
                        ..removeCurrentSnackBar()
                        ..showSnackBar(
                            SnackBar(content: Text("مشکلی پیش آمده است")));
                    }
                  }
                }
              }
            },
            child: SizedBox(height: height * 0.04),
          ),
          BlocBuilder<MachinaryCubit, MachinaryState>(
            builder: (context, state) {
              if (state is LoadingMachinary) {
                return Center(child: CircularProgressIndicator());
              }
              if (state is LoadedMachinary) {
                if (state.storageMachinarys['data'] == null) {
                  return Center(child: Text("چیزی برای نمایش وجود ندارد"));
                } else {
                  return Expanded(
                                        child: ListView.separated(

                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Directionality(
                            textDirection: TextDirection.rtl,
                            child: Container(
                              height: height * 0.5,
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
                                  IntrinsicWidth(
                                    stepWidth: width * 0.6,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Row(
                                          textDirection: TextDirection.rtl,
                                          children: [
                                            Text(
                                              "${state.storageMachinarys['data'][index]['title'] ?? "بدون عنوان"}  مقدار: ${state.storageMachinarys['data'][index]['amount'] ?? ""}",
                                              overflow: TextOverflow.fade,
                                            ),
                                          ],
                                        ),
                                        Divider(),
                                        Text(
                                          " ${state.storageMachinarys['data'][index]['unit'] ?? ""}",
                                        ),
                                        ConstrainedBox(
                                            constraints: BoxConstraints(
                                                maxWidth: width * 0.1),
                                            child: Text(
                                              "${state.storageMachinarys['data'][index]['info'] ?? ""}",
                                              maxLines: 5,
                                              overflow: TextOverflow.visible,
                                              textDirection: TextDirection.rtl,
                                            )),
                                        Divider(),
                                        state.storageMachinarys['data'][index]
                                                    ['confirms'] ==
                                                null
                                            ? Text("تاییدی وجود ندارد")
                                            : SingleChildScrollView(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                child: Row(
                                                  children:
                                                      (state.storageMachinarys[
                                                                          'data']
                                                                      [index]
                                                                  ['confirms']
                                                              as List)
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
                                                                          color:
                                                                              Colors.red),
                                                                  Text(
                                                                      "${e["role"]}:"),
                                                                  Text(
                                                                      "${e['response']['msg']}"),
                                                                  SizedBox(
                                                                      width: 7)
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
                                                          Navigator.pop(
                                                              context);
                                                          await BlocProvider.of<
                                                                      MachinaryCubit>(
                                                                  context)
                                                              .deletingMachinary(   token:
                                          BlocProvider.of<LoginCubit>(context)
                                              .token,
                                      projectId:
                                          BlocProvider.of<LoginCubit>(context)
                                              .projectId,
                                      activityId:
                                          BlocProvider.of<LoginCubit>(context)
                                              .activityId,
                                                            itemId:
                                                                state.storageMachinarys[
                                                                        'data'][
                                                                    index]['id'],
                                                          );
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
                                              builder: (_) =>
                                                  BlocProvider.value(
                                                    value: context
                                                        .read<MachinaryCubit>(),
                                                    child: MachinaryDialog(
                                                      addOrupdate: true,
                                                      itemId: state
                                                              .storageMachinarys[
                                                          'data'][index]['id'],
                                                      description: state
                                                              .storageMachinarys[
                                                          'data'][index]['info'],
                                                      amounT: state
                                                          .storageMachinarys[
                                                              'data'][index]
                                                              ['amount']
                                                          .toString(),
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
                        itemCount: state.storageMachinarys['data'].length),
                  );
                }
              }
              return Text("چیزی برای نمایش وجود ندارد");
            },
          ),
        ],
      ),
    );
  }
}

_textFields(double height, double width,
    {TextEditingController controller,
    String hintText,
    TextInputType keyboardtype = TextInputType.multiline}) {
  return Container(
    margin: EdgeInsets.all(width * 0.02),
    padding: EdgeInsets.only(right: width * 0.02),
    height: hintText == "توضیحات" ? height * 0.1 : null,
    child: Directionality(
      textDirection: TextDirection.rtl,
      child: TextField(
        controller: controller,
        textDirection: TextDirection.rtl,
        keyboardType: keyboardtype,
        maxLines: 1,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
        ),
      ),
    ),
    decoration: containerShadow,
  );
}
