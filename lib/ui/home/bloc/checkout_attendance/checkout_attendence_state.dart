part of 'checkout_attendence_bloc.dart';

@freezed
class CheckoutAttendenceState with _$CheckoutAttendenceState {
  const factory CheckoutAttendenceState.initial() = _Initial;
  const factory CheckoutAttendenceState.loading() = _Loading;
  const factory CheckoutAttendenceState.loaded(
      CheckOutResponseModel responseModel) = _Loaded;
  const factory CheckoutAttendenceState.error(String message) = _Error;
}
