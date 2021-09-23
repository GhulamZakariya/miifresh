import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutterdelivery/api/responses/change_status_response.dart';
import 'package:flutterdelivery/repositories/change_status_repo.dart';

part 'status_event.dart';

part 'status_state.dart';

class StatusBloc extends Bloc<StatusEvent, StatusState> {
  final ChangeStatusRepo statusRepo;

  StatusBloc(this.statusRepo) : super(StatusInitial());

  @override
  Stream<StatusState> mapEventToState(StatusEvent event) async* {
    if (event is ToggleOnline) {
      try {
        final changeStatusResponse =
            await statusRepo.changeStatus(event.status, event.pinCode);
        if (changeStatusResponse.success == "1")
          yield StatusLoaded(changeStatusResponse);
        else
          yield StatusError(changeStatusResponse.message);
      } on Error {
        yield StatusError("Something went wrong");
      }
    }
  }
}
