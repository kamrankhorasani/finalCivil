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
            return Center(child: Text("چیزی برای نمایش وجود ندارد"));
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
                    child: new Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 24),
                      child: new Stack(
                        alignment: Alignment.topRight,
                        children: [
                          new Container(
                            height: 400,
                            margin: new EdgeInsets.only(right: 36),
                            decoration: new BoxDecoration(
                                color: Colors.grey,
                                shape: BoxShape.rectangle,
                                borderRadius: new BorderRadius.circular(8),
                                boxShadow: <BoxShadow>[
                                  new BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 10,
                                      offset: new Offset(0, 10))
                                ]),
                          ),
                          new Container(
                            margin: const EdgeInsets.symmetric(vertical: 16,horizontal: 20),
                            child: new Stack(
                              alignment: Alignment.center,
                              children: <Widget>[
                                Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.rectangle,
                                      borderRadius: BorderRadius.circular(9)),
                                ),
                                Container(
                                  height: 40,
                                  width: 40,
                                  child: Expanded(
                                      child: Image.asset(
                                    "assets/images/" +
                                        BlocProvider.of<CartableCubit>(context)
                                            .crt[index]["msgType"]
                                            .toString() +
                                        ".png",
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Image.asset(
                                                "assets/images/noimage.png"),
                                  )),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      borderRadius: BorderRadius.circular(9)),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ));
              });
        },
      ),
    );
  }
}
