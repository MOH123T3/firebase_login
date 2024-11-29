// ignore_for_file: must_be_immutable, prefer_const_constructors, deprecated_member_use

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_json_schema/home/cache_data_page.dart';
import 'package:form_json_schema/home/drawer.dart';
import 'package:form_json_schema/home/fire_store_data_page.dart';
import 'package:form_json_schema/local_database/database.dart';
import 'package:form_json_schema/utils/utils.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final db = LocalTableDatabase();
  bool fetchData = false;
  int timeStamps = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  //Todo Get Offline sql data for time stamps
  getData() async {
    setState(() {});
    try {
      var data = await db.fetchAllData();
      fetchData = data.isEmpty;
      timeStamps = data.first.timestamp!;
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        //Todo logout dialog

        Utils.logoutDialog(context);

        return false;
      },
      child: Scaffold(
          drawer: DrawerScreen(),
          body: StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasData) {
                  // Todo when user online

                  Utils.showToastMessage("You are online now", Colors.green);
                  return FirestoreDataPage();
                } else if (DateTime.now()
                            .difference(
                                DateTime.fromMillisecondsSinceEpoch(timeStamps))
                            .inHours <
                        24 &&
                    fetchData == false) {
                  //Todo   If data is valid within the last 24 hours, return it

                  Utils.showToastMessage(
                      "Data fetched within the last 24", Colors.green);
                  return CacheDataPage();
                } else {
                  return Center(
                    child: Text("Something went wrong"),
                  );
                }
              })),
    );
  }
}
