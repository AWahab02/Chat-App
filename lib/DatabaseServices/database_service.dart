import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Database_service
{
  final String? uid;
  Database_service({this.uid});

  final CollectionReference userCollection = FirebaseFirestore.instance.collection("Accounts");

  Future gettingUserData(String email) async
  {
    QuerySnapshot snapshot = await userCollection.where("Email", isEqualTo: email).get();
    return snapshot;
  }

  getUserGroups() async
  {
    return FirebaseFirestore.instance.collection("Accounts").doc(uid).snapshots();
  }

  Future<bool> isUserJoined(String groupname, String groupId, String username) async
  {
    DocumentReference userDocumentReference = FirebaseFirestore.instance.collection('Accounts').doc(this.uid);
    DocumentSnapshot documentSnapshot = await userDocumentReference.get();

    List<dynamic> groups = await documentSnapshot['groups'];
    if(groups.contains("${groupId}_$groupname")){
      return true;
    }
    else
      {
        return false;
      }

  }

  Future toggleGroupJoin(String grpname, String email, String grpID) async
  {
    DocumentReference userDocumentReference = FirebaseFirestore.instance
        .collection('Accounts').doc(this.uid);
    DocumentReference groupDocumentReference = FirebaseFirestore.instance
        .collection('Chats').doc(grpID);

    DocumentSnapshot documentSnapshot = await userDocumentReference.get();
    List<dynamic> groups = await documentSnapshot['groups'];

    if (groups.contains("${grpID}_$grpname")) {
      await userDocumentReference.update({
        "groups": FieldValue.arrayRemove(["${grpID}_$grpname"])
      });
      await groupDocumentReference.update({
        "groups": FieldValue.arrayRemove(["${uid}_$grpname"])
      });
    }
    else {
      await userDocumentReference.update({
        "groups": FieldValue.arrayUnion(["${grpID}_$grpname"])
      });
      await groupDocumentReference.update({
        "groups": FieldValue.arrayUnion(["${uid}_$grpname"])
      });    }
  }

  sendMessage(String groupId, Map<String, dynamic> chatMessageData) async
  {
    FirebaseFirestore.instance.collection('Chats').doc(groupId).collection('messages').add(chatMessageData);
    FirebaseFirestore.instance.collection('Chats').doc(groupId).update({
      "recentMessage": chatMessageData['message'],
      "recentMessagesender": chatMessageData['sender'],
      "recentMessageTime": chatMessageData['time'].toString(),
    });
  }

  getChats(String groupId) async {
    return FirebaseFirestore.instance.collection('Chats')
        .doc(groupId)
        .collection("messages")
        .orderBy("time")
        .snapshots();
  }

}