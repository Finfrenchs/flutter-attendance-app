import 'package:camera/camera.dart';
import 'package:flutter_attendance_app/data/datasource/attendance_remote_datasource.dart';
import 'package:flutter_attendance_app/data/model/request/update_request_model.dart';
import 'package:flutter_attendance_app/data/model/response/login_response_model.dart';
import 'package:flutter_attendance_app/data/model/response/user_response_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_user_register_face_event.dart';
part 'update_user_register_face_state.dart';
part 'update_user_register_face_bloc.freezed.dart';

class UpdateUserRegisterFaceBloc
    extends Bloc<UpdateUserRegisterFaceEvent, UpdateUserRegisterFaceState> {
  final AttendanceRemoteDatasource datasource;

  UpdateUserRegisterFaceBloc(
    this.datasource,
  ) : super(const _Initial()) {
    on<_UpdateUserRegisterFace>((event, emit) async {
      emit(const _Loading());

      final requestData = UpdateRequestModel(
        faceEmbedding: event.user.faceEmbedding!,
        image: event.image,
      );

      final response = await datasource.updateProfileRegisterFace(requestData);
      response.fold(
        (l) => emit(_Error(l)),
        (r) => emit(_Loaded(r)),
      );
    });
  }
}
