import 'package:flutter_attendance_app/data/datasource/attendance_remote_datasource.dart';
import 'package:flutter_attendance_app/data/model/response/attendance_response_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_attendance_by_date_event.dart';
part 'get_attendance_by_date_state.dart';
part 'get_attendance_by_date_bloc.freezed.dart';

class GetAttendanceByDateBloc
    extends Bloc<GetAttendanceByDateEvent, GetAttendanceByDateState> {
  final AttendanceRemoteDatasource datasource;
  GetAttendanceByDateBloc(
    this.datasource,
  ) : super(const _Initial()) {
    on<_FetchByDate>((event, emit) async {
      emit(const _Loading());

      final response = await datasource.getAttendanceByDate(event.date);
      response.fold(
        (l) => emit(_Error(l)),
        (r) => emit(_Loaded(r.data ?? [])),
      );
    });
  }
}
