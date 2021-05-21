import 'package:bloc/bloc.dart';
import 'package:civil_project/data/network.dart';
import 'package:civil_project/screens/homee/home_items.dart';
import 'package:equatable/equatable.dart';

part 'program_state.dart';

class ProgramCubit extends Cubit<ProgramState> {
  ProgramCubit() : super(ProgramInitial());

  Future gettingPrograms({String token, int projectId, int activityId}) async {
    emit(LoadingPrograms());
    try {
      final body = await Routing().getProgram(
          token: token,
          projectId: projectId,
          activityId: activityId,
          dateIn: globalDateController.text);
      print(body);
      emit(LoadedPrograms(body));
    } catch (e) {
      print(e.toString());
      emit(FailedLoadingPrograms());
    }
  }

  Future delteingPrograms(
      {String token, int projectId, int activityId, int itemId}) async {
    emit(DeletingProgram());
    try {
      final body = await Routing().deleteProgram(token: token, itemId: itemId);
      print(body);
      emit(DeletedProgram(body['success']));
      await gettingPrograms(
          token: token, projectId: projectId, activityId: activityId);
    } catch (e) {
      print(e.toString());
      emit(FailedDeletingProgram());
    }
  }

  Future updatingPrograms(
      {String token,
      int projectId,
      int activityId,
      int itemId,
      String titleOf,
      String descriptionOf,
      List file}) async {
    emit(UpdatingProgram());

    try {
      final body = await Routing().updateProgram(
          token: token,
          itemId: itemId,
          titleOf: titleOf,
          descriptionOf: descriptionOf,
          file: file);
      print(body);
      emit(UpdatedProgram(body['success']));
      await gettingPrograms(
          token: token, projectId: projectId, activityId: activityId);
    } catch (e) {
      print(e.toString());
      emit(FailedUpdatingProgram());
    }
  }

  Future addingProgram(
      {String token,
      int projectId,
      int activityId,
      String titleOf,
      String descriptionOf,
      List<dynamic> file}) async {
    emit(AddingProgram());
    try {
      final body = await Routing().addProgram(
          token: token,
          projectId: projectId,
          activityId: activityId,
          dateIn: globalDateController.text,
          descriptionOf: descriptionOf,
          titleOf: titleOf,
          file: file);
      print(body);
      emit(AddedProgram(body['success']));
      await gettingPrograms(
          token: token, projectId: projectId, activityId: activityId);
    } catch (e) {
      print(e.toString());
      emit(FailedAddingProgram());
    }
  }
}
