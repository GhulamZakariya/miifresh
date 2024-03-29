import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_app1/app_data.dart';
import 'package:flutter_app1/src/blocs/server_settings/server_settings_bloc.dart';
import 'package:flutter_app1/src/ui/screens/home_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // ignore: close_sinks
    final serverSettingsBloc = BlocProvider.of<ServerSettingsBloc>(context);
    serverSettingsBloc.add(GetServerSettings());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ServerSettingsBloc, ServerSettingsState>(
      listener: (context, state) {
        if (state is ServerSettingsLoaded) {
          AppData.settings = state.settingsResponse.data;
          Future.microtask(() => Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (BuildContext context) => Home())));
        }
      },
      child: ScreenUi(),
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
        backgroundColor: Theme.of(context).primaryColor,
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 100.0,
                        height: 100.0,
                        child: Image.asset(
                          "assets/images/icon.png",
                          fit: BoxFit.fill,
                        ),
                      ),
                      Text(
                        "Mii Fresh",
                        style: TextStyle(color: Colors.white, fontSize: 35),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 25),
                        child: CircularProgressIndicator(),
                      ),
                      // Padding(
                      //   padding: EdgeInsets.only(bottom: 50),
                      //   child: Text("By Themes Coder"),
                      // ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/*
AppData.settings = snapshot.data.data;
Future.microtask(() => Navigator.of(context).pushReplacement(
MaterialPageRoute(builder: (BuildContext context) => Home())));
*/
