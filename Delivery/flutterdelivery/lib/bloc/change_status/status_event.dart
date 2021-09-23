part of 'status_bloc.dart';

abstract class StatusEvent extends Equatable {
  const StatusEvent();
}

class ToggleOnline extends StatusEvent {
  final String pinCode;
  final String status;

  const ToggleOnline(this.pinCode, this.status);

  @override
  List<Object> get props => [this.pinCode, this.status];
}
