import 'package:chat_app/DatabaseServices/database_service.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'ChatPage.dart';

class SearchBar extends StatefulWidget {
  const SearchBar({Key? key, required this.email, required this.uID})
      : super(key: key);

  final String email;
  final String uID;

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  bool isLoading = false;
  QuerySnapshot? searchSnapshot;
  bool isJoinedbool = false;
  bool hasUserSearched = false;
  TextEditingController searching = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Search'),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Container(
            color: Colors.black,
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: TextField(
                      style: TextStyle(color: Colors.white),
                      controller: searching,
                      decoration: const InputDecoration(
                        hintText: 'Enter group name..',
                        hintStyle: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 8.0),
                  child: IconButton(
                    onPressed: SearchMethod,
                    icon: Icon(Icons.search, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                )
              : groupList(),
        ],
      ),
    );
  }

  SearchMethod() async {
    if (searching.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
      FirebaseFirestore.instance
          .collection('Chats')
          .where('ChatName', isEqualTo: searching.text)
          .get()
          .then((snapshot) {
        setState(() {
          searchSnapshot = snapshot;
          isLoading = false;
          hasUserSearched = true;
        });
      });
    }
  }

  groupList() {
    return hasUserSearched
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: searchSnapshot!.docs.length,
            itemBuilder: (context, index) {
              return groupTile(searchSnapshot!.docs[index]['ChatID'],
                  searchSnapshot!.docs[index]['ChatName']);
            },
          )
        : Container();
  }

  IsJoined(String grpname, String grpId, String useremail) async {
    await Database_service(uid: widget.uID)
        .isUserJoined(grpname, grpId, useremail)
        .then((value) {
      setState(() {
        isJoinedbool = value;
      });
    });
  }

  Widget groupTile(String groupId, String groupName) {
    IsJoined(groupName, groupId, widget.email);

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      leading: CircleAvatar(
        radius: 30,
        backgroundColor: Colors.black,
        child: Text(groupName.substring(0, 1).toUpperCase()),
      ),
      title: Text(groupName),
      trailing: InkWell(
        onTap: () async {
          await Database_service(uid: widget.uID)
              .toggleGroupJoin(groupName, widget.email, groupId);

          if (isJoinedbool) {
            setState(() {
              isJoinedbool = !isJoinedbool;
              Future.delayed(const Duration(milliseconds: 20), () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ChatPage(
                        groupId: groupId,
                        groupName: groupName,
                        username: widget.email)));
              });
            });
          } else {
            setState(() {
              isJoinedbool = !isJoinedbool;
            });
          }
        },
        child: isJoinedbool
            ? Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black,
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: const Text(
                  'Joined',
                  style: TextStyle(color: Colors.white),
                ),
              )
            : Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black,
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: const Text(
                  'Join now',
                  style: TextStyle(color: Colors.white),
                ),
              ),
      ),
    );
  }
}
