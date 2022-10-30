import'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chat_app/DatabaseServices/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';


class AccountSettings extends StatefulWidget {
  const AccountSettings({Key? key, required this.email, required this.uID}) : super(key: key);

  final String email;
  final String uID;


  @override
  State<AccountSettings> createState() => _AccountSettingsState();
}

class _AccountSettingsState extends State<AccountSettings> {
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search))
        ],
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.black,
        title: Text('Account Settings'),

      ),

      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 170),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [

            const Icon(Icons.account_circle, size: 150),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                Text('First Name'),
                StreamBuilder(
                    stream: FirebaseFirestore.instance.collection('Accounts').doc(widget.uID).snapshots(),
                    builder: (context, snapshot){
                      if(snapshot.hasData)
                      {
                        return Center(
                          child: Text(
                            snapshot.data!.get('FName').toString(),
                            style: TextStyle(fontSize: 14),
                          ),
                        );
                      }
                      return const Text("Not Available");
                    }),
              ],

            ),

            Divider(
              height: 40,
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Last Name', style: TextStyle(fontSize: 14)),
                StreamBuilder(
                    stream: FirebaseFirestore.instance.collection('Accounts').doc(widget.uID).snapshots(),
                    builder: (context, snapshot){
                      if(snapshot.hasData)
                      {
                        return Center(
                          child: Text(
                            snapshot.data!.get('LName').toString(),
                            style: TextStyle(fontSize: 14),
                          ),
                        );
                      }
                      return const Text("Not Available");
                    }),
              ],
            ),


            Divider(
              height: 40,
            ),



            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Email', style: TextStyle(fontSize: 14)),
                Text(widget.email)
              ],
            ),

            Divider(
              height: 30,
            ),



            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Password', style: TextStyle(fontSize: 14)),
                StreamBuilder(
                    stream: FirebaseFirestore.instance.collection('Accounts').doc(widget.uID).snapshots(),
                    builder: (context, snapshot){
                      if(snapshot.hasData)
                      {
                        return Center(
                          child: Text(
                            snapshot.data!.get('Password').toString(),
                            style: TextStyle(fontSize: 14),
                          ),
                        );
                      }
                      return const Text("Not Available");
                    }),
              ],
            ),
            

          ],
        ),
      ),


    );
  }
}