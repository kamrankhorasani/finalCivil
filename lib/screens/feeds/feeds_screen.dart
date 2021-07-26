import 'package:civil_project/constants/constantdecorations.dart';
import 'package:civil_project/logic/feed_cubit/feed_cubit.dart';
import 'package:civil_project/logic/login_cubit/login_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persian_datepicker/persian_datepicker.dart';

import '../../civil_icons.dart';

class FeedScreen extends StatefulWidget {
  static const List<List> titleText = [
    ["تصویر و فیلم", "media", Civil.monitor],
    ["کارکرد نیروها", 'worker', Civil.engineer],
    ["مصالح مصرفی", "masaleh", Civil.crane],
    ["ماشین آلات مصرفی", "tajhizat", Civil.crane1],
    ["فعالیتها", "works", Civil.blueprint3],
    ["دستورکار", 'order', Civil.graphic_design],
    ["بازدیدها", 'bazdid', Civil.excavator],
    ["اجاره", "rent", Civil.house],
    ["استعلام", "estelam", Civil.blueprint2],
    ["حوادث", 'event', Civil.brickwall],
    ["آب و هوا", 'weather', Civil.wrench],
    ["پرمیت", 'permit', Civil.blueprint2],
    ["جلسات", 'session', Civil.house2],
    ["قرارداد", "contractor", Civil.engineer1],
    ["انبار خروجی", "anbar_out", Civil.house],
    ["هزینه", "cost", Civil.helmet],
    ["مالی ورودی", "mali_in", Civil.tools],
    ["مالی خروجی", "mali_out", Civil.paintroller],
    ["تعدیل", "tadil", Civil.worker]
    //["صورت وضعیت", "soorat_vaziat", Civil.engineer],
  ];
  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final TextEditingController _startDate = TextEditingController();
  final TextEditingController _endDate = TextEditingController();
  PersianDatePickerWidget fromDatePicker;
  PersianDatePickerWidget toDatePicker;
  List _activities = [];
  List tempActives = [];
  String activityList = "";
  int choice;
  @override
  void initState() {
    super.initState();

    BlocProvider.of<FeedCubit>(context).getActivityList(
      token: BlocProvider.of<LoginCubit>(context).token,
      projectId: BlocProvider.of<LoginCubit>(context).projectId,
    );
    fromDatePicker = PersianDatePicker(
      controller: _startDate,
      fontFamily: 'Vazir',
      farsiDigits: true,
      onChange: (oldText, newText) {
        if (oldText != newText) {
          Navigator.pop(context);
        }
      },
    ).init();
    toDatePicker = PersianDatePicker(
      controller: _endDate,
      fontFamily: 'Vazir',
      farsiDigits: true,
      onChange: (oldText, newText) {
        if (oldText != newText) {
          Navigator.pop(context);
        }
      },
    ).init();
  }

  @override
  void dispose() {
    super.dispose();
    _startDate.dispose();
    _endDate.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text("گزاراشات", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
            horizontal: width * 0.040, vertical: height * 0.08),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          textDirection: TextDirection.rtl,
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: width * 0.05, vertical: height * 0.08),
              decoration: containerShadow,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    textDirection: TextDirection.rtl,
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: Container(
                          decoration: containerShadow,
                          child: BlocBuilder<FeedCubit, FeedState>(
                            builder: (context, state) {
                              if (state is LoadedFeedActivity) {
                                return DropdownButton(
                                    underline: Container(),
                                    hint: Text("فعالیتها"),
                                    isExpanded: true,
                                    value: choice,
                                    items:
                                        (state.activityList['data'] as List ??
                                                [])
                                            .map((e) => DropdownMenuItem(
                                                  child: Center(
                                                      child: Text(e['title'])),
                                                  value: e['id'],
                                                ))
                                            .toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        choice = value;
                                        tempActives.add(value);
                                        (state.activityList['data'] as List)
                                            .forEach((element) {
                                          if (element['id'] == value) {
                                            _activities.add(element['title']);
                                          }
                                        });
                                      });

                                      activityList =
                                          activityList + "," + value.toString();
                                    });
                              }
                              return Container();
                            },
                          ),
                        ),
                      )),
                    ],
                  ),
                  SizedBox(height: 10),
                  Wrap(
                    children: List<Widget>.generate(
                        _activities.length,
                        (index) => Chip(
                              backgroundColor: Colors.lime,
                              label: Text("${_activities[index]}"),
                              onDeleted: () {
                                setState(() {
                                  _activities.removeAt(index);
                                });
                                String temp;
                                tempActives.removeAt(index);
                                activityList = null;
                                temp = tempActives.toString();
                                activityList = temp.substring(
                                    0, temp.length-1);

                              },
                              deleteIcon: Icon(Icons.cancel),
                              deleteIconColor: Colors.red,
                            )),
                  ),
                  Container(
                    decoration: containerShadow,
                    margin: EdgeInsets.symmetric(horizontal: width * 0.12),
                    child: TextField(
                        textAlign: TextAlign.center,
                        decoration:
                            new InputDecoration.collapsed(hintText: 'از'),
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
                        controller: _startDate),
                  ),
                  SizedBox(height: 10),
                  Container(
                    decoration: containerShadow,
                    margin: EdgeInsets.symmetric(horizontal: width * 0.12),
                    child: TextField(
                        textAlign: TextAlign.center,
                        decoration:
                            new InputDecoration.collapsed(hintText: 'تا'),
                        enableInteractiveSelection:
                            false, // *** this is important to prevent user interactive selection ***
                        onTap: () {
                          FocusScope.of(context).requestFocus(
                              FocusNode()); // *** to prevent opening default keyboard
                          showModalBottomSheet(
                              isScrollControlled: true,
                              context: context,
                              builder: (BuildContext context) {
                                return toDatePicker;
                              });
                        },
                        controller: _endDate),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            SizedBox(
              width: width * 1,
              height: height * 1.2,
              child: Container(
                decoration: containerShadow,
                child: GridView.builder(
                  itemCount: FeedScreen.titleText.length,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 5.0,
                    mainAxisSpacing: 5.0,
                  ),
                  itemBuilder: (context, index) => GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, "/feeddetail", arguments: {
                        "tbl": FeedScreen.titleText[index][1],
                        "activityList": activityList.substring(1,activityList.length),
                        "fromDate": _startDate.text,
                        "toDate": _endDate.text
                      }).then((value) {
                        setState(() {
                          // _activities = [];
                          // activityList = "";
                          choice = null;
                        });
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.amber,
                          child: Center(
                              child: Icon(FeedScreen.titleText[index][2],
                                  size: 35, color: Colors.black)),
                        ),
                        Text(
                          FeedScreen.titleText[index][0],
                          style: TextStyle(fontSize: 12, color: Colors.white),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
