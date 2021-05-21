part of 'configur_cubit.dart';

abstract class ConfigurState extends Equatable {
  const ConfigurState();

  @override
  List<Object> get props => [];
}

class ConfigurInitial extends ConfigurState {
  final String actitle;

  ConfigurInitial(this.actitle);
}
