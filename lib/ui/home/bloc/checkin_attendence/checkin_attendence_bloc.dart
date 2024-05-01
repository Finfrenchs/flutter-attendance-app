import 'package:bloc/bloc.dart';
import 'package:flutter_attendance_app/data/datasource/attendance_remote_datasource.dart';
import 'package:flutter_attendance_app/data/model/response/checkin_response_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'checkin_attendence_event.dart';
part 'checkin_attendence_state.dart';
part 'checkin_attendence_bloc.freezed.dart';

class CheckinAttendenceBloc
    extends Bloc<CheckinAttendenceEvent, CheckinAttendenceState> {
  final AttendanceRemoteDatasource datasource;
  CheckinAttendenceBloc(
    this.datasource,
  ) : super(const _Initial()) {
    on<_Checkin>((event, emit) async {
      emit(const _Loading());

      final response = await datasource.checkin(
        event.latitude,
        event.longitude,
      );

      response.fold(
        (l) => emit(_Error(l)),
        (r) => emit(_Loaded(r)),
      );
    });
  }
}
