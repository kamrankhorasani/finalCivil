import 'dart:async';
import 'dart:io';
import 'package:civil_project/constants/constantdecorations.dart';
import 'package:civil_project/logic/add_importation_cubit/add_importation_cubit.dart';
import 'package:civil_project/logic/login_cubit/login_cubit.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persian_datepicker/persian_datepicker.dart';
import 'package:flutter/material.dart';

String storageItemChoose;
int choiceItem;

class SearchBox extends StatefulWidget {
  @override
  _SearchBoxState createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox> {
  final TextEditingController _searchText = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  //bool isLoading = false;
  int _currentMax = 0;
  Timer _debounce;

  _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce.cancel();
    _debounce = Timer(const Duration(seconds: 1), () async {
      print(query);

      BlocProvider.of<AddImportationCubit>(context).searchedItems.clear();
      await BlocProvider.of<AddImportationCubit>(context).searchItems(
          token: BlocProvider.of<LoginCubit>(context).token,
          type: "ALL",
          txt: query,
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
    await BlocProvider.of<AddImportationCubit>(context).searchItems(
        token: BlocProvider.of<LoginCubit>(context).token,
        type: "ALL",
        txt: _searchText.text,
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
                    height: height * 0.08,
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
                  BlocBuilder<AddImportationCubit, AddImportationState>(
                    builder: (context, state) {
                      if (BlocProvider.of<AddImportationCubit>(context)
                                  .searchedItems ==
                              null ||
                          BlocProvider.of<AddImportationCubit>(context)
                                  .searchedItems
                                  .length ==
                              0) {
                        return Center(
                            child: Text("چیزی برای نمایش وجود ندارد"));
                      }
                      return Container(
                          width: double.maxFinite,
                          height: height*0.8,
                          child: ListView.separated(
                            controller: _scrollController,
                            separatorBuilder: (context, index) => Divider(),
                            itemCount: BlocProvider.of<AddImportationCubit>(
                                    context)
                                .searchedItems
                                .length,
                            itemBuilder: (context, index) {
                              if (BlocProvider.of<AddImportationCubit>(
                                          context)
                                      .searchedItems
                                      .length ==
                                  index + 1) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    storageItemChoose = BlocProvider.of<
                                            AddImportationCubit>(context)
                                        .searchedItems[index]['title'];
                                    choiceItem = BlocProvider.of<
                                            AddImportationCubit>(context)
                                        .searchedItems[index]['id'];
                                    print(choiceItem);
                                  });

                                  BlocProvider.of<AddImportationCubit>(
                                          context)
                                      .searchedItems
                                      .clear();
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
                                          "${BlocProvider.of<AddImportationCubit>(context).searchedItems[index]['title'] ?? ""}" ??
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
                                                "${BlocProvider.of<AddImportationCubit>(context).searchedItems[index]['code'] ?? ""}" ??
                                                    ""),
                                            Text(
                                                "${BlocProvider.of<AddImportationCubit>(context).searchedItems[index]['unit'] ?? ""}" ??
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
                    },
                  )
                ],
              ),
            ))
      ],
    );
  }
}

class AddImportation extends StatefulWidget {
  @override
  _AddImportationState createState() => _AddImportationState();
}

class _AddImportationState extends State<AddImportation> {
  final TextEditingController _datePicker = TextEditingController();
  final TextEditingController _amount = TextEditingController();
  final TextEditingController _evacuation = TextEditingController();
  final TextEditingController _title = TextEditingController();
  int choiceProvider;
  int choiceUnit;
  List _pickedFiles = [];
  //List<String> _titles = [];
  List _encodedFiles = [];
  File ss;
  String encoded;
  List<int> fileBytes;
  FilePickerResult result;
  Widget type;
  PersianDatePickerWidget persianDatePicker;
  @override
  void initState() {
    BlocProvider.of<AddImportationCubit>(context)
        .getItems(token: BlocProvider.of<LoginCubit>(context).token);
    persianDatePicker = PersianDatePicker(
      controller: _datePicker,
      fontFamily: 'Vazir',
      farsiDigits: true,
    ).init();
    super.initState();
  }

  @override
  void dispose() {
    _datePicker.dispose();
    _amount.dispose();
    _evacuation.dispose();
    _title.dispose();
    super.dispose();
  }

