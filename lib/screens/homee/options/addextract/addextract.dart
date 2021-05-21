import 'package:civil_project/constants/constantdecorations.dart';
import 'package:civil_project/logic/addallextraction_cubit/alladdextraction_cubit.dart';
import 'package:civil_project/logic/login_cubit/login_cubit.dart';
import 'package:civil_project/widgets/boxes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../home_items.dart';

class ExtractionDialog extends StatefulWidget {
  final String amounT;
  final String description;
  final int choose;
  final int itemId;
  final bool addOrupdate;
  final String type;

  ExtractionDialog(
      {this.amounT,
      this.description,
      this.type,
      this.choose,
      this.itemId,
      this.addOrupdate});
  @override
  _ExtractionDialogState createState() => _ExtractionDialogState();
}

class _ExtractionDialogState extends State<ExtractionDialog> {
  final TextEditingController _amount = TextEditingController();
  final TextEditingController _descript = TextEditingController();
  int choiceExtraction;
  @override
  void dispose() {
    super.dispose();
    _amount.dispose();
    _descript.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (widget.addOrupdate == true) {
      _amount.text = widget.amounT;
      _descript.text = widget.description;
      choiceExtraction = widget.choose;
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return SimpleDialog(
      children: [
        Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            textDirection: TextDirection.rtl,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                decoration: containerShadow,
                padding: EdgeInsets.symmetric(horizontal: width * 0.02),
                margin: EdgeInsets.all(width * 0.02),
                child:
                    BlocBuilder<AlladdextractionCubit, AlladdextractionState>(
                  builder: (context, state) {
                    if (state is LoadingAllExtraction) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (state is LoadedAllExtraction) {
                      return DropdownButtonHideUnderline(
                        child: DropdownButton(
                          disabledHint: Text("نوع"),
                          value: choiceExtraction,
                          underline: Divider(
                            color: Colors.white,
                          ),
                          hint: Text("نوع"),
                          items: (state.all['data']['items'] as List)
                              .map((e) => DropdownMenuItem(
                                    child: Text(e['title']),
                                    value: e['id'],
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              choiceExtraction = value;
                            });
                          },
                        ),
                      );
                    }
                    return Container();
                  },
                ),
              ),
              BlocListener<AlladdextractionCubit, AlladdextractionState>(
                listener: (context, state) {
                  if (state is AllExtractionAdded) {
                    _amount.clear();
                    _descript.clear();
                    setState(() {
                      choiceExtraction = null;
                    });
                    Navigator.pop(context);
                  }
                  if (state is UpdatedAllExtraction) {
                    _amount.clear();
                    _descript.clear();
                    setState(() {
                      choiceExtraction = null;
                    });
                    Navigator.pop(context);
                  }
                },
                child: SizedBox(
                  height: height * 0.03,
                ),
              ),
              _textFields(height, width,
                  hintText: "مقدار",
                  controller: _amount,
                  keyboardtype: TextInputType.numberWithOptions()),
              _textFields(height * 1.5, width,
                  hintText: "توضیحات", controller: _descript),
            ],
          ),
        ),
        BlocBuilder<AlladdextractionCubit, AlladdextractionState>(
          builder: (context, state) {
            if (state is AddingAllExtraction) {
              return Center(child: CircularProgressIndicator());
            }
            if (state is UpdatingAllExtraction) {
              return Center(child: CircularProgressIndicator());
            } else {
              return Container(
                height: height * 0.08,
                margin: EdgeInsets.symmetric(
                    horizontal: width * 0.01, vertical: height * 0.05),
                child: RaisedButton(
                  onPressed: () async {
                    if (widget.addOrupdate == false) {
                      await BlocProvider.of<AlladdextractionCubit>(context)
                          .addExtraction(
                              token: BlocProvider.of<LoginCubit>(context).token,
                              projectId: BlocProvider.of<LoginCubit>(context)
                                  .projectId,
                              activityId: BlocProvider.of<LoginCubit>(context)
                                  .activityId,
                              amount: _amount.text,
                              itemId: choiceExtraction,
                              info: _descript.text,
                              type: widget.type);
                    }
                    if (widget.addOrupdate == true) {
                      await BlocProvider.of<AlladdextractionCubit>(context)
                          .updatingExtraction(
                              token: BlocProvider.of<LoginCubit>(context).token,
                              projectId: BlocProvider.of<LoginCubit>(context)
                                  .projectId,
                              activityId: BlocProvider.of<LoginCubit>(context)
                                  .activityId,
                              amount: _amount.text,
                              itemId: choiceExtraction,
                              description: _descript.text,
                              type: widget.type);
                    }
                  },
                  child: Text("ثبت", style: TextStyle(color: Colors.white)),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  elevation: 10,
                  color: Colors.green,
                ),
              );
            }
          },
        )
      ],
    );
  }
}

