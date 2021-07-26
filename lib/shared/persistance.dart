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

  Future saveWBSId({@required int data}) async {
    pref = await SharedPreferences.getInstance();
    await pref.setInt("wbsId", data);
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
    //return "MOBILE_6eafbe7f55369dac8b01ce10bd925a00";
  }

  Future loadingProjectIdData() async {
    print("loading pid:");
    pref = await SharedPreferences.getInstance();
    var temp = pref.getInt("projectId");
    return temp;
  }

  Future loadingWBSIdData() async {
    pref = await SharedPreferences.getInstance();
    var temp = pref.getInt("wbsId");
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
