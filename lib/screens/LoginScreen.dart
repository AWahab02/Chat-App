import 'package:chat_app/screens/MainScreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chat_app/widgets/Textfields.dart';
import 'Registration_Screen.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  late bool isLoading = false;
  late bool _success = false;

  Future signIn() async {
    try {
      setState(() {
        isLoading = true;
      });
      final User? user =
          (await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _email.text.trim(),
        password: _password.text.trim(),
      ))
              .user;

      if (user != null) {
        setState(() {
          //user_doc_id=FirebaseFirestore.instance.collection('Account').where()
          _success = true;
          isLoading = false;
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => MainScreen(email: _email.text, uID: user.uid)));
        });
      } else {
        _success = false;
      }
    } catch (e) {
      setState(() {
        _success = false;
        isLoading = false;
      });
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
                'Login Page',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(top: 10.0, left: 25.0, right: 25.0),
              child: TextFieldWidget(
                hinttext: 'Email',
                TextInput: _email,
                obscuretext: false,

              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(top: 10.0, left: 25.0, right: 25.0),
              child: TextFieldWidget(
                hinttext: 'Password',
                TextInput: _password,
                obscuretext: true,

              ),
            ),

            isLoading ? const CircularProgressIndicator()
                :Center(
                child: Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: SizedBox(
                      width: 130,
                      child: ElevatedButton(
                        onPressed: signIn,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                        ),
                        child: const Text(
                          'Login',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ))),
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => RegScreen()));
                },
                child: const Text(
                  'Dont have an account? Sign Up',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w800),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
