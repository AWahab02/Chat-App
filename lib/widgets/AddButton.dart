import 'package:flutter/material.dart';

class AddButton extends StatefulWidget {
  const AddButton({Key? key}) : super(key: key);

  @override
  State<AddButton> createState() => _AddButtonState();
}

class _AddButtonState extends State<AddButton> {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(onPressed: null);
  }
}
