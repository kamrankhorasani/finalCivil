import 'package:civil_project/logic/storage_get_import_cubit/storage_get_import_cubit.dart';
import 'package:civil_project/logic/storeage_get_extract_cubit/storeage_get_extract_cubit.dart';
import 'package:civil_project/logic/storeage_stock_cubit/storeagestock_cubit.dart';
import 'package:civil_project/screens/storage/extraction.dart';
import 'package:civil_project/screens/storage/importation.dart';
import 'package:civil_project/screens/storage/stock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StorageScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 1,
      length: 3,
      child: Scaffold(
        drawer: Drawer(),
        appBar: AppBar(
          centerTitle: true,
          bottom: TabBar(
            indicatorColor: Colors.amber,
            tabs: [Text("خروجی"), Text("موجودی"), Text("ورودی")],
          ),
          title: Text('انبار',style: TextStyle(fontWeight:FontWeight.bold)),
        ),
        body: TabBarView(
          children: [
            BlocProvider(
              create: (context) => StorageGetExtractCubit(),
              child: StorageExtraction(),
            ),
            BlocProvider(
              create: (context) => StorageGetStockCubit(),
              child: StorageStock(),
            ),
            BlocProvider(
              create: (context) => StorageGetImportCubit(),
              child: StorageImportation(),
            )
          ],
        ),
      ),
    );
  }
}
