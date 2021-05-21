import 'package:civil_project/logic/alarms_cubit/alarms_cubit.dart';
import 'package:civil_project/logic/login_cubit/login_cubit.dart';
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
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Dialog(
      child: SingleChildScrollView(
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
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _loadMoreData();
      }
    });
    BlocProvider.of<AlarmsCubit>(context).getAlarms(
        token: BlocProvider.of<LoginCubit>(context).token,
        projectId: BlocProvider.of<LoginCubit>(context).projectId,
        isRead: -1,
        frm: 0,
        cnt: 10);
    super.initState();
  }

  _loadMoreData() async {
    _currentMax += 10;
    await BlocProvider.of<AlarmsCubit>(context).getAlarms(
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
      body: Padding(
          padding: EdgeInsets.symmetric(
              vertical: height * 0.05, horizontal: width * 0.1),
          child: BlocBuilder<AlarmsCubit, AlarmsState>(
            builder: (context, state) {
              if (state is LoadingAlarms) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (state is LoadedAlarms) {
                if (state.alarms["data"]["items"] == null) {
                  return Text("چیزی برای نمیشا وجود ندارد");
                }
                if (state.alarms["data"]["items"].length == 0) {
                  return Text("چیزی برای نمیشا وجود ندارد");
                }
                return ListView.separated(
                    controller: _scrollController,
                    itemBuilder: (context, index) {
                      if (BlocProvider.of<AlarmsCubit>(context)
                              .alarms['data']["items"]
                              .length ==
                          index + 1) {
                        return Center(child: CircularProgressIndicator());
                      }
                      return Card(
                        child: GestureDetector(
                          onTap: () => showDialog(
                            context: context,
                            builder: (_) {
                              return BlocProvider.value(
                                  child: AlarmDialog(
                                    resourceTitle:
                                        BlocProvider.of<AlarmsCubit>(context)
                                                    .alarms['data']["items"]
                                                [index]["resource_title"] ??
                                            "",
                                    activityTitle:
                                        BlocProvider.of<AlarmsCubit>(context)
                                                    .alarms['data']["items"]
                                                [index]["resource_title"] ??
                                            "",
                                    total: BlocProvider.of<AlarmsCubit>(context)
                                            .alarms['data']["items"][index]
                                                ["total"]
                                            .toString() ??
                                        1,
                                    id: BlocProvider.of<AlarmsCubit>(context)
                                                .alarms['data']["items"][index]
                                            ["itemId"] ??
                                        "",
                                  ),
                                  value: context.read<AlarmsCubit>());
                            },
                          ),
                          child: ListTile(
                            title: Text(BlocProvider.of<AlarmsCubit>(context)
                                .alarms["data"]["items"][index]
                                    ["resource_title"]
                                .toString()),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => Divider(),
                    itemCount: BlocProvider.of<AlarmsCubit>(context)
                        .alarms["data"]["items"]
                        .length);
              }
              return Center(child: Text("چیزی برای نمایش وجود ندارد"));
            },
          )),
    );
  }
}
