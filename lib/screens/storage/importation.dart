import 'package:civil_project/constants/constantdecorations.dart';
import 'package:civil_project/logic/login_cubit/login_cubit.dart';
import 'package:civil_project/logic/storage_get_import_cubit/storage_get_import_cubit.dart';
import 'package:flutter/material.dart';
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
              child: Icon(Icons.add),
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
                            decoration: containerShadow,
                            height: height * 0.3,
                            margin: EdgeInsets.symmetric(
                                horizontal: width * 0.03,
                                vertical: height * 0.01),
                            padding: EdgeInsets.symmetric(
                              horizontal: width * 0.03,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Image.network(
                                      '${state.importations['data'][index]['title']}',
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              Image.asset(
                                        "assets/images/noimage.png",
                                        color: Colors.grey,
                                      ),
                                    ),
                                    VerticalDivider(),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                              "${state.importations['data'][index]['title']}",overflow: TextOverflow.clip,),
                                        SizedBox(height: height * 0.01),
                                        Text(
                                            "${state.importations['data'][index]['amount']} ${state.importations['data'][index]['unit']}  "),
                                        SizedBox(height: height * 0.01),
                                        Text(
                                            "${state.importations['data'][index]['provider']}")
                                      ],
                                    ),
                                    SizedBox(width: width * 0.02),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Center(
                                          child: Text(
                                              "${persianDate.toJalaali()}"),
                                        ),
                                        SizedBox(height: height * 0.02),
                                        Text(
                                            "${state.importations['data'][index]['dateIn'].substring(10)}"),
                                      ],
                                    ),
                                  ],
                                ),
                                Divider(),
                                state.importations['data'][index]['confirms'] ==
                                        null
                                    ? Text("تاییدی وجود ندارد")
                                    : SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          children: (state.importations['data']
                                                  [index]['confirms'] as List)
                                              .map((e) => Row(
                                                    children: [
                                                      e['is_confirm'] == 1
                                                          ? Icon(
                                                              Icons
                                                                  .thumb_up_alt,
                                                              color:
                                                                  Colors.green)
                                                          : Icon(
                                                              Icons
                                                                  .thumb_down_alt,
                                                              color:
                                                                  Colors.red),
                                                      Text("${e["role"]}:"),
                                                      Text(
                                                          "${e['response']['msg']}"),
                                                      SizedBox(width: 7)
                                                    ],
                                                  ))
                                              .toList(),
                                        ),
                                      )
                              ],
                            ));
                      }),
                ),
              );
            }
            return Text("");
          },
        ));
  }
}
