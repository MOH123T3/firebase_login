// ignore_for_file: library_private_types_in_public_api

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:form_json_schema/local_database/database.dart';

class FirestoreDataPage extends StatefulWidget {
  const FirestoreDataPage({super.key});

  @override
  _FirestoreDataPageState createState() => _FirestoreDataPageState();
}

class _FirestoreDataPageState extends State<FirestoreDataPage> {
  final db = LocalTableDatabase();

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text('Home Page Online'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          //Todo  firebase dynamic data add dialog

          showDialog(
              context: context,
              builder: (BuildContext context) {
                return Form(
                  key: _formKey,
                  child: AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0)),
                    title: const Text('Add data in firebase'),
                    actions: [
                      TextFormField(
                          controller: titleController,
                          autofocus: false,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "title field is empty";
                            }
                          },
                          decoration: InputDecoration(
                              contentPadding: const EdgeInsets.fromLTRB(
                                  20.0, 15.0, 20.0, 15.0),
                              hintText: "Title",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(32.0)))),
                      const SizedBox(height: 25.0),
                      TextFormField(
                          controller: descriptionController,
                          autofocus: false,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "description field is empty";
                            }
                          },
                          decoration: InputDecoration(
                              contentPadding: const EdgeInsets.fromLTRB(
                                  20.0, 15.0, 20.0, 15.0),
                              hintText: "Description",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(32.0),
                              ))),
                      const SizedBox(height: 35.0),
                      Material(
                        elevation: 5.0,
                        borderRadius: BorderRadius.circular(30.0),
                        color: Theme.of(context).primaryColor,
                        child: MaterialButton(
                          minWidth: MediaQuery.of(context).size.width,
                          padding:
                              const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              Map<String, dynamic> sampleData = {
                                "description":
                                    descriptionController.text.trim(),
                                "title": titleController.text.trim()
                              };
                              FirebaseFirestore.instance
                                  .collection('tab_collection')
                                  .add(sampleData);

                              Navigator.pop(context);
                              titleController.clear();
                              descriptionController.clear();
                            }
                          },
                          child: const Text(
                            "Save",
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      const SizedBox(height: 25.0),
                    ],
                  ),
                );
              });
        },
        label: const Text(
          'Add Data',
          style: TextStyle(color: Colors.white),
        ),
        icon: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: StreamBuilder<List<DocumentSnapshot>>(
        stream: getFetchFromFirebaseData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data available'));
          }

          //Todo Fetch the documents and display them in a ListView

          var documents = snapshot.data!;

          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, index) {
              var document = documents[index].data() as Map<String, dynamic>;

              //Todo Save offline data

              offlineSave(document['title'], document['description']);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text("${index + 1}"),
                  ),
                  ListTile(
                    title: Text("Title : ${document['title'] ?? 'No Title'}"),
                    subtitle: Text(
                        "Description : ${document['description'] ?? 'No Description'}"),
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

//Todo Function to  Fetch data From Firebase Database

  Stream<List<DocumentSnapshot>> getFetchFromFirebaseData() {
    return FirebaseFirestore.instance
        .collection('tab_collection')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs;
    });
  }

//Todo Function to save data in offline database

  offlineSave(title, description) async {
    var offlineSave = LocalDatabase(
        timestamp: DateTime.now().millisecondsSinceEpoch,
        title: title.toString(),
        description: description.toString());
    await db.addData(offlineSave);
  }
}
