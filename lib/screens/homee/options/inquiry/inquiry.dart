import 'dart:ui';

import 'package:civil_project/constants/constantdecorations.dart';
import 'package:civil_project/logic/inquiry_cubit/inquiry_cubit.dart';
import 'package:civil_project/logic/login_cubit/login_cubit.dart';
import 'package:civil_project/screens/homee/home_items.dart';
import 'package:civil_project/widgets/boxes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persian_datepicker/persian_datepicker.dart';

class InquiryDialog extends StatefulWidget {
  final String description;
  final String amount;
  final String date;
  final int itemId;
  final bool addOrupdate;

  InquiryDialog(
      {this.description,
      this.amount,
      this.date,
      this.itemId,
      this.addOrupdate});
  @override
  _InquiryDialogState createState() => _InquiryDialogState();
}

class _InquiryDialogState extends State<InquiryDialog> {
  final TextEditingController _descript = TextEditingController();
  final TextEditingController _amount = TextEditingController();
  final TextEditingController fromDate = TextEditingController();
  int choose;

  PersianDatePickerWidget fromDatePicker;

  @override
  void dispose() {
    super.dispose();
    _descript.dispose();
    _amount.dispose();
    fromDate.dispose();
  }

  @override
  void initState() {
    super.initState();
    fromDatePicker = PersianDatePicker(
            controller: fromDate,

            fontFamily: 'Vazir',
            farsiDigits: true)
        .init();
    if (widget.addOrupdate == true) {
      _descript.text = widget.description;
      _amount.text = widget.amount;
      fromDate.text = widget.date;
    }
  }

  _dropDownButtons(double height, double width,
      {String hint = "", List items}) {
    return Container(
      decoration: containerShadow,
      padding: EdgeInsets.symmetric(horizontal: width * 0.02),
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
                child: Text(e["title"], textDirection: TextDirection.rtl)))
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
                textDirection: TextDirection.rtl,
                children: [
                  _textFields(height * 0.15, width,
                      hintText: " توضیحات ", controller: _descript),
                  _textFields(height * 0.08, width,
                      hintText: " مقدار استعلام ",
                      controller: _amount,
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true)),
                  _dropDownButtons(height, width,
                      hint: "تامین کننده",
                      items: BlocProvider.of<InquiryCubit>(context).providers),
                  BlocListener<InquiryCubit, InquiryState>(
                    listener: (context, state) {
                      if (state is AddedInquiry) {
                        _descript.clear();
                        _amount.clear();
                        fromDate.clear();
                        setState(() {
                          choose = null;
                        });
                        Navigator.pop(context);
                      }
                      if (state is UpdatedInquiry) {
                        _descript.clear();
                        _amount.clear();
                        fromDate.clear();
                        setState(() {
                          choose = null;
                        });
                        Navigator.pop(context);
                      }
                    },
                    child: SizedBox(height: 5),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: width * 0.1),
                    decoration: containerShadow,
                    child: TextField(
                        textAlign: TextAlign.center,
                        decoration:
                            new InputDecoration.collapsed(hintText: 'تاریخ'),
                        enableInteractiveSelection:
                            false, // *** this is important to prevent user interactive selection ***
                        onTap: () {
                          FocusScope.of(context).requestFocus(
                              new FocusNode()); // *** to prevent opening default keyboard
                          showModalBottomSheet(
                              isScrollControlled: true,
                              context: context,
                              builder: (BuildContext context) {
                                return fromDatePicker;
                              });
                        },
                        controller: fromDate),
                  ),
                  BlocBuilder<InquiryCubit, InquiryState>(
                    builder: (context, state) {
                      if (state is AddingInquiry) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (state is UpdatingInquiry) {
                        return Center(child: CircularProgressIndicator());
                      }
                      return Container(
                        height: height * 0.08,
                        margin: EdgeInsets.symmetric(
                            horizontal: width * 0.01, vertical: height * 0.05),
                        child: RaisedButton(
                          onPressed: () async {
                            if (widget.addOrupdate == false) {
                              await BlocProvider.of<InquiryCubit>(context)
                                  .addingInquiry(   token:
                                          BlocProvider.of<LoginCubit>(context)
                                              .token,
                                      projectId:
                                          BlocProvider.of<LoginCubit>(context)
                                              .projectId,
                                      activityId:
                                          BlocProvider.of<LoginCubit>(context)
                                              .activityId,
                                      descriptionOf: _descript.text,
                                      providerId: choose,
                                      estelamDateFor: fromDate.text,
                                      estelamAmount: _amount.text);
                            }
                            if (widget.addOrupdate == true) {
                              await BlocProvider.of<InquiryCubit>(context)
                                  .updatingInquiry(   token:
                                          BlocProvider.of<LoginCubit>(context)
                                              .token,
                                      projectId:
                                          BlocProvider.of<LoginCubit>(context)
                                              .projectId,
                                      activityId:
                                          BlocProvider.of<LoginCubit>(context)
                                              .activityId,
                                      itemId: widget.itemId,
                                      descriptionOf: _descript.text,
                                      providerId: choose,
                                      estelamDateFor: fromDate.text,
                                      estelamAmount: _amount.text);
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
            ))
      ],
    );
  }
}

