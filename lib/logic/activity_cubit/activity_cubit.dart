import 'package:bloc/bloc.dart';
import 'package:civil_project/data/network.dart';
import 'package:civil_project/screens/homee/home_items.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

part 'activity_state.dart';

class ActivityCubit extends Cubit<ActivityState> {
  ActivityCubit() : super(ActivityInitial());

  String description = "";
  double precent;

  Future getActivities({String token, int projectId, int activityId}) async {
    emit(LoadingActivity());
    try {
      final body = await Routing().getDailyActivity(
          token: token,
          projectId: projectId,
          activityId: activityId,
          dateIn: globalDateController.text) as Map;
      print(body);
      precent = (body['data'][0]['percent'] as int).toDouble()??0;
      description = body['data'][0]['description']??"";
      emit(LoadedActivity(
          (body['data'][0]['percent']), body['data'][0]['description']));
    } catch (e) {
      print(e.toString());
    }
  }
  //!Add is not usable anymore

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

  Future updateActivity({
    String token,
    int projectId,
    int activityId,
    int percentVal,
    String description,
  }) async {
    emit(UpdatingActivity());
    try {
      final body = await Routing().updateDailyActivity(
          token: token,
          projectId: projectId,
          activityId: activityId,
          dateIn: globalDateController.text,
          description: description,
          percentVal: percentVal);
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
