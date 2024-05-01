part of 'checkout_attendence_bloc.dart';

@freezed
class CheckoutAttendenceEvent with _$CheckoutAttendenceEvent {
  const factory CheckoutAttendenceEvent.started() = _Started;
  const factory CheckoutAttendenceEvent.checkout(
      String latitude, String longitude) = _Checkout;
}
