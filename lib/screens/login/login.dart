import 'package:civil_project/constants/constantdecorations.dart';
import 'package:civil_project/logic/login_cubit/login_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _mobileNumberController = TextEditingController();
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
  void dispose() {
    _mobileNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: width * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: height * 0.05,
            ),
            Column(
              children: [
                AnimatedAlign(
                  curve: Curves.ease,
                  duration: Duration(seconds: 3),
                  alignment: _alignment,
                  child: AnimatedContainer(

                    height: isHeight ? height * 0.4 : height * 0.2,
                    width: isHeight ? height * 0.4 : height * 0.2,
                    curve: Curves.easeInToLinear,
                    duration: Duration(seconds: 2),
                    child: SizedBox(
                      height: height * 0.4,
                      child: Image.asset(
                        "assets/images/intro.png",
                        height: height * 0.4,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: height * 0.02,
            ),
            Center(
              child: Container(
                padding: EdgeInsets.only(right: width * 0.02),
                height: height * 0.08,
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: TextField(
                    textAlign: TextAlign.justify,
                    controller: _mobileNumberController,
                    style: TextStyle(fontSize: width * 0.05),
                    textDirection: TextDirection.rtl,
                    keyboardType: TextInputType.phone,
                    maxLines: 1,
                    decoration: InputDecoration(
                      
                      border: InputBorder.none,
                      hintText: "شماره خود را وارد کنید...",
                    ),
                  ),
                ),
                decoration: containerShadow,
              ),
            ),
            SizedBox(
              height: height * 0.01,
            ),
            Container(
              height: height * 0.08,
              margin: EdgeInsets.symmetric(
                  horizontal: width * 0.01, vertical: height * 0.05),
              child: RaisedButton(
                onPressed: () async {
                  await BlocProvider.of<LoginCubit>(context)
                      .login(mobile: _mobileNumberController.text);
                  Navigator.pushNamed(context, '/digitcode',
                      arguments: _mobileNumberController.text);
                },
                child: Text(
                  "دریافت کد",
                  style: TextStyle(color: Colors.white),
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                elevation: 10,
                color: Colors.amber.shade700,
              ),
            )
          ],
        ),
      ),
    );
  }
}
