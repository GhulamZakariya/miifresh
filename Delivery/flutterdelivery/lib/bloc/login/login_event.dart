part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();
}

class PerformLogin extends LoginEvent {

  final String pinCode;
  final String deviceId;

  const PerformLogin(this.pinCode, this.deviceId);

  @override
  List<Object> get props => [this.pinCode, this.deviceId];

}