import 'package:bloc/bloc.dart';
import 'package:civil_project/data/network.dart';
import 'package:civil_project/shared/persistance.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());
  int activityId;
  int projectId;
  String activityTitle;
  String token;

  Future<void> persistToken({@required String token}) async {
    await PersistData().saveToken(data: token);
  }

  Future<void> persistProjectId({@required int projectId}) async {
    await PersistData().saveProjectId(data: projectId);
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
  }

  Future<void> loadProjectId() async {
    emit(LoadingFile());
    final SharedPreferences pref = await SharedPreferences.getInstance();
    projectId = pref.getInt("projectId");
    emit(FileLoaded(projectId));
  }

  // loadActivityId() async {
  //   activityId = await LoadData().loadingActivityIdData();
  // }

  // loadActivityTitle() async {
  //   activityTitle = await LoadData().loadingActivityTitleData();
  // }

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
}
