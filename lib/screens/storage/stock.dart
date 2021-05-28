import 'package:civil_project/constants/constantdecorations.dart';
import 'package:civil_project/logic/login_cubit/login_cubit.dart';
import 'package:civil_project/logic/storeage_stock_cubit/storeagestock_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StorageStock extends StatefulWidget {
  @override
  _StorageStockState createState() => _StorageStockState();
}

class _StorageStockState extends State<StorageStock> {
  @override
  void initState() {
    BlocProvider.of<StorageGetStockCubit>(context).getStock(
        token: BlocProvider.of<LoginCubit>(context).token,
        projectId: BlocProvider.of<LoginCubit>(context).projectId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: BlocConsumer<StorageGetStockCubit, StoreagestockState>(
        listener: (context, state) {
          if (state is StoreageStockLoadFailed) {
            Scaffold.of(context)
                .showSnackBar(SnackBar(content: Text('مشکلی هست')));
          }
        },
        builder: (context, state) {
          if (state is StoreageStockLoading) {
            return Center(child: CircularProgressIndicator());
          }
          if (state is StoreageStockLoaded) {
            return ListView.separated(
              separatorBuilder: (context, index) => Divider(),
              itemCount: state.stock['data'].length,
              itemBuilder: (context, index) {
                return Container(
                  height: 250,
                  child: Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Container(
                        height: double.infinity,
                        width: double.infinity,
                        margin: EdgeInsets.only(left: 10, top: 20, right: 40),
                        decoration: containerShadow,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              alignment: Alignment.topRight,
                              margin:
                                  EdgeInsets.only(right: 30, top: 30, left: 10),
                              child: Expanded(
                                flex: 2,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: Text(
                                      '${state.stock['data'][index]['title']}',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 15),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.topRight,
                              margin: EdgeInsets.only(
                                  right: 30, top: 30, left: 10, bottom: 10),
                              child: Expanded(
                                  flex: 1,
                                  child: Directionality(
                                      textDirection: TextDirection.rtl,
                                      child: Text('مقدار: ' +
                                          '${state.stock['data'][index]['amount']}' +
                                          ' ${state.stock['data'][index]['unit']}'))),
                            )
                          ],
                        ),
                      ),
                      Container(
                        height: 50,
                        width: 50,
                        padding: EdgeInsets.all(6),
                        margin: EdgeInsets.only(right: 10, top: 40),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            shape: BoxShape.rectangle,
                            color: Colors.white),
                        child: Image.asset(
                          "assets/images/" +
                              "${state.stock['data'][index]['logo'].toString().toLowerCase()}",
                          errorBuilder: (context, error, stacktrace) =>
                              Image.asset(
                            "assets/images/noimage.png",
                            color: Colors.grey,
                          ),
                        ),
                      )
                    ],
                  ),
                );
              },
            );
          } else
            return Center(child: Text("چیزی برای نمایش وجود ندارد!"));
        },
      ),
    );
  }
}
