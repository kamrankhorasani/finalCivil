part of 'checklist_cubit.dart';

abstract class ChecklistState extends Equatable {
  const ChecklistState();

  @override
  List<Object> get props => [];
}

class ChecklistInitial extends ChecklistState {}
class LoadingChecklist extends ChecklistState {}

class LoadedChecklist extends ChecklistState {
  final Map checklists;
  LoadedChecklist(this.checklists);
  List<Object> get props => [checklists];

}

class FailedLoadingChecklist extends ChecklistState {}

class AddingChecklist extends ChecklistState {}

class AddedChecklist extends ChecklistState {}

class FailedAddingChecklist extends ChecklistState {}

class UpdatingChecklist extends ChecklistState {}

class UpdatedChecklist extends ChecklistState {}

class FailedUpdatingChecklist extends ChecklistState {}

class DeletingChecklist extends ChecklistState {}

class DeletedChecklist extends ChecklistState {}

class FailedDeletingChecklist extends ChecklistState {}
