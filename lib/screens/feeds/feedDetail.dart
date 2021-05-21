import 'package:civil_project/logic/feed_cubit/feed_cubit.dart';
import 'package:civil_project/logic/login_cubit/login_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FeedDetail extends StatefulWidget {
  final String tbl;
  final String activityList;
  final String fromDate;
  final String toDate;

  const FeedDetail(
      {Key key, this.tbl, this.activityList, this.fromDate, this.toDate})
      : super(key: key);
  @override
  _FeedDetailState createState() => _FeedDetailState();
}

class _FeedDetailState extends State<FeedDetail> {
  @override
  void initState() {
    super.initState();

    BlocProvider.of<FeedCubit>(context).getFeed(
        token: BlocProvider.of<LoginCubit>(context).token,
        tbl: widget.tbl,
        activityList: widget.activityList,
        fromDate: widget.fromDate,
        toDate: widget.toDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Column(
            textDirection: TextDirection.rtl,
            children: [
              SizedBox(
                height: 25,
              ),
              BlocBuilder<FeedCubit, FeedState>(
                builder: (context, state) {
                  if (state is LoadingFeed) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (state is LoadedFeed) {
                    if (state.feeds['data'] == null ||
                        (state.feeds['data'] as List).isEmpty) {
                      return Center(
                          child: Text("چیزی برای نمایش وجود ندارد"));
                    } else {
                      return Expanded(
                                                child: InteractiveViewer(
                                                                                                  child: ListView.builder(
                            itemCount: state.feeds['data'].length,
                            itemBuilder: (context, index) {
                              return SingleChildScrollView(
                                padding: EdgeInsets.symmetric(vertical: 15),
                                scrollDirection: Axis.horizontal,
                                child: DataTable(
                                    columns: [
                                      DataColumn(
                                          label: Text(
                                        "عنوان",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w900),
                                      )),
                                      DataColumn(
                                          label: Text("مقدار",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w900))),
                                    ],
                                    rows: (state.feeds['data'][index] as Map)
                                        .entries
                                        .map((e) => DataRow(cells: [
                                                DataCell(
                                                    Text(e.key.toString())),
                                                DataCell(
                                                    Text(e.value.toString())),
                                            ]))
                                        .toList()),
                              );
                            }),
                                                ),
                      );
                    }
                  }
                  return Center(child: Text("چیزی برای نمایش وجود ندارد"));
                },
              ),
            ],
          )),
    );
  }
}
