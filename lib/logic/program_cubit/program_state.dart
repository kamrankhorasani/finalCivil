part of 'program_cubit.dart';

abstract class ProgramState extends Equatable {
  const ProgramState();

  @override
  List<Object> get props => [];
}

class ProgramInitial extends ProgramState {}

class LoadingPrograms extends ProgramState {}

class LoadedPrograms extends ProgramState {
  final Map programs;

  LoadedPrograms(this.programs);
}

class FailedLoadingPrograms extends ProgramState {}

class DeletingProgram extends ProgramState {}

class DeletedProgram extends ProgramState {
  final bool success;

  DeletedProgram(this.success);
}

class FailedDeletingProgram extends ProgramState {}

class UpdatingProgram extends ProgramState {}

class UpdatedProgram extends ProgramState {
    final bool success;

  UpdatedProgram(this.success);
}

class FailedUpdatingProgram extends ProgramState {}

class AddingProgram extends ProgramState {}

class AddedProgram extends ProgramState {
    final bool success;

  AddedProgram(this.success);
}

class FailedAddingProgram extends ProgramState {}
