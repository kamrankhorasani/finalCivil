import 'package:bloc/bloc.dart';
import 'package:civil_project/data/network.dart';
import 'package:civil_project/shared/persistance.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/network.dart';
part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());
  int activityId;
  int projectId;
  int wbsId;
  String activityTitle;
  String token;

  Future<void> persistToken({@required String token}) async {
    await PersistData().saveToken(data: token);
  }

  Future<void> persistProjectId({@required int projectId}) async {
    await PersistData().saveProjectId(data: projectId);
  }

  Future<void> persistWBSId({@required int wbsId}) async {
    await PersistData().saveWBSId(data: wbsId ?? 0);
  }

  Future<void> persistActivityId({@required int activityId}) async {
    await PersistData().saveActivityId(data: activityId);
  }

  Future<void> persistActivityTitle({@required String activityTitle}) async {
    await PersistData().saveActivityTitle(data: activityTitle);
  }

  Future<void> loadToken() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
     token = pref.getString("token");
    //token = "MOBILE_6eafbe7f55369dac8b01ce10bd925a00";
  }

  Future loadWBSId() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    wbsId = pref.getInt("wbsId");
  }

  Future<void> loadProjectId() async {
    emit(LoadingFile());
    final SharedPreferences pref = await SharedPreferences.getInstance();
    projectId = pref.getInt("projectId");
    emit(FileLoaded(projectId));
  }

  Future login({@required String mobile}) async {
    try {
      final body = await Routing().userLogin(mobile);
      print(body);
    } catch (e) {
      print(e);
    }
  }

  Future submitCode({@required String digitCode, String mobile}) async {
    try {
      final body =
          await Routing().verify(verifyCode: digitCode, mobile: mobile);
      emit(GrantCode(verify: body));
      print(body);
    } catch (e) {
      emit(WrongCode(error: e.toString()));
    }
  }

  Future settingPanel({String token, int projectId}) async {
    final body = Routing().setPanel(token, projectId);
    print(body);
  }
}
