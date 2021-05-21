import 'package:civil_project/logic/worker_cubit/worker_cubit.dart';
import 'package:civil_project/screens/homee/options/subcontractor/attachment.dart';
//import 'package:civil_project/screens/homee/options/subcontractor/attachment.dart';
import 'package:civil_project/screens/homee/options/subcontractor/contract.dart';
import 'package:civil_project/screens/homee/options/subcontractor/workers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SubContractor extends StatefulWidget {
  @override
  _SubContractorState createState() => _SubContractorState();
}

class _SubContractorState extends State<SubContractor> {
  final WorkerCubit _workerCubit = WorkerCubit();
  

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Align(
            child: Text("پیمانکاران جزء"),
            alignment: Alignment.centerRight,
          ),
          bottom: TabBar(
            indicatorColor: Colors.amber,
            tabs: [
              Text("نیروها"),
              Text("ضمائم"),
              Text("مفاد قرارداد"),
            ],
          ),
        ),
        body: TabBarView(children: [
          BlocProvider.value(value: _workerCubit, child: Workers()),
          BlocProvider.value(value: _workerCubit, child: Attachments()),
          BlocProvider.value(value: _workerCubit, child: Contract()),
        ]),
      ),
    );
  }
}
