import 'package:flutter/material.dart';
import 'package:tree_view/tree_view.dart';

import 'treeViewActivity.dart';

class TreeViewItems {
  int id = -1;
  String title = "";
  List<TreeViewActivity> activitys = new List<TreeViewActivity>();
  List<TreeViewItems> items = new List<TreeViewItems>();
  int level = 0;

  TreeViewItems(int id, String title, List<TreeViewActivity> activities,
      List<TreeViewItems> items, int level) {
    this.id = id;
    this.title = title;
    this.level = level;
    this.items = items;
    this.activitys = activities;
  }

  Parent getTreeViewItem() {
    return Parent(
      parent: Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: EdgeInsets.only(left: (this.level * 25.toDouble())),
          child: Card(
            elevation: 5,
            child: ListTile(
              title: Text(this.title),
              leading: Icon(
                Icons.folder,
              ),
              trailing: Text(this.id.toString()),
            ),
          ),
        ),
      ),
      childList: ChildList(
        children: [
          ...(this.activitys.map((e) => e ).toList()),
          ...(this.items.map((e) => e.getTreeViewItem()).toList()),
        ],
      ),
    );
  }
}
