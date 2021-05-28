import 'package:civil_project/constants/constantdecorations.dart';
import 'package:civil_project/logic/financial_cubit/financial_cubit.dart';
import 'package:civil_project/logic/login_cubit/login_cubit.dart';
import 'package:civil_project/screens/homee/home_items.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persian_datepicker/persian_datepicker.dart';
import 'package:persian_datepicker/persian_datetime.dart';

class FinancialScreen extends StatefulWidget {
  @override
  _FinancialScreenState createState() => _FinancialScreenState();
}

class _FinancialScreenState extends State<FinancialScreen> {
  final TextEditingController fromDate = TextEditingController();
  final TextEditingController toDate = TextEditingController();
  PersianDatePickerWidget fromDatePicker;
  PersianDatePickerWidget toDatePicker;
  PersianDateTime persianDate3;

  @override
  void dispose() {
    fromDate.dispose();
    toDate.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    BlocProvider.of<FinancialCubit>(context).getTransactions(
        token: BlocProvider.of<LoginCubit>(context).token,
        fromDate: globalDateController.text,
        toDate: globalDateController.text);

    fromDatePicker = PersianDatePicker(
      controller: fromDate,
      fontFamily: 'Vazir',
      farsiDigits: true,
      onChange: (oldText, newText) {
        Navigator.pop(context);
      },
    ).init();

    toDatePicker = PersianDatePicker(
      controller: toDate,
      fontFamily: 'Vazir',
      farsiDigits: true,
      onChange: (oldText, newText) async {
        await BlocProvider.of<FinancialCubit>(context).getTransactions(
            token: BlocProvider.of<LoginCubit>(context).token,
            fromDate: fromDate.text,
            toDate: toDate.text);
        Navigator.pop(context);
      },
    ).init();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.payment_rounded,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pushNamed(context, '/payment').then(
              (value) async => await BlocProvider.of<FinancialCubit>(context)
                  .getTransactions(
                      token: BlocProvider.of<LoginCubit>(context).token,
                      fromDate: globalDateController.text,
                      toDate: globalDateController.text)),
          backgroundColor: Colors.amber[500],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        appBar: AppBar(
          title: Align(alignment: Alignment.center, child: Text('سیویلیتو')),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: width * 0.05, vertical: height * 0.01),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                decoration: containerShadow,
                padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                height: height * 0.2,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("تومان"),
                      BlocBuilder<FinancialCubit, FinancialState>(
                        builder: (context, state) {
                          if (state is LoadingTransactions) {
                            return Center(child: CircularProgressIndicator());
                          }
                          if (state is LoadedTransactions) {
                            if (state.transactions['data'] == null) {
                              return Center(child: Text("بدون مقدار"));
                            } else {
                              return Text(
                                  "${state.transactions['data']['balance'].toString()}",
                                  style: TextStyle(fontSize: width * 0.09));
                            }
                          }
                          return Center(child: Text("بدون مقدار"));
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: height * 0.02),
              Container(
                decoration: containerShadow,
                height: height * 0.09,
                padding: EdgeInsets.symmetric(horizontal: width * 0.1),
                child: Row(
                  textDirection: TextDirection.rtl,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //**From Date */
                    Expanded(
                      child: Center(
                        child: TextField(
                            textAlign: TextAlign.center,
                            decoration:
                                new InputDecoration.collapsed(hintText: 'از'),
                            enableInteractiveSelection: false,
                            // *** this is important to prevent user interactive selection ***
                            onTap: () {
                              FocusScope.of(context).requestFocus(
                                  new FocusNode()); // *** to prevent opening default keyboard
                              showModalBottomSheet(
                                  isScrollControlled: true,
                                  context: context,
                                  builder: (BuildContext context) {
                                    return fromDatePicker;
                                  });
                            },
                            controller: fromDate),
                      ),
                    ),
                    VerticalDivider(),
                    //**To Date */
                    Expanded(
                      child: Center(
                        child: TextField(
                            textAlign: TextAlign.center,
                            decoration:
                                new InputDecoration.collapsed(hintText: 'تا'),
                            enableInteractiveSelection: false,
                            // *** this is important to prevent user interactive selection ***
                            onTap: () {
                              FocusScope.of(context).requestFocus(
                                  new FocusNode()); //*** to prevent opening default keyboard
                              showModalBottomSheet(
                                  isScrollControlled: true,
                                  context: context,
                                  builder: (BuildContext context) {
                                    return toDatePicker;
                                  });
                            },
                            controller: toDate),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: height * 0.01),
              BlocBuilder<FinancialCubit, FinancialState>(
                builder: (context, state) {
                  if (state is LoadingTransactions) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (state is LoadedTransactions) {
                    if (state.transactions['data']['transaction'] == null) {
                      return Center(child: Text("چیزی برای نمایش وجود ندارد"));
                    } else {
                      return Expanded(
                        child: ListView.builder(
                          itemCount: (state.transactions['data']['transaction']
                                  as List)
                              .length,
                          itemBuilder: (context, index) {
                            persianDate3 = PersianDateTime.fromGregorian(
                                gregorianDateTime:
                                    "${state.transactions['data']['transaction'][index]['date'].substring(0, 9)}");
                            return Directionality(
                              textDirection: TextDirection.rtl,
                              child: Container(
                                decoration: BoxDecoration(),
                                height: 75,
                                margin: EdgeInsets.only(bottom: 0),
                                child: Column(
                                  children: [
                                    Container(
                                      height: 73,
                                      child: Row(
                                        children: [
                                          Container(
                                            height: 73,
                                            width: 73,
                                            alignment: Alignment.centerRight,
                                            child: Image.network(
                                              "${state.transactions['data']['transaction'][index]['logo']}" ??
                                                  "",
                                              height: double.infinity,
                                              width: double.infinity,
                                              fit: BoxFit.fill,
                                              errorBuilder: (context, exception,
                                                  stacktrac) {
                                                return Expanded(
                                                    child: Image.asset(
                                                  'assets/images/noimage.png',
                                                  color: Colors.grey,
                                                  height: double.infinity,
                                                  width: double.infinity,
                                                  fit: BoxFit.fill,
                                                ));
                                              },
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(top: 10),
                                            height: 73,
                                            width: 160,
                                            child: Directionality(
                                              textDirection: TextDirection.rtl,
                                              child: Text(
                                                state.transactions['data'][
                                                                    'transaction']
                                                                    [index]
                                                                    ['receiver']
                                                                .toString()
                                                                .trim() !=
                                                            null &&
                                                        state.transactions[
                                                                    'data'][
                                                                    'transaction']
                                                                    [index]
                                                                    ['receiver']
                                                                .toString()
                                                                .trim() !=
                                                            ""
                                                    ? "${state.transactions['data']['transaction'][index]['receiver']}"
                                                    : "هزینه عمومی",
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 18),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              height: 73,
                                              child: Column(
                                                children: [
                                                  Container(
                                                    alignment:
                                                        Alignment.topLeft,
                                                    margin: EdgeInsets.only(
                                                        top: 12, left: 5),
                                                    child: Text(
                                                        "${state.transactions['data']['transaction'][index]['amount'].toString()} تومان",
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color: Colors.white,
                                                            fontSize: 16)),
                                                  ),
                                                  Container(
                                                    alignment:
                                                        Alignment.topLeft,
                                                    margin: EdgeInsets.only(
                                                        top: 18, left: 5),
                                                    child: Text(
                                                        "${state.transactions['data']['transaction'][index]['date'].substring(10, 19)}  " +
                                                            "${persianDate3.toJalaali()}",
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w100,
                                                            color: Colors
                                                                .yellowAccent,
                                                            fontSize: 10)),
                                                  )
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                        child: Container(
                                      margin: EdgeInsets.only(right: 73),
                                      decoration: BoxDecoration(
                                          shape: BoxShape.rectangle,
                                          color: Colors.black12),
                                    ))
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }
                  }
                  return Center(child: Text("چیزی برای نمایش وجود ندارد"));
                },
              )
            ],
          ),
        ));
  }
}
