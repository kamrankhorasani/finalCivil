import 'package:bloc/bloc.dart';
import 'package:civil_project/data/network.dart';
import 'package:equatable/equatable.dart';

part 'alarms_state.dart';

class AlarmsCubit extends Cubit<AlarmsState> {
  AlarmsCubit() : super(AlarmsInitial());
  Map alarms = {};

  Future getAlarms(
      {String token, int projectId, int isRead, int frm, int cnt = 10}) async {
    // emit(LoadingAlarms());
    try {
      final body = await Routing().getAlarm(
          token: token,
          projectId: projectId,
          isRead: isRead,
          frm: frm,
          cnt: cnt);
      print(body);
      alarms.addAll(body);
      emit(LoadedAlarms(body));
    } catch (e) {
      print(e);
      emit(FailedLoadingAlarms());
    }
  }

  setOffAlarm({String token, int itemId}) async {
    emit(SettingAlarmOff());
    try {
      final body = await Routing().alarmOffset(token, itemId);
      print(body);
      emit(SettedAlarmOff(body["success"]));
    } catch (e) {
      print(e);
      emit(FailedSettingAlarmOff());
    }
  }
}
