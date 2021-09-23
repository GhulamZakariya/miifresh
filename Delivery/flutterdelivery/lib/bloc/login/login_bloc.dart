import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutterdelivery/models/user.dart';

import '../../repositories/login_repo.dart';

part 'login_state.dart';

part 'login_event.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginRepo loginRepo;

  LoginBloc(this.loginRepo) : super(LoginInitial());

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is PerformLogin) {
      try {
        print("mapEventToState/////////////////////////////////////");
        print(event.deviceId);
        print(event.pinCode);
        final loginResponse =
            await loginRepo.getLoginResponse(event.pinCode, event.deviceId);
        print("loginResponse/////////////////////////////////////");
        print(loginResponse);
        if (loginResponse.success == "1" &&
            loginResponse.data != null &&
            loginResponse.data.isNotEmpty)
          yield LoginLoaded(loginResponse.data[0]);
        else
          yield LoginError(loginResponse.message);
      } on Error {
        yield LoginError("Something went wrong!");
      }
    }
  }
}
