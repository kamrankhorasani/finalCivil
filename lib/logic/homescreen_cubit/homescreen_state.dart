part of 'homescreen_cubit.dart';

abstract class HomescreenState extends Equatable {
  const HomescreenState();

  @override
  List<Object> get props => [];
}

class HomescreenInitial extends HomescreenState {}

class HomescreenLoadingProject extends HomescreenState {}

class HomescreenLoadedProject extends HomescreenState {
  final Map projects;

  HomescreenLoadedProject(this.projects);
}

class HomeScreenLoadFailed extends HomescreenState {
  final String error;

  HomeScreenLoadFailed(this.error);
}
