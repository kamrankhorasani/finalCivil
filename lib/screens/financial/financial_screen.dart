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
          child: Icon(Icons.payment_rounded),
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
          title: Align(alignment: Alignment.centerRight, child: Text('پروژه')),
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
                            enableInteractiveSelection:
                                false, // *** this is important to prevent user interactive selection ***
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
                            enableInteractiveSelection:
                                false, // *** this is important to prevent user interactive selection ***
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
                                decoration: containerShadow,
                                height: height * 0.08,
                                padding: EdgeInsets.symmetric(horizontal:width*0.02),
                                margin: EdgeInsets.symmetric(
                                    horizontal: width * 0.02,
                                    vertical: height * 0.01),
                                child: Row(
                                  textDirection: TextDirection.rtl,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Image.network(
                                      "${state.transactions['data']['transaction'][index]['logo']}" ??
                                          "",
                                      fit: BoxFit.fill,
                                      errorBuilder:
                                          (context, exception, stacktrac) {
                                        return Image.asset(
                                            'assets/images/noimage.png',
                                            fit: BoxFit.fill,
                                            color: Colors.grey);
                                      },
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(height: 10),
                                        Text(state.transactions['data'][
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
                                                overflow: TextOverflow.ellipsis,),
                                        Text(
                                            "${state.transactions['data']['transaction'][index]['amount'].toString()} تومان"),
                                        SizedBox(height: 10),
                                        // Text(
                                        //     "${persianConverter(state.transactions['data']['transaction'][index]['description'].toString())}")
                                      ],
                                    ),
                                    SizedBox(width: width * 0.02),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(height: 10),
                                        Text("${persianDate3.toJalaali()}"),
                                        Text(
                                            "${state.transactions['data']['transaction'][index]['date'].substring(10, 19)}"),
                                        SizedBox(height: 10),
                                      ],
                                    ),
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
