import 'package:civil_project/constants/constantdecorations.dart';
import 'package:civil_project/logic/worker_cubit/worker_cubit.dart';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persian_datepicker/persian_datepicker.dart';

class Contract extends StatefulWidget {
  @override
  _ContractState createState() => _ContractState();
}

class _ContractState extends State<Contract> {
  PersianDatePickerWidget startDatePicker;
  PersianDatePickerWidget endDatePicker;
  @override
  void initState() {
    super.initState();
    
    startDatePicker = PersianDatePicker(
      controller: BlocProvider.of<WorkerCubit>(context).startDate,
      fontFamily: 'Vazir',
      farsiDigits: true,
      onChange: (oldText, newText) => Navigator.pop(context),
    ).init();
    endDatePicker = PersianDatePicker(
      controller: BlocProvider.of<WorkerCubit>(context).endDate,
      fontFamily: 'Vazir',
      farsiDigits: true,
      onChange: (oldText, newText) => Navigator.pop(context),
    ).init();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
            horizontal: width * 0.05, vertical: height * 0.05),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          textDirection: TextDirection.rtl,
          children: [
            SizedBox(height: height * 0.06),
            Container(
              decoration: containerShadow,
              padding: EdgeInsets.symmetric(
                  horizontal: width * 0.03, vertical: height * 0.015),
              height: height * 0.55,
              child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              child: _textFields(height * 0.07, width,
                                  hintText: "موضوع",
                                  controller:
                                      BlocProvider.of<WorkerCubit>(context)
                                          .contractTitle)),
                          Expanded(
                              child: _textFields(height * 0.07, width,
                                  hintText: "قیمت",
                                  keyboardType: TextInputType.numberWithOptions(
                                      decimal: true),
                                  controller:
                                      BlocProvider.of<WorkerCubit>(context)
                                          .contractPrice))
                        ],
                      ),
                      _textFields(height * 0.15, width,
                          hintText: "شرح پرداخت",
                          controller: BlocProvider.of<WorkerCubit>(context)
                              .contractCondition),
                      Row(
                        children: [
                          Expanded(
                              child: _textFields(height * 0.07, width,
                                  hintText: "پیش پرداخت",
                                  keyboardType: TextInputType.numberWithOptions(
                                      decimal: true),
                                  controller:
                                      BlocProvider.of<WorkerCubit>(context)
                                          .contractPrepay)),
                          Expanded(
                              child: _textFields(height * 0.07, width,
                                  hintText: "حسن انجام کار",
                                  keyboardType: TextInputType.numberWithOptions(
                                      decimal: true),
                                  controller:
                                      BlocProvider.of<WorkerCubit>(context)
                                          .contractPostpay)),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(right: width*0.02),
                              decoration: containerShadow,
                              child: TextField(
                                textAlign: TextAlign.center,
                                decoration: new InputDecoration.collapsed(
                                    hintText: 'از'),
                                enableInteractiveSelection:
                                    false, // *** this is important to prevent user interactive selection ***
                                onTap: () {
                                  FocusScope.of(context).requestFocus(
                                      new FocusNode()); //*** to prevent opening default keyboard
                                  showModalBottomSheet(
                                      isScrollControlled: true,
                                      context: context,
                                      builder: (BuildContext context) {
                                        return startDatePicker;
                                      });
                                },
                                controller:
                                    BlocProvider.of<WorkerCubit>(context)
                                        .startDate,
                              ),
                            ),
                          ),
                          SizedBox(width: width * 0.06),
                          Expanded(
                            child: Container(
                                margin: EdgeInsets.only(left: width*0.02),
                              decoration: containerShadow,
                              child: TextField(
                                textAlign: TextAlign.center,
                                decoration: new InputDecoration.collapsed(
                                    hintText: 'تا'),
                                enableInteractiveSelection:
                                    false, // *** this is important to prevent user interactive selection ***
                                onTap: () {
                                  FocusScope.of(context).requestFocus(
                                      new FocusNode()); //*** to prevent opening default keyboard
                                  showModalBottomSheet(
                                      isScrollControlled: true,
                                      context: context,
                                      builder: (BuildContext context) {
                                        return endDatePicker;
                                      });
                                },
                                controller:
                                    BlocProvider.of<WorkerCubit>(context)
                                        .endDate,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }
}

_textFields(double height, double width,
    {TextEditingController controller,
    String hintText,
    TextInputType keyboardType = TextInputType.multiline}) {
  return Container(
    margin: EdgeInsets.all(width * 0.02),
    padding: EdgeInsets.only(right: width * 0.02),
    height: height,
    child: Directionality(
      textDirection: TextDirection.rtl,
      child: TextField(
        controller: controller,
        style: TextStyle(fontSize: width * 0.04),
        textDirection: TextDirection.rtl,
        keyboardType: keyboardType,
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
