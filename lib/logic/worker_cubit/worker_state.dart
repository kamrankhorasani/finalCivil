part of 'worker_cubit.dart';

abstract class WorkerState extends Equatable {
  const WorkerState();

  @override
  List<Object> get props => [];
}

class WorkerInitial extends WorkerState {}

class LoadingWorkers extends WorkerState {}

class LoadedWorkers extends WorkerState {
  final Map workers;
  final List types;


  LoadedWorkers(this.workers,this.types);
}

class FailedLoadingWorkers extends WorkerState {}

class DeletingWorker extends WorkerState {}

class WorkerDeleted extends WorkerState {
  final bool success;

  WorkerDeleted(this.success);
}

class FailedDeletingWorker extends WorkerState {}

class AddingWorker extends WorkerState {}

class WorkerAdded extends WorkerState {
  final bool success;

  WorkerAdded(this.success);
}

class FailedAddingWorker extends WorkerState {}

class UpdatingWorker extends WorkerState {}

class UpdatedWorker extends WorkerState {
  final bool success;

  UpdatedWorker(this.success);
}

class FailedUpdatingWorker extends WorkerState {}
