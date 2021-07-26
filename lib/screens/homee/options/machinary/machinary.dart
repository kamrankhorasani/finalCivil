import 'dart:async';

import 'package:civil_project/constants/constantdecorations.dart';
import 'package:civil_project/logic/add_extraction_cubit/add_extraction_cubit.dart';
import 'package:civil_project/logic/login_cubit/login_cubit.dart';
import 'package:civil_project/logic/machinary_cubit/machinary_cubit.dart';
import 'package:civil_project/widgets/boxes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../home_items.dart';

class MachinSearch extends StatefulWidget {
  const MachinSearch({Key key}) : super(key: key);
  @override
  _MachinSearchState createState() => _MachinSearchState();
}

class _MachinSearchState extends State<MachinSearch> {
  final TextEditingController _searchText = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool isLoading = false;
  int _currentMax = 0;
  Timer _debounce;
  _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce.cancel();
    _debounce = Timer(const Duration(seconds: 1), () async {
      print(query);
      BlocProvider.of<MachinaryCubit>(context).searchedItems.clear();
      await BlocProvider.of<MachinaryCubit>(context).searchMachine(
          token: BlocProvider.of<LoginCubit>(context).token,
          type: "TAJHIZAT",
          title1: query,
          frm: _currentMax);
    });
  }

  @override
  void dispose() {
    _searchText.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _loadMoreData();
      }
    });
    super.initState();
  }

  _loadMoreData() async {
    _currentMax += 10;
    await BlocProvider.of<MachinaryCubit>(context).loadMoreMachine(
        token: BlocProvider.of<LoginCubit>(context).token,
        type: "TAJHIZAT",
        title1: _searchText.text,
        frm: _currentMax);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return SimpleDialog(
      children: [
        Directionality(
            textDirection: TextDirection.rtl,
            child: Container(
              width: double.maxFinite,
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.all(width * 0.02),
                    padding: EdgeInsets.only(right: width * 0.02),
                    height: height * 0.065,
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: TextField(
                        controller: _searchText,
                        onChanged: _onSearchChanged,
                        textDirection: TextDirection.rtl,
                        maxLines: 1,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Icon(Icons.search_sharp),
                          hintText: "جستجو...",
                        ),
                      ),
                    ),
                    decoration: containerShadow,
                  ),
                  BlocBuilder<MachinaryCubit, MachinaryState>(
                    builder: (context, state) {
                      if (state is SearchingMachine) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (state is SearchedMachine) {
                        if (state.searchedItems == null ||
                            state.searchedItems.length == 0) {
                          return Center(
                            child: Text("چیزی برای نمایش وجود ندارد"),
                          );
                        }
                        return Container(
                            width: double.maxFinite,
                            height: height * 0.8,
                            child: ListView.separated(
                              controller: _scrollController,
                              separatorBuilder: (context, index) => Divider(),
                              itemCount:
                                  BlocProvider.of<MachinaryCubit>(context)
                                      .searchedItems
                                      .length,
                              itemBuilder: (context, index) {
                                if (state.searchedItems.length == index + 1) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      tajhizatChoose =
                                          state.searchedItems[index]['title'];
                                      choiceItem =
                                          state.searchedItems[index]['code'];
                                      print(choiceItem);
                                    });
                                    state.searchedItems.clear();
                                    Navigator.pop(context);
                                  },
                                  child: Card(
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${state.searchedItems[index]['title']}" ??
                                                "",
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          SizedBox(
                                            height: height * 0.05,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Text(
                                                  "${state.searchedItems[index]['unit']}" ??
                                                      "")
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ));
                      }
                      return Container();
                    },
                  )
                ],
              ),
            ))
      ],
    );
  }
}

enum StorageandRent { storage, rent }
String tajhizatChoose;
String choiceItem;

class MachinaryDialog extends StatefulWidget {
  final String info;
  final int itemId;
  final bool isUpdate;
  final String type;
  final String amount;
  final String fehrestCode;
  final String priceRent;
  final String resourceCode;
  final String resourceTitle;
  final int stockId;

  MachinaryDialog(
      {this.info,
      this.type,
      this.itemId,
      this.fehrestCode,
      this.amount,
      this.resourceCode,
      this.resourceTitle,
      this.priceRent,
      this.isUpdate,
      this.stockId});
  @override
  _MachinaryDialogState createState() => _MachinaryDialogState();
}

