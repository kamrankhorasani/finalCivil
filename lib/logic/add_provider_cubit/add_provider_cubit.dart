import 'package:bloc/bloc.dart';
import 'package:civil_project/data/network.dart';
import 'package:equatable/equatable.dart';

part 'add_provider_state.dart';

class AddProviderCubit extends Cubit<AddProviderState> {
  AddProviderCubit() : super(AddProviderInitial());

  Future getProviderTypes({String token}) async {
    emit(AddProviderLoadingTypes());
    try {
      final body = await Routing().getProvierType(token: token) as Map;
      emit(AddProviderLoadedTypes(body));
    } catch (e) {
      emit(AddProviderLoadingTypesFailed(e.toString()));
    }
  }

  Future getAddressPicked(double lat, double long) async {
    try {
      final body = await Routing().getAddress(lat: lat, lng: long) as Map;
      return body;
    } catch (e) {
      print(e.toString());
    }
  }

  Future addProvider(
      {String token,
      String title,
      String firstName,
      String lastName,
      String tell,
      String mobile,
      int lat,
      int lng,
      String address,
      String cardNumber,
      String shaba,
      int providerTypeId}) async {
    emit(AddingProvider());
    try {
      final body = await Routing().addProvider(
          token: token,
          title: title,
          firstName: firstName,
          lastName: lastName,
          tell: tell,
          mobile: mobile,
          lat: lat,
          lng: lng,
          address: address,
          cardNumber: cardNumber,
          shaba: shaba,
          providerTypeId: providerTypeId);
      print(body);
      emit(ProviderAdded(body["success"]));
    } catch (e) {
      emit(AddingProviderFailed(e.toString()));
    }
  }
}