class Extractions extends StatefulWidget {
  @override
  _ExtractionsState createState() => _ExtractionsState();
}

class _ExtractionsState extends State<Extractions> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<AlladdextractionCubit>(context).getMaterilas(
      token: BlocProvider.of<LoginCubit>(context).token,
      projectid: BlocProvider.of<LoginCubit>(context).projectId,
      activityId: BlocProvider.of<LoginCubit>(context).activityId,
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("انبار خروجی"),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await showDialog(
            context: context,
            builder: (_) => BlocProvider.value(
              value: context.read<AlladdextractionCubit>(),
              child: ExtractionDialog(
                addOrupdate: false,
              ),
            ),
          );
        },
        label: Text("اضافه کردن"),
        icon: Icon(Icons.add),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        textDirection: TextDirection.rtl,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: height * 0.05, horizontal: width * 0.02),
            child: Row(
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
          ),
          BlocListener<AlladdextractionCubit, AlladdextractionState>(
            listener: (context, state) {
              if (state is AllExtractionAdded) {
                if (state.succes == false) {
                  Scaffold.of(context)
                    ..removeCurrentSnackBar()
                    ..showSnackBar(
                        SnackBar(content: Text("متاسفانه اضافه نشد")));
                } else {
                  Scaffold.of(context)
                    ..removeCurrentSnackBar()
                    ..showSnackBar(
                        SnackBar(content: Text("با موفقیت اضافه شد")));
                }
                if (state is DeletedAllExtraction) {
                  if (state.succes == false) {
                    Scaffold.of(context)
                      ..removeCurrentSnackBar()
                      ..showSnackBar(
                          SnackBar(content: Text("متاسفانه حذف نشد")));
                  } else {
                    Scaffold.of(context)
                      ..removeCurrentSnackBar()
                      ..showSnackBar(
                          SnackBar(content: Text("با موفقیت حذف شد")));
                  }
                  if (state is UpdatedAllExtraction) {
                    if (state.succes == false) {
                      Scaffold.of(context)
                        ..removeCurrentSnackBar()
                        ..showSnackBar(
                            SnackBar(content: Text("متاسفانه بروز نشد")));
                    } else {
                      Scaffold.of(context)
                        ..removeCurrentSnackBar()
                        ..showSnackBar(
                            SnackBar(content: Text("با موفقیت بروز شد")));
                    }
                    if (state is FailedDeletingAllExtraction) {
                      Scaffold.of(context)
                        ..removeCurrentSnackBar()
                        ..showSnackBar(
                            SnackBar(content: Text("مشکلی پیش آمده است")));
                    }
                    if (state is FailedUpdatingAllExtraction) {
                      Scaffold.of(context)
                        ..removeCurrentSnackBar()
                        ..showSnackBar(
                            SnackBar(content: Text("مشکلی پیش آمده است")));
                    }
                    if (state is AddingAllExtractionFailed) {
                      Scaffold.of(context)
                        ..removeCurrentSnackBar()
                        ..showSnackBar(
                            SnackBar(content: Text("مشکلی پیش آمده است")));
                    }
                  }
                }
              }
            },
            child: SizedBox(height: height * 0.04),
          ),
          BlocBuilder<AlladdextractionCubit, AlladdextractionState>(
            builder: (context, state) {
              if (state is LoadingAllExtraction) {
                return Center(child: CircularProgressIndicator());
              }
              if (state is LoadedAllExtraction) {
                if (state.storageAllExtractions['data'] == null) {
                  return Center(child: Text("چیزی برای نمایش وجود ندارد"));
                } else {
                  return Expanded(
                    child: ListView.separated(
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Directionality(
                            textDirection: TextDirection.rtl,
                            child: Container(
                              height: height * 0.5,
                              decoration: containerShadow,
                              margin: EdgeInsets.symmetric(
                                  horizontal: width * 0.04),
                              padding: EdgeInsets.symmetric(
                                  horizontal: width * 0.05,
                                  vertical: height * 0.02),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  IntrinsicWidth(
                                    stepWidth: width * 0.6,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Row(
                                          textDirection: TextDirection.rtl,
                                          children: [
                                            Text(
                                              "${state.storageAllExtractions['data'][index]['title'] ?? "بدون عنوان"}  مقدار: ${state.storageAllExtractions['data'][index]['amount'] ?? ""}",
                                              overflow: TextOverflow.fade,
                                            ),
                                          ],
                                        ),
                                        Divider(),
                                        Expanded(
                                          child: ConstrainedBox(
                                              constraints: BoxConstraints(
                                                  maxWidth: width * 0.1),
                                              child: Text(
                                                "${state.storageAllExtractions['data'][index]['info'] ?? ""}",
                                                maxLines: 5,
                                                overflow: TextOverflow.visible,
                                                textDirection:
                                                    TextDirection.rtl,
                                              )),
                                        ),
                                        Expanded(
                                          child: Text(
                                            " ${state.storageAllExtractions['data'][index]['unit'] ?? ""}",
                                          ),
                                        ),
                                        Divider(),
                                        state.storageAllExtractions['data']
                                                    [index]['confirms'] ==
                                                null
                                            ? Text("تاییدی وجود ندارد")
                                            : SingleChildScrollView(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                child: Row(
                                                  children:
                                                      (state.storageAllExtractions[
                                                                          'data']
                                                                      [index]
                                                                  ['confirms']
                                                              as List)
                                                          .map((e) => Row(
                                                                children: [
                                                                  e['is_confirm'] ==
                                                                          1
                                                                      ? Icon(
                                                                          Icons
                                                                              .thumb_up_alt,
                                                                          color: Colors
                                                                              .green)
                                                                      : Icon(
                                                                          Icons
                                                                              .thumb_down_alt,
                                                                          color:
                                                                              Colors.red),
                                                                  Text(
                                                                      "${e["role"]}:"),
                                                                  Text(
                                                                      "${e['response']['msg']}"),
                                                                  SizedBox(
                                                                      width: 7)
                                                                ],
                                                              ))
                                                          .toList(),
                                                ),
                                              )
                                      ],
                                    ),
                                  ),
                                  VerticalDivider(
                                    endIndent: 65,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                          child: IconButton(
                                        icon: Icon(
                                          Icons.cancel_outlined,
                                          color: Colors.red[400],
                                          size: width * 0.10,
                                        ),
                                        onPressed: () async {
                                          await showDialog(
                                              context: context,
                                              builder: (ctx) {
                                                return AlertDialog(
                                                  title: Text(
                                                      "آیا از حذف مطمئن هستید؟"),
                                                  actions: [
                                                    TextButton(
                                                        onPressed: () async {
                                                          Navigator.pop(
                                                              context);
                                                          await BlocProvider.of<
                                                                      AlladdextractionCubit>(
                                                                  context)
                                                              .deletingExtraction(   token:
                                          BlocProvider.of<LoginCubit>(context)
                                              .token,
                                      projectId:
                                          BlocProvider.of<LoginCubit>(context)
                                              .projectId,
                                      activityId:
                                          BlocProvider.of<LoginCubit>(context)
                                              .activityId,
                                                            itemId:
                                                                state.storageAllExtractions[
                                                                        'data'][
                                                                    index]['id'],
                                                          );
                                                        },
                                                        child: Text("تایید")),
                                                    TextButton(
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                                context),
                                                        child: Text("لغو")),
                                                  ],
                                                );
                                              });
                                        },
                                      )),
                                      Expanded(
                                          child: IconButton(
                                        icon: Icon(
                                          Icons.edit,
                                          color: Colors.green[400],
                                          size: width * 0.12,
                                        ),
                                        onPressed: () async {
                                          await showDialog(
                                              context: context,
                                              builder: (_) =>
                                                  BlocProvider.value(
                                                    value: context.read<
                                                        AlladdextractionCubit>(),
                                                    child: ExtractionDialog(
                                                      addOrupdate: true,
                                                      itemId: state
                                                              .storageAllExtractions[
                                                          'data'][index]['id'],
                                                      amounT: state
                                                          .storageAllExtractions[
                                                              'data'][index]
                                                              ['amount']
                                                          .toString(),
                                                    ),
                                                  ));
                                        },
                                      )),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) => Divider(),
                        itemCount: state.storageAllExtractions['data'].length),
                  );
                }
              }
              return Text("چیزی برای نمایش وجود ندارد");
            },
          ),
        ],
      ),
    );
  }
}

_textFields(double height, double width,
    {TextEditingController controller,
    String hintText,
    TextInputType keyboardtype = TextInputType.multiline}) {
  return Container(
    margin: EdgeInsets.all(width * 0.02),
    padding: EdgeInsets.only(right: width * 0.02),
    height: hintText == "توضیحات" ? height * 0.1 : null,
    child: Directionality(
      textDirection: TextDirection.rtl,
      child: TextField(
        controller: controller,
        textDirection: TextDirection.rtl,
        keyboardType: keyboardtype,
        maxLines: 1,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
        ),
      ),
    ),
    decoration: containerShadow,
  );
}
