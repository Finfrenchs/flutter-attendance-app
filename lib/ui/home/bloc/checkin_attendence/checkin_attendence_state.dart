part of 'checkin_attendence_bloc.dart';

@freezed
class CheckinAttendenceState with _$CheckinAttendenceState {
  const factory CheckinAttendenceState.initial() = _Initial;
  const factory CheckinAttendenceState.loading() = _Loading;
  const factory CheckinAttendenceState.loaded(
      CheckinResponseModel responseModel) = _Loaded;
  const factory CheckinAttendenceState.error(String message) = _Error;
}
