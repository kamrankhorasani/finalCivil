import 'package:civil_project/logic/homescreen_cubit/homescreen_cubit.dart';
import 'package:civil_project/logic/login_cubit/login_cubit.dart';
import 'package:civil_project/screens/locationpicker/locapick.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<HomescreenCubit>(context).getProject(
      token: BlocProvider.of<LoginCubit>(context).token,
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget _constantTexts(String title) {
      return Align(
        alignment: Alignment.centerRight,
        child: Text(
          "$title",
          textDirection: TextDirection.rtl,
          textAlign: TextAlign.right,
          style: TextStyle(fontSize: 10),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('عمران'),
      ),
      body: BlocBuilder<HomescreenCubit, HomescreenState>(
        builder: (context, state) {
          if (state is HomescreenLoadingProject) {
            return Center(child: CircularProgressIndicator());
          }
          if (state is HomescreenLoadedProject) {
            if (state.projects['data'] == null) {
              return Center(child: Text("چیزی برای نمایش وجود ندارد"));
            }
            return GridView.builder(
              itemCount: state.projects['data'].length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, childAspectRatio: 3 / 4),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () async {
                    BlocProvider.of<LoginCubit>(context).projectId =
                        state.projects['data'][index]['id'];
                    await BlocProvider.of<LoginCubit>(context).persistProjectId(
                        projectId: state.projects['data'][index]['id']);
                    // Navigator.popUntil(
                    //     context, ModalRoute.withName("/mainscreen"));
                    // Navigator.pushNamedAndRemoveUntil(
                    //     context, '/mainscreen', (route) => false);
                    //  Navigator.pushNamedAndRemoveUntil(context, '/mainscreen');
                    Navigator.pushReplacementNamed(context, "/mainscreen");
                  },
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    shadowColor: Colors.grey,
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${state.projects['data'][index]['startDate']}",
                                style: TextStyle(fontSize: 10),
                              ),
                              Text(
                                "${state.projects['data'][index]['date_tahvil']}",
                                style: TextStyle(fontSize: 10),
                              ),
                            ],
                          ),
                          Divider(
                            color: Colors.black87,
                          ),
                          //*Map
                          Expanded(
                              child: SimpleLocationPicker(
                            displayOnly: true,
                            initialLatitude: state.projects['data'][index]
                                            ['lat'] ==
                                        null ||
                                    state.projects['data'][index]['lat'] > 90 ||
                                    state.projects['data'][index]['lat'] < -90
                                ? 36.00
                                : (state.projects['data'][index]['lat'] as int)
                                    .toDouble(),
                            initialLongitude: state.projects['data'][index]
                                            ['lng'] ==
                                        null ||
                                    state.projects['data'][index]['lng'] > 90 ||
                                    state.projects['data'][index]['lng'] < -90
                                ? 36.00
                                : (state.projects['data'][index]['lng'] as int)
                                    .toDouble(),
                          )),
                          Divider(
                            color: Colors.black87,
                          ),
                          Column(
                            children: [
                              _constantTexts(
                                  "عنوان پروژه:${state.projects['data'][index]['title']}" ??
                                      ""),
                              _constantTexts(
                                  "آدرس:${state.projects['data'][index]['address']}" ??
                                      ""),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
          if (state is HomeScreenLoadFailed) {
            return Text("مشکلی هست!!!!");
          }
          return Text("پروژه ای وجود ندارد");
        },
      ),
    );
  }
}
