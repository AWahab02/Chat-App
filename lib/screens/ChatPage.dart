import 'package:chat_app/DatabaseServices/database_service.dart';
import 'package:chat_app/widgets/MessageTile.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';



class ChatPage extends StatefulWidget {
  final String username;
  final String groupId;
  final String groupName;
  const ChatPage(
      {Key? key,
      required this.groupId,
      required this.groupName,
      required this.username})
      : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  ScrollController _scrollController = ScrollController();
  Stream<QuerySnapshot>? chats;
  TextEditingController messageController = TextEditingController();

  _scrolltobottom()
  {
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  }

  @override

  void initState() {
    super.initState();
    getChatData();
  }

  Future getChatData() async {
    Database_service().getChats(widget.groupId).then((val){
      setState(() {
        chats=val;
      });
    });
  }

  String getUserName(String res) {
    return res.substring(0, res.indexOf("@"));
  }

  @override

  Widget build(BuildContext context) {


    return Scaffold(
      resizeToAvoidBottomInset: true,
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.black,
          title: Text(widget.groupName),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [

              Container(

                height: 610,
                child: chatMessages(),

              ),
              Container(
                alignment: Alignment.bottomCenter,
                width: MediaQuery.of(context).size.width,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                  width: MediaQuery.of(context).size.width,
                  color: Colors.blueGrey,
                  child: Row(
                    children: [
                      Expanded(
                          child: TextFormField(
                        controller: messageController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          hintText: 'Enter Message..',
                          hintStyle: TextStyle(color: Colors.white, fontSize: 14),
                          border: InputBorder.none,
                        ),
                      )),

                      SizedBox(width: 12),
                      GestureDetector(
                        onTap: sendMessage,

                        child: Container(
                          height: 45,
                          width: 45,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(child: Icon(Icons.send_rounded, color: Colors.white,)),
                        ),

                      )


                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  chatMessages() {
    return StreamBuilder(
        stream: chats,
        builder: (context, AsyncSnapshot snapshot) {
          WidgetsBinding.instance.addPostFrameCallback((_) => _scrolltobottom());
          return snapshot.hasData
              ? ListView.builder(
                  shrinkWrap: true,
                  controller: _scrollController,
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    String senderString = snapshot.data.docs[index]['sender'];
                    bool containsAt=false;
                    if(senderString.contains('@'))
                      {
                        containsAt=true;
                      }
                    else
                      {
                        containsAt=false;
                      }
                    return MessageTile(
                        message: snapshot.data.docs[index]['message'],
                        sender: containsAt? senderString.substring(0, senderString.indexOf('@')) : senderString,
                        sentByMe: widget.username == snapshot.data.docs[index]['sender']);
                  },
                )
              : Text('');
        });
  }

  sendMessage()
  {
    if(messageController.text.isNotEmpty)
      {
        Map<String, dynamic> chatMessageMap =
            {
              "message": messageController.text,
              "sender": widget.username,
              "time": DateTime.now().millisecondsSinceEpoch,
            };

        Database_service().sendMessage(widget.groupId, chatMessageMap);
        setState(() {
          messageController.clear();
          sendMessage();
        });


      }
  }

}
