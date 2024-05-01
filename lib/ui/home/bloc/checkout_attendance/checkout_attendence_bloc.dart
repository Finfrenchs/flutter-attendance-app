import 'package:bloc/bloc.dart';
import 'package:flutter_attendance_app/data/datasource/attendance_remote_datasource.dart';
import 'package:flutter_attendance_app/data/model/response/checkout_response_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'checkout_attendence_event.dart';
part 'checkout_attendence_state.dart';
part 'checkout_attendence_bloc.freezed.dart';

class CheckoutAttendenceBloc
    extends Bloc<CheckoutAttendenceEvent, CheckoutAttendenceState> {
  final AttendanceRemoteDatasource datasource;
  CheckoutAttendenceBloc(
    this.datasource,
  ) : super(const _Initial()) {
    on<_Checkout>((event, emit) async {
      emit(const _Loading());

      final response = await datasource.checkout(
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
