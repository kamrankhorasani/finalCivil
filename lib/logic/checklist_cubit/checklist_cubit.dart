import 'package:bloc/bloc.dart';
import 'package:civil_project/data/network.dart';
import 'package:equatable/equatable.dart';

part 'checklist_state.dart';

class ChecklistCubit extends Cubit<ChecklistState> {
  ChecklistCubit() : super(ChecklistInitial());

  Future gettingChecklist({String token, int activityId}) async {
    emit(LoadingChecklist());
    try {
      final body =
          await Routing().getCheckList(token: token, activityId: activityId);
      print(body);
      emit(LoadedChecklist(body));
    } catch (e) {
      print(e.toString());
      emit(FailedLoadingChecklist());
    }
  }

  Future updatingChecklist({String token, int activityId, List items}) async {
    emit(AddingChecklist());
    try {
      final body = await Routing().upadteChecklist(token: token, items: items);
      print(body);
      emit(AddedChecklist());
      await gettingChecklist(token: token, activityId: activityId);
    } catch (e) {
      print(e.toString());
      emit(FailedAddingChecklist());
    }
  }
}
