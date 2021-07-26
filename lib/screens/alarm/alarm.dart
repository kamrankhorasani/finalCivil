import 'package:civil_project/logic/alarms_cubit/alarms_cubit.dart';
import 'package:civil_project/logic/login_cubit/login_cubit.dart';
import 'package:civil_project/widgets/toJalali.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AlarmDialog extends StatefulWidget {
  final String activityTitle;
  final String resourceTitle;
  final String total;

  final int id;

  const AlarmDialog({
    Key key,
    this.id,
    this.activityTitle,
    this.resourceTitle,
    this.total,
  }) : super(key: key);
  @override
  _AlarmDialogState createState() => _AlarmDialogState();
}

class _AlarmDialogState extends State<AlarmDialog> {
  @override
  void initState() {
    BlocProvider.of<AlarmsCubit>(context).setOffAlarm(
        token: BlocProvider.of<LoginCubit>(context).token, itemId: widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return SimpleDialog(
      children: [
        SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: width * 0.2),
            child: Column(
              children: [
                Text(widget.resourceTitle ?? ""),
                Text(widget.activityTitle ?? ""),
                Divider(),
                Text(widget.total.toString() + ":مجموع" ?? ""),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class AlarmScreen extends StatefulWidget {
  @override
  _AlarmScreenState createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {
  final ScrollController _scrollController = ScrollController();
  int _currentMax = 0;
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    BlocProvider.of<AlarmsCubit>(context).getAlarms(
        token: BlocProvider.of<LoginCubit>(context).token,
        projectId: BlocProvider.of<LoginCubit>(context).projectId,
        isRead: -1,
        frm: 0,
        cnt: 10);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _loadMoreData();
      }
    });
  }

  _loadMoreData() async {
    _currentMax += 10;
    await BlocProvider.of<AlarmsCubit>(context).getMoreAlarms(
        token: BlocProvider.of<LoginCubit>(context).token,
        projectId: BlocProvider.of<LoginCubit>(context).projectId,
        isRead: -1,
        frm: _currentMax,
        cnt: 10);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: BlocListener<AlarmsCubit, AlarmsState>(
        listener: (context, state) {
          if (state is SettedAlarmOff) {
            if (state.success == true) {
              Scaffold.of(context)
                ..removeCurrentSnackBar()
                ..showSnackBar(
                    SnackBar(content: Text("با موفقیت غیر فعال شد")));
            } else {
              Scaffold.of(context)
                ..removeCurrentSnackBar()
                ..showSnackBar(
                    SnackBar(content: Text("متاسفانه غیر فعال نشد")));
            }
          }
        },
        child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: height * 0.05, horizontal: width * 0.1),
            child: BlocBuilder<AlarmsCubit, AlarmsState>(
              builder: (context, state) {
                if (state is LoadingAlarms) {
                  return Center(child: CircularProgressIndicator());
                }

                if (state is LoadedAlarms) {
                  if (state.alarms == null || state.alarms.length == 0) {
                    return Center(child: Text("چیزی برای نمایش وجود ندارد"));
                  }
                  return ListView.separated(
                      controller: _scrollController,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        if (state.alarms.length == index) {
                          return Center(child: CircularProgressIndicator());
                        }
                        return Card(
                          child: ListTile(
                            isThreeLine: true,
                            title: Column(
                              textDirection: TextDirection.rtl,
                              children: [
                                Text(
                                    state.alarms[index]["resource_title"] ?? "",
                                    textAlign: TextAlign.right),
                                Row(
                                  textDirection: TextDirection.rtl,
                                  children: [
                                    Flexible(
                                                                          child: Text(
                                          "${state.alarms[index]["jitter"]??0}:مقدار انحراف",
                                          textAlign: TextAlign.right),
                                    ),
                                    SizedBox(width: width * 0.07),
                                    state.alarms[index]["type"] == "NEED"
                                        ? Text(
                                            "${converttoJalali(state.alarms[index]["date_for"])}:تاریخ",
                                            textAlign: TextAlign.right)
                                        : Container()
                                  ],
                                )
                              ],
                            ),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                state.alarms[index]["type"] == "NEED"
                                    ? Icon(Icons.error, color: Colors.red)
                                    : Icon(Icons.warning_amber_sharp,
                                        color: Colors.yellow),
                                GestureDetector(
                                  onTap: () async {
                                    await BlocProvider.of<AlarmsCubit>(context)
                                        .setOffAlarm(
                                            token: BlocProvider.of<LoginCubit>(
                                                    context)
                                                .token,
                                            projectId:
                                                BlocProvider.of<LoginCubit>(
                                                        context)
                                                    .projectId,
                                            itemId: state.alarms[index]
                                                ["itemId"]);
                                    (state.alarms as List).removeAt(index);
                                  },
                                  child: Container(
                                    child: Text(
                                      "OFF",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius: BorderRadius.circular(5)),
                                  ),
                                )
                              ],
                            ),
                            subtitle: Row(
                              textDirection: TextDirection.rtl,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                    state.alarms[index]["activity_title"] ?? "",
                                    textAlign: TextAlign.right),
                                state.alarms[index]["type"] == "NEED"
                                    ? Container()
                                    : Text(
                                        "${converttoJalali(state.alarms[index]["dateIn"].toString().substring(0, 9))}",
                                        textAlign: TextAlign.right,
                                        )
                              ],
                            ),
                            //subtitle: Text(data),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => Divider(),
                      itemCount: state.alarms.length);
                }
                return Container();
              },
            )),
      ),
    );
  }
}
