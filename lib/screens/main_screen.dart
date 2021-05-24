import 'package:civil_project/logic/alarms_cubit/alarms_cubit.dart';
import 'package:civil_project/logic/cartable_cubit/cartable_cubit.dart';
import 'package:civil_project/logic/feed_cubit/feed_cubit.dart';
import 'package:civil_project/logic/financial_cubit/financial_cubit.dart';
import 'package:civil_project/logic/mainscreen_cubit/mainscreen_cubit.dart';
import 'package:civil_project/screens/cartable/cartable_screen.dart';
import 'package:civil_project/screens/feeds/feeds_screen.dart';
import 'package:civil_project/screens/financial/financial_screen.dart';
import 'package:civil_project/screens/homee/home_items.dart';
import 'package:civil_project/screens/storage/storeage_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 4;

  List<Widget> _pages = <Widget>[
    BlocProvider.value(value: FeedCubit(), child: FeedScreen(),),
    StorageScreen(),
    BlocProvider(create: (context) => FinancialCubit(), child: FinancialScreen(),),
    BlocProvider(create: (context) => CartableCubit(), child: CartableScreen(),),
    MultiBlocProvider(providers: [BlocProvider(create: (context) => MainscreenCubit()), BlocProvider(
          create: (context) => AlarmsCubit(),
        ),
      ],
      child: HomeItems(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: _pages.elementAt(_selectedIndex),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(color: Colors.black26, boxShadow: [
          BoxShadow(blurRadius: 20, color: Colors.black.withOpacity(.1))
        ]),
        child: SafeArea(
          child: Padding(
            padding:
                EdgeInsets.symmetric(horizontal: width * 0.05, vertical: 5),
            child: GNav(
                gap: width * 0.05,
                activeColor: Colors.white,
                color: Colors.white,
                iconSize: 24,
                padding:
                    EdgeInsets.symmetric(horizontal: width * 0.02, vertical: 5),
                duration: Duration(milliseconds: 400),
                tabBackgroundColor: Colors.yellow[700],
                tabs: [
                  GButton(
                    icon: Icons.menu_book,
                    text: "گزارشات",
                  ),
                  GButton(
                    icon: Icons.storage,
                    text: 'انبار',
                  ),
                  GButton(
                    icon: Icons.monetization_on,
                    text: 'مالی',
                  ),
                  GButton(

                    icon: Icons.engineering,
                    text: 'کارتابل',
                  ),
                  GButton(
                    icon: Icons.home,
                    text: "خانه",
                  )
                ],
                selectedIndex: _selectedIndex,
                onTabChange: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                }),
          ),
        ),
      ),
      // BottomNavigationBar(
      //   type: BottomNavigationBarType.fixed,
      //   selectedLabelStyle: const TextStyle(
      //     fontSize: 11,
      //     height: 2,
      //   ),
      //   unselectedLabelStyle:
      //       const TextStyle(fontSize: 11, height: 2, color: Colors.grey),
      //   items: <BottomNavigationBarItem>[
      //     BottomNavigationBarItem(
      //         icon: Icon(Icons.menu_book), label: "گزارشات"),
      //     BottomNavigationBarItem(icon: Icon(Icons.storage), label: "انبار"),
      //     BottomNavigationBarItem(
      //         icon: Icon(Icons.monetization_on), label: "مالی"),
      //     BottomNavigationBarItem(icon: Icon(Icons.email), label: "کارتابل"),
      //     BottomNavigationBarItem(icon: Icon(Icons.home), label: "خانه")
      //   ],
      //   currentIndex: _selectedIndex,
      //   onTap: (int index) {
      //     setState(() {
      //       _selectedIndex = index;
      //     });
      //   },
      // ),
    );
  }
}
