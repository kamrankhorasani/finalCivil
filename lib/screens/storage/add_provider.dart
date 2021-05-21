import 'package:civil_project/logic/login_cubit/login_cubit.dart';
import 'package:civil_project/screens/locationpicker/locapick.dart';
import 'package:civil_project/screens/locationpicker/utils.dart';
import 'package:flutter/material.dart';
import 'package:civil_project/constants/constantdecorations.dart';
import 'package:civil_project/logic/add_provider_cubit/add_provider_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddProvider extends StatefulWidget {
  @override
  _AddProviderState createState() => _AddProviderState();
}

class _AddProviderState extends State<AddProvider> {
  TextEditingController _title = TextEditingController();
  TextEditingController _firstName = TextEditingController();
  TextEditingController _lastName = TextEditingController();
  TextEditingController _tell = TextEditingController();
  TextEditingController _mobileNumber = TextEditingController();
  TextEditingController _creditCard = TextEditingController();
  TextEditingController _shabaNumber = TextEditingController();
  SimpleLocationResult _selectedLocation;
  int choice;

  Map locationAddress;

  @override
  void initState() {
    BlocProvider.of<AddProviderCubit>(context).getProviderTypes(  token: BlocProvider.of<LoginCubit>(context).token);
    super.initState();
  }

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _title.dispose();
    _creditCard.dispose();
    _shabaNumber.dispose();
    _mobileNumber.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: BlocConsumer<AddProviderCubit, AddProviderState>(
        listener: (context, state) {
          if (state is AddProviderLoadingTypesFailed) {
            Scaffold.of(context)
                .showSnackBar(SnackBar(content: Text('مشکلی هست')));
          }
          if (state is AddingProviderFailed) {
            Scaffold.of(context)
                .showSnackBar(SnackBar(content: Text('مشکلی هست')));
          }
          if (state is ProviderAdded) {
            if (state.success == false) {
              Scaffold.of(context)
                  .showSnackBar(SnackBar(content: Text('متاسفانه اضافه نشد')));
            } else {}
            Scaffold.of(context)
                .showSnackBar(SnackBar(content: Text('اضافه شد')));
            List<TextEditingController> _controllers = [
              _title,
              _firstName,
              _lastName,
              _tell,
              _mobileNumber,
              _creditCard,
              _shabaNumber
            ];
            for (var item in _controllers) {
              item.clear();
            }
          }
        },
        builder: (context, state) {
          if (state is AddProviderLoadingTypes) {
            return Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          if (state is AddProviderLoadedTypes) {
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                  vertical: height * 0.05, horizontal: width * 0.1),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _textFields(height, width,
                      hintText: "عنوان", controller: _title),
                  _textFields(height, width,
                      hintText: "نام", controller: _firstName),
                  _textFields(height, width,
                      hintText: "نام خانوادگی", controller: _lastName),
                  _textFields(height, width,
                      hintText: "تلفن",
                      inputType: TextInputType.phone,
                      controller: _tell),
                  _textFields(height, width,
                      hintText: "موبایل",
                      inputType: TextInputType.phone,
                      controller: _mobileNumber),
                  _textFields(height, width,
                      hintText: "شماره کارت",
                      inputType: TextInputType.number,
                      controller: _creditCard),
                  _textFields(height, width,
                      hintText: "شماره شبا",
                      inputType: TextInputType.number,
                      controller: _shabaNumber),
                  _dropDownButtons(height, width,
                      hint: "نوع", items: state.options['data']),
                  RaisedButton.icon(
                      onPressed: () {
                        double _latitude = _selectedLocation != null
                            ? _selectedLocation.latitude
                            : 35.6892;
                        double _longitude = _selectedLocation != null
                            ? _selectedLocation.longitude
                            : 51.3890;
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SimpleLocationPicker(
                                      initialLatitude: _latitude,
                                      initialLongitude: _longitude,
                                    ))).then((value) async {
                          if (value != null) {
                            _selectedLocation = value;
                            locationAddress =
                                await BlocProvider.of<AddProviderCubit>(context)
                                    .getAddressPicked(
                                        _selectedLocation.latitude,
                                        _selectedLocation.longitude);
                            setState(() {});
                          } else {
                            print("آدرس انتخاب نشد");
                          }
                        });
                      },
                      icon: Icon(Icons.location_on_outlined),
                      label: Text("انتخاب آدرس بر روی نقشه")),
                  _selectedLocation != null
                      ? ConstrainedBox(
                          constraints:
                              BoxConstraints(maxHeight: 350, maxWidth: 250),
                          child: SimpleLocationPicker(
                            initialLatitude: _selectedLocation.latitude,
                            initialLongitude: _selectedLocation.longitude,
                            displayOnly: true,
                          ),
                        )
                      : SizedBox(height: 2),
                  _selectedLocation != null
                      ? Center(
                          child: Text(
                              "${locationAddress['data']['formatted_address']}"))
                      : SizedBox(height: 2),
                  SizedBox(height: height * 0.05),
                  ElevatedButton(
                      onPressed: () async {
                        BlocProvider.of<AddProviderCubit>(context).addProvider(
                            token: BlocProvider.of<LoginCubit>(context).token,
                            title: _title.text,
                            firstName: _firstName.text,
                            lastName: _lastName.text,
                            tell: _tell.text,
                            mobile: _mobileNumber.text,
                            lat: _selectedLocation.latitude.toInt(),
                            lng: _selectedLocation.longitude.toInt(),
                            address: locationAddress['data']
                                    ['formatted_address']
                                .toString(),
                            cardNumber: _creditCard.text,
                            shaba: _shabaNumber.text,
                            providerTypeId: choice);
                      },
                      child: Text("ثبت"))
                ],
              ),
            );
          }
          if (state is AddingProvider) {
            return Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          return AddProvider();
        },
      ),
    );
  }

  _textFields(double height, double width,
      {TextEditingController controller,
      TextInputType inputType = TextInputType.text,
      String hintText}) {
    return Container(
      margin: EdgeInsets.all(width * 0.02),
      padding: EdgeInsets.only(right: width * 0.02),
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

  _dropDownButtons(double height, double width,
      {String hint = "", List items}) {
    for (var i = 0; i < items.length; i++) {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          decoration: containerShadow,
          padding: EdgeInsets.symmetric(
              horizontal: hint == "تاریخ" ? width * 0.09 : width * 0.02),
          margin: EdgeInsets.symmetric(
              horizontal: width * 0.02, vertical: height * 0.02),
          child: DropdownButton(
            disabledHint: Text("نوع"),
            value: choice,
            isExpanded: true,
            underline: Divider(
              color: Colors.transparent,
            ),
            hint: Text(hint),
            items: items
                .map((e) => DropdownMenuItem(
                    value: items[i]['id'],
                    child: Text(items[i]['title'].toString())))
                .toList(),
            onChanged: (value) {
              setState(() {
                choice = value;
              });
            },
          ),
        ),
      );
    }
  }
}
