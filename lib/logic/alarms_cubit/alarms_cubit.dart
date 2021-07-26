import 'package:bloc/bloc.dart';
import 'package:civil_project/data/network.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

part 'alarms_state.dart';

class AlarmsCubit extends Cubit<AlarmsState> {
  AlarmsCubit() : super(AlarmsInitial());
  Map alarms = {};
  List allAlarms = [];
  int initLoadCount = 10;
  int loadMoreCount = 0;
  int loadedLastIndex = 0;

  Future getAlarms(
      {String token, int projectId, int isRead, int frm, int cnt = 10}) async {
    emit(LoadingAlarms());
    try {
      final body = await Routing().getAlarm(
          token: token,
          projectId: projectId,
          isRead: isRead,
          frm: frm,
          cnt: cnt);
      print(body);
      alarms.addAll(body);
      allAlarms.addAll(body["data"]["items"]);
      emit(LoadedAlarms(allAlarms));
    } catch (e) {
      print(e);
      emit(FailedLoadingAlarms());
    }
  }

  Future getMoreAlarms(
      {String token, int projectId, int isRead, int frm, int cnt = 10}) async {
    try {
      final body = await Routing().getAlarm(
          token: token,
          projectId: projectId,
          isRead: isRead,
          frm: frm,
          cnt: cnt);
      print(body);

      allAlarms.addAll(body["data"]["items"] ?? []);
      emit(LoadedAlarms(allAlarms));
    } catch (e) {
      print(e);
      emit(FailedLoadingAlarms());
    }
  }

  setOffAlarm(
      {String token,
      int itemId,
      int projectId,
      int isRead,
      int frm,
      int cnt}) async {
    emit(SettingAlarmOff());
    try {
      final body = await Routing().alarmOffset(token, itemId);
      print(body);
      emit(SettedAlarmOff(body["success"]));
      await getAlarms(
          token: token, projectId: projectId, isRead: -1, frm: 0, cnt: 10);
    } catch (e) {
      print(e);
      emit(FailedSettingAlarmOff());
    }
  }
}
