import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextFieldWidget extends StatelessWidget {
  TextFieldWidget({Key? key, required this.hinttext, required this.TextInput, required this.obscuretext }) : super(key: key);

  var TextInput = TextEditingController();
  final String hinttext;
  bool obscuretext;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: TextField(
        controller: TextInput,
        obscureText: obscuretext,
        decoration: InputDecoration(
          hintText: hinttext,
          hintStyle: const TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}
