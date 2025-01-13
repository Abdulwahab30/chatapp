import 'package:chatapp/providers/user_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<EditProfileScreen> {
  Map<String, dynamic>? userData = {};
  TextEditingController nameText = TextEditingController();
  var editProfileFormKey = GlobalKey<FormState>();
  var db = FirebaseFirestore.instance;
  @override
  void initState() {
    nameText.text = Provider.of<UserProvider>(context, listen: false).userName;
    super.initState();
  }

  void upateData() {
    Map<String, dynamic> dataToUpdate = {
      "name": nameText.text,
    };
    db
        .collection("users")
        .doc(Provider.of<UserProvider>(context, listen: false).userId)
        .update(dataToUpdate);

    Provider.of<UserProvider>(context, listen: false).getUserDetails();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        centerTitle: true,
        actions: [
          InkWell(
            onTap: () {
              if (editProfileFormKey.currentState!.validate()) {
                upateData();
              }
            },
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.check),
            ),
          )
        ],
      ),
      body: Container(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: editProfileFormKey,
            child: Column(
              children: [
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Name cannot be empty";
                    }
                  },
                  controller: nameText,
                  decoration: const InputDecoration(label: Text("Name")),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
