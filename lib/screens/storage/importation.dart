import 'package:civil_project/constants/constantdecorations.dart';
import 'package:civil_project/logic/login_cubit/login_cubit.dart';
import 'package:civil_project/logic/storage_get_import_cubit/storage_get_import_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persian_datepicker/persian_datetime.dart';

class StorageImportation extends StatefulWidget {
  @override
  _StorageImportationState createState() => _StorageImportationState();
}

class _StorageImportationState extends State<StorageImportation> {
  @override
  void initState() {
    super.initState();

    BlocProvider.of<StorageGetImportCubit>(context).getImportation(
        token: BlocProvider.of<LoginCubit>(context).token,
        projectId: BlocProvider.of<LoginCubit>(context).projectId);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // FloatingActionButton(
            //   onPressed: () {},
            //   child: Icon(Icons.search),
            //   heroTag: "search",
            //   tooltip: "جستجو",
            // ),
            SizedBox(
              width: width * 0.01,
            ),
            FloatingActionButton(
              onPressed: () => Navigator.pushNamed(context, '/addimportation'),
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
              heroTag: "add",
              tooltip: "اضافه کردن",
            ),
          ],
        ),
        body: BlocConsumer<StorageGetImportCubit, StorageGetImportState>(
          listener: (context, state) {
            if (state is LoadingImportationFailed) {
              Scaffold.of(context)
                  .showSnackBar(SnackBar(content: Text("مشکلی هست!")));
            }
          },
          builder: (context, state) {
            if (state is LoadingImportation) {
              return Center(child: CircularProgressIndicator());
            }
            if (state is LoadedImportation) {
              return Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: width * 0.03, vertical: height * 0.01),
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: ListView.separated(
                      separatorBuilder: (context, index) => Divider(),
                      itemCount: (state.importations["data"] as List).length,
                      itemBuilder: (context, index) {
                        var persianDate = PersianDateTime.fromGregorian(
                            gregorianDateTime:
                                "${state.importations['data'][index]['dateIn'].substring(0, 9)}");
                        return Container(
                          margin: EdgeInsets.all(5),
                          height: 200,
                          child: Stack(
                            alignment: Alignment.topRight,
                            children: [
                              Container(
                                margin: EdgeInsets.only(right: 40),
                                decoration: BoxDecoration(
                                  color: Colors.grey[600],
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey[800],
                                      spreadRadius: 0.5,
                                      blurRadius: 0.5,
                                      offset: Offset(
                                          0.5, 1), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: Expanded(
                                  child: Column(
                                    children: [
                                      Container(
                                        alignment: Alignment.topRight,
                                        height: 150,
                                        margin:
                                            EdgeInsets.only(top: 30, right: 35),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(flex: 2,
                                              child: Container(
                                                alignment: Alignment.topRight,
                                                child: SingleChildScrollView(scrollDirection: Axis.vertical,
                                                  child: Directionality(
                                                    textDirection:
                                                        TextDirection.rtl,
                                                    child: Text(
                                                      "${state.importations['data'][index]['title']}",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 15,),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(flex: 1,
                                              child: Container(
                                                alignment: Alignment.centerRight,
                                                child: Directionality(
                                                  textDirection:
                                                      TextDirection.rtl,
                                                  child: Text(
                                                    "${state.importations['data'][index]['amount']}" +
                                                        " ${state.importations['data'][index]['unit']}" +
                                                        "",
                                                    style: TextStyle(
                                                        fontSize: 15,),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(flex: 1,
                                              child: Container(
                                                alignment: Alignment.centerRight,
                                                child: Directionality(
                                                  textDirection:
                                                      TextDirection.rtl,
                                                  child: Text(
                                                    "تهیه کننده: " +
                                                        "${state.importations['data'][index]['provider']}",
                                                    style: TextStyle(
                                                        fontSize: 15),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                          child: Container(
                                        color: Colors.white,
                                      )),
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        height: 19,
                                        margin: EdgeInsets.only(left: 15),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                                "${state.importations['data'][index]['dateIn'].substring(10)}" +
                                                    "  ${persianDate.toJalaali()}",
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.white,
                                                    fontSize: 13)),
                                            Container(
                                              alignment: Alignment.centerRight,
                                              child: Directionality(
                                                textDirection:
                                                    TextDirection.rtl,
                                                child:
                                                    state.importations['data']
                                                                    [index]
                                                                ['confirms'] ==
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
                                                              children: (state.importations['data']
                                                                              [
                                                                              index]
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
                                                                                        Icons.thumb_up_alt,size: 17,
                                                                                        color: Colors.green,
                                                                                      ),
                                                                                    )
                                                                                  : Container(margin: EdgeInsets.only(right: 5), child: Icon(Icons.thumb_down_alt,size: 17, color: Colors.red)),
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
                              ),
                              Container(
                                margin: EdgeInsets.only(right: 20, top: 20),
                                height: 50,
                                width: 50,
                                padding: EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.white),
                                child: Image.asset(
                                    "assets/images/" +
                                        '${state.importations['data'][index]['logo'].toString().toLowerCase()}',
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Image.asset(
                                              "assets/images/noimage.png",
                                              color: Colors.grey,
                                            )),
                              )
                            ],
                          ),
                        );
                      }),
                ),
              );
            }
            return Text("");
          },
        ));
  }
}
