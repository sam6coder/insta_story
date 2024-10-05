import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
showAlertDialog(
    {required BuildContext context,
      required String titleText,
      required String alertMessage,
      Icon? alertIcon,
      Widget? button}) {
  AlertDialog alert = AlertDialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
    title: Row(
      children: [
        alertIcon ?? Container(),
        const SizedBox(width: 10),
        Expanded(child: Text(titleText)),
      ],
    ),
    content: Text(
      alertMessage,
      style: const TextStyle(
        fontSize: 15,
      ),
    ),
    actions: [
      button ?? Container(),
      TextButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Text("ok"),
      ),
    ],
  );
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

Future showAlertToast({required String msg, Color? backgroundColor}) {
  return Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: backgroundColor == null
          ? Colors.grey[900]
          : backgroundColor,
      textColor: Colors.white,
      fontSize: 16.0);
}