// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_json_schema/sessions/login.dart';
import 'package:get/get.dart';

class Utils {
//Todo common toast message

  static showToastMessage(msg, backgroundColor) {
    return Fluttertoast.showToast(msg: msg, backgroundColor: backgroundColor);
  }

//Todo logout dialog

  static logoutDialog(context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          content: Text('Are you sure want to logout?'),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextButton(
                  onPressed: () async {
                    //Todo logout from firebase

                    await FirebaseAuth.instance.signOut();

                    Navigator.pop(context);
                    Get.to(Login());
                  },
                  child: Text('Yes'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('No'),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
