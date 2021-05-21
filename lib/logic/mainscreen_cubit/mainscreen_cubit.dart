import 'package:bloc/bloc.dart';
import 'package:civil_project/data/network.dart';
import 'package:civil_project/models/wbs/treeViewActivity.dart';
import 'package:civil_project/models/wbs/treeViewItem.dart';
import 'package:equatable/equatable.dart';
import 'package:tree_view/tree_view.dart';

part 'mainscreen_state.dart';

class MainscreenCubit extends Cubit<MainscreenState> {
  MainscreenCubit() : super(MainscreenInitial());


  Future<void> getWbs({String token,int projectId}) async {
    emit(WBSLoading());
    try {
      final body = await Routing()
          .getWBS(token: token, wbsId: projectId) as Map;
      final body2 = await Routing().getAllWBSActivity(
          token: token, projectId: projectId) as Map;
      final body3 = await Routing().getUser(
          token: token, projectId: projectId) as Map;

      List<TreeViewItems> list = [];
      for (int i = 0; i < (body['data'] as List).length; i++) {
        list.add(newShowTree(body['data'][i]['id'], body['data'][i]['title'],
            body['data'][i]['item'], body['data'][i]['activity'], () {}));
      }
      List<Parent> finalList = list.map((e) => e.getTreeViewItem()).toList();
      emit(WBSLoaded(finalList, body2['data'],users: body3));
    } catch (e) {
      print(e.toString());
    }
  }

  TreeViewItems newShowTree(
      int id, String title, List item, List activity, Function onClick,
      {int level = 0}) {
    List<TreeViewActivity> activityList = new List();
    List<TreeViewItems> itemsList = new List();
    try {
      if (activity.length > 0) {
        for (var i = 0; i < activity.length; i++) {
          activityList.add(new TreeViewActivity(
              id: activity[i]['id'],
              title: activity[i]['title'],
              level: level + 1));
        }
      }

      if (item.length > 0) {
        for (var i = 0; i < item.length; i++) {
          TreeViewItems sitem = newShowTree(item[i]['id'], item[i]['title'],
              item[i]['item'], item[i]['activity'], onClick,
              level: level + 1);
          itemsList.add(sitem);
        }
      }
    } catch (e) {
      print(e);
    }

    return TreeViewItems(id, title, activityList, itemsList, level);
  }
}
