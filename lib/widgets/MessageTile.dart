import 'package:flutter/material.dart';

class MessageTile extends StatefulWidget {
  final String message;
  final String sender;
  final bool sentByMe;
  const MessageTile(
      {Key? key,
      required this.message,
      required this.sender,
      required this.sentByMe})
      : super(key: key);

  @override
  State<MessageTile> createState() => _MessageTileState();
}

class _MessageTileState extends State<MessageTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.sentByMe? EdgeInsets.only(top:8, bottom: 8, left: 175, right: 25) : EdgeInsets.only(top:8, bottom: 8, left: 25, right: 175),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: widget.sentByMe? const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomLeft: Radius.circular(20),
          )
              :

          const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomLeft: Radius.circular(20),
          ),
              color: widget.sentByMe? Colors.red : Colors.deepPurple,

        ),
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.sender.toUpperCase(),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 8, width: 4,),
              Text(widget.message, textAlign: TextAlign.left, style: const TextStyle(fontSize: 14, color: Colors.white),),
            ],
          ),
        ),
      ),
    );
  }
}
