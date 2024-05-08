part of 'get_attendance_by_date_bloc.dart';

@freezed
class GetAttendanceByDateEvent with _$GetAttendanceByDateEvent {
  const factory GetAttendanceByDateEvent.started() = _Started;
  const factory GetAttendanceByDateEvent.fetchByDate(String date) =
      _FetchByDate;
}
