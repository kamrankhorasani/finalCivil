import 'package:bloc/bloc.dart';
import 'package:civil_project/data/network.dart';
import 'package:civil_project/screens/homee/home_items.dart';
import 'package:equatable/equatable.dart';

part 'activity_state.dart';

class ActivityCubit extends Cubit<ActivityState> {
  ActivityCubit() : super(ActivityInitial());

  Future getActivities({String token, int projectId, int activityId}) async {
    emit(LoadingActivity());
    try {
      final body = await Routing().getDailyActivity(
          token: token,
          projectId: projectId,
          activityId: activityId,
          dateIn: globalDateController.text) as Map;
      print(body);
      emit(LoadedActivity(body));
    } catch (e) {
      print(e.toString());
    }
  }

  Future addActivity({
    String token,
    String description,
    String title,
    List files,
    int projectId,
    int activityId,
  }) async {
    emit(AddingActivity());
    try {
      final body = await Routing().addDailyActivity(
          token: token,
          projectId: projectId,
          activityId: activityId,
          dateIn: globalDateController.text,
          description: description,
          title: title,
          files: files);
      print(body);
      emit(ActivityAdded(body["success"]));
      await getActivities(
          token: token, projectId: projectId, activityId: activityId);
    } catch (e) {
      print(e.toString());
    }
  }

  Future updateActivity(
      {String token,
      int projectId,
      int activityId,
      int itemId,
      String title,
      String description,
      List files}) async {
    emit(UpdatingActivity());
    try {
      final body = await Routing().updateDailyActivity(
          token: token,
          projectId: projectId,
          activityId: activityId,
          dateIn: globalDateController.text,
          itemId: itemId,
          title: title,
          description: description,
          files: files);
      print(body);
      emit(ActivityUpdated(body["success"]));
      await getActivities(
          token: token, projectId: projectId, activityId: activityId);
    } catch (e) {
      print(e.toString());
    }
  }

  Future deleteActivity(
      {String token, int projectId, int activityId, int itemId}) async {
    emit(DeletingActivity());
    try {
      final body =
          await Routing().deleteDailyActivity(token: token, itemId: itemId);
      print(body);
      emit(ActivityDeleted(body["success"]));
      await getActivities(
          token: token, projectId: projectId, activityId: activityId);
    } catch (e) {
      print(e.toString());
    }
  }
}
