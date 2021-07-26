part of 'alarms_cubit.dart';

abstract class AlarmsState extends Equatable {
  const AlarmsState();

  @override
  List<Object> get props => [];
}

class AlarmsInitial extends AlarmsState {}

class LoadingAlarms extends AlarmsState {}

class LoadedAlarms extends AlarmsState {
  final alarms;
  LoadedAlarms(this.alarms);
  List<Object> get props => [alarms];

}

class FailedLoadingAlarms extends AlarmsState {}

class SettingAlarmOff extends AlarmsState {}

class SettedAlarmOff extends AlarmsState {
  final success;
  SettedAlarmOff(this.success);
  List<Object> get props => [success];

}

class FailedSettingAlarmOff extends AlarmsState {}
