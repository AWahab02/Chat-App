import 'package:chat_app/screens/LoginScreen.dart';
import 'package:chat_app/screens/MainScreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chat_app/widgets/Textfields.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class RegScreen extends StatefulWidget {
  RegScreen({Key? key}) : super(key: key);

  @override
  State<RegScreen> createState() => _RegScreen();
}

class _RegScreen extends State<RegScreen> {
  final TextEditingController _fName = TextEditingController();
  final TextEditingController _lName = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool isLoading = false;
  late bool _success=false;
  late String _userEmail;

  void _register() async {
    setState(() {
      isLoading = true;
    });
    final User? user = (await _auth.createUserWithEmailAndPassword(
        email: _email.text, password: _password.text))
        .user;

    if (user != null) {
      FirebaseFirestore.instance.collection('Accounts').doc(user.uid).set({
        "Email": _email.text,
        "FName": _fName.text,
        "LName": _lName.text,
        "groups": [],
        "Profile_pic": "",
        "Password": _password.text,
      });



      setState(() {
        _success = true;
        isLoading = false;
        _userEmail = user.email!;

        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => const LoginScreen()));
      });
    } else {
      _success = false;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 40.0),
              child: Center(
                child: Text(
                  'Kimbra',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 34),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: Image(
                image: AssetImage('assets/ChatAppIcon.png'),
                width: 90,
              ),
            ),

            const Padding(
              padding: EdgeInsets.only(top: 10.0, left: 25.0, right: 25.0),
              child: Text(
                'Connect to the world.',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),

            const Padding(
              padding: EdgeInsets.only(top: 20.0, left: 25.0, right: 25.0),
              child: Text(
                'Sign Up Page',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 10.0, left: 25.0, right: 25.0),
              child: TextFieldWidget(
                hinttext: 'First Name',
                TextInput: _fName,
                obscuretext: false,


              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0, left: 25.0, right: 25.0),
              child: TextFieldWidget(
                hinttext: 'Last Name',
                TextInput: _lName,
                obscuretext: false,

              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0, left: 25.0, right: 25.0),
              child: TextFieldWidget(
                hinttext: 'Email',
                TextInput: _email,
                obscuretext: false,

              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0, left: 25.0, right: 25.0),
              child: TextFieldWidget(
                hinttext: 'Password',
                TextInput: _password,
                obscuretext: true,


              ),
            ),


            isLoading
                ? const Center(child: CircularProgressIndicator())
                : Center(
              child: Padding(
                  padding: const EdgeInsets.only(top:10.0),
                  child: SizedBox(
                    width: 130,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                      ),
                      onPressed: _register,
                      child: const Text(
                        'Register', style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ))
            ),

            Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const LoginScreen()));
                  },
                  child: const Text('Already have an account? Sign In',
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
