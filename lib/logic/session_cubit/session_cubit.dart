import 'package:bloc/bloc.dart';
import 'package:civil_project/data/network.dart';
import 'package:civil_project/screens/homee/home_items.dart';
import 'package:equatable/equatable.dart';

part 'session_state.dart';

class SessionCubit extends Cubit<SessionState> {
  SessionCubit() : super(SessionInitial());
  Future gettingSession({String token, int projectId, int activityId}) async {
    emit(LoadingSession());
    try {
      final body = await Routing().getSession(
          token: token,
          projectId: projectId,
          activityId: activityId,
          dateIn: globalDateController.text);
      print(body);
      emit(LoadedSession(body));
    } catch (e) {
      print(e.toString());
      emit(FailedLoadingSession());
    }
  }

  Future deletingSession(
      {String token, int projectId, int activityId, int itemId}) async {
    emit(DeletingSession());

    try {
      final body = await Routing().deleteSession(token: token, itemId: itemId);
      print(body);
      emit(DeletedSession(body['success']));
      await gettingSession(
          token: token, projectId: projectId, activityId: activityId);
    } catch (e) {
      print(e.toString());
      emit(FailedDeletingSession());
    }
  }

  Future updatingSession(
      {String token,
      int projectId,
      int activityId,
      int itemId,
      String titleOf,
      String descriptionOf,
      List sessionItems}) async {
    emit(UpdatingSession());
    try {
      final body = await Routing().updateSession(
          token: token,
          itemId: itemId,
          titleOf: titleOf,
          descriptionOf: descriptionOf,
          sessionItems: sessionItems);
      print(body);
      emit(UpdatedSession(body['success']));
      await gettingSession(
          token: token, projectId: projectId, activityId: activityId);
    } catch (e) {
      print(e.toString());
      emit(FailedUpdatingSession());
    }
  }

  Future addingSession(
      {String token,
      int projectId,
      int activityId,
      String titleOf,
      String descriptionOf,
      List sessionItems}) async {
    emit(AddingSession());

    try {
      final body = await Routing().addSession(
          token: token,
          projectId: projectId,
          activityId: activityId,
          dateIn: globalDateController.text,
          titleOf: titleOf,
          descriptionOf: descriptionOf,
          sessionItems: sessionItems);
      print(body);
      emit(AddedSession(body['success']));
      await gettingSession(
          token: token, projectId: projectId, activityId: activityId);
    } catch (e) {
      print(e.toString());
      emit(FailedAddingSession());
    }
  }
}
