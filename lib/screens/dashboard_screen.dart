import 'package:chatapp/providers/user_provider.dart';
import 'package:chatapp/screens/chatroom_screen.dart';
import 'package:chatapp/screens/profile_screen.dart';
import 'package:chatapp/screens/splash_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  var scaffoldKey = GlobalKey<ScaffoldState>();

  var user = FirebaseAuth.instance.currentUser;
  var db = FirebaseFirestore.instance;

  List<Map<String, dynamic>> chatroomsList = [];
  List<String> chatroomsIds = [];

  void getChatroom() {
    db.collection("chatrooms").get().then((dataSnapshot) {
      for (var singleChatroomData in dataSnapshot.docs) {
        chatroomsList.add(singleChatroomData.data());
        chatroomsIds.add(singleChatroomData.id.toString());
      }
      setState(() {});
    });
  }

  @override
  void initState() {
    getChatroom();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: const Text("Chat AWS"),
          centerTitle: true,
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                scaffoldKey.currentState!.openDrawer();
              },
              child: CircleAvatar(
                child: Text(
                  userProvider.userName[0],
                ),
              ),
            ),
          ),
        ),
        drawer: Drawer(
          child: Container(
            child: Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                ListTile(
                  onTap: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return const ProfileScreen();
                      }),
                    );
                  },
                  leading: CircleAvatar(
                    child: Text(
                      userProvider.userName[0],
                    ),
                  ),
                  title: Text(
                    userProvider.userName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(userProvider.userEmail),
                ),
                ListTile(
                  onTap: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return const ProfileScreen();
                      }),
                    );
                  },
                  leading: const Icon(Icons.people_alt),
                  title: const Text("Profile"),
                ),
                ListTile(
                  onTap: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.pushAndRemoveUntil(context,
                        MaterialPageRoute(builder: (context) {
                      return const SplashScreen();
                    }), (route) {
                      return false;
                    });
                  },
                  leading: const Icon(Icons.logout_outlined),
                  title: const Text("logout"),
                ),
              ],
            ),
          ),
        ),
        body: ListView.builder(
            itemCount: chatroomsList.length,
            itemBuilder: (BuildContext context, int index) {
              String chatroomName = chatroomsList[index]["chatroom_name"] ?? "";
              return ListTile(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ChatroomScreen(
                      chatroomId: chatroomsIds[index],
                      chatroomName: chatroomName,
                    );
                  }));
                },
                leading: CircleAvatar(
                  child: Text(chatroomName[0]),
                  backgroundColor: Colors.blueGrey,
                ),
                title: Text(chatroomName),
                subtitle: Text(chatroomsList[index]["desc"] ?? ""),
              );
            }));
  }
}
