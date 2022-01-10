import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:isro_pedia/screens/AuthPage/signup.dart';
import 'package:isro_pedia/screens/HomePage/home_page.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final formKey = GlobalKey<FormState>();
  final email = TextEditingController();
  final pass = TextEditingController();

  bool isLoad = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: isLoad
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      const Spacer(),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: email,
                        validator: (val) =>
                            validateEmail(val!) ? null : "Enter Valid Email",
                        decoration: const InputDecoration(
                          hintText: "Email",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: pass,
                        validator: (val) => val!.isEmpty ? "Required" : null,
                        decoration: const InputDecoration(
                          hintText: "Password",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      InkWell(
                        onTap: () async {
                          if (formKey.currentState!.validate()) {
                            try {
                              setState(() {
                                isLoad = true;
                              });
                              await FirebaseAuth.instance
                                  .signInWithEmailAndPassword(
                                      email: email.text, password: pass.text)
                                  .then((value) {
                                setState(() {
                                  isLoad = false;
                                });
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => const HomePage()));
                              });
                            } on FirebaseAuthException catch (e) {
                              setState(() {
                                isLoad = false;
                              });
                              if (e.code == 'user-not-found') {
                                // print('No user found for that email.');
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text("No user found for that email."),
                                  ),
                                );
                              } else if (e.code == 'wrong-password') {
                                // print('Wrong password provided for that user.');
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        "Wrong password provided for that user."),
                                  ),
                                );
                              }
                            } catch (e) {
                              setState(() {
                                isLoad = false;
                              });
                            }
                          }
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 20),
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(30)),
                          child: const Text(
                            "Sign In",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Don\'t have an account? ',
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 17)),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const SignUp()));
                            },
                            child: const Text('Sign Up',
                                style: TextStyle(
                                    color: Colors.white70,
                                    decoration: TextDecoration.underline,
                                    fontSize: 17)),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 80,
                      )
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}

bool validateEmail(String value) {
  String pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = RegExp(pattern);
  return (!regex.hasMatch(value)) ? false : true;
}
