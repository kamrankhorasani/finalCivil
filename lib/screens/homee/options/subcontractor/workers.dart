import 'package:civil_project/constants/constantdecorations.dart';
import 'package:civil_project/logic/login_cubit/login_cubit.dart';
import 'package:civil_project/logic/worker_cubit/worker_cubit.dart';
import 'package:civil_project/screens/homee/home_items.dart';
import 'package:civil_project/widgets/boxes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persian_datepicker/persian_datepicker.dart';

List mediaList = [];

class Workers extends StatefulWidget {
  @override
  _WorkersState createState() => _WorkersState();
}

class _WorkersState extends State<Workers> {
  final TextEditingController fromDate = TextEditingController();
  final TextEditingController toDate = TextEditingController();
  final TextEditingController _firstName = TextEditingController();
  final TextEditingController _lastName = TextEditingController();
  final TextEditingController _idCode = TextEditingController();
  final TextEditingController _numberPhone = TextEditingController();
  final TextEditingController _address = TextEditingController();
  PersianDatePickerWidget fromDatePicker;
  PersianDatePickerWidget toDatePicker;
  List _workersNames = [];
  int choiceSkill;
  bool addORupdate = false;
  int itemId;
  @override
  void initState() {
    super.initState();
    BlocProvider.of<WorkerCubit>(context).getWorkers(
      token: BlocProvider.of<LoginCubit>(context).token,
      projectId: BlocProvider.of<LoginCubit>(context).projectId,
      activityId: BlocProvider.of<LoginCubit>(context).activityId,
    );
    fromDatePicker = PersianDatePicker(
            controller: fromDate, fontFamily: 'Vazir', farsiDigits: true)
        .init();
    toDatePicker = PersianDatePicker(
            controller: toDate, fontFamily: 'Vazir', farsiDigits: true)
        .init();
  }

  @override
  void dispose() {
    super.dispose();
    _firstName.dispose();
    _lastName.dispose();
    _idCode.dispose();
    _numberPhone.dispose();
    _address.dispose();
    // BlocProvider.of<WorkerCubit>(context).disposer();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        padding: EdgeInsets.symmetric(
            horizontal: width * 0.05, vertical: height * 0.05),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
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
            SizedBox(height: height * 0.04),

