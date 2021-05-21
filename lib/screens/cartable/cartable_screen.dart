import 'package:civil_project/constants/constantdecorations.dart';
import 'package:civil_project/logic/cartable_cubit/cartable_cubit.dart';
import 'package:civil_project/logic/login_cubit/login_cubit.dart';

import 'package:flutter/material.dart';
import 'package:persian_datepicker/persian_datetime.dart';
import 'item_details.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartableScreen extends StatefulWidget {
  @override
  _CartableScreenState createState() => _CartableScreenState();
}

class _CartableScreenState extends State<CartableScreen> {
  
  int _currentMax = 0;
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _loadMoreData();
      }
    });
    context.read<CartableCubit>().getCartable(
        token: BlocProvider.of<LoginCubit>(context).token, frm: _currentMax);
    super.initState();
  }

  _loadMoreData() async {
    _currentMax += 10;
    await BlocProvider.of<CartableCubit>(context).getCartable(
        token: BlocProvider.of<LoginCubit>(context).token, frm: _currentMax);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.pushNamed(context, '/addcartable').then(
              (value) async => await BlocProvider.of<CartableCubit>(context)
                  .getCartable(
                      token: BlocProvider.of<LoginCubit>(context).token,
                      frm: _currentMax)),
          child: Icon(Icons.add)),
      appBar: AppBar(
        title: Text('عمران'),
        centerTitle: true,
      ),
      body: BlocConsumer<CartableCubit, CartableState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (BlocProvider.of<CartableCubit>(context).crt == null) {
            return Center(child: Text("چیزی باری نمایش وجود ندارد"));
          }
          return ListView.separated(
              controller: _scrollController,
              separatorBuilder: (context, index) => Divider(),
              itemCount: BlocProvider.of<CartableCubit>(context).crt.length,
              itemBuilder: (context, index) {
                var persianDate3 = PersianDateTime.fromGregorian(
                    gregorianDateTime:
                        "${BlocProvider.of<CartableCubit>(context).crt[index]['date'].substring(0, 9)}");
                if (BlocProvider.of<CartableCubit>(context).crt.length ==
                    index + 1) {
                  return Center(child: CircularProgressIndicator());
                }
                return GestureDetector(
                  onTap: () {
                    if (BlocProvider.of<CartableCubit>(context).crt[index]
                            ["msgType"] !=
                        "msg") {
                      Navigator.pushNamed(context, '/itemdetails2',
                          arguments: BlocProvider.of<CartableCubit>(context)
                              .crt[index]["id"]);
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => BlocProvider.value(
                                    value: CartableCubit(),
                                    child: ItemDetails(
                                      title: BlocProvider.of<CartableCubit>(
                                              context)
                                          .crt[index]["title"],
                                      name: BlocProvider.of<CartableCubit>(
                                              context)
                                          .crt[index]["from_user"],
                                      date: BlocProvider.of<CartableCubit>(
                                              context)
                                          .crt[index]["date"],
                                      files: BlocProvider.of<CartableCubit>(
                                              context)
                                          .crt[index]["files"],
                                    ),
                                  )));
                    }
                  },
                  child: Container(
                    decoration: containerShadow,
                    margin: EdgeInsets.all(8),
                    padding: EdgeInsets.all(8),
                    width: double.maxFinite,
                    height: height * 0.25,
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            textDirection: TextDirection.rtl,
                            children: [
                              Text(
                                  "${BlocProvider.of<CartableCubit>(context).crt[index]["from_user"]}"),
                              Text(
                                  " ${BlocProvider.of<CartableCubit>(context).crt[index]["title"]}"),
                              Text(
                                  "${persianDate3.toJalaali()} ${BlocProvider.of<CartableCubit>(context).crt[index]["date"].toString().substring(11)}"),
                            ],
                          ),
                        ),
                        VerticalDivider(
                          color: Colors.grey,
                        ),
                        Expanded(
                            child: Image.asset(
                          "assets/images/" +
                              BlocProvider.of<CartableCubit>(context)
                                  .crt[index]["msgType"]
                                  .toString() +
                              ".png",
                          errorBuilder: (context, error, stackTrace) =>
                              Image.asset("assets/images/noimage.png"),
                        )),
                      ],
                    ),
                  ),
                );
              });
        },
      ),
    );
  }
}
