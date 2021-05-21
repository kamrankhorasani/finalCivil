import 'package:flutter/foundation.dart' show required;
import 'package:shared_preferences/shared_preferences.dart';

class PersistData {
  SharedPreferences pref;
  Future saveToken({@required String data}) async {
    print("sharedpref token save:");
    print(data);
    pref = await SharedPreferences.getInstance();
    var temp = await pref.setString("token", data);
    print(temp);
  }

  Future saveActivityTitle({@required String data}) async {
    pref = await SharedPreferences.getInstance();
    await pref.setString('activityTitle', data);
  }

  Future saveActivityId({@required int data}) async {
    pref = await SharedPreferences.getInstance();
    await pref.setInt("activityId", data);
  }

  Future saveProjectId({@required int data}) async {
    pref = await SharedPreferences.getInstance();
    await pref.setInt("projectId", data);
  }

  Future loadingTokenData() async {
  
    print("loading token:");
    pref = await SharedPreferences.getInstance();
    var temp = pref.getString("token");
    return temp;
  }

  Future loadingProjectIdData() async {
    print("loading pid:");
    pref = await SharedPreferences.getInstance();
    var temp = pref.getInt("projectId");
    return temp;
  }
}

class LoadData {
  SharedPreferences pref;

  loadingActivityIdData() async {
    pref = await SharedPreferences.getInstance();
    return pref.getInt('activityId');
  }

  loadingActivityTitleData() async {
    pref = await SharedPreferences.getInstance();
    return pref.getString('activityTitle');
  }
}
