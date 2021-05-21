import 'package:civil_project/constants/constantdecorations.dart';
import 'package:civil_project/logic/login_cubit/login_cubit.dart';
import 'package:civil_project/logic/payment_cubit/payment_cubit.dart';
import 'package:civil_project/screens/homee/home_items.dart';
import 'package:civil_project/widgets/boxes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Payment extends StatefulWidget {
  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  final TextEditingController _price = TextEditingController();
  final TextEditingController _descript = TextEditingController();
  final List types = [
    ['PROVIDER', "تامین کنندگان"],
    ['HUMAN', "منابع انسانی"],
    ['COST', 'هزینه های عمومی']
  ];

  final List icons = [
    Icon(Icons.store_mall_directory_outlined),
    Icon(Icons.person),
    Icon(Icons.money_outlined)
  ];
  String type;
  int choice;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<PaymentCubit>(context).getCostProperties(   token:
                                          BlocProvider.of<LoginCubit>(context)
                                              .token,
                                      projectId:
                                          BlocProvider.of<LoginCubit>(context)
                                              .projectId,
                                    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: Text("پرداخت"),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
              horizontal: width * 0.05, vertical: height * 0.1),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            textDirection: TextDirection.rtl,
            children: [
              Row(
                children: [
                  Expanded(
                      child: activityBox(height, width,
                          actvity: BlocProvider.of<LoginCubit>(context)
                              .activityTitle)),
                  SizedBox(width: width * 0.03),
                  Expanded(
                      child: dateBox(height, width,
                          date: globalDateController.text)),
                ],
              ),
              SizedBox(height: height * 0.04),
              //*MiddleBox
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: width * 0.03, vertical: height * 0.015),
                decoration: containerShadow,
                height: height * 0.6,
                child: BlocListener<PaymentCubit, PaymentState>(
                  listener: (context, state) {
                    if (state is AddingPaymentFailed) {
                      Scaffold.of(context)
                          .showSnackBar(SnackBar(content: Text("اضافه نشد")));
                    }

                    if (state is PaymentAdded) {
                      if (state.success == false) {
                        Scaffold.of(context).showSnackBar(SnackBar(
                            content: Text("متاسفانه پرداخت انجام نشد")));
                      }
                      Scaffold.of(context).showSnackBar(
                          SnackBar(content: Text("پرداخت با موفقیت اضافه شد")));
                      _price.clear();
                      _descript.clear();
                      Navigator.pop(context);
                    }
                  },
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: BlocBuilder<PaymentCubit, PaymentState>(
                      builder: (context, state) {
                        if (state is PaymentLoadingProperty) {
                          return Center(child: CircularProgressIndicator());
                        }
                        if (state is PaymentLoadedProperty) {
                          return Column(
                            textDirection: TextDirection.rtl,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _dropDownButtonforType(height, width,
                                  hint: 'نوع هزینه', items: types),
                              _textFields(height * 0.15, width,
                                  hintText: "شرح هزینه", controller: _descript),
                              _textFields(height * 0.080, width,
                                  hintText: "مبلغ", controller: _price),
                              type == 'HUMAN' || type == 'PROVIDER'
                                  ? (type == 'HUMAN'
                                      ? _dropDownButtons(height, width,
                                          hint: 'نوع گیرنده',
                                          items: state.properties['data']
                                              ['resource'])
                                      : _dropDownButtons(height, width,
                                          hint: 'نوع گیرنده',
                                          items: state.properties['data']
                                              ['provider']))
                                  : Container(),
                            ],
                          );
                        }
                        return Container();
                      },
                    ),
                  ),
                ),
              ),
              BlocBuilder<PaymentCubit, PaymentState>(
                builder: (context, state) {
                  if (state is AddingPayment) {
                    return Center(child: CircularProgressIndicator());
                  }
                  return Container(
                    height: height * 0.08,
                    margin: EdgeInsets.symmetric(
                        horizontal: width * 0.01, vertical: height * 0.05),
                    child: RaisedButton(
                      onPressed: () async {
                        await BlocProvider.of<PaymentCubit>(context).addPayment(   token:
                                          BlocProvider.of<LoginCubit>(context)
                                              .token,
                                      projectId:
                                          BlocProvider.of<LoginCubit>(context)
                                              .projectId,
                                      activityId:
                                          BlocProvider.of<LoginCubit>(context)
                                              .activityId,
                            amount: _price.text,
                            description: _descript.text,
                            receiverId: choice,
                            type: type);
                      },
                      child: Text("ثبت",
                          style: TextStyle(
                              color: Colors.white, fontSize: width * 0.045)),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      elevation: 10,
                      color: Colors.green,
                    ),
                  );
                },
              )
            ],
          ),
        ));
  }

  _dropDownButtons(
    double height,
    double width, {
    String hint = "",
    List items,
  }) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        decoration: containerShadow,
        padding: EdgeInsets.symmetric(horizontal: width * 0.02),
        margin: EdgeInsets.symmetric(
            horizontal: width * 0.02, vertical: height * 0.02),
        child: DropdownButton(
          disabledHint: Text(hint),
          value: choice,
          isExpanded: true,
          underline: Divider(
            color: Colors.transparent,
          ),
          hint: Text(hint),
          items: items
              .map((e) => DropdownMenuItem(
                  value: e['id'],
                  child: type == 'HUMAN'
                      ? Text(e['firstName'] + " " + e['lastName'])
                      : Text(e['title'].toString())))
              .toList(),
          onChanged: (value) {
            setState(() {
              choice = value;
            });
          },
        ),
      ),
    );
  }

  _dropDownButtonforType(double height, double width,
      {String hint = "", List items, Icon icon}) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        decoration: containerShadow,
        padding: EdgeInsets.symmetric(horizontal: width * 0.02),
        margin: EdgeInsets.symmetric(
            horizontal: width * 0.02, vertical: height * 0.02),
        child: DropdownButton(
          disabledHint: Text(hint),
          value: type,
          isExpanded: true,
          underline: Divider(
            color: Colors.transparent,
          ),
          hint: Text(hint),
          items: items
              .map((e) => DropdownMenuItem(
                  value: e[0],
                  child: ListTile(
                    leading: icon,
                    title: Text(e[1].toString()),
                  )))
              .toList(),
          onChanged: (value) {
            setState(() {
              type = value;
            });
          },
        ),
      ),
    );
  }

  _textFields(double height, double width,
      {TextEditingController controller, String hintText}) {
    return Container(
      margin: EdgeInsets.all(width * 0.02),
      padding: EdgeInsets.only(right: width * 0.02),
      height: height,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: TextField(
          controller: controller,
          textDirection: TextDirection.rtl,
          keyboardType: hintText != "مبلغ"
              ? TextInputType.multiline
              : TextInputType.numberWithOptions(decimal: true),
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
}
