import 'package:civil_project/constants/constantdecorations.dart';
import 'package:civil_project/logic/login_cubit/login_cubit.dart';
import 'package:civil_project/logic/weather_cubit/weather_cubit.dart';
import 'package:civil_project/models/weatherModel.dart';
import 'package:civil_project/screens/homee/home_items.dart';
import 'package:civil_project/widgets/boxes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WeatherDialog extends StatefulWidget {
  final String degree;
  final String fTime;
  final String choose;
  final int itemId;
  final bool addOrupdate;

  WeatherDialog(
      {this.degree, this.fTime, this.choose, this.itemId, this.addOrupdate});
  @override
  _WeatherDialogState createState() => _WeatherDialogState();
}

class _WeatherDialogState extends State<WeatherDialog> {
  static List<WeatherModel> weatherTypes = [
    WeatherModel("ابری", "Cloudy", "assets/images/cloudy.png"),
    WeatherModel("کاملا ابری", "Overcast", "assets/images/overcast.png"),
    WeatherModel("آفتابی", "Sunny", "assets/images/sunny.png"),
    WeatherModel("نیمه ابری", "partially cloudy", "assets/images/partly.png"),
    WeatherModel("بارانی", "Rain", "assets/images/rain.png"),
    WeatherModel("نم نم", "Drizzle", "assets/images/drizzle.png"),
    WeatherModel("برفی", "Snow", "assets/images/snow.png"),
    WeatherModel("طوفانی", "Stormy", "assets/images/stormy.png")
  ];
  final TextEditingController _degree = TextEditingController();
  String fromTime;
  String choosenType;
  TimeOfDay _selectedTime;
  Future<void> _selectTime(BuildContext context) async {
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
        fromTime = '${_selectedTime.hour}:${_selectedTime.minute}';
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _degree.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (widget.addOrupdate == true) {
      _degree.text = widget.degree;
      choosenType = widget.choose;
      fromTime = widget.fTime;
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                textDirection: TextDirection.rtl,
                children: [
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: Column(
                      textDirection: TextDirection.rtl,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        BlocListener<WeatherCubit, WeatherState>(
                          listener: (context, state) {
                            if (state is AddedWeather) {
                              _degree.clear();
                              setState(() {
                                fromTime = null;
                                choosenType = null;
                              });
                              Navigator.pop(context);
                            }
                            if (state is UpdatedWeather) {
                              _degree.clear();
                              setState(() {
                                fromTime = null;
                                choosenType = null;
                              });
                              Navigator.pop(context);
                            }
                          },
                          child: Container(),
                        ),
                        SizedBox(
                          height: height * 0.2,
                          child: ListWheelScrollView(
                              onSelectedItemChanged: (value) {
                                setState(() {
                                  choosenType = weatherTypes[value].type;
                                });
                              },
                              itemExtent: height * 0.2,
                              children: weatherTypes
                                  .map((e) => Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(e.address),
                                          Text(e.name)
                                        ],
                                      ))
                                  .toList()),
                        ),
                        _textFields(height * 0.08, width,
                            hintText: "دما",
                            controller: _degree,
                            type:
                                TextInputType.numberWithOptions(decimal: true)),
                        GestureDetector(
                          onTap: () async => await _selectTime(context),
                          child: Container(
                            height: height * 0.07,
                            decoration: containerShadow,
                            margin: EdgeInsets.symmetric(
                                horizontal: width * 0.1,
                                vertical: height * 0.01),
                            padding: EdgeInsets.symmetric(
                                horizontal: width * 0.03,
                                vertical: height * 0.010),
                            child: Center(child: Text(fromTime ?? "زمان")),
                          ),
                        ),
                      ],
                    ),
                  ),
                  BlocBuilder<WeatherCubit, WeatherState>(
                    builder: (context, state) {
                      if (state is AddingWeahter) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (state is UpdatingWeather) {
                        return Center(child: CircularProgressIndicator());
                      } else {
                        return Container(
                          height: height * 0.08,
                          margin: EdgeInsets.symmetric(
                              horizontal: width * 0.01,
                              vertical: height * 0.05),
                          child: RaisedButton(
                            onPressed: () async {
                              if (widget.addOrupdate == false) {
                                await BlocProvider.of<WeatherCubit>(context)
                                    .addingWeather(   token:
                                          BlocProvider.of<LoginCubit>(context)
                                              .token,
                                      projectId:
                                          BlocProvider.of<LoginCubit>(context)
                                              .projectId,
                                      activityId:
                                          BlocProvider.of<LoginCubit>(context)
                                              .activityId,
                                        weatherType: choosenType,
                                        degreeOf: _degree.text,
                                        timeDay: fromTime);
                              }
                              if (widget.addOrupdate == true) {
                                await BlocProvider.of<WeatherCubit>(context)
                                    .updatingWeather(   token:
                                          BlocProvider.of<LoginCubit>(context)
                                              .token,
                                      projectId:
                                          BlocProvider.of<LoginCubit>(context)
                                              .projectId,
                                      activityId:
                                          BlocProvider.of<LoginCubit>(context)
                                              .activityId,
                                        itemId: widget.itemId,
                                        degreeOf: _degree.text,
                                        timeDay: fromTime,
                                        weatherType: choosenType);
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
            ))
      ],
    );
  }
}

class Weather extends StatefulWidget {
  @override
  _WeatherState createState() => _WeatherState();
}

class _WeatherState extends State<Weather> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<WeatherCubit>(context).gettingWeather(   token:
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
        title: Text("آب و هوا"),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            await showDialog(
              context: context,
              builder: (_) {
                return BlocProvider.value(
                    value: context.read<WeatherCubit>(),
                    child: WeatherDialog(
                      addOrupdate: false,
                    ));
              },
            );
          },
          label: Text("اضافه کردن"),
          icon: Icon(Icons.add)),
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
          BlocListener<WeatherCubit, WeatherState>(
            listener: (context, state) {
              if (state is FailedAddingWeather) {
                Scaffold.of(context)
                  ..removeCurrentSnackBar(reason: SnackBarClosedReason.timeout)
                  ..showSnackBar(SnackBar(content: Text("مشکلی پیش آمده")));
              }
              if (state is FailedUpdatingWeather) {
                Scaffold.of(context)
                  ..removeCurrentSnackBar(reason: SnackBarClosedReason.timeout)
                  ..showSnackBar(SnackBar(content: Text("مشکلی پیش آمده")));
              }
              if (state is FailedDeletingWeather) {
                Scaffold.of(context)
                  ..removeCurrentSnackBar(reason: SnackBarClosedReason.timeout)
                  ..showSnackBar(SnackBar(content: Text("مشکلی پیش آمده")));
              }
              if (state is AddedWeather) {
                if (state.success == false) {
                  Scaffold.of(context)
                    ..removeCurrentSnackBar()
                    ..showSnackBar(SnackBar(content: Text("مشکلی پیش آمده")));
                } else {
                  Scaffold.of(context)
                    ..removeCurrentSnackBar(
                        reason: SnackBarClosedReason.timeout)
                    ..showSnackBar(SnackBar(content: Text("اضافه شد")));
                }
              }
              if (state is UpdatedWeather) {
                if (state.success == false) {
                  Scaffold.of(context)
                    ..removeCurrentSnackBar()
                    ..showSnackBar(SnackBar(content: Text("مشکلی پیش آمده")));
                } else {
                  Scaffold.of(context)
                    ..removeCurrentSnackBar(
                        reason: SnackBarClosedReason.timeout)
                    ..showSnackBar(SnackBar(content: Text("بروز شد")));
                }
              }
              if (state is DeletedWeather) {
                if (state.success == false) {
                  Scaffold.of(context)
                    ..removeCurrentSnackBar()
                    ..showSnackBar(SnackBar(content: Text("مشکلی پیش آمده")));
                } else {
                  Scaffold.of(context)
                    ..removeCurrentSnackBar()
                    ..showSnackBar(SnackBar(content: Text("حذف شد")));
                }
              }
            },
            child: SizedBox(height: height * 0.04),
          ),
          BlocBuilder<WeatherCubit, WeatherState>(
            builder: (context, state) {
              if (state is LoadingWeather) {
                return Center(child: CircularProgressIndicator());
              }
              if (state is LoadedWeather) {
                if (state.weathers['data'] == null) {
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
                                        "نوع:  ${state.weathers['data'][index]['weatherType']}",
                                        overflow: TextOverflow.fade,
                                      ),
                                      Divider(),
                                      Text(
                                        "دما:  ${state.weathers['data'][index]['degree']}",
                                        maxLines: 3,
                                        textDirection: TextDirection.rtl,
                                      ),
                                      Text(
                                          "زمان: ${state.weathers['data'][index]['timeof']}"),
                                      Divider(),
                                      state.weathers['data'][index]
                                                  ['confirms'] ==
                                              null
                                          ? Text("تاییدی وجود ندارد")
                                          : SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Row(
                                                children: (state.weathers[
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
                                        await showGeneralDialog(
                                            context: context,
                                            pageBuilder: (_, __, ___) {
                                              return AlertDialog(
                                                title: Text(
                                                    "آیا از حذف مطمئن هستید؟"),
                                                actions: [
                                                  TextButton(
                                                      onPressed: () async {
                                                        Navigator.pop(context);
                                                        await BlocProvider.of<
                                                                    WeatherCubit>(
                                                                context)
                                                            .deletingWeather(   token:
                                          BlocProvider.of<LoginCubit>(context)
                                              .token,
                                      projectId:
                                          BlocProvider.of<LoginCubit>(context)
                                              .projectId,
                                      activityId:
                                          BlocProvider.of<LoginCubit>(context)
                                              .activityId,
                                                                itemId: state
                                                                            .weathers[
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
                                            value: context.read<WeatherCubit>(),
                                            child: WeatherDialog(
                                              addOrupdate: true,
                                              degree: state.weathers['data']
                                                      [index]['degree']
                                                  .toString(),
                                              fTime: state.weathers['data']
                                                  [index]['timeof'],
                                              choose: state.weathers['data']
                                                  [index]['weatherType'],
                                              itemId: state.weathers['data']
                                                  [index]['id'],
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
                      },
                      separatorBuilder: (context, index) => Divider(),
                      itemCount: state.weathers['data'].length),
                );
              }

              return Center(child: Text("چیزی برای نمایش وجود ندارد"));
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
    TextInputType type = TextInputType.multiline}) {
  return Container(
    margin: EdgeInsets.all(width * 0.02),
    padding: EdgeInsets.only(right: width * 0.02),
    height: height,
    child: Directionality(
      textDirection: TextDirection.rtl,
      child: TextField(
        controller: controller,
        textDirection: TextDirection.rtl,
        keyboardType: type,
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
