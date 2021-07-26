import 'package:civil_project/civil_icons.dart';
import 'package:civil_project/constants/constantdecorations.dart';
import 'package:civil_project/logic/alarms_cubit/alarms_cubit.dart';
import 'package:civil_project/logic/configur_cubit/configur_cubit.dart';
import 'package:civil_project/logic/login_cubit/login_cubit.dart';
import 'package:civil_project/logic/mainscreen_cubit/mainscreen_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persian_datepicker/jalaali_js.dart';
import 'package:persian_datepicker/persian_datepicker.dart';
import 'package:tree_view/tree_view.dart';

bool isSelectted = false;
int globalChoiceActivityId;
TextEditingController globalDateController =
    TextEditingController(text: Jalaali.now().toString());

class HomeItems extends StatefulWidget {
  static const List<List> titleText = [
    ["مصالح مصرفی", "/materials", Civil.crane],
    ["ماشین آلات مصرفی", "/machinary", Civil.crane1],
    ["کارکرد نیروها", '/workrole', Civil.engineer],
    ["پیشرفت فعالیتها", "/activity", Civil.worker],
    ["دستورکار", '/program', Civil.graphic_design],
    ["تصویر و فیلم", '/media', Civil.monitor],
    ["حوادث", '/accident', Civil.brickwall],
    ["چک لیستها", '/checklist', Civil.engineer2],
    ["پرمیت", '/permit', Civil.blueprint2],
    //*Added to Drawer-------["بازدیدها", '/inspection', Civil.excavator],
    //*Added to Drawer-------["آب و هوا", '/weather', Civil.wrench],
    //*Added to Drawer-------["جلسات", '/session', Civil.house2],
    //["پیمانکاران جزء", "/subcontractor", Civil.engineer1]
    //["اجاره", "/rent", Civil.house],
    //["استعلام", "/inquiry", Civil.blueprint2],
  ];

  @override
  _HomeItemsState createState() => _HomeItemsState();
}

class _HomeItemsState extends State<HomeItems> {
  PersianDatePickerWidget _datePicker;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<LoginCubit>(context).loadToken();
    _datePicker = PersianDatePicker(
      controller: globalDateController,
      datetime: Jalaali.now().toString(),
      fontFamily: 'Vazir',
      farsiDigits: true,
      onChange: (oldText, newText) => Navigator.pop(context),
    ).init();

