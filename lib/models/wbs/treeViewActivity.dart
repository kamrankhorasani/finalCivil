import 'package:civil_project/logic/configur_cubit/configur_cubit.dart';
import 'package:civil_project/logic/login_cubit/login_cubit.dart';
import 'package:civil_project/screens/homee/home_items.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';



class TreeViewActivity extends StatefulWidget {
  final int id;
  final String title;
  final int level;

  TreeViewActivity({Key key, this.id, this.title, this.level = 0})
      : super(key: key);
  @override
  _TreeViewActivityState createState() => _TreeViewActivityState();
}

class _TreeViewActivityState extends State<TreeViewActivity> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: EdgeInsets.only(left: ((widget.level) * 25.toDouble())),
        child: GestureDetector(
          onTap: () {
            setState(() {
              isSelectted = !isSelectted;
              //globalChoiceactivityTitle = widget.title;
              globalChoiceActivityId = widget.id;
            });
            BlocProvider.of<LoginCubit>(context).activityTitle = widget.title;
            BlocProvider.of<LoginCubit>(context).activityId = widget.id;
            BlocProvider.of<ConfigurCubit>(context)
                .activityTitleset(widget.title);
            Navigator.pop(context, globalChoiceActivityId);
          },
          child: Card(
            elevation: 5,
            child: ListTile(
              tileColor: !isSelectted ? Colors.grey : Colors.white,
              title: Text(
                widget.title,
              ),
              leading: Icon(
                Icons.arrow_forward_ios,
              ),
              subtitle: Text("فعالیت"),
              trailing: Text("${this.widget.toString()}"),
            ),
          ),
        ),
      ),
    );
  }
}

// class TreeViewActivity {
//   int id;
//   String title;
//   int level = 0;

//   TreeViewActivity(this.id, this.title, this.level);

//   getActivity() {
//     return GestureDetector(
//       onTap: () async {
//         await PersistData()
//             .saveData(name: "activityId", data: this.id.toString());
//         print(this.id);
//       },
//       child: Directionality(
//         textDirection: TextDirection.rtl,
//         child: Padding(
//           padding: EdgeInsets.only(left: ((this.level) * 25.toDouble())),
//           child: Card(
//             elevation: 5,
//             child: ListTile(
//               title: Text(
//                 persianConverter(this.title),
//               ),
//               leading: Icon(
//                 Icons.arrow_forward_ios,
//               ),
//               subtitle: Text("Activity"),
//               trailing: Text("${persianConverter(this.id.toString())}"),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
