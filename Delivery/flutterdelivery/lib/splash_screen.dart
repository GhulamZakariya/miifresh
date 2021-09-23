import 'dart:async';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutterdelivery/app_data.dart';
import 'package:flutterdelivery/bloc/login/login_bloc.dart';
import 'package:flutterdelivery/bloc/server_settings/server_settings_bloc.dart';
import 'package:flutterdelivery/login_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterdelivery/repositories/login_repo.dart';

import 'home_screen.dart';
import 'shared_prefs.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  LoginBloc loginBloc;

  @override
  void initState() {
    super.initState();
    // ignore: close_sinks
    ServerSettingsBloc serverSettingsBloc =
        BlocProvider.of<ServerSettingsBloc>(context);
    print("splach Screen ////////////////////////////////////////");
    serverSettingsBloc.add(GetServerSettings());
    print("serverSettingsBloc ////////////////////////////////////////");
    print(serverSettingsBloc);
    loginBloc = BlocProvider.of<LoginBloc>(context);
    print("loginBloc ////////////////////////////////////////");
    print(loginBloc);



  }

  Future<void> moveToNext() async {
    if (await FirebaseAuth.instance.currentUser != null) {
      final sharedPrefService = await SharedPreferencesService.instance;
      String pinCode = sharedPrefService.userCode;
      if (pinCode != null){
        print("ander//////////////////////////////////////");
        loginBloc.add(PerformLogin(
            pinCode, "shkaffewgg321c"));
      } else {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) =>
                BlocProvider<LoginBloc>(
                  create: (context) => LoginBloc(RealLoginRepo()),
                  child: MyHomePage(),
                )));
      }
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) => BlocProvider<LoginBloc>(
                create: (context) => LoginBloc(RealLoginRepo()),
                child: LoginScreen(),
              )));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ServerSettingsBloc, ServerSettingsState>(
      builder: (context, state) {
        return BlocConsumer<LoginBloc, LoginState>(
          builder: (context, state) => ScreenUi(),
          listener: (context, state) {
            if (state is LoginLoaded) {
              AppData.user = state.user;
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) =>
                      BlocProvider<LoginBloc>(
                        create: (context) => LoginBloc(RealLoginRepo()),
                        child: MyHomePage(),
                      )));
            }
          },
        );
      },
      listener: (context, state) {
        if (state is ServerSettingsInitial) {
        } else if (state is ServerSettingsLoading) {
        } else if (state is ServerSettingsLoaded) {
          if (state.settingsResponse.success == "1" &&
              state.settingsResponse.data != null) {
            AppData.settings = state.settingsResponse.data;
            moveToNext();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.settingsResponse.message)));
          }
        } else if (state is ServerSettingsError) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.error)));
        }
      },
    );
  }
}

class ScreenUi extends StatelessWidget {
  const ScreenUi({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/splash.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              Expanded(
                child: Container(),
              ),
              Expanded(
                  child: Container(
                child: Center(
                  child: Container(child: CircularProgressIndicator()),
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }
}
