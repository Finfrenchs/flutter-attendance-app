part of 'logout_bloc.dart';

@freezed
class LogoutState with _$LogoutState {
  const factory LogoutState.initial() = _Initial;
  const factory LogoutState.loading() = _Loading;
  const factory LogoutState.loaded(LogoutResponseModel responseModel) = _Loaded;
  const factory LogoutState.error(String message) = _Error;
}
