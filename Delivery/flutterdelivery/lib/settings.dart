import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterdelivery/account_info.dart';
import 'package:flutterdelivery/app_data.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterdelivery/bloc/change_status/status_bloc.dart';
import 'package:flutterdelivery/repositories/change_status_repo.dart';

import 'api/responses/change_status_response.dart';
import 'app_data.dart';
import 'app_data.dart';
import 'app_data.dart';
import 'app_data.dart';
import 'app_data.dart';
import 'app_data.dart';
import 'app_data.dart';

class Settings extends StatefulWidget {
  final Function(int position) _toHomeScreen;
  final Function(Widget nextScreen) _toNextScreen;
  final Function() _toLoginScreen;
  final Function() _dismissDialog;

  Settings(this._toHomeScreen, this._toNextScreen, this._toLoginScreen,
      this._dismissDialog);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  StatusBloc statusBloc;

  ChangeStatusRepo repo;
  GlobalKey thisKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    repo = RealChangeStatusRepo();

    statusBloc = BlocProvider.of<StatusBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: thisKey,
      appBar: AppBar(title: Text("Settings"), actions: [
        Row(
          children: [
            Text(
              AppData.isOnline ? "Online" : "Offline",
              style: TextStyle(fontSize: 12.0),
            ),
            Switch(
                value: AppData.isOnline,
                onChanged: (val) async {
                  showLoaderDialog(context);
                  statusBloc.add(
                      ToggleOnline(AppData.user.password, val ? "8" : "11"));
                }),
          ],
        ),
      ]),
      body: BlocConsumer<StatusBloc, StatusState>(
        builder: (context, state) => buildSingleChildScrollView(context),
        listener: (context, state) {
          if (state is StatusLoaded) {
            widget._dismissDialog();
            setState(() {
              AppData.isOnline = !AppData.isOnline;
            });
            if (AppData.isOnline) widget._toHomeScreen(0);
          } else if (state is StatusError) {
            widget._dismissDialog();
          }
        },
      ),
    );
  }

  Widget buildSingleChildScrollView(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(35),
            width: double.maxFinite,
            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
            child: Column(
              children: [
                SizedBox(
                  width: 100.0,
                  height: 100.0,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50.0),
                    child: Image.asset(
                      "assets/images/avator.png",
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  AppData.user.firstName + " " + AppData.user.lastName,
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                Text(
                  AppData.user.email,
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
                Padding(
                    padding: EdgeInsets.all(4),
                    child: Text(
                      AppData.settings.currencySymbol + AppData.user.balance.toString(),
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    )),
                TextButton(
                    onPressed: () {
                      print("object");
                    },
                    child: Text(
                      "WithDraw",
                      style: TextStyle(color: Colors.white),
                    ))
              ],
            ),
          ),
          ListView(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            children: [
              ListTile(
                title: Text("Floating Cash"),
                trailing: Text(
                  AppData.settings.currencySymbol + AppData.user.flostingCash.toString(),
                  style: TextStyle(fontSize: 18),
                ),
              ),
              ListTile(
                title: Text("Account info"),
                onTap: () {
                  widget._toNextScreen(AccountInfo());
                },
              ),
              ListTile(
                title: Text("Dashboard"),
                onTap: () {
                  if (AppData.isOnline)
                    widget._toHomeScreen(0);
                  else
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("You are offline. Please go online.")));
                },
              ),
              ListTile(
                title: Text("History"),
                onTap: () {
                  if (AppData.isOnline)
                    widget._toHomeScreen(1);
                  else
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("You are offline. Please go online.")));
                },
              ),
              ListTile(
                title: Text("Legal"),
                onTap: () {},
              ),
              ListTile(
                title: Text("Logout"),
                onTap: () {
                  _signOut();
                },
              ),
            ],
          )
        ],
      ),
    );
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    AppData.user = null;
    widget._toLoginScreen();
  }

  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(
              margin: EdgeInsets.only(left: 7), child: Text("Loading...")),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