  _dropDownButtons(double height, double width,
      {String hint = " ", List items}) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        decoration: containerShadow,
        padding: EdgeInsets.symmetric(horizontal: width * 0.02),
        margin: EdgeInsets.symmetric(
            horizontal: width * 0.02, vertical: height * 0.02),
        child: DropdownButton(
          disabledHint: Text("تامین کننده"),
          value: choiceProvider,
          isExpanded: true,
          underline: Divider(
            color: Colors.transparent,
          ),
          hint: Text(hint),
          items: items
              .map((e) =>
                  DropdownMenuItem(value: e['id'], child: Text(e['title'])))
              .toList(),
          onChanged: (value) {
            choiceProvider = value;

            setState(() {});
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Directionality(
      textDirection: TextDirection.rtl,
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
            horizontal: width * 0.05, vertical: height * 0.04),
        physics: ScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            BlocListener<AddImportationCubit, AddImportationState>(
              listener: (context, state) {
                if (state is ImportationAdded) {
                  if (state.success == false) {
                    Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text("متاسفانه اضافه نشد"),
                        duration: Duration(
                          microseconds: 3,
                        )));
                  } else {
                    Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text("با موفقیت اضافه شد"),
                        duration: Duration(
                          microseconds: 3,
                        )));
                  }
                }
              },
              child: Container(),
            ),
            Container(
              decoration: containerShadow,
              height: height * 0.60,
              child: Column(
                children: [
                  Padding(
                      padding: EdgeInsets.symmetric(
                    vertical: height * 0.01,
                  )),
                  GestureDetector(
                      onTap: () async {
                        await showDialog(
                          context: context,
                          builder: (_) {
                            return BlocProvider.value(
                              value: context.read<AddImportationCubit>(),
                              child: SearchBox(),
                            );
                          },
                        );
                      },
                      child: Container(
                          decoration: containerShadow,
                          height: height * 0.08,
                          margin:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 6),
                          padding: EdgeInsets.all(8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ConstrainedBox(
                                  constraints:
                                      BoxConstraints(maxWidth: width * 0.7),
                                  child: Text(
                                    storageItemChoose ?? "نوع",
                                    overflow: TextOverflow.ellipsis,
                                  )),
                              storageItemChoose == null
                                  ? Icon(Icons.arrow_drop_down_outlined)
                                  : Container()
                            ],
                          ))),

                  _textFields(height * 0.08, width,
                      hintText: "مقدار",
                      controller: _amount,
                      inputType: TextInputType.number),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BlocBuilder<AddImportationCubit, AddImportationState>(
                        builder: (context, state) {
                          if (state is AddImportationLoadedItemsProperty) {
                            return Expanded(
                                child: _dropDownButtons(
                              height,
                              width,
                              items: state.itemsOption['data'] ?? [],
                              hint: "تامین کننده",
                            ));
                          }
                          return Expanded(
                              child: _dropDownButtons(
                            height,
                            width,
                            items: [],
                            hint: "تامین کننده",
                          ));
                        },
                      ),
                      IconButton(
                          icon: Icon(Icons.add, color: Colors.black),
                          onPressed: () =>
                              Navigator.pushNamed(context, '/addprovider')),
                    ],
                  ),
                  //*For Picking Date
                  Container(
                    height: height * 0.07,
                    decoration: containerShadow,
                    margin: EdgeInsets.symmetric(horizontal: width * 0.05),
                    padding: EdgeInsets.symmetric(
                        horizontal: width * 0.01, vertical: height * 0.01),
                    child: TextField(
                      enableInteractiveSelection: false,
                      controller: _datePicker,
                      decoration:
                          InputDecoration.collapsed(hintText: 'تاریخ ورود'),
                      onTap: () {
                        FocusScope.of(context).requestFocus(
                            new FocusNode()); // To prevent opening default keyboard
                        showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              return persianDatePicker;
                            });
                      },
                    ),
                  ),
                  _textFields(height * 0.08, width,
                      hintText: "محل تخلیه", inputType: TextInputType.text),

                  SizedBox(height: height * 0.01),
                ],
              ),
            ),
            submitButton(height, width, callback: () async {
              BlocProvider.of<AddImportationCubit>(context).addImportation(
                  token: BlocProvider.of<LoginCubit>(context).token,
                  projectId: BlocProvider.of<LoginCubit>(context).projectId,
                  itemId: choiceItem,
                  providerId: choiceProvider,
                  vahedId: choiceUnit,
                  amount: _amount.text,
                  evacuation: _evacuation.text,
                  files: _encodedFiles);
              _amount.clear();
              _evacuation.clear();
              _pickedFiles.clear();
              _title.clear();
              _encodedFiles.clear();
            })
          ],
        ),
      ),
    ));
  }

  Container submitButton(double height, double width, {Function callback}) {
    return Container(
      height: height * 0.08,
      margin: EdgeInsets.symmetric(
          horizontal: width * 0.01, vertical: height * 0.05),
      child: RaisedButton(
        onPressed: callback,
        child: Text("ثبت", style: TextStyle(color: Colors.white)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 10,
        color: Colors.green,

      ),
    );
  }
}

_textFields(double height, double width,
    {TextEditingController controller,
    String hintText,
    TextInputType inputType = TextInputType.name}) {
  return Container(
    margin: EdgeInsets.all(width * 0.02),
    padding: EdgeInsets.only(right: width * 0.02),
    height: height,
    child: Directionality(
      textDirection: TextDirection.rtl,
      child: TextField(
        controller: controller,
        textDirection: TextDirection.rtl,
        keyboardType: inputType,
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
