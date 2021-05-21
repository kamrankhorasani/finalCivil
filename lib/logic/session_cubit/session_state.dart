part of 'session_cubit.dart';

abstract class SessionState extends Equatable {
  const SessionState();

  @override
  List<Object> get props => [];
}

class SessionInitial extends SessionState {}

class LoadingSession extends SessionState {}

class LoadedSession extends SessionState {
  final Map sessions;

  LoadedSession(this.sessions);
}

class FailedLoadingSession extends SessionState {}

class AddingSession extends SessionState {}

class AddedSession extends SessionState {
    final bool success;

  AddedSession(this.success);
}

class FailedAddingSession extends SessionState {}

class UpdatingSession extends SessionState {}

class UpdatedSession extends SessionState {
    final bool success;

  UpdatedSession(this.success);
}

class FailedUpdatingSession extends SessionState {}

class DeletingSession extends SessionState {}

class DeletedSession extends SessionState {
    final bool success;

  DeletedSession(this.success);
}

class FailedDeletingSession extends SessionState {}