    BlocProvider.of<MainscreenCubit>(context).getWbs(
      token: BlocProvider.of<LoginCubit>(context).token,
      projectId: BlocProvider.of<LoginCubit>(context).wbsId,
    );
    BlocProvider.of<AlarmsCubit>(context).getAlarms(
        token: BlocProvider.of<LoginCubit>(context).token,
        projectId: BlocProvider.of<LoginCubit>(context).projectId,
        isRead: 0,
        frm: 0,
        cnt: 10);
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    final width = queryData.size.width;
    final height = queryData.size.height;
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.notifications,
                      size: height * 0.05,
                    ),
                    onPressed: () {
                      showMenu(
                          useRootNavigator: true,
                          context: context,
                          position: RelativeRect.fromLTRB(100, 100, 100, 100),
                          color: Colors.grey[600],
                          items: [
                            PopupMenuItem(
                              child: ListTile(
                                isThreeLine: true,
                                title: Column(
                                  children: [
                                    Text(BlocProvider.of<AlarmsCubit>(context)
                                                .alarms['data']["items"][0]
                                            ["resource_title"] ??
                                        ""),
                                    Row(
                                      textDirection: TextDirection.rtl,
                                      children: [
                                        BlocProvider.of<AlarmsCubit>(context)
                                                        .alarms['data']["items"]
                                                    [0]["type"] ==
                                                "NEED"
                                            ? Expanded(
                                                flex: 1,
                                                child: Text(":مقدارنیاز"))
                                            : Text(":مجاز"),
                                        Expanded(
                                          flex: 2,
                                          child: Text(
                                              "${BlocProvider.of<AlarmsCubit>(context).alarms['data']["items"][0]["total"]}"),
                                        )
                                      ],
                                    ),
                                    Row(
                                      textDirection: TextDirection.rtl,
                                      children: [
                                        BlocProvider.of<AlarmsCubit>(context)
                                                        .alarms['data']["items"]
                                                    [0]["type"] ==
                                                "NEED"
                                            ? Text(":تاریخ")
                                            : Text(":انحراف"),
                                        BlocProvider.of<AlarmsCubit>(context)
                                                        .alarms['data']["items"]
                                                    [1]["type"] ==
                                                "NEED"
                                            ? Text(
                                                "${BlocProvider.of<AlarmsCubit>(context).alarms['data']["items"][0]["date_for"]}")
                                            : Text(
                                                "${BlocProvider.of<AlarmsCubit>(context).alarms['data']["items"][0]["jitter"]}")
                                      ],
                                    )
                                  ],
                                ),
                                trailing: BlocProvider.of<AlarmsCubit>(context)
                                                .alarms['data']["items"][0]
                                            ["type"] ==
                                        "NEED"
                                    ? Icon(Icons.error, color: Colors.red)
                                    : Icon(Icons.warning_amber_sharp),
                                subtitle: Text(
                                    BlocProvider.of<AlarmsCubit>(context)
                                                .alarms['data']["items"][0]
                                            ["activity_title"] ??
                                        ""),
                              ),
                            ),
                            PopupMenuItem(
                              child: ListTile(
                                isThreeLine: true,
                                title: Column(
                                  children: [
                                    Text(BlocProvider.of<AlarmsCubit>(context)
                                                .alarms['data']["items"][1]
                                            ["resource_title"] ??
                                        ""),
                                    Row(
                                      textDirection: TextDirection.rtl,
                                      children: [
                                        BlocProvider.of<AlarmsCubit>(context)
                                                        .alarms['data']["items"]
                                                    [1]["type"] ==
                                                "NEED"
                                            ? Expanded(
                                                flex: 1,
                                                child: Text(":مقدارنیاز"))
                                            : Text(":مجاز"),
                                        Expanded(
                                          flex: 2,
                                          child: Text(
                                              "${BlocProvider.of<AlarmsCubit>(context).alarms['data']["items"][1]["total"]}"),
                                        )
                                      ],
                                    ),
                                    Row(
                                      textDirection: TextDirection.rtl,
                                      children: [
                                        BlocProvider.of<AlarmsCubit>(context)
                                                        .alarms['data']["items"]
                                                    [1]["type"] ==
                                                "NEED"
                                            ? Text(":تاریخ")
                                            : Text(":انحراف"),
                                        BlocProvider.of<AlarmsCubit>(context)
                                                        .alarms['data']["items"]
                                                    [1]["type"] ==
                                                "NEED"
                                            ? Text(
                                                "${BlocProvider.of<AlarmsCubit>(context).alarms['data']["items"][1]["date_for"]}")
                                            : Text(
                                                "${BlocProvider.of<AlarmsCubit>(context).alarms['data']["items"][1]["jitter"]}")
                                      ],
                                    )
                                  ],
                                ),
                                trailing: BlocProvider.of<AlarmsCubit>(context)
                                                .alarms['data']["items"][1]
                                            ["type"] ==
                                        "NEED"
                                    ? Icon(Icons.error, color: Colors.red)
                                    : Icon(Icons.warning_amber_sharp),
                                subtitle: Text(
                                    BlocProvider.of<AlarmsCubit>(context)
                                                .alarms['data']["items"][1]
                                            ["activity_title"] ??
                                        ""),
                              ),
                            ),
                            PopupMenuItem(
                                child: Center(
                              child: GestureDetector(
                                  onTap: () => Navigator.pushNamed(context, "/alarm")
                                      .then((value) async => await BlocProvider
                                              .of<AlarmsCubit>(context)
                                          .getAlarms(
                                              token:
                                                  BlocProvider.of<LoginCubit>(
                                                          context)
                                                      .token,
                                              projectId:
                                                  BlocProvider.of<LoginCubit>(
                                                          context)
                                                      .projectId,
                                              isRead: 0,
                                              frm: 0,
                                              cnt: 10)),
                                  child: Text("نمایش همه")),
                            ))
                          ]);
                    },
                  ),
                  Positioned(
                    top: 12.0,
                    right: 7.0,
                    height: 15,
                    child: CircleAvatar(
                      backgroundColor: Colors.black,
                      child: Center(
                        child: BlocBuilder<AlarmsCubit, AlarmsState>(
                          builder: (context, state) {
                            if (state is LoadedAlarms) {
                              return Padding(
                                padding: EdgeInsets.symmetric(vertical: 0.05),
                                child: Text(
                                  BlocProvider.of<AlarmsCubit>(context)
                                      .alarms['data']["itemCount"],
                                  style: TextStyle(fontSize: 10),
                                ),
                              );
                            }
                            return Text("");
                          },
                        ),
                      ),
                      // decoration: BoxDecoration(
                      //     shape: BoxShape.circle, color: Colors.black),
                    ),
                  )
                ],
              ),
              SizedBox(width: 35),
              Expanded(
                  child: Text(
                'سیویلیتو',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              )),
            ],
          ),
          leading: Builder(
              builder: (context) => GestureDetector(
                  onTap: () => Scaffold.of(context).openDrawer(),
                  child: Center(
                      child: Text(
                    "WBS",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  )))),
        ),
        endDrawer: Drawer(
          child: ListView(
            children: [
              DrawerHeader(
                  child: Center(
                      child: Text("پروژه عمرانی",
                          style: TextStyle(fontSize: width * 0.1)))),
              Card(
                child: ListTile(
                  title: Text(
                    "پروژه های من",
                    textAlign: TextAlign.right,
                  ),
                  leading: Icon(Civil.crane),
                  onTap: () => Navigator.pushNamed(context, '/homescreen'),
                ),
              ),
              Card(
                child: ListTile(
                  title: Text("جلسات", textAlign: TextAlign.right),
                  leading: Icon(Civil.house2),
                  onTap: () => Navigator.pushNamed(context, '/session'),
                ),
              ),
              Card(
                child: ListTile(
                  title: Text("آب و هوا", textAlign: TextAlign.right),
                  leading: Icon(Civil.wrench),
                  onTap: () => Navigator.pushNamed(context, '/weather'),
                ),
              ),
              Card(
                child: ListTile(
                  title: Text("بازدیدها", textAlign: TextAlign.right),
                  leading: Icon(Civil.excavator),
                  onTap: () => Navigator.pushNamed(context, '/inspection'),
                ),
              ),
            ],
          ),
        ),
        drawer: Drawer(
          child: BlocBuilder<MainscreenCubit, MainscreenState>(
            builder: (context, state) {
              if (state is WBSLoading) {
                return Center(child: CircularProgressIndicator());
              }
              if (state is WBSLoaded) {
                print(globalDateController.text);
                return Center(
                  child: TreeView(
                    parentList: state.wbs,
                  ),
                );
              }
              return Text("مشکلی هست");
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: height * 0.15,
                width: width,
                child: Center(
                  child: BlocBuilder<MainscreenCubit, MainscreenState>(
                    builder: (context, state) {
                      if (state is WBSLoaded) {
                        if (state.users['data'] == null ||
                            state.users['success'] == false) {
                          return Text("چیزی برای نمایش وجود ندارد");
                        }
                        BlocProvider.of<ConfigurCubit>(context).users =
                            state.users['data'];
                        return Container(
                          margin: EdgeInsets.only(left: 15),
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            separatorBuilder: (context, index) =>
                                SizedBox(width: 8),
                            itemCount: (state.users['data'] as List).length,
                            itemBuilder: (context, index) => Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    if (globalChoiceActivityId != null) {
                                      setState(() {
                                        BlocProvider.of<ConfigurCubit>(context)
                                                .itemId =
                                            state.users['data'][index]['id'];
                                      });
                                      Navigator.pushNamed(
                                          context, "/addcartable");
                                    } else {
                                      await showDialog(
                                          context: context,
                                          builder: (ctx) {
                                            return AlertDialog(
                                              title: Text(
                                                "لطفا برای ادامه کار یک فعالیت انتخاب کنید",
                                                textDirection:
                                                    TextDirection.rtl,
                                              ),
                                              actions: [
                                                TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(context),
                                                    child: Text(
                                                      "باشه",
                                                      textDirection:
                                                          TextDirection.rtl,
                                                    ))
                                              ],
                                            );
                                          });
                                    }
                                  },
                                  child: CircleAvatar(
                                    minRadius: 30,
                                    backgroundColor: Colors.grey,
                                    onBackgroundImageError:
                                        (exception, stackTrace) => print(""),
                                    backgroundImage: NetworkImage(state
                                        .users['data'][index]['pic']
                                        .toString()),
                                  ),
                                ),
                                Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                          "${state.users['data'][index]['firstName']} "),
                                      Text(
                                          "${state.users['data'][index]['lastName']} ")
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      }
                      return Container();
                    },
                  ),
                ),
              ),
              Divider(color: Colors.black87),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  textDirection: TextDirection.rtl,
                  children: [
                    Builder(
                      builder: (context) => GestureDetector(
                          onTap: () => Scaffold.of(context).openDrawer(),
                          child: Text(":فعالیت")),
                    ),
                    Expanded(
                      child: Builder(
                        builder: (context) => GestureDetector(
                          onTap: () => Scaffold.of(context).openDrawer(),
                          child: Container(
                              height: height * 0.05,
                              decoration: containerShadow.copyWith(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.white,
                                    spreadRadius: 0,
                                    blurRadius: 0,
                                    offset: Offset(
                                        0, 0), // changes position of shadow
                                  ),
                                ],
                              ),
                              margin: EdgeInsets.symmetric(horizontal: 5),
                              child: Center(child:
                                  BlocBuilder<ConfigurCubit, ConfigurState>(
                                builder: (context, state) {
                                  if (state is ConfigurInitial) {
                                    return Text(state.actitle);
                                  }
                                  return Text('');
                                },
                              ))),
                        ),
                      ),
                    ),
                    Text(" :تاریخ"),
                    Expanded(
                      child: Container(
                        decoration: containerShadow.copyWith(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white,
                              spreadRadius: 0,
                              blurRadius: 0,
                              offset:
                                  Offset(0, 0), // changes position of shadow
                            ),
                          ],
                        ),
                        height: height * 0.05,
                        child: Center(
                          child: TextField(
                              textAlign: TextAlign.center,
                              decoration:
                                  InputDecoration.collapsed(hintText: ""),
                              enableInteractiveSelection: false,
                              // *** this is important to prevent user interactive selection ***
                              onTap: () {
                                FocusScope.of(context).requestFocus(
                                    FocusNode()); // *** to prevent opening default keyboard
                                showModalBottomSheet(
                                    isScrollControlled: false,
                                    context: context,
                                    builder: (BuildContext context) {
                                      return _datePicker;
                                    });
                              },
                              controller: globalDateController),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(color: Colors.black87),
              GridView.builder(
                padding: EdgeInsets.all(10),
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 5.0,
                  mainAxisSpacing: 5.0,
                ),
                itemCount: HomeItems.titleText.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () async {
                      if (globalChoiceActivityId != null) {
                        Navigator.pushNamed(
                            context, HomeItems.titleText[index][1]);
                      } else {
                        await showDialog(
                            context: context,
                            builder: (ctx) {
                              return AlertDialog(
                                title: Text(
                                  "لطفا برای ادامه کار یک فعالیت انتخاب کنید",
                                  textDirection: TextDirection.rtl,
                                ),
                                actions: [
                                  TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text(
                                        "باشه",
                                        textDirection: TextDirection.rtl,
                                      ))
                                ],
                              );
                            });
                      }
                    },
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.amber,
                          child: Center(
                              child: Icon(HomeItems.titleText[index][2],
                                  size: 35, color: Colors.black)),
                        ),
                        Text(
                          HomeItems.titleText[index][0],
                          style: TextStyle(fontSize: 12, color: Colors.white),
                        )
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ));
  }
}
