import'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../screens/AccountSettings.dart';


class DrawerWidget extends StatefulWidget {
  const DrawerWidget({Key? key, required this.uid, required this.email}) : super(key: key);

  final String uid;
  final String email;
  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 50),
        children: <Widget>[
          Icon(Icons.account_circle, size: 150),

          StreamBuilder(
              stream: FirebaseFirestore.instance.collection('Accounts').doc(widget.uid).snapshots(),
              builder: (context, snapshot){
                if(snapshot.hasData)
                {
                  return Center(
                    child: Text(
                      snapshot.data!.get('FName').toString(),
                      style: TextStyle(fontSize: 26),
                    ),
                  );
                }
                return const Text("Not Available");
              }),

          const SizedBox(
            height: 30,
          ),

          const Divider(
            height: 5,
          ),

          ListTile(
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => AccountSettings(email: widget.email, uID: widget.uid,)));
            },
            selectedColor: Colors.red,
            selected: true,
            leading: const Icon(Icons.settings),
            title: Text('Account Settings', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
          ),

          ListTile(
            onTap: (){},
            selectedColor: Colors.red,
            selected: true,
            leading: const Icon(Icons.logout),
            title: Text('Logout', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
          )

        ],
      ),
    );
  }
}
