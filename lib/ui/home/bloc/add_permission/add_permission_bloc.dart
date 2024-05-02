// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:flutter_attendance_app/data/model/request/add_permission_request_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:flutter_attendance_app/data/datasource/permission_remote_datasource.dart';
import 'package:flutter_attendance_app/data/model/response/add_permission_response_model.dart';

part 'add_permission_bloc.freezed.dart';
part 'add_permission_event.dart';
part 'add_permission_state.dart';

class AddPermissionBloc extends Bloc<AddPermissionEvent, AddPermissionState> {
  final PermissionRemoteDatasource datasource;
  AddPermissionBloc(
    this.datasource,
  ) : super(const _Initial()) {
    on<_AddPermission>((event, emit) async {
      emit(const _Loading());

      final requestData = AddPermissionRequestModel(
        datePermission: event.datePermission,
        reason: event.reason,
        image: event.image,
      );

      final response = await datasource.addPermission(requestData);

      response.fold(
        (l) => emit(_Error(l)),
        (r) => emit(_Loaded(r)),
      );
    });
  }
}
