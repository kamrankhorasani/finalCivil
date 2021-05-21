import 'package:civil_project/logic/login_cubit/login_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class DigiCodeScreen extends StatefulWidget {
  final String mobileNumber;

  DigiCodeScreen({this.mobileNumber});
  @override
  _DigiCodeScreenState createState() => _DigiCodeScreenState();
}

class _DigiCodeScreenState extends State<DigiCodeScreen> {
  TextEditingController _controller = TextEditingController();
  Alignment _alignment = Alignment.centerLeft;
  bool isHeight = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) => setState(() {
          _alignment = Alignment.center;
          isHeight = true;
        }));
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: width * 0.04),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: height * 0.08,
            ),
            BlocListener<LoginCubit, LoginState>(
              listener: (context, state) {
                if (state is GrantCode) {
                  if (state.verify['success'] == true) {
                    BlocProvider.of<LoginCubit>(context)
                        .persistToken(token: state.verify['data']);
                    BlocProvider.of<LoginCubit>(context).token =
                        state.verify['data'];
                    Navigator.pushNamedAndRemoveUntil(
                        context, "/homescreen", (route) => false);
                  } else {
                    Scaffold.of(context)
                        .showSnackBar(SnackBar(content: Text('کد اشتباه است')));
                  }
                } else {
                  Scaffold.of(context)
                      .showSnackBar(SnackBar(content: Text('کد اشتباه است')));
                }
              },
              child: AnimatedAlign(
                alignment: _alignment,
                duration: Duration(seconds: 2),
                curve: Curves.ease,
                child: AnimatedContainer(
                  height: isHeight ? height * 0.35 : height * 0.2,
                  width: isHeight ? height * 0.35 : height * 0.2,
                  curve: Curves.easeInToLinear,
                  duration: Duration(seconds: 2),
                  child: SizedBox(
                      height: height * 0.4,
                      child: Icon(
                        Icons.lock,
                        color: Colors.amber,
                        size: height * 0.35,
                      )),
                ),
              ),
            ),
            SizedBox(
              height: height * 0.1,
            ),
            PinCodeTextField(
                backgroundColor: Colors.transparent,
                controller: _controller,
                appContext: context,
                length: 4,
                keyboardType: TextInputType.number,
                autoDismissKeyboard: true,
                textStyle: TextStyle(color: Colors.white),
                boxShadows: [
                  BoxShadow(
                    color: Colors.grey[800],
                    spreadRadius: 0.1,
                    blurRadius: 0.1,
                    //offset: Offset(2, 2), // changes position of shadow
                  ),
                ],
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderWidth: 3,
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  fieldHeight: 50,
                  fieldWidth: 50,
                  activeColor: Colors.transparent,
                  inactiveColor: Colors.transparent,
                  selectedColor: Colors.amber,
                  activeFillColor: Color(0xFFEFEFF2),
                  inactiveFillColor: Color(0xFFEFEFF2),
                  selectedFillColor: Color(0xFF2A3952),
                ),
                onChanged: (value) {}),
            Container(
              height: height * 0.08,
              margin: EdgeInsets.symmetric(
                  horizontal: width * 0.01, vertical: height * 0.05),
              child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  elevation: 10,
                  color: Colors.amber.shade700,
                  child: Text(
                    'ثبت  کد',
                    style:
                        TextStyle(color: Colors.white, fontSize: width * 0.05),
                  ),
                  onPressed: () async {
                    await BlocProvider.of<LoginCubit>(context).submitCode(
                        digitCode: _controller.text,
                        mobile: widget.mobileNumber);
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
