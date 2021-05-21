import 'package:civil_project/constants/constantdecorations.dart';
import 'package:civil_project/logic/login_cubit/login_cubit.dart';
import 'package:civil_project/logic/storeage_stock_cubit/storeagestock_cubit.dart';
import 'package:flutter/material.dart';
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
                    decoration: containerShadow,
                    height: height * 0.15,
                    margin: EdgeInsets.symmetric(
                        horizontal: width * 0.05, vertical: height * 0.03),
                    padding: EdgeInsets.symmetric(
                        horizontal: width * 0.04, vertical: height * 0.01),
                    child: Row(
                      textDirection: TextDirection.rtl,
                      children: [
                        Expanded(
                            child: Image.asset(
                          'assets/images/noimage.png',
                          color: Colors.grey,
                        )),
                        VerticalDivider(color: Colors.grey),
                        Expanded(
                          child: Column(
                            textDirection: TextDirection.rtl,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${state.stock['data'][index]['title']}'),
                              Row(
                                textDirection: TextDirection.rtl,
                                children: [
                                  Text(
                                      '${state.stock['data'][index]['amount']}'),
                                  Text('${state.stock['data'][index]['unit']}'),
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ));
              },
            );
          } else
            return Center(child: Text("چیزی برای نمایش وجود ندارد!"));
        },
      ),
    );
  }
}
