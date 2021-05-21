part of 'weather_cubit.dart';

abstract class WeatherState extends Equatable {
  const WeatherState();

  @override
  List<Object> get props => [];
}

class WeatherInitial extends WeatherState {}

class LoadingWeather extends WeatherState {}

class LoadedWeather extends WeatherState {
  final Map weathers;
  LoadedWeather(this.weathers);
}

class FailedLoadingWeather extends WeatherState {}

class DeletingWeather extends WeatherState {}

class DeletedWeather extends WeatherState {
    final bool success;

  DeletedWeather(this.success);
}

class FailedDeletingWeather extends WeatherState {}

class UpdatingWeather extends WeatherState {}

class UpdatedWeather extends WeatherState {
    final bool success;

  UpdatedWeather(this.success);
}

class FailedUpdatingWeather extends WeatherState {}

class AddingWeahter extends WeatherState {}

class AddedWeather extends WeatherState {
    final bool success;

  AddedWeather(this.success);
}

class FailedAddingWeather extends WeatherState {}
