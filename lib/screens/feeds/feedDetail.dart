import 'dart:convert';

import 'package:civil_project/constants/constantdecorations.dart';
import 'package:civil_project/logic/feed_cubit/feed_cubit.dart';
import 'package:civil_project/logic/login_cubit/login_cubit.dart';
import 'package:civil_project/models/imageView.dart';
import 'package:civil_project/models/videoView.dart';
import 'package:civil_project/widgets/toJalali.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';

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
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: BlocBuilder<FeedCubit, FeedState>(
            builder: (context, state) {
              if (state is LoadingFeed) {
                return Center(child: CircularProgressIndicator());
              }
              if (state is LoadedFeed) {
                if (state.feeds['data'] == null ||
                    (state.feeds['data'] as List).isEmpty) {
                  return Center(child: Text("چیزی برای نمایش وجود ندارد"));
                } else {
                  return widget.tbl != 'media'
                      ? InteractiveViewer(
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
                                    rows: (state.feeds['data'][index]
                                            as Map)
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
                      )
                      : ListView.builder(
                          itemCount: (state.feeds['data'] as List).length,
                          itemBuilder: (context, index) {
                            return Container(
                              height: height * 0.4,
                              decoration: containerShadow,
                              margin:
                                  EdgeInsets.symmetric(vertical: height * 0.1),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                      "${state.feeds['data'][index]['activity']}",style: TextStyle(fontSize:width*0.05 ),),

                                  Text(
                                      "${converttoJalali(state.feeds['data'][index]['date'])}",style: TextStyle(fontSize:width*0.04 )),
                                      SizedBox(height: width*0.1,),
                                  state.feeds['data'][index]['pics'] == null ||
                                          (state.feeds['data'][index]['pics']
                                                  as List)
                                              .isEmpty
                                      ?  Text("بدون عکس",textAlign: TextAlign.center,style: TextStyle(fontSize:width*0.1 ),)

                                      : Expanded(
                                          child: ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              shrinkWrap: true,
                                              itemCount: (state.feeds['data']
                                                      [index]['pics'] as List)
                                                  .length,
                                              itemBuilder: (context, idx2) {
                                                return GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) => ImageView(
                                                                address: state.feeds['data'][index]['pics']
                                                                            [
                                                                            idx2]
                                                                        [
                                                                        'file'] ??
                                                                    "")));
                                                  },
                                                  child: Padding(
                                                    padding: EdgeInsets.all(
                                                        width * 0.05),
                                                    child: SizedBox(
                                                      height: width * 0.1,
                                                      child: Image.network(
                                                        state.feeds['data']
                                                                        [index]
                                                                    ['pics'][
                                                                idx2]['file'] ??
                                                            "",
                                                        width: width * 0.2,
                                                        height: height * 0.3,
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }),
                                        ),
                                  Divider(
                                      thickness: 1, indent: 10, endIndent: 10),
                                  state.feeds['data'][index]['video'] == null ||
                                          (state.feeds['data'][index]['video']
                                                  as List)
                                              .isEmpty
                                      ? Text("بدون فیلم",textAlign: TextAlign.center,style: TextStyle(fontSize:width*0.1 ),)
                                      : Expanded(
                                          child: ListView.builder(
                                              shrinkWrap: true,
                                              scrollDirection: Axis.horizontal,
                                              itemCount: (state.feeds['data']
                                                      [index]['video'] as List)
                                                  .length,
                                              itemBuilder: (context, idx1) {
                                                return GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) => ChewieListItem(
                                                              videoPlayerController:
                                                                  VideoPlayerController.network(state.feeds['data']
                                                                              [
                                                                              index]
                                                                          [
                                                                          'pics'][idx1]
                                                                      [
                                                                      'file']))),
                                                    );
                                                  },
                                                  child: Padding(
                                                    padding: EdgeInsets.all(
                                                        width * 0.05),
                                                    child: SizedBox(
                                                      width: width * 0.1,
                                                      child: Image.asset(
                                                        "assets/images/film.png",
                                                        width: width * 0.2,
                                                        height: height * 0.3,
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }),
                                        ),
                                ],
                              ),
                            );
                          },
                        );
                }
              }
              return Center(child: Text("چیزی برای نمایش وجود ندارد"));
            },
          )),
    );
  }
}
// SizedBox(
//   height: 100,
//     child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         itemCount: (state.feeds['data']
//                 [index]['video'] as List)
//             .length,
//         itemBuilder: (context, idx1) {
//           return Column(
//             mainAxisAlignment:
//                 MainAxisAlignment.center,
//             children: [
//               Text(
//                   "${state.feeds['data'][index]['video'][idx1]['title']}??'' "),
//               GestureDetector(
//                 onTap: () {
//                   Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) =>
//                               ChewieListItem(
//                                 videoPlayerController:
//                                     VideoPlayerController.network(utf8.decode(base64.decode(state.feeds['data'][index]['video'][idx1]
//                                         [
//                                         'file']??"")))),
//                               ));
//                 },
//                 child: Image.asset(
//                     "asstes/images/film.png"),
//               ),
//             ],
//           );
//         })),
