part of 'add_permission_bloc.dart';

@freezed
class AddPermissionEvent with _$AddPermissionEvent {
  const factory AddPermissionEvent.started() = _Started;
  const factory AddPermissionEvent.addPermission(
    String datePermission,
    String reason,
    XFile image,
  ) = _AddPermission;
}
