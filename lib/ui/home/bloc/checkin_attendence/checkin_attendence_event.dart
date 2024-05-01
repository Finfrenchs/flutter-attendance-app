part of 'checkin_attendence_bloc.dart';

@freezed
class CheckinAttendenceEvent with _$CheckinAttendenceEvent {
  const factory CheckinAttendenceEvent.started() = _Started;
  const factory CheckinAttendenceEvent.checkin(
      String latitude, String longitude) = _Checkin;
}
