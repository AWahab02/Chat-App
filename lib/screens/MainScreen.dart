import 'package:chat_app/DatabaseServices/database_service.dart';
import 'package:chat_app/screens/AccountSettings.dart';
import 'package:chat_app/widgets/ChatList.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'SearchBar.dart';
import 'package:chat_app/widgets/Textfields.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chat_app/widgets/Drawer.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key, required this.email, required this.uID})
      : super(key: key);

  final String email;
  final String uID;
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Stream? groups;
  late TextEditingController newgroup = TextEditingController();

  @override
  void initState() {
    super.initState();
    gettingUserData();
  }



  String getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  String getName(String res) {
    return res.substring(res.indexOf("_") + 1);
  }

  String getUserName(String res) {
    return res.substring(0, res.indexOf("@"));
  }

  Future gettingUserData() async {
    await Database_service(uid: FirebaseAuth.instance.currentUser!.uid).getUserGroups().then((snapshot) {
      setState(() {
        groups = snapshot;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [IconButton(onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => SearchBar(email: widget.email,uID: widget.uID)));
        }, icon: const Icon(Icons.search))],
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.black,
        title: Text('Chats'),
      ),
      drawer: DrawerWidget(
        uid: widget.uID,
        email: widget.email,
      ),
      body: groupList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          popUpDialog(context);
        },
        backgroundColor: Colors.black,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  popUpDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Create Chatroom'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFieldWidget(
                    hinttext: 'Group Name',
                    TextInput: newgroup,
                    obscuretext: false)
              ],
            ),
            actions: [
              ElevatedButton(
                  onPressed: () async {
                    createGroup(widget.uID, widget.email, newgroup.text);
                    Navigator.of(context).pop();
                  },
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.black),
                  child: const Text(
                    'Create',
                    style: TextStyle(color: Colors.white),
                  )),
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.black),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.white),
                  ))
            ],
          );
        });
  }

  groupList() {
    return StreamBuilder(
        stream: groups,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data['groups'].length,
              itemBuilder: (context, index) {
                int reverseIndex = snapshot.data['groups'].length-index-1;
                return ChatList(
                    username: getUserName(widget.email),
                    groupId: getId(snapshot.data['groups'][reverseIndex]),
                    groupName: getName(snapshot.data['groups'][reverseIndex]));
              },
            );
          } else {
            return Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.add_circle_outline_rounded,
                    color: Colors.grey,
                    size: 70,
                  ),
                ],
              ),
            );
          }
        });
  }

  Future createGroup(String id, String email, String chatname) async {
    DocumentReference documentReference =
        await FirebaseFirestore.instance.collection('Chats').add({
      "ChatName": chatname,
      "groupIcon": "",
      "members": [],
      "recentMessage": "",
      "recentMessagesender": ""
    });

    await documentReference.update({
      "members": FieldValue.arrayUnion(["${id}_$email"]),
      "ChatID": documentReference.id,
    });

    return await FirebaseFirestore.instance
        .collection('Accounts')
        .doc(widget.uID)
        .update({
      "groups": FieldValue.arrayUnion(["${documentReference.id}_$chatname"])
    });
  }

  getUserGroups() async {
    return FirebaseFirestore.instance
        .collection("Accounts")
        .doc(widget.uID)
        .snapshots();
  }
}
