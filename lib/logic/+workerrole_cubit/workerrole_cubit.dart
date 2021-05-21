import 'package:bloc/bloc.dart';
import 'package:civil_project/data/network.dart';
import 'package:civil_project/screens/homee/home_items.dart';
import 'package:equatable/equatable.dart';

part 'workerrole_state.dart';

class WorkerroleCubit extends Cubit<WorkerroleState> {
  WorkerroleCubit() : super(WorkerroleInitial());

  Future getHumenResources(
      {String token, int projectId, int activityId}) async {
    emit(WorkerRoleLoading());
    try {
      final body = await Routing()
          .getHumenResource(token: token, projectId: projectId) as Map;
      final body2 = await Routing().getHumenWorkers(
          token: token,
          projectId: projectId,
          activityId: activityId,
          dateIn: globalDateController.text) as Map;
      print(body2);
      print(body);
      emit(WorkerRoleLoaded(body['data'], body2));
    } catch (e) {
      print(e.toString());
      emit(WorkerRoleFailedLoading());
    }
  }

  Future updatingHumen(
      {String token,
      int projectId,
      int activityId,
      int itemId,
      int humanId,
      String descriptionWork,
      String timeFor,
      String timeTo}) async {
    emit(UpdatingRole());
    try {
      final body = await Routing().updateHumen(
          token: token,
          humanId: humanId,
          itemId: itemId,
          descriptionWork: descriptionWork,
          timeFor: timeFor,
          timeTo: timeTo);
      print(body);
      emit(UpdatedRole(body["success"]));
      await getHumenResources(
          token: token, projectId: projectId, activityId: activityId);
    } catch (e) {
      emit(UpdatingFailedRole());
    }
  }

  Future deletingHumen(
      {String token,
      int itemId,
      int projectId,
      int activityId,
      String dateIn}) async {
    emit(DeletingRole());
    try {
      final body = await Routing().deleteHumen(token: token, itemId: itemId);
      print(body);
      emit(DeletedRole(body["success"]));
      await getHumenResources(
          token: token, projectId: projectId, activityId: activityId);
    } catch (e) {
      emit(DeletingFailedRole());
    }
  }

  Future addingHumen(
      {String token,
      int projectId,
      int activityId,
      int humanId,
      String descriptionWork,
      String fromTime,
      String toTime}) async {
    emit(AddingRole());
    try {
      final body = await Routing().addHumenResource(
          token: token,
          projectId: projectId,
          activityId: activityId,
          dateIn: globalDateController.text,
          humanId: humanId,
          descriptionWork: descriptionWork,
          fromTime: fromTime,
          toTime: toTime);
      print(body);
      emit(AddedRole(body["success"]));
      await getHumenResources(token: token,projectId: projectId,activityId:activityId);
    } catch (e) {
      print(e.toString());
      emit(AddingFailedRole());
    }
  }
}
