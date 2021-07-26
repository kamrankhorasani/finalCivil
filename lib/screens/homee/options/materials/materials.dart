import 'package:civil_project/constants/constantdecorations.dart';
import 'package:civil_project/logic/add_extraction_cubit/add_extraction_cubit.dart';
import 'package:civil_project/logic/login_cubit/login_cubit.dart';
import 'package:civil_project/screens/homee/home_items.dart';
import 'package:civil_project/widgets/boxes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MaterialDialog extends StatefulWidget {
  final String amounT;
  final String description;
  final int choose;
  final int itemId;
  final bool isUpdate;
  final int stockId;
  final String fehrestCode;

  final String type;

  MaterialDialog(
      {this.amounT,
      this.fehrestCode,
      this.description,
      this.type,
      this.choose,
      this.itemId,
      this.stockId,
      this.isUpdate});
  @override
  _MaterialDialogState createState() => _MaterialDialogState();
}

class _MaterialDialogState extends State<MaterialDialog> {
  final TextEditingController _amount = TextEditingController();
  final TextEditingController _descript = TextEditingController();
  int choiceMaterial;
  String fehrestCode;
  @override
  void dispose() {
    super.dispose();
    _amount.dispose();
    _descript.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (widget.isUpdate == true) {
      _amount.text = widget.amounT;
      _descript.text = widget.description;
      choiceMaterial = widget.stockId;
      fehrestCode = widget.fehrestCode;

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
                margin: EdgeInsets.all(width * 0.02),
                child: BlocBuilder<AddExtractionCubit, AddExtractionState>(
                  builder: (context, state) {
                    if (state is LoadingMaterials) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (state is LoadedMaterials) {
                      return DropdownButtonHideUnderline(
                        child: DropdownButton(
                          isExpanded: true,
                          disabledHint: Text("نوع"),
                          value: choiceMaterial,
                          underline: Divider(
                            color: Colors.white,
                          ),
                          hint: Text("نوع"),
                          items: (state.materials['data']['items'] as List)
                              .map((e) => DropdownMenuItem(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: width * 0.01),
                                      child: Text(
                                        e['title'],
                                        textDirection: TextDirection.rtl,
                                      ),
                                    ),
                                    value: e['id'],
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              choiceMaterial = value;
                            });
                          },
                        ),
                      );
                    }
                    return Container();
                  },
                ),
              ),
              Container(
                decoration: containerShadow,
                padding: EdgeInsets.symmetric(horizontal: width * 0.02),
                margin: EdgeInsets.all(width * 0.02),
                child: BlocBuilder<AddExtractionCubit, AddExtractionState>(
                  builder: (context, state) {
                    if (state is LoadingMaterials) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (state is LoadedMaterials) {
                      return DropdownButtonHideUnderline(
                        child: DropdownButton(
                          isExpanded: true,
                          disabledHint: Text("فهرست بها"),
                          value: fehrestCode,
                          hint: Padding(
                            padding: EdgeInsets.only(right: 8.0),
                            child: Text("فهرست بها"),
                          ),
                          items: (state.fehrest['data'] as List ?? [])
                              .map((e) => DropdownMenuItem(
                                    child: Text(e['title']),
                                    value: e['code'],
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              fehrestCode = value;
                            });
                          },
                        ),
                      );
                    }
                    return Container(
                      child: Text(""),
                    );
                  },
                ),
              ),
              BlocListener<AddExtractionCubit, AddExtractionState>(
                listener: (context, state) {
                  if (state is ExtractionAdded) {
                    _amount.clear();
                    _descript.clear();
                    setState(() {
                      choiceMaterial = null;
                    });
                    Navigator.pop(context);
                  }
                  if (state is UpdatedExtraction) {
                    _amount.clear();
                    _descript.clear();
                    setState(() {
                      choiceMaterial = null;
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
        BlocBuilder<AddExtractionCubit, AddExtractionState>(
          builder: (context, state) {
            if (state is AddingExtraction) {
              return Center(child: CircularProgressIndicator());
            }
            if (state is UpdatingExtraction) {
              return Center(child: CircularProgressIndicator());
            } else {
              return Container(
                height: height * 0.08,
                margin: EdgeInsets.symmetric(
                    horizontal: width * 0.01, vertical: height * 0.05),
                child: RaisedButton(
                  onPressed: () async {
                    if (widget.isUpdate == false) {
                      await BlocProvider.of<AddExtractionCubit>(context)
                          .addExtraction(
                              token: BlocProvider.of<LoginCubit>(context).token,
                              projectId: BlocProvider.of<LoginCubit>(context)
                                  .projectId,
                              activityId: BlocProvider.of<LoginCubit>(context)
                                  .activityId,
                              amount: _amount.text,
                              itemId: choiceMaterial,
                              info: _descript.text,
                              fehrestCode: fehrestCode);
                    }
                    if (widget.isUpdate == true) {
                      await BlocProvider.of<AddExtractionCubit>(context)
                          .updatingExtraction(
                              token: BlocProvider.of<LoginCubit>(context).token,
                              projectId: BlocProvider.of<LoginCubit>(context)
                                  .projectId,
                              activityId: BlocProvider.of<LoginCubit>(context)
                                  .activityId,
                              amount: _amount.text,
                              itemId: widget.itemId,
                              description: _descript.text,
                              stockId: choiceMaterial,
                              fehrestCode: fehrestCode);
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

class Materials extends StatefulWidget {
  @override
  _MaterialsState createState() => _MaterialsState();
}

class _MaterialsState extends State<Materials> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<AddExtractionCubit>(context).getMaterilas(
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
        title: Text("مصالح"),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await showDialog(
            context: context,
            builder: (_) => BlocProvider.value(
              value: context.read<AddExtractionCubit>(),
              child: MaterialDialog(
                isUpdate: false,
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
          Row(
            children: [
              Expanded(
                  child: activityBox(height, width,
                      actvity:
                          BlocProvider.of<LoginCubit>(context).activityTitle)),
              SizedBox(width: width * 0.03),
              Expanded(
                  child:
                      dateBox(height, width, date: globalDateController.text)),
            ],
          ),
          BlocListener<AddExtractionCubit, AddExtractionState>(
            listener: (context, state) {
              if (state is ExtractionAdded) {
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
                if (state is DeletedExtraction) {
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
                  if (state is UpdatedExtraction) {
                    if (state.succes == false) {
                      Scaffold.of(context)
                        ..removeCurrentSnackBar()
                        ..showSnackBar(
                            SnackBar(content: Text("متاسفانه بعلت کمبود موجودی بروز نشد")));
                    } else {
                      Scaffold.of(context)
                        ..removeCurrentSnackBar()
                        ..showSnackBar(
                            SnackBar(content: Text("با موفقیت بروز شد")));
                    }
                    if (state is FailedDeletingExtraction) {
                      Scaffold.of(context)
                        ..removeCurrentSnackBar()
                        ..showSnackBar(
                            SnackBar(content: Text("مشکلی پیش آمده است")));
                    }
                    if (state is FailedUpdatingExtraction) {
                      Scaffold.of(context)
                        ..removeCurrentSnackBar()
                        ..showSnackBar(
                            SnackBar(content: Text("مشکلی پیش آمده است")));
                    }
                    if (state is AddingExtractionFailed) {
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
          BlocBuilder<AddExtractionCubit, AddExtractionState>(
            builder: (context, state) {
              if (state is LoadingMaterials) {
                return Center(child: CircularProgressIndicator());
              }
              if (state is LoadedMaterials) {
                if (state.storageExtractions['data'] == null) {
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
                                  horizontal: width * 0.01),
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
                                              "${state.storageExtractions['data'][index]['title'] ?? "بدون عنوان"}  مقدار: ${state.storageExtractions['data'][index]['amount'] ?? 0}",
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
                                                "${state.storageExtractions['data'][index]['info'] ?? ""}",
                                                maxLines: 5,
                                                overflow: TextOverflow.visible,
                                                textDirection:
                                                    TextDirection.rtl,
                                              )),
                                        ),
                                        Expanded(
                                          child: Text(
                                            " ${state.storageExtractions['data'][index]['unit'] ?? ""}",
                                          ),
                                        ),
                                        Divider(),
                                        state.storageExtractions['data'][index]
                                                    ['confirms'] ==
                                                null
                                            ? Text("تاییدی وجود ندارد")
                                            : SingleChildScrollView(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                child: Row(
                                                  children:
                                                      (state.storageExtractions[
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
                                                                      AddExtractionCubit>(
                                                                  context)
                                                              .deletingExtraction(
                                                            token: BlocProvider
                                                                    .of<LoginCubit>(
                                                                        context)
                                                                .token,
                                                            projectId: BlocProvider
                                                                    .of<LoginCubit>(
                                                                        context)
                                                                .projectId,
                                                            activityId: BlocProvider
                                                                    .of<LoginCubit>(
                                                                        context)
                                                                .activityId,
                                                            itemId:
                                                                state.storageExtractions[
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
                                                        AddExtractionCubit>(),
                                                    child: MaterialDialog(
                                                      isUpdate: true,
                                                      itemId: state
                                                              .storageExtractions[
                                                          'data'][index]['id'],
                                                      amounT: state
                                                          .storageExtractions[
                                                              'data'][index]
                                                              ['amount']
                                                          .toString(),
                                                      description: state
                                                              .storageExtractions[
                                                          'data'][index]['info'],
                                                      stockId:
                                                          state.storageExtractions[
                                                                  'data'][index]
                                                              ['stockId'],
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
                        itemCount: state.storageExtractions['data'].length),
                  );
                }
              }
              return Center(child: Text("چیزی برای نمایش وجود ندارد"));
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
