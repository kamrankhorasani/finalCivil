part of 'activity_cubit.dart';

abstract class ActivityState extends Equatable {
  const ActivityState();

  @override
  List<Object> get props => [];
}

class ActivityInitial extends ActivityState {}

class LoadingActivity extends ActivityState {}

class LoadedActivity extends ActivityState {
  final Map activitiesList;

  LoadedActivity(this.activitiesList);
}

class LoadingFailedActivty extends ActivityState {}

class AddingActivity extends ActivityState {}

class ActivityAdded extends ActivityState {
  final bool succes;

  ActivityAdded(this.succes);
}

class DeletingActivity extends ActivityState {}

class ActivityDeleted extends ActivityState {
  final bool succes;

  ActivityDeleted(this.succes);
}

class UpdatingActivity extends ActivityState {}

class ActivityUpdated extends ActivityState {
  final bool succes;

  ActivityUpdated(this.succes);
}
