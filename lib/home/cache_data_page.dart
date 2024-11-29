import 'package:flutter/material.dart';
import 'package:form_json_schema/local_database/database.dart';

class CacheDataPage extends StatefulWidget {
  const CacheDataPage({super.key});

  @override
  State<CacheDataPage> createState() => _CacheDataPageState();
}

class _CacheDataPageState extends State<CacheDataPage> {
  final db = LocalTableDatabase();
  List<String> title = [];
  List<String> description = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text('Home Page Offline'),
      ),
      body: FutureBuilder(
        future: getData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          //Todo Fetch the data and display them in a ListView

          return ListView.builder(
            itemCount: title.length,
            itemBuilder: (context, index) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text("${index + 1}"),
                  ),
                  ListTile(
                    title: Text("Title : ${title[index]}"),
                    subtitle: Text("Description : ${description[index]}"),
                  ),
                  const Divider()
                ],
              );
            },
          );
        },
      ),
    );
  }

//Todo Function to  Get data From local Database

  getData() async {
    var data = await db.fetchAllData();

    for (var i = 0; i < data.length; i++) {
      title.add(data[i].title.toString());
      description.add(data[i].description.toString());
    }
  }
}
