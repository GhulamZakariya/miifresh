import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterdelivery/app_data.dart';
import 'package:flutterdelivery/bloc/login/login_bloc.dart';
import 'package:flutterdelivery/dialog_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterdelivery/repositories/login_repo.dart';
import 'package:flutterdelivery/shared_prefs.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _verificationId;

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController inputCodeController = TextEditingController();

  LoginBloc loginBloc;

  @override
  void initState() {
    super.initState();

    loginBloc = BlocProvider.of<LoginBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: BlocConsumer<LoginBloc, LoginState>(
        builder: (context, state) => Container(
          width: double.maxFinite,
          height: double.maxFinite,
          color: Theme.of(context).primaryColor,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 18.0),
            child: Column(
              children: [
                Expanded(
                    child: Image.asset(
                  "assets/images/splashed.png",
                )),
                Column(
                  children: [
                    Text(
                      "Welcome to delivery boy application. This application give a functionality which builds a link between Admin and the Delivery boy",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(
                      height: 12.0,
                    ),
                    Container(
                        width: double.maxFinite,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 12.0),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.white, // set border color
                                width: 1.0), // set border width
                            borderRadius: BorderRadius.all(Radius.circular(
                                5.0)), // set rounded corner radius
                          ),
                          child: TextField(
                            controller: inputCodeController,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: 'User Pin Code',
                              hintStyle: TextStyle(color: Colors.white),
                              border: InputBorder.none,
                            ),
                          ),
                        )),
                    SizedBox(
                      height: 8.0,
                    ),
                    Container(
                      width: double.maxFinite,
                      child: OutlinedButton(
                        onPressed: () {
                          if (inputCodeController.text.isNotEmpty)
                            print("pressed///////////////////////////////////////////////////");
                            loginBloc.add(
                                PerformLogin(
                                inputCodeController.text, "shkaffewgg321c")
                            );
                            print("performlogin//////////////////////////////////////");
                        },
                        child: Text(
                          "Login",
                          style: TextStyle(color: Colors.white),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(width: 1, color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 18.0,
                ),
              ],
            ),
          ),
        ),
        listener: (context, state) {
          if (state is LoginLoaded) {
            print("LoginLoaded///////////////////////////////");
            AppData.user = state.user;
            print(AppData.user);
            showLoaderDialog(context);
            print("AppData.user.phone///////////////////////////////");
            print(AppData.user.phone);
            sendOtpCode(AppData.user.phone);
          }
        },
      ),
    );
  }

  Future<void> okBtnFunction(String code) async {
    try {
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: code,
      );

      final User user = (await _auth.signInWithCredential(credential)).user;

      Navigator.pop(context);
      if (user != null) {
        final sharedPrefService = await SharedPreferencesService.instance;
        sharedPrefService.setUserCode(AppData.user.password);
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (BuildContext context) => MyHomePage()));
        showSnackbar("Successfully signed in UID: ${user.uid}");
      }
    } catch (e) {
      Navigator.pop(context);
      showSnackbar("Failed to sign in: " + e.toString());
    }
  }

  Future<void> sendOtpCode(String phoneNumber) async {
    try {
      print("sendotp////////////////////////////////////////////////////");
      print(phoneNumber);
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(minutes: 2),
        verificationCompleted: (phoneAuthCredential) async {
          print("phoneAuthCredential////////////////////////////////////////////////////");
          await _auth.signInWithCredential(phoneAuthCredential);
          print("signInWithCredential////////////////////////////////////////////////////");
          final sharedPrefService = await SharedPreferencesService.instance;
          sharedPrefService.setUserCode(AppData.user.password);
          showSnackbar(
              "Phone number automatically verified and user signed in: ${_auth.currentUser.uid}");
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) => MyHomePage()));
        },
        verificationFailed: (error) {
          showSnackbar(
              'Phone number verification failed. Code: ${error.code}. Message: ${error.message}');
          Navigator.pop(context);
        },
        codeSent: (verificationId, forceResendingToken) {
          showSnackbar('Please check your phone for the verification code.');
          _verificationId = verificationId;
          DialogUtils.showCustomDialog(context,
              title: "Validate OTP", okBtnFunction: okBtnFunction);
        },
        codeAutoRetrievalTimeout: (verificationId) {
          showSnackbar("verification code: " + verificationId);
          _verificationId = verificationId;
        },
      );
    } catch (e) {
      showSnackbar("Failed to Verify Phone Number: ${e}");
      Navigator.pop(context);
    }
  }

  void showSnackbar(String message) {
    ScaffoldMessenger.of(_scaffoldKey.currentContext).hideCurrentSnackBar();
    ScaffoldMessenger.of(_scaffoldKey.currentContext)
        .showSnackBar(SnackBar(content: Text(message)));
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
