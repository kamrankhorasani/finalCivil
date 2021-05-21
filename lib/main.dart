import 'package:civil_project/logic/configur_cubit/configur_cubit.dart';
import 'package:civil_project/logic/homescreen_cubit/homescreen_cubit.dart';
import 'package:civil_project/logic/login_cubit/login_cubit.dart';
import 'package:civil_project/router/router_generator.dart';
import 'package:civil_project/screens/homee/home_screen.dart';
import 'package:civil_project/screens/login/login.dart';
import 'package:civil_project/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MultiBlocProvider(providers: [
    BlocProvider(
      create: (context) => LoginCubit(),
    ),
    BlocProvider(create: (context) => ConfigurCubit()),
  ], child: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    BlocProvider.of<LoginCubit>(context).loadToken();
    BlocProvider.of<LoginCubit>(context).loadProjectId();
  }

  final AppRouter _approute = AppRouter();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Civil Project",
      theme: ThemeData(
          fontFamily: 'Vazir',
          hintColor: Colors.grey[200],
          iconTheme: IconThemeData(color: Colors.black),
          cardTheme: CardTheme(color: Colors.grey),
          backgroundColor: Colors.grey[600],
          canvasColor: Colors.grey[600],
          dialogTheme: DialogTheme(
            backgroundColor: Colors.grey[600],
            titleTextStyle:
                TextStyle(color: Colors.yellow[700], fontFamily: 'Vazir'),
            contentTextStyle:
                TextStyle(color: Colors.yellow[800], fontFamily: 'Vazir'),
          ),
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
              selectedLabelStyle: TextStyle(fontWeight: FontWeight.w800),
              backgroundColor: Colors.black38,
              unselectedItemColor: Color(0xfff9f6f7),
              selectedItemColor: Colors.yellow[800]),
          accentColor: Colors.amber,
          primaryColor: Colors.amber,
          accentColorBrightness: Brightness.dark,
          primaryColorBrightness: Brightness.dark,
          scaffoldBackgroundColor: Colors.grey[700],
          snackBarTheme: SnackBarThemeData(
              behavior: SnackBarBehavior.floating,
              contentTextStyle:
                  TextStyle(color: Colors.yellow[700], fontFamily: 'Vazir'),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15))),
          textTheme: TextTheme(
            bodyText1: TextStyle(color: Colors.yellow[700]),
            bodyText2: TextStyle(color: Colors.yellow[700]),
            subtitle1: TextStyle(color: Colors.yellow[700]),
            subtitle2: TextStyle(color: Colors.yellow[700]),
          )),
      home: BlocBuilder<LoginCubit, LoginState>(
        builder: (context, state) {
          if (state is LoadingFile) {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          if (state is FileLoaded) {
            if (state.data == null &&
                BlocProvider.of<LoginCubit>(context).token != null) {
              return BlocProvider(
                create: (context) => HomescreenCubit(),
                child: HomeScreen(),
              );
            }
            if (state.data != null &&
                BlocProvider.of<LoginCubit>(context).token != null) {
              return MainScreen();
            }
          }
          return LoginScreen();
        },
      ),
      onGenerateRoute: _approute.onGenerateRoute,
    );
  }
}
