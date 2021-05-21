import 'package:civil_project/logic/checklist_cubit/checklist_cubit.dart';
import 'package:civil_project/logic/login_cubit/login_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CheckList extends StatefulWidget {
  @override
  _CheckListState createState() => _CheckListState();
}

class _CheckListState extends State<CheckList> {
  List items = [];
  List<bool> isCheckedList = [];
  @override
  void initState() {
    super.initState();
    BlocProvider.of<ChecklistCubit>(context).gettingChecklist(
      token: BlocProvider.of<LoginCubit>(context).token,
      activityId: BlocProvider.of<LoginCubit>(context).activityId,
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: RaisedButton(
          padding: EdgeInsets.symmetric(
              horizontal: height * 0.2, vertical: height * 0.02),
          child: Text("ثبت"),
          onPressed: () async {
            await BlocProvider.of<ChecklistCubit>(context).updatingChecklist(
                token: BlocProvider.of<LoginCubit>(context).token,
                activityId: BlocProvider.of<LoginCubit>(context).activityId,
                items: items);
          },
          color: Colors.green,
          textColor: Colors.white),
      appBar: AppBar(
        title: Text("چک لیست"),
      ),
      body: BlocConsumer<ChecklistCubit, ChecklistState>(
        listener: (context, state) {
          if (state is AddingChecklist) {
            Scaffold.of(context)
              ..removeCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text("در حال ثبت")));
          }
          if (state is AddedChecklist) {
            Scaffold.of(context)
              ..removeCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text("ثبت شد")));
          }
        },
        builder: (context, state) {
          if (state is LoadingChecklist) {
            return Center(child: CircularProgressIndicator());
          }
          if (state is LoadedChecklist) {
            if (state.checklists['data'] == null) {
              return Center(child: Text("چیزی برای نمایش وجود ندارد"));
            } else {
              return ListView.separated(
                separatorBuilder: (context, index) => Divider(),
                itemCount: (state.checklists['data'] as List).length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: Column(
                        textDirection: TextDirection.rtl,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            textDirection: TextDirection.rtl,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                    "${state.checklists['data'][index]['title']}"),
                              ),
                            ],
                          ),
                          Divider(),
                          state.checklists['data'][index]['items'] == null
                              ? Center(child: Text("آیتمی وجود ندارد"))
                              : SizedBox(
                                  height: height * 0.2,
                                  child: ListView.separated(
                                      itemBuilder: (context, indx) {
                                        (state.checklists['data'][index]
                                                ['items'] as List)
                                            .forEach((e) {
                                          if (e["is_checked"] == 0) {
                                            isCheckedList.add(false);
                                          }
                                          if (e["is_checked"] == 1) {
                                            isCheckedList.add(true);
                                          }
                                        });

                                        return CheckboxListTile(
                                          title: Text(state.checklists['data']
                                              [index]['items'][indx]['title']),
                                          value: isCheckedList[indx],
                                          selected: isCheckedList[indx],
                                          onChanged: (value) {
                                            setState(() {
                                              isCheckedList[indx] = value;
                                            });
                                            if (isCheckedList[indx] == false) {
                                              items.add({
                                                "item_id": state
                                                            .checklists['data']
                                                        [index]['items'][indx]
                                                    ["checklist_item_id"],
                                                "is_checked": 0
                                              });
                                            } else {
                                              items.add({
                                                "item_id": state
                                                            .checklists['data']
                                                        [index]['items'][indx]
                                                    ["checklist_item_id"],
                                                "is_checked": 1
                                              });
                                            }
                                          },
                                        );
                                      },
                                      separatorBuilder: (context, indx) =>
                                          SizedBox(),
                                      itemCount: (state.checklists['data']
                                              [index]['items'] as List)
                                          .length)),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          }
          return Center(child: Text("چیزی برای نمایش وجود ندارد"));
        },
      ),
    );
  }
}