            //*Middle Container
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: width * 0.03, vertical: height * 0.015),
              decoration: containerShadow,
              height: height * 0.95,
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Column(
                  textDirection: TextDirection.rtl,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _textFields(height * 0.09, width,
                              hintText: " نام ", controller: _firstName),
                        ),
                        Expanded(
                          child: _textFields(height * 0.09, width,
                              hintText: " نام خانوادگی ",
                              controller: _lastName),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: _textFields(height * 0.09, width,
                              hintText: " تلفن ", controller: _numberPhone),
                        )
                      ],
                    ),
                    _textFields(height * 0.15, width,
                        hintText: "آدرس", controller: _address),
                    BlocBuilder<WorkerCubit, WorkerState>(
                      builder: (context, state) {
                        if (state is LoadedWorkers) {
                          return _dropDownButtons(height, width,
                              hint: "حرفه", items: state.types);
                        }
                        return Container();
                      },
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: width * 0.2),
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _workersNames
                                .add([_firstName.text, _lastName.text]);
                          });
                        },
                        child: Text("اضافه کردن نیرو"),
                      ),
                    ),
                    SizedBox(height: height * 0.01),
                    SizedBox(
                      width: double.maxFinite,
                      height: height * 0.2,
                      child: ListView.separated(
                          key: UniqueKey(),
                          physics: ScrollPhysics(),
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return Stack(children: <Widget>[
                              Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      "assets/images/workers.png",
                                      height: height * 0.09,
                                    ),
                                    Text(
                                        "${_workersNames[index][0]} ${_workersNames[index][1]}")
                                  ],
                                ),
                              ),
                              Positioned(
                                height: 56,
                                width: 25,
                                top: -1,
                                right: -10,
                                child: IconButton(
                                    icon: Icon(
                                      Icons.cancel,
                                      size: 30,
                                      color: Colors.pinkAccent[400],
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _workersNames.removeAt(index);
                                      });
                                    }),
                              )
                            ]);
                          },
                          separatorBuilder: (context, index) => VerticalDivider(
                                indent: height * 0.05,
                                endIndent: height * 0.04,
                              ),
                          itemCount: _workersNames.length),
                    ),
                    BlocBuilder<WorkerCubit, WorkerState>(
                      builder: (context, state) {
                        if (state is AddingWorker) {
                          return Center(child: CircularProgressIndicator());
                        }
                        if (state is UpdatingWorker) {
                          return Center(child: CircularProgressIndicator());
                        }
                        return RaisedButton(
                          onPressed: () async {
                            if (addORupdate == false) {
                              BlocProvider.of<WorkerCubit>(context)
                                  .addingWorker(
                                token:
                                    BlocProvider.of<LoginCubit>(context).token,
                                projectId: BlocProvider.of<LoginCubit>(context)
                                    .projectId,
                                activityId: BlocProvider.of<LoginCubit>(context)
                                    .activityId,
                                title: BlocProvider.of<WorkerCubit>(context)
                                    .contractTitle
                                    .text,
                                dateIn: globalDateController.text,
                                firstName: _firstName.text,
                                lastName: _lastName.text,
                                tell: _numberPhone.text,
                                address: _address.text,
                                skillId: choiceSkill ?? 1,
                                price: BlocProvider.of<WorkerCubit>(context)
                                    .contractPrice
                                    .text,
                                postPay: BlocProvider.of<WorkerCubit>(context)
                                    .contractPostpay
                                    .text,
                                prePay: BlocProvider.of<WorkerCubit>(context)
                                    .contractPrepay
                                    .text,
                                payCondition:
                                    BlocProvider.of<WorkerCubit>(context)
                                        .contractCondition
                                        .text,
                                files: BlocProvider.of<WorkerCubit>(context)
                                        .encodedfiles +
                                    mediaList,
                                workers: _workersNames,
                                startDate: BlocProvider.of<WorkerCubit>(context)
                                    .startDate
                                    .text,
                                endDate: BlocProvider.of<WorkerCubit>(context)
                                    .startDate
                                    .text,
                              );
                            }

                            if (addORupdate == true) {
                              BlocProvider.of<WorkerCubit>(context)
                                  .updatingWorker(
                                token:
                                    BlocProvider.of<LoginCubit>(context).token,
                                projectId: BlocProvider.of<LoginCubit>(context)
                                    .projectId,
                                activityId: BlocProvider.of<LoginCubit>(context)
                                    .activityId,
                                itemId: itemId,
                                title: BlocProvider.of<WorkerCubit>(context)
                                    .contractTitle
                                    .text,
                                firstName: _firstName.text,
                                lastName: _lastName.text,
                                tell: _numberPhone.text,
                                address: _address.text,
                                skillId: choiceSkill ?? 1,
                                price: BlocProvider.of<WorkerCubit>(context)
                                    .contractPrice
                                    .text,
                                postPay: BlocProvider.of<WorkerCubit>(context)
                                    .contractPostpay
                                    .text,
                                prePay: BlocProvider.of<WorkerCubit>(context)
                                    .contractPrepay
                                    .text,
                                payCondition:
                                    BlocProvider.of<WorkerCubit>(context)
                                        .contractCondition
                                        .text,
                                files: BlocProvider.of<WorkerCubit>(context)
                                    .encodedfiles,
                                workers: _workersNames,
                                startDate: BlocProvider.of<WorkerCubit>(context)
                                    .startDate
                                    .text,
                                endDate: BlocProvider.of<WorkerCubit>(context)
                                    .endDate
                                    .text,
                              );
                            }
                          },
                          child: Text("ثبت نهایی"),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            BlocListener<WorkerCubit, WorkerState>(
              listener: (context, state) {
                if (state is WorkerAdded) {
                  _firstName.clear();
                  _lastName.clear();
                  _idCode.clear();
                  _numberPhone.clear();
                  _address.clear();
                  BlocProvider.of<WorkerCubit>(context)
                      .contractCondition
                      .clear();
                  BlocProvider.of<WorkerCubit>(context).contractPrice.clear();
                  BlocProvider.of<WorkerCubit>(context).contractTitle.clear();
                  BlocProvider.of<WorkerCubit>(context).contractPrepay.clear();
                  BlocProvider.of<WorkerCubit>(context).contractPostpay.clear();
                  BlocProvider.of<WorkerCubit>(context).startDate.clear();
                  BlocProvider.of<WorkerCubit>(context).endDate.clear();
                  setState(() {
                    choiceSkill = null;
                    _workersNames = [];
                  });
                  Scaffold.of(context).showSnackBar(
                      SnackBar(content: Text("با موفقیت اضافه شد")));
                }
                if (state is WorkerDeleted) {
                  Scaffold.of(context).showSnackBar(
                      SnackBar(content: Text("با موفقیت حذف شد")));
                }
                if (state is UpdatedWorker) {
                  _firstName.clear();
                  _lastName.clear();
                  _idCode.clear();
                  _numberPhone.clear();
                  _address.clear();
                  BlocProvider.of<WorkerCubit>(context)
                      .contractCondition
                      .clear();
                  BlocProvider.of<WorkerCubit>(context).contractPrice.clear();
                  BlocProvider.of<WorkerCubit>(context).contractTitle.clear();
                  BlocProvider.of<WorkerCubit>(context).contractPrepay.clear();
                  BlocProvider.of<WorkerCubit>(context).contractPostpay.clear();
                  BlocProvider.of<WorkerCubit>(context).startDate.clear();
                  BlocProvider.of<WorkerCubit>(context).endDate.clear();
                  setState(() {
                    choiceSkill = null;
                    _workersNames = [];
                    addORupdate = false;
                  });

                  Scaffold.of(context).showSnackBar(
                      SnackBar(content: Text("با موفقیت آپدیت شد")));
                }
              },
              child: SizedBox(height: height * 0.02),
            ),
            BlocBuilder<WorkerCubit, WorkerState>(
              builder: (context, state) {
                if (state is LoadingWorkers) {
                  return Center(child: CircularProgressIndicator());
                }
                if (state is LoadedWorkers) {
                  if (state.workers['data'] == null) {
                    return Center(child: Text("چیزی برای نمایش وجود ندارد"));
                  }
                  return SizedBox(
                    height: double.maxFinite,
                    child: ListView.separated(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Directionality(
                            textDirection: TextDirection.rtl,
                            child: Container(
                              height: height * 0.3,
                              decoration: containerShadow,
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
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                                "${state.workers['data'][index]['title']}     حرفه: ${state.workers['data'][index]['skill_title']}"),
                                          ],
                                        ),
                                        Divider(),
                                        ConstrainedBox(
                                          constraints: BoxConstraints(
                                              maxWidth: width * 0.1),
                                          child: Text(
                                              '${state.workers['data'][index]['firstName']} ' +
                                                  ' ${state.workers['data'][index]['lastName']}'),
                                        ),
                                        Divider(),
                                        state.workers['data'][index]
                                                    ['confirms'] ==
                                                null
                                            ? Text("تاییدی وجود ندارد")
                                            : SingleChildScrollView(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                child: Row(
                                                  children: (state.workers[
                                                              'data'][index]
                                                          ['confirms'] as List)
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
                                                                      color: Colors
                                                                          .red),
                                                              Text(
                                                                  "${e["role"]}:"),
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
                                  VerticalDivider(
                                    endIndent: height * 0.07,
                                  ),
                                  IntrinsicWidth(
                                    stepWidth: width * 0.01,
                                    child: Column(
                                      children: [
                                        IconButton(
                                          icon: Icon(
                                            Icons.cancel_outlined,
                                            color: Colors.red[400],
                                            size: width * 0.1,
                                          ),
                                          onPressed: () async {
                                            await BlocProvider.of<WorkerCubit>(
                                                    context)
                                                .deleteContract(
                                                    token: BlocProvider.of<
                                                            LoginCubit>(context)
                                                        .token,
                                                    projectId: BlocProvider.of<
                                                            LoginCubit>(context)
                                                        .projectId,
                                                    activityId: BlocProvider.of<
                                                            LoginCubit>(context)
                                                        .activityId,
                                                    itemId:
                                                        state.workers['data']
                                                            [index]['id']);
                                          },
                                        ),
                                        Divider(),
                                        IconButton(
                                          icon: Icon(
                                            Icons.edit_outlined,
                                            color: Colors.green[400],
                                            size: width * 0.1,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              mediaList = state.workers['data']
                                                  [index]['files'];
                                              // state.workers['data'][index]
                                              //         ['files']
                                              //     .forEach((element) {
                                              //   mediaList.add(FileModel(
                                              //     title: element['title'],
                                              //     address: element["file"],
                                              //     image: element['file']
                                              //             .toString()
                                              //             .contains("pdf")
                                              //         ? Image.asset(
                                              //             "assets/images/pdf.png",
                                              //             height: 50)
                                              //         : Image.network(
                                              //             element['file'],
                                              //             height: 50),
                                              //   ));
                                              // });
                                              addORupdate = true;
                                              choiceSkill =
                                                  state.workers['data'][index]
                                                      ['skill_id'];
                                              itemId = state.workers['data']
                                                  [index]['id'];
                                              _lastName.text =
                                                  state.workers['data'][index]
                                                      ['lastName'];
                                              BlocProvider.of<WorkerCubit>(
                                                          context)
                                                      .contractTitle
                                                      .text =
                                                  state.workers['data'][index]
                                                      ['title'];
                                              BlocProvider.of<WorkerCubit>(
                                                      context)
                                                  .contractPrice
                                                  .text = state.workers['data']
                                                      [index]['price']
                                                  .toString();
                                              BlocProvider.of<WorkerCubit>(
                                                      context)
                                                  .contractPostpay
                                                  .text = state.workers['data']
                                                      [index]['postpay']
                                                  .toString();
                                              BlocProvider.of<WorkerCubit>(
                                                          context)
                                                      .contractCondition
                                                      .text =
                                                  state.workers['data'][index]
                                                      ['pay_condition'];
                                              BlocProvider.of<WorkerCubit>(
                                                      context)
                                                  .contractPrepay
                                                  .text = state.workers['data']
                                                      [index]['prepay']
                                                  .toString();
                                              _firstName.text =
                                                  state.workers['data'][index]
                                                      ['firstName'];
                                              _address.text =
                                                  state.workers['data'][index]
                                                      ['address'];
                                              _numberPhone.text =
                                                  state.workers['data'][index]
                                                      ['tell'];
                                              _workersNames.addAll(
                                                  state.workers['data'][index]
                                                      ['nirooha']);
                                              print(state.workers['data'][index]
                                                  ['nirooha']);
                                            });
                                          },
                                        ),
                                        Divider(),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) => Divider(),
                        itemCount: (state.workers['data'] as List).length),
                  );
                }
                return Center(child: Text("چیزی برای نمایش وجود ندارد"));
              },
            ),
          ],
        ),
      ),
    );
  }

  _dropDownButtons(double height, double width,
      {String hint = "", List items}) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        decoration: containerShadow,
        padding: EdgeInsets.symmetric(horizontal: width * 0.02),
        margin: EdgeInsets.symmetric(
            horizontal: width * 0.02, vertical: height * 0.02),
        child: DropdownButton(
          disabledHint: Text("نوع"),
          value: choiceSkill,
          isExpanded: true,
          underline: Divider(
            color: Colors.transparent,
          ),
          hint: Text(hint),
          items: items
              .map((e) => DropdownMenuItem(
                  value: e['id'], child: Text(e['title'].toString())))
              .toList(),
          onChanged: (value) {
            setState(() {
              choiceSkill = value;
            });
          },
        ),
      ),
    );
  }

  _textFields(double height, double width,
      {TextEditingController controller, String hintText}) {
    _typeofKeyboard() {
      if (hintText == " کدملی " || hintText == " تلفن ") {
        return TextInputType.number;
      } else
        return TextInputType.multiline;
    }

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
          keyboardType: _typeofKeyboard(),
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
}