//************************************************* */
class Inquiry extends StatefulWidget {
  @override
  _InquiryState createState() => _InquiryState();
}

class _InquiryState extends State<Inquiry> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<InquiryCubit>(context).gettingInquiry(   token:
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
        title: Text("استعلام"),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            await showDialog(
              context: context,
              useRootNavigator: false,
              builder: (_) {
                return BlocProvider.value(
                    value: context.read<InquiryCubit>(),
                    child: InquiryDialog(addOrupdate: false));
              },
            );
          },
          label: Text("اضافه کردن"),
          icon: Icon(Icons.add)),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: width * 0.01, vertical: height * 0.05),
        child: Column(
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
            BlocListener<InquiryCubit, InquiryState>(
              listener: (context, state) {
                if (state is FailedAddingInquiry) {
                  Scaffold.of(context)
                    ..removeCurrentSnackBar()
                    ..showSnackBar(SnackBar(content: Text("مشکلی پیش آمده")));
                }
                if (state is FailedUpdatingInquiry) {
                  Scaffold.of(context)
                    ..removeCurrentSnackBar()
                    ..showSnackBar(SnackBar(content: Text("مشکلی پیش آمده")));
                }
                if (state is AddedInquiry) {
                  if (state.success == false) {
                    Scaffold.of(context)
                      ..removeCurrentSnackBar()
                      ..showSnackBar(SnackBar(
                          content: Text("متاسفانه استعلام اضافه نشد")));
                  } else {
                    Scaffold.of(context)
                      ..removeCurrentSnackBar()
                      ..showSnackBar(SnackBar(
                          content: Text("استعلام با موفقیت اضافه شد")));
                  }
                }
                if (state is UpdatedInquiry) {
                  if (state.success == false) {
                    Scaffold.of(context)
                      ..removeCurrentSnackBar()
                      ..showSnackBar(
                          SnackBar(content: Text("متاسفانه بروز نشد")));
                  } else {
                    Scaffold.of(context)
                      ..removeCurrentSnackBar()
                      ..showSnackBar(SnackBar(content: Text(" بروز شد")));
                  }
                }
                if (state is DeletedInquiry) {
                  if (state.success == false) {
                    Scaffold.of(context)
                      ..removeCurrentSnackBar()
                      ..showSnackBar(
                          SnackBar(content: Text("متاسفانه  اضافه نشد")));
                  } else {
                    Scaffold.of(context)
                      ..removeCurrentSnackBar()
                      ..showSnackBar(
                          SnackBar(content: Text("با موفقیت اضافه شد")));
                  }
                }
              },
              child: Container(),
            ),
            BlocBuilder<InquiryCubit, InquiryState>(
              builder: (context, state) {
                if (state is LoadingInquiry) {
                  return Center(child: CircularProgressIndicator());
                }
                if (state is LoadedInquiry) {
                  if (state.inquiries['data'] == null) {
                    return Center(child: Text("چیزی برای نمایش وجود ندارد"));
                  } else {
                    return Expanded(
                      child: ListView.separated(
                          separatorBuilder: (context, index) => Divider(),
                          itemCount: (state.inquiries['data'] as List).length,
                          itemBuilder: (context, index) {
                            return Container(
                              height: height * 0.5,
                              decoration: containerShadow,
                              margin: EdgeInsets.symmetric(
                                  horizontal: width * 0.05,
                                  vertical: height * 0.05),
                              padding: EdgeInsets.symmetric(
                                  horizontal: width * 0.05,
                                  vertical: height * 0.02),
                              child: Directionality(
                                textDirection: TextDirection.rtl,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
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
                                              "${state.inquiries['data'][index]['provider']} مبلغ:${state.inquiries['data'][index]['amount']}",
                                            ),
                                          ),
                                          Divider(),
                                          Expanded(
                                            child: ConstrainedBox(
                                              constraints: BoxConstraints(
                                                  maxWidth: width * 0.15),
                                              child: Text(
                                                state.inquiries['data'][index]
                                                        ['description']
                                                    .toString(),
                                                maxLines: 5,
                                                textDirection:
                                                    TextDirection.rtl,
                                              ),
                                            ),
                                          ),
                                          Divider(),
                                          state.inquiries['data'][index]
                                                      ['confirms'] ==
                                                  null
                                              ? Text("تاییدی وجود ندارد")
                                              : SingleChildScrollView(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  child: Row(
                                                    children:
                                                        (state.inquiries['data']
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
                                                                        width:
                                                                            7)
                                                                  ],
                                                                ))
                                                            .toList(),
                                                  ),
                                                )
                                        ],
                                      ),
                                    ),
                                    VerticalDivider(
                                      endIndent: 65,
                                    ),
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
                                                            await BlocProvider
                                                                    .of<InquiryCubit>(
                                                                        context)
                                                                .deletingInquiry(   token:
                                          BlocProvider.of<LoginCubit>(context)
                                              .token,
                                      projectId:
                                          BlocProvider.of<LoginCubit>(context)
                                              .projectId,
                                      activityId:
                                          BlocProvider.of<LoginCubit>(context)
                                              .activityId,
                                                                    itemId: state.inquiries['data']
                                                                            [
                                                                            index]
                                                                        ['id']);
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
                                              builder: (_) {
                                                return BlocProvider.value(
                                                  value: context
                                                      .read<InquiryCubit>(),
                                                  child: InquiryDialog(
                                                    addOrupdate: true,
                                                    itemId:
                                                        state.inquiries['data']
                                                            [index]['id'],
                                                    description: state
                                                            .inquiries['data']
                                                        [index]['description'],
                                                    date:
                                                        state.inquiries['data']
                                                            [index]['date'],
                                                    amount:
                                                        state.inquiries['data']
                                                            [index]['amount'],
                                                  ),
                                                );
                                              },
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
                if (state is FailedLoadingInquiry) {
                  return Text("مشکلی هست");
                }
                return Text("چیزی برای نمایش وجود ندارد");
              },
            )
          ],
        ),
      ),
    );
  }
}

_textFields(double height, double width,
    {TextEditingController controller,
    String hintText,
    TextInputType keyboardType = TextInputType.multiline}) {
  return Container(
    margin: EdgeInsets.all(width * 0.02),
    padding: EdgeInsets.only(right: width * 0.02),
    height: height,
    child: Directionality(
      textDirection: TextDirection.rtl,
      child: TextField(
        controller: controller,
        textDirection: TextDirection.rtl,
        keyboardType: keyboardType,
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
