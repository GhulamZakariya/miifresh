import 'package:flutter/material.dart';
import 'package:flutterdelivery/bloc/change_status/status_bloc.dart';
import 'package:flutterdelivery/bloc/login/login_bloc.dart';
import 'package:flutterdelivery/bloc/server_settings/server_settings_bloc.dart';
import 'package:flutterdelivery/repositories/change_status_repo.dart';
import 'package:flutterdelivery/repositories/login_repo.dart';
import 'package:flutterdelivery/repositories/settings_repo.dart';
import 'package:flutterdelivery/splash_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'home_screen.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mii Fresh Delivery',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (BuildContext context) =>
                  ServerSettingsBloc(RealServerSettingsRepo())),
          BlocProvider(create: (context) => LoginBloc(RealLoginRepo())),
        ],
        child: SplashScreen(),
      ),
    );
  }
}
