import 'package:chat_app/screens/LoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/screens/ChatPage.dart';

class ChatList extends StatefulWidget {
  final String username;
  final String groupId;
  final String groupName;
  const ChatList({Key? key, required this.username, required this.groupId, required this.groupName}) : super(key: key);

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => ChatPage(groupId: widget.groupId, groupName: widget.groupName, username: widget.username)));
      },
      child: Container(
        child: ListTile(
          leading: CircleAvatar(radius: 20, backgroundColor: Colors.black, child: Text(widget.groupName.substring(0, 1).toUpperCase()),),
          title: Text(widget.groupName, style: const TextStyle(fontWeight: FontWeight.bold),),
          subtitle: Text('Enter group as ${widget.username}')
        ),
      ),
    );
  }
}