class _MachinaryDialogState extends State<MachinaryDialog> {
  final TextEditingController _amount = TextEditingController();
  final TextEditingController _rentAmount = TextEditingController();
  final TextEditingController _descript = TextEditingController();
  StorageandRent _source = StorageandRent.storage;
  String fehrestCode;
  @override
  void dispose() {
    super.dispose();
    _amount.dispose();
    _descript.dispose();
    _rentAmount.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (widget.isUpdate == true) {
      _amount.text = widget.amount;
      _rentAmount.text = widget.priceRent;
      _descript.text = widget.info;
      widget.type == "RENT"
          ? _source = StorageandRent.rent
          : _source = StorageandRent.storage;
      fehrestCode = widget.fehrestCode;
      choiceItem = widget.resourceCode;
      tajhizatChoose = widget.resourceTitle;
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return SimpleDialog(
      children: [
        BlocListener<MachinaryCubit, MachinaryState>(
          listener: (context, state) {
            if (state is ExtractionAdded) {
              Navigator.pop(context);
            }
          },
          child: Container(),
        ),
        Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            textDirection: TextDirection.rtl,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GestureDetector(
                  onTap: () async {
                    await showDialog(
                      context: context,
                      builder: (____) {
                        return BlocProvider(
                          create: (____) => MachinaryCubit(),
                          child: MachinSearch(),
                        );
                      },
                    );
                  },
                  child: Container(
                    height: height * 0.05,
                    padding: EdgeInsets.all(8),
                    margin: EdgeInsets.symmetric(horizontal: 8),
                    decoration: containerShadow,
                    child: Text(tajhizatChoose ?? "نوع"),
                  )),
              Container(
                decoration: containerShadow,
                padding: EdgeInsets.symmetric(horizontal: width * 0.02),
                margin: EdgeInsets.all(width * 0.02),
                child: BlocBuilder<MachinaryCubit, MachinaryState>(
                  builder: (context, state) {
                    if (state is LoadedMachinary) {
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
                    return DropdownButtonHideUnderline(
                      child: DropdownButton(
                        isExpanded: true,
                        disabledHint: Text("فهرست بها"),
                        value: fehrestCode,
                        hint: Padding(
                          padding: EdgeInsets.only(right: 8.0),
                          child: Text("فهرست بها"),
                        ),
                        items: ([])
                            .map((e) => DropdownMenuItem(
                                  child: Text(""),
                                  value: "",
                                ))
                            .toList(),
                        onChanged: (value) {},
                      ),
                    );
                  },
                ),
              ),
              BlocListener<MachinaryCubit, MachinaryState>(
                listener: (context, state) {
                  if (state is MachinaryAdded) {
                    _amount.clear();
                    _descript.clear();
                    _rentAmount.clear();
                    setState(() {
                      choiceItem = null;
                      fehrestCode = null;
                    });

                    Navigator.pop(context);
                  }
                  if (state is UpdatedMachinary) {
                    _amount.text = "";
                    _descript.text = "";
                    _rentAmount.text = "";
                    setState(() {
                      choiceItem = null;
                      fehrestCode = null;
                    });
                    Navigator.pop(context);
                  }
                },
                child: SizedBox(
                  height: height * 0.03,
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile(
                      title: Text("انبار"),
                      activeColor: Colors.amber[500],
                      value: StorageandRent.storage,
                      groupValue: _source,
                      onChanged: (value) {
                        setState(() {
                          _source = value;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: RadioListTile(
                      title: Text("اجاره"),
                      activeColor: Colors.amber[500],
                      value: StorageandRent.rent,
                      groupValue: _source,
                      onChanged: (value) {
                        setState(() {
                          _source = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
              _source != StorageandRent.rent
                  ? Container()
                  : _textFields(height, width,
                      hintText: "مبلغ اجاره",
                      controller: _rentAmount,
                      keyboardtype: TextInputType.numberWithOptions()),
              _textFields(height, width,
                  hintText: "مقدار",
                  controller: _amount,
                  keyboardtype: TextInputType.numberWithOptions()),
              _textFields(height * 1.5, width,
                  hintText: "توضیحات", controller: _descript),
            ],
          ),
        ),
        BlocBuilder<MachinaryCubit, MachinaryState>(
          builder: (context, state) {
            if (state is AddingMachinary) {
              return Center(child: CircularProgressIndicator());
            }
            if (state is UpdatingMachinary) {
              return Center(child: CircularProgressIndicator());
            } else {
              return Container(
                height: height * 0.08,
                margin: EdgeInsets.symmetric(
                    horizontal: width * 0.01, vertical: height * 0.05),
                child: RaisedButton(
                  onPressed: () async {
                    if (widget.isUpdate == false) {
                      await BlocProvider.of<MachinaryCubit>(context)
                          .addMachinary(
                              token: BlocProvider.of<LoginCubit>(context).token,
                              projectId: BlocProvider.of<LoginCubit>(context)
                                  .projectId,
                              activityId: BlocProvider.of<LoginCubit>(context)
                                  .activityId,
                              amount: _amount.text,
                              itemCode: choiceItem,
                              info: _descript.text,
                              fehrestCode: fehrestCode,
                              fromSource: _source == StorageandRent.storage
                                  ? "ANBAR"
                                  : "RENT",
                              priceRent: _rentAmount.text);
                    }
                    if (widget.isUpdate == true && widget.type == "RENT") {
                      await BlocProvider.of<MachinaryCubit>(context).updatRent(
                          token: BlocProvider.of<LoginCubit>(context).token,
                          itemId: widget.itemId,
                          amount: _amount.text,
                          resourceCode: choiceItem,
                          info: _descript.text,
                          fehrestCode: fehrestCode,
                          priceRent: _rentAmount.text);
                    }
                    if (widget.isUpdate == true && widget.type == "ANBAR") {
                      await BlocProvider.of<MachinaryCubit>(context)
                          .updatingMachinary(
                              token: BlocProvider.of<LoginCubit>(context).token,
                              projectId: BlocProvider.of<LoginCubit>(context)
                                  .projectId,
                              activityId: BlocProvider.of<LoginCubit>(context)
                                  .activityId,
                              itemId: widget.itemId,
                              description: _descript.text,
                              amount: _amount.text,
                              stockId: int.parse(widget.resourceCode));
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

class Machinarys extends StatefulWidget {
  @override
  _MachinarysState createState() => _MachinarysState();
}

class _MachinarysState extends State<Machinarys> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<MachinaryCubit>(context).getMachines(
      token: BlocProvider.of<LoginCubit>(context).token,
      projectid: BlocProvider.of<LoginCubit>(context).projectId,
      activityId: BlocProvider.of<LoginCubit>(context).activityId,
    );
  }

  @override
  Widget build(BuildContext context) {

    final height = MediaQuery.of(context).size.height;
    final width  = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("ماشین آلات"),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await showDialog(
            context: context,
            builder: (_) => BlocProvider.value(
              value: context.read<MachinaryCubit>(),
              child: MachinaryDialog(
                isUpdate: false,
              ),
            ),
          );
        },
        label: Text("اضافه کردن"),
        icon: Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
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
            BlocListener<MachinaryCubit, MachinaryState>(
              listener: (context, state) {
                if (state is MachinaryAdded) {
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
                }
                if (state is DeletedMachinary) {
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
                }
                if (state is UpdatedMachinary) {
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
                }
                if (state is FailedDeletingMachinary) {
                  Scaffold.of(context)
                    ..removeCurrentSnackBar()
                    ..showSnackBar(
                        SnackBar(content: Text("مشکلی پیش آمده است")));
                }
                if (state is FailedUpdatingMachinary) {
                  Scaffold.of(context)
                    ..removeCurrentSnackBar()
                    ..showSnackBar(
                        SnackBar(content: Text("مشکلی پیش آمده است")));
                }
                if (state is AddingMachinaryFailed) {
                  Scaffold.of(context)
                    ..removeCurrentSnackBar()
                    ..showSnackBar(
                        SnackBar(content: Text("مشکلی پیش آمده است")));
                }
              },
              child: SizedBox(height: height * 0.04),
            ),
            BlocBuilder<MachinaryCubit, MachinaryState>(
              builder: (context, state) {
                if (state is LoadingMachinary) {
                  return Center(child: CircularProgressIndicator());
                }
                if (state is LoadedMachinary) {
                  if (state.storageMachinarys['data']['anbar'] == null) {
                    return Container();
                  } else {
                    return Expanded(
                        child: ListView.separated(
                            physics: BouncingScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return Directionality(
                                textDirection: TextDirection.rtl,
                                child: Container(
                                  height: height * 0.3,
                                  decoration: containerShadow,
                                  margin: EdgeInsets.symmetric(
                                      horizontal: width * 0.01),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: width * 0.05,
                                      vertical: height * 0.02),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      IntrinsicWidth(
                                        stepWidth: width * 0.6,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            ConstrainedBox(
                                                constraints: BoxConstraints(
                                                    maxWidth: width * 0.1),
                                                child: Text(
                                                  "${state.storageMachinarys['data']['anbar'][index]['title'] ?? "بدون عنوان"}(از انبار)",
                                                  maxLines: 5,
                                                  overflow:
                                                      TextOverflow.visible,
                                                  textDirection:
                                                      TextDirection.rtl,
                                                )),
                                            ConstrainedBox(
                                                constraints: BoxConstraints(
                                                    maxWidth: width * 0.2),
                                                child: Text(
                                                  "${state.storageMachinarys['data']['anbar'][index]['info'] ?? ""}",
                                                  maxLines: 5,
                                                  overflow:
                                                      TextOverflow.visible,
                                                  textDirection:
                                                      TextDirection.rtl,
                                                )),
                                            ConstrainedBox(
                                                constraints: BoxConstraints(
                                                    maxWidth: width * 0.1),
                                                child: Text(
                                                  "مقدار: ${state.storageMachinarys['data']['anbar'][index]['amount'] ?? "0"}",
                                                  maxLines: 5,
                                                  overflow:
                                                      TextOverflow.visible,
                                                  textDirection:
                                                      TextDirection.rtl,
                                                )),
                                            Divider(),
                                            state.storageMachinarys['data']
                                                            ['anbar'][index]
                                                        ['confirms'] ==
                                                    null
                                                ? Text("تاییدی وجود ندارد")
                                                : SingleChildScrollView(
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    child: Row(
                                                      children: (state.storageMachinarys[
                                                                          'data']
                                                                      ['anbar']
                                                                  [index][
                                                              'confirms'] as List)
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
                                      VerticalDivider(),
                                      Column(
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
                                                            onPressed:
                                                                () async {
                                                              Navigator.pop(
                                                                  context);
                                                              await BlocProvider
                                                                      .of<MachinaryCubit>(
                                                                          context)
                                                                  .deletingMachinary(
                                                                token: BlocProvider.of<
                                                                            LoginCubit>(
                                                                        context)
                                                                    .token,
                                                                projectId: BlocProvider.of<
                                                                            LoginCubit>(
                                                                        context)
                                                                    .projectId,
                                                                activityId: BlocProvider.of<
                                                                            LoginCubit>(
                                                                        context)
                                                                    .activityId,
                                                                itemId: state.storageMachinarys[
                                                                            'data']
                                                                        [
                                                                        "anbar"]
                                                                    [
                                                                    index]['id'],
                                                              );
                                                            },
                                                            child:
                                                                Text("تایید")),
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
                                                              MachinaryCubit>(),
                                                          child:
                                                              MachinaryDialog(
                                                            isUpdate: true,
                                                            type: "ANBAR",
                                                            fehrestCode: state
                                                                            .storageMachinarys[
                                                                        'data'][
                                                                    "anbar"][index]
                                                                [
                                                                'fehrest_code'],
                                                            itemId: state.storageMachinarys[
                                                                        'data']
                                                                    ["anbar"]
                                                                [index]['id'],
                                                            info: state.storageMachinarys[
                                                                        'data']
                                                                    ["anbar"]
                                                                [index]['info'],
                                                            amount: state
                                                                .storageMachinarys[
                                                                    'data']
                                                                    [index]
                                                                    ["anbar"]
                                                                    ['amount']
                                                                .toString(),
                                                            resourceCode: state
                                                                .storageMachinarys[
                                                                    'data']
                                                                    [index]
                                                                    ["anbar"][
                                                                    'resourceCode']
                                                                .toString(),
                                                            resourceTitle: state
                                                                .storageMachinarys[
                                                                    'data']
                                                                    [index]
                                                                    ["anbar"][
                                                                    'resuorceTitle']
                                                                .toString(),
                                                            stockId: state.storageMachinarys[
                                                                            'data']
                                                                        [index]
                                                                    ["anbar"]
                                                                ['stockId'],
                                                          ),
                                                        ));
                                              },
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                            separatorBuilder: (context, index) => Divider(),
                            itemCount: state
                                .storageMachinarys['data']["anbar"].length));
                  }
                }
                return Center(child: Text("چیزی برای نمایش وجود ندارد"));
              },
            ),
            BlocBuilder<MachinaryCubit, MachinaryState>(
              builder: (context, state) {
                if (state is LoadedMachinary) {
                  if (state.storageMachinarys["data"]["rent"] == null) {
                    return Container();
                  } else {
                    return Expanded(
                        child: ListView.separated(
                            physics: BouncingScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return Directionality(
                                textDirection: TextDirection.rtl,
                                child: Container(
                                  height: height * 0.3,
                                  decoration: containerShadow,
                                  margin: EdgeInsets.symmetric(
                                      horizontal: width * 0.01),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: width * 0.05,
                                      vertical: height * 0.02),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      IntrinsicWidth(
                                        stepWidth: width * 0.6,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            ConstrainedBox(
                                                constraints: BoxConstraints(
                                                    maxWidth: width * 0.1),
                                                child: Text(
                                                  "${state.storageMachinarys['data']['rent'][index]['title'] ?? "بدون عنوان"} (از اجاره)",
                                                  maxLines: 5,
                                                  overflow:
                                                      TextOverflow.visible,
                                                  textDirection:
                                                      TextDirection.rtl,
                                                )),
                                            ConstrainedBox(
                                                constraints: BoxConstraints(
                                                    maxWidth: width * 0.2),
                                                child: Text(
                                                  "${state.storageMachinarys['data']['rent'][index]['info'] ?? ""}",
                                                  maxLines: 5,
                                                  overflow:
                                                      TextOverflow.visible,
                                                  textDirection:
                                                      TextDirection.rtl,
                                                )),
                                            ConstrainedBox(
                                                constraints: BoxConstraints(
                                                    maxWidth: width * 0.1),
                                                child: Text(
                                                  "مقدار: ${state.storageMachinarys['data']['rent'][index]['amount'] ?? 0}",
                                                  maxLines: 5,
                                                  overflow:
                                                      TextOverflow.visible,
                                                  textDirection:
                                                      TextDirection.rtl,
                                                )),
                                            Divider(),
                                            state.storageMachinarys['data']
                                                            ['rent'][index]
                                                        ['confirms'] ==
                                                    null
                                                ? Text("تاییدی وجود ندارد")
                                                : SingleChildScrollView(
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    child: Row(
                                                      children: (state.storageMachinarys[
                                                                      'data'][
                                                                  'rent'][index]
                                                              [
                                                              'confirms'] as List)
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
                                      VerticalDivider(),
                                      Column(
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
                                                            onPressed:
                                                                () async {
                                                              Navigator.pop(
                                                                  context);
                                                              await BlocProvider
                                                                      .of<MachinaryCubit>(
                                                                          context)
                                                                  .deletRent(
                                                                token: BlocProvider.of<
                                                                            LoginCubit>(
                                                                        context)
                                                                    .token,
                                                                projectId: BlocProvider.of<
                                                                            LoginCubit>(
                                                                        context)
                                                                    .projectId,
                                                                activityId: BlocProvider.of<
                                                                            LoginCubit>(
                                                                        context)
                                                                    .activityId,
                                                                itemId: state.storageMachinarys[
                                                                            'data']
                                                                        ['rent']
                                                                    [
                                                                    index]['id'],
                                                              );
                                                            },
                                                            child:
                                                                Text("تایید")),
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
                                                              MachinaryCubit>(),
                                                          child:
                                                              MachinaryDialog(
                                                            isUpdate: true,
                                                            type: "RENT",
                                                            itemId: state.storageMachinarys[
                                                                        'data']
                                                                    ['rent']
                                                                [index]['id'],
                                                            info: state.storageMachinarys[
                                                                        'data']
                                                                    ['rent']
                                                                [index]['info'],
                                                            amount: state
                                                                .storageMachinarys[
                                                                    'data']
                                                                    ['rent']
                                                                    [index]
                                                                    ['amount']
                                                                .toString(),
                                                            priceRent: state
                                                                .storageMachinarys[
                                                                    'data']
                                                                    ['rent']
                                                                    [index][
                                                                    'priceRent']
                                                                .toString(),
                                                            fehrestCode: state
                                                                .storageMachinarys[
                                                                    'data']
                                                                    ['rent']
                                                                    [index][
                                                                    'fehrest_code']
                                                                .toString(),
                                                            resourceCode: state
                                                                .storageMachinarys[
                                                                    'data']
                                                                    ['rent']
                                                                    [index][
                                                                    'resourceCode']
                                                                .toString(),
                                                            resourceTitle: state
                                                                .storageMachinarys[
                                                                    'data']
                                                                    ['rent']
                                                                    [index][
                                                                    'resourceTitle']
                                                                .toString(),
                                                          ),
                                                        ));
                                              },
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                            separatorBuilder: (context, index) => Divider(),
                            itemCount: state
                                .storageMachinarys['data']["rent"].length));
                  }
                }
                return Container();
              },
            ),
            BlocBuilder<MachinaryCubit, MachinaryState>(
              builder: (context, state) {
                if (state is LoadedMachinary) {
                  if (state.storageMachinarys["data"]["rent"] == null &&
                      state.storageMachinarys["data"]["anbar"] == null) {
                    return Center(child: Text("چیزی برای نمایش وجود ندارد"));
                  }
                }
                return Container();
              },
            ),
            SizedBox(
              height: height * 0.01,
            )
          ],
        ),
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
