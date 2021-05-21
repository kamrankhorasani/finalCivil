part of 'mainscreen_cubit.dart';

abstract class MainscreenState extends Equatable {
  const MainscreenState();

  @override
  List<Object> get props => [];
}

class MainscreenInitial extends MainscreenState {}

class WBSLoading extends MainscreenState {}

class WBSLoaded extends MainscreenState {
  final List<Parent> wbs;
  final List ddbactivity;
  final Map users;

  WBSLoaded(this.wbs, this.ddbactivity, {this.users});
}
