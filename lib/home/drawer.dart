// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:form_json_schema/utils/utils.dart';

class DrawerScreen extends StatefulWidget {
  const DrawerScreen({super.key});

  @override
  State<DrawerScreen> createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero, // Removes default padding
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: Text(
              'Drawer ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {
                //Todo logout dialog

                Utils.logoutDialog(context);
              }),
        ],
      ),
    );
  }
}
