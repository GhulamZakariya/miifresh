import 'package:flutter/material.dart';

class DialogUtils {
  static DialogUtils _instance = new DialogUtils.internal();

  DialogUtils.internal();

  factory DialogUtils() => _instance;

  static TextEditingController inputCodeController = TextEditingController();


  static void showCustomDialog(BuildContext context,
      {@required String title,
      String okBtnText = "Ok",
      String cancelBtnText = "Cancel",
      @required Function(String code) okBtnFunction}) {
    showDialog(
      barrierDismissible: false,
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text(title),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "A One Time Password has been send to given Phone Number. Please enter the otp bellow to verify your login",
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 12.0,),
                Container(
                    width: double.maxFinite,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Theme.of(context)
                                .primaryColor, // set border color
                            width: 1.0), // set border width
                        borderRadius: BorderRadius.all(
                            Radius.circular(5.0)), // set rounded corner radius
                      ),
                      child: TextField(
                        controller: inputCodeController,
                        decoration: InputDecoration(
                          hintText: 'User Pin Code',
                          border: InputBorder.none,
                        ),
                      ),
                    )),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: Text(okBtnText),
                onPressed: () {
                  okBtnFunction(inputCodeController.text);
                },
              ),
              TextButton(
                  child: Text(cancelBtnText),
                  onPressed: () => Navigator.pop(context))
            ],
          );
        });
  }
}
