import 'package:civil_project/logic/itemdetails2_cubit/itemdeteils2_cubit.dart';
import 'package:civil_project/logic/login_cubit/login_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:civil_project/constants/constantdecorations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ItemDetails2 extends StatefulWidget {
  final int itemId;

  const ItemDetails2({Key key, this.itemId}) : super(key: key);
  @override
  _ItemDetails2State createState() => _ItemDetails2State();
}

class _ItemDetails2State extends State<ItemDetails2> {
  final TextEditingController _controller = TextEditingController();
  int confirm;
  bool animate = false;
  @override
  void initState() {
    super.initState();

    BlocProvider.of<Itemdeteils2Cubit>(context).getCartablebyId(
        token: BlocProvider.of<LoginCubit>(context).token,
        itemId: widget.itemId);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                  horizontal: width * 0.05, vertical: height * 0.09),
              child: Container(
                height: height * 1.35,
                margin: EdgeInsets.symmetric(vertical: height * 0.01),
                padding: EdgeInsets.symmetric(
                    horizontal: width * 0.01, vertical: height * 0.01),
                width: double.infinity,
                decoration: containerShadow,
                child: BlocConsumer<Itemdeteils2Cubit, Itemdeteils2State>(
                    listener: (context, state) {
                  if (state is FaildAddingItem) {
                    Scaffold.of(context)
                      ..removeCurrentSnackBar()
                      ..showSnackBar(SnackBar(content: Text("مشکلی پیش آمده")));
                  }
                  if (state is FaildLoadingItem) {
                    Scaffold.of(context)
                      ..removeCurrentSnackBar()
                      ..showSnackBar(SnackBar(content: Text("مشکلی پیش آمده")));
                  }
                }, builder: (context, state) {
                  if (state is LoadingItem) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (state is LoadedItem) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      textDirection: TextDirection.rtl,
                      children: [
                        Row(
                          textDirection: TextDirection.rtl,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.network(
                              "",
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset("assets/images/noimage.png");
                              },
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              textDirection: TextDirection.rtl,
                              children: [
                                ConstrainedBox(
                                    constraints: BoxConstraints(
                                        maxWidth: width * 0.4,
                                        maxHeight: height * 0.1),
                                    child: Text(
                                        "${state.details['data'][0]['title']}:عنوان")),
                                SizedBox(height: height * 0.04),
                                Text(
                                    "${state.details['data'][0]["from_user"]}:فرستنده"),
                                SizedBox(height: height * 0.04),
                                Text(
                                    "${state.details['data'][0]['date'].toString().substring(0, 9)}:تاریخ ارسال"),
                              ],
                            ),
                            SizedBox(width: width * 0.07)
                          ],
                        ),
                        SizedBox(
                          height: height * 0.02,
                        ),
                        Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: width * 0.1),
                          child: Directionality(
                            textDirection: TextDirection.rtl,
                            child: Container(
                              child: DataTable(
                                  showBottomBorder: true,
                                  columns: [
                                    DataColumn(label: Text("عنوان")),
                                    DataColumn(label: Text("مقدار"))
                                  ],
                                  rows: (state.details['data'][0]['relatedItem']
                                          as Map)
                                      .entries
                                      .map((e) => DataRow(cells: [
                                            DataCell(Text(e.key.toString())),
                                            DataCell(Text(e.value.toString()))
                                          ]))
                                      .toList()),
                            ),
                          ),
                        ),
                        SizedBox(height: height * 0.1),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            state.details['data'][0]['confirmResult'] != null
                                ? Container()
                                : Expanded(
                                    child: RaisedButton(
                                      child: !animate
                                          ? Text("تایید")
                                          : Text("تایید شد"),
                                      color: !animate
                                          ? Colors.blueGrey
                                          : Colors.greenAccent,
                                      textColor: !animate
                                          ? Colors.black
                                          : Colors.white,
                                      elevation: !animate ? 10 : 35,
                                      shape: !animate
                                          ? RoundedRectangleBorder()
                                          : RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                      onPressed: () async {
                                        confirm = 1;
                                        setState(() {
                                          animate = !animate;
                                        });
                                        print(animate);
                                        await showDialog(
                                            builder: (context) => SimpleDialog(
                                              children: [
                                                Scrollbar(
                                                    child: Column(
                                                  children: [
                                                    _textFields(height, width,
                                                        controller: _controller,
                                                        hintText: "نظرشما..."),
                                                    RaisedButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text("ثبت نظر"),
                                                    )
                                                  ],
                                                ))
                                              ],
                                            ), context: (context));
                                      },
                                    ),
                                  ),
                            SizedBox(width: width * 0.05),
                            state.details['data'][0]['confirmResult'] != null
                                ? Container()
                                : Expanded(
                                    child: RaisedButton(
                                      child: animate
                                          ? Text("عدم تایید")
                                          : Text("تایید نشد"),
                                      color: animate
                                          ? Colors.blueGrey
                                          : Colors.red,
                                      textColor:
                                          animate ? Colors.black : Colors.white,
                                      elevation: animate ? 10 : 35,
                                      shape: animate
                                          ? RoundedRectangleBorder()
                                          : RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                      onPressed: () async {
                                        confirm = -1;
                                        setState(() {
                                          animate = !animate;
                                        });
                                        print("ff");
                                        await showDialog(
                                            builder: (context) => SimpleDialog(
                                              children: [
                                                Scrollbar(
                                                    child: Column(
                                                  children: [
                                                    _textFields(height, width,
                                                        controller: _controller,
                                                        hintText: "نظرشما..."),
                                                    RaisedButton(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              context),
                                                      child: Text("ثبت نظر"),
                                                    )
                                                  ],
                                                ))
                                              ],
                                            ), context: (context));
                                      },
                                    ),
                                  ),
                          ],
                        ),
                        state.details['data'][0]['confirmResult'] != null
                            ? Container()
                            : Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: width * 0.2,
                                    vertical: height * 0.05),
                                child: RaisedButton(
                                  padding: EdgeInsets.symmetric(
                                      vertical: height * 0.01),
                                  onPressed: () async {
                                    await BlocProvider.of<Itemdeteils2Cubit>(
                                            context)
                                        .cartableConfirm(
                                            token: BlocProvider.of<LoginCubit>(
                                                    context)
                                                .token,
                                            cartableId: widget.itemId,
                                            isConfirm: confirm,
                                            responseJson: {
                                          "isConfirm": confirm,
                                          "response": _controller.text
                                        });
                                    _controller.clear();
                                    setState(() {
                                      confirm = null;
                                    });
                                  },
                                  child: Text(
                                    "تایید نهایی",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  color: Colors.green,
                                ),
                              ),
                        state.details['data'][0]['confirmResult'] == null
                            ? Container()
                            : RaisedButton(
                                color: state.details['data'][0]['confirmResult']
                                            ['isConfirm'] ==
                                        1
                                    ? Colors.green
                                    : Colors.red,
                                child: state.details['data'][0]['confirmResult']
                                            ['isConfirm'] ==
                                        1
                                    ? Text("تایید شده")
                                    : Text("تایید نشده"),
                                onPressed: () {}),
                        SizedBox(
                          height: height * 0.05,
                          child: Directionality(
                              textDirection: TextDirection.rtl,
                              child: Text("پیام ارسالی:")),
                        ),
                        state.details['data'][0]['confirmResult'] == null
                            ? Container()
                            : ConstrainedBox(
                                constraints:
                                    BoxConstraints(maxWidth: width * 0.5),
                                child: Text(
                                  "'${state.details['data'][0]['confirmResult']['response']['msg']}'",
                                  textDirection: TextDirection.rtl,
                                ),
                              ),
                      ],
                    );
                  }
                  return Center(child: Text("چیزی برای نمایش وجود ندارد"));
                }),
              ),
            ),
            Positioned(
                top: 15,
                child: IconButton(
                    icon: Icon(
                      Icons.cancel,
                      size: height * 0.06,
                      color: Colors.red,
                    ),
                    onPressed: () => Navigator.pop(context)))
          ],
        ),
      ),
    );
  }
}

_textFields(double height, double width,
    {TextEditingController controller, String hintText}) {
  return Container(
    margin: EdgeInsets.all(width * 0.07),
    padding: EdgeInsets.only(right: width * 0.02),
    height: height * 0.15,
    child: Directionality(
      textDirection: TextDirection.rtl,
      child: TextField(
        controller: controller,
        textDirection: TextDirection.rtl,
        keyboardType: TextInputType.multiline,
        maxLines: null,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
        ),
      ),
    ),
    decoration: containerShadow,
  );
}
