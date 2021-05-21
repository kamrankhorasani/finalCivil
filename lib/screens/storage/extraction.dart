import 'package:civil_project/constants/constantdecorations.dart';
import 'package:civil_project/logic/login_cubit/login_cubit.dart';
import 'package:civil_project/logic/storeage_get_extract_cubit/storeage_get_extract_cubit.dart';
import 'package:civil_project/screens/homee/home_items.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StorageExtraction extends StatefulWidget {
  @override
  _StorageExtractionState createState() => _StorageExtractionState();
}

class _StorageExtractionState extends State<StorageExtraction> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<StorageGetExtractCubit>(context).getExtraction(
        token: BlocProvider.of<LoginCubit>(context).token,
        projectId: BlocProvider.of<LoginCubit>(context).projectId);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // FloatingActionButton(
            //   onPressed: () {},
            //   child: Icon(Icons.search),
            //   tooltip: "جستجو",
            //   heroTag: "Search",
            // ),
            SizedBox(
              width: width * 0.01,
            ),
            FloatingActionButton(
                tooltip: "اضافه کردن",
                heroTag: "Add",
                onPressed: () async {
                  if (globalChoiceActivityId != null) {
                    Navigator.pushNamed(context, '/addextraction');
                    print(globalChoiceActivityId);
                  } else {
                    showDialog(
                        builder: (context) => AlertDialog(
                          title:
                              Text("لطفا برای ادامه کار یک فعالیت انتخاب کنید"),
                          actions: [
                            TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text("باشه"))
                          ],
                        ), context: context);
                  }
                },
                child: Icon(Icons.add))
          ],
        ),
        body: Column(
          children: [
            BlocBuilder<StorageGetExtractCubit, StoreageGetExtractState>(
              builder: (context, state) {
                if (state is StoreageGetExtractLoading) {
                  return Center(child: CircularProgressIndicator());
                }
                if (state is StoreageGetExtractLoaded) {
                  if (state.extraction['data'] == null) {
                    return Text("چیزی برای نمایش وجود ندارد");
                  } else {
                    return Expanded(
                      child: ListView.builder(
                          itemCount: state.extraction['data'].length,
                          itemBuilder: (context, index) {
                            return Directionality(
                              textDirection: TextDirection.rtl,
                              child: Container(
                                height: height * 0.3,
                                width: double.minPositive,
                                decoration: containerShadow,
                                margin: EdgeInsets.symmetric(
                                    horizontal: width * 0.05,
                                    vertical: height * 0.03),
                                padding: EdgeInsets.symmetric(
                                    horizontal: width * 0.06),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Center(
                                            child: Image.network(
                                          '${state.extraction['data'][index]['logo']}',
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  Image.asset(
                                            "assets/images/noimage.png",
                                            color: Colors.grey,
                                          ),
                                        )),
                                        VerticalDivider(color: Colors.grey),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                                "${state.extraction['data'][index]['title']}"),
                                            Text(
                                                "مقدار:    ${state.extraction['data'][index]['amount']}")
                                          ],
                                        ),
                                      ],
                                    ),
                                    Divider(),
                                    state.extraction['data'][index]
                                                ['confirms'] ==
                                            null
                                        ? Text("تاییدی وجود ندارد")
                                        : SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Row(
                                              children: (state.extraction[
                                                          'data'][index]
                                                      ['confirms'] as List)
                                                  .map((e) => Row(
                                                        children: [
                                                          e['is_confirm'] == 1
                                                              ? Icon(
                                                                  Icons
                                                                      .thumb_up_alt,
                                                                  color: Colors
                                                                      .green)
                                                              : Icon(
                                                                  Icons
                                                                      .thumb_down_alt,
                                                                  color: Colors
                                                                      .red),
                                                          Text("${e["role"]}"),
                                                          Text(
                                                              "${e['response']['msg']}"),
                                                          SizedBox(width: 7)
                                                        ],
                                                      ))
                                                  .toList(),
                                            ),
                                          )
                                  ],
                                ),
                              ),
                            );
                          }),
                    );
                  }
                }

                return Center(child: Text('چیزی پیدا نشد'));
              },
            ),
          ],
        ));
  }
}
