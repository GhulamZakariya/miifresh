part of 'status_bloc.dart';

abstract class StatusState extends Equatable {
  const StatusState();
}

class StatusInitial extends StatusState {
  const StatusInitial();

  @override
  List<Object> get props => [];
}

class StatusLoading extends StatusState {
  const StatusLoading();

  @override
  List<Object> get props => [];
}

class StatusLoaded extends StatusState {
  final ChangeStatusResponse response;

  const StatusLoaded(this.response);

  @override
  List<Object> get props => [this.response];
}

class StatusError extends StatusState {
  final String error;

  const StatusError(this.error);

  @override
  List<Object> get props => [this.error];
}
