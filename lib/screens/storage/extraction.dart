
import 'package:civil_project/logic/login_cubit/login_cubit.dart';
import 'package:civil_project/logic/storeage_get_extract_cubit/storeage_get_extract_cubit.dart';
import 'package:civil_project/screens/homee/home_items.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class StorageExtraction extends StatefulWidget {
  @override
  _StorageExtractionState createState() => _StorageExtractionState();
}

class _StorageExtractionState extends State<StorageExtraction> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<StorageGetExtractCubit>(context).getExtraction(
        token: BlocProvider.of<LoginCubit>(context).token,
        projectId: BlocProvider.of<LoginCubit>(context).projectId);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // FloatingActionButton(
            //   onPressed: () {},
            //   child: Icon(Icons.search),
            //   tooltip: "جستجو",
            //   heroTag: "Search",
            // ),
            SizedBox(
              width: width * 0.01,
            ),
            FloatingActionButton(
                tooltip: "اضافه کردن",
                heroTag: "Add",
                onPressed: () async {
                  if (globalChoiceActivityId != null) {
                    Navigator.pushNamed(context, '/addextraction');
                    print(globalChoiceActivityId);
                  } else {
                    showDialog(
                        builder: (context) => AlertDialog(
                              title: Text(
                                  "لطفا برای ادامه کار یک فعالیت انتخاب کنید"),
                              actions: [
                                TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text("باشه"))
                              ],
                            ),
                        context: context);
                  }
                },
                child: Icon(Icons.add,color: Colors.white,))
          ],
        ),
        body: Column(
          children: [
            BlocBuilder<StorageGetExtractCubit, StoreageGetExtractState>(
              builder: (context, state) {
                if (state is StoreageGetExtractLoading) {
                  return Center(child: CircularProgressIndicator());
                }
                if (state is StoreageGetExtractLoaded) {
                  if (state.extraction['data'] == null) {
                    return Text("چیزی برای نمایش وجود ندارد");
                  } else {
                    return Expanded(
                      child: ListView.builder(
                          itemCount: state.extraction['data'].length,
                          itemBuilder: (context, index) {
                            return Directionality(
                              textDirection: TextDirection.rtl,
                              child: Container(
                                margin: EdgeInsets.all(5),
                                height: 200,
                                child: Stack(
                                  alignment: Alignment.topRight,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(right: 40,left: 5),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[600],
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey[800],
                                            spreadRadius: 0.5,
                                            blurRadius: 0.5,
                                            offset: Offset(0.5,
                                                1), // changes position of shadow
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        children: [
                                          Container(
                                            alignment: Alignment.topRight,
                                            height: 150,
                                            margin: EdgeInsets.only(
                                                top: 30, right: 35),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(alignment: Alignment.topRight,
                                                  margin: EdgeInsets.only(
                                                      left: 10),
                                                  child:
                                                      SingleChildScrollView(
                                                    scrollDirection:
                                                        Axis.vertical,
                                                    child: Directionality(
                                                      textDirection:
                                                          TextDirection.rtl,
                                                      child: Text(
                                                        "${state.extraction['data'][index]['title']}",
                                                        style: TextStyle(
                                                          color:
                                                              Colors.white,
                                                          fontSize: 15,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: Directionality(
                                                    textDirection:
                                                        TextDirection.rtl,
                                                    child: Text(
                                                      "مقدار: " +
                                                          "${state.extraction['data'][index]['amount']}" +
                                                          " ${state.extraction['data'][index]['unit']}" +
                                                          "",
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            color: Colors.white,
                                          ),
                                          Container(
                                            alignment: Alignment.centerLeft,
                                            height: 19,
                                            margin: EdgeInsets.only(left: 15),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  margin: EdgeInsets.only(
                                                      right: 10),
                                                  child: Directionality(
                                                    textDirection:
                                                        TextDirection.rtl,
                                                    child: state.extraction[
                                                                        'data']
                                                                    [index][
                                                                'confirms'] ==
                                                            null
                                                        ? Text(
                                                            "وضعیت: بررسی نشده",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 9,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold))
                                                        : SingleChildScrollView(
                                                            scrollDirection:
                                                                Axis.horizontal,
                                                            child: Row(
                                                              children: (state.extraction['data'][index]
                                                                          [
                                                                          'confirms']
                                                                      as List)
                                                                  .map(
                                                                      (e) =>
                                                                          Row(
                                                                            children: [
                                                                              Text("وضعیت: ", style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                                                                              Text("${e["role"]}:", style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                                                                              Text("${e['response']['msg']}", style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                                                                              e['is_confirm'] == 1
                                                                                  ? Container(
                                                                                      margin: EdgeInsets.only(right: 5),
                                                                                      child: Icon(
                                                                                        Icons.thumb_up_alt,
                                                                                        size: 17,
                                                                                        color: Colors.green,
                                                                                      ),
                                                                                    )
                                                                                  : Container(margin: EdgeInsets.only(right: 5), child: Icon(Icons.thumb_down_alt, size: 17, color: Colors.red)),
                                                                            ],
                                                                          ))
                                                                  .toList(),
                                                            ),
                                                          ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Container(
                                      margin:
                                          EdgeInsets.only(right: 20, top: 20),
                                      height: 50,
                                      width: 50,
                                      padding: EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                          shape: BoxShape.rectangle,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: Colors.white),
                                      child: Image.asset(
                                          "assets/images/" +
                                              '${state.extraction['data'][index]['logo'].toString().toLowerCase()}',
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  Image.asset(
                                                    "assets/images/noimage.png",
                                                    color: Colors.grey,
                                                  )),
                                    )
                                  ],
                                ),
                              ),
                            );
                          }),
                    );
                  }
                }

                return Center(child: Text('چیزی پیدا نشد'));
              },
            ),
          ],
        ));
  }
}
