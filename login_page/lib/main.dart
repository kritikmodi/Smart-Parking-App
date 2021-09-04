import 'package:flutter/material.dart';
import 'package:login_page/homePage1.dart';
import 'package:fluttertoast/fluttertoast.dart'; //package required for displaying toast messages
import 'package:login_page/signup.dart';
import 'package:login_page/forgotPass.dart';
//import the firebase_core and firebase_auth plugin
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'ProfilePage.dart';

// code for Firebase authentication
void mainff()
{
    runApp(App());
  }

class App extends StatefulWidget {
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  // Set default `_initialized` and `_error` state to false
  bool _initialized = false;
  bool _error = false;

  // Define an async function to initialize FlutterFire
  void initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
    } catch(e) {
      // Set `_error` state to true if Firebase initialization fails
      setState(() {
        _error = true;
      });
    }
  }

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Show error message if initialization failed
    if(_error) {
      return error();
    }

    // Show a loader until FlutterFire is initialized
    if (!_initialized) {
      return loading();
    }

  }

  Widget error() {
    print("Initialization failed!");
  }

  Widget loading() {
    print("Initialization successful!");
  }
}

//code for the main app
void main() async { //the await expression can only be used inside an async function
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); //this method is needed for the app to utilize Firebase services
  runApp(MaterialApp(
      theme: ThemeData(fontFamily: 'montserrat'),
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<MyApp> {
  TextEditingController loginController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance; //creating an instance for authentication. Create a stream for listening to the user's login/logout activity status.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.black,
          title: Text('CODE SHINOBIS',
        style: TextStyle(fontFamily: 'painter'))
        ),
        body: Padding(
            padding: EdgeInsets.all(10),
            child: ListView(
              children: <Widget>[

                Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'Smart Parking System',
                      style: TextStyle(
                          fontFamily: 'montserrat1',
                          fontSize: 30),
                    )),
                Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'Sign in',
                      style: TextStyle(fontFamily: 'montserrat',fontSize: 20),
                    )),
                Container(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    controller: loginController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'User email',
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: TextField(
                    obscureText: true,
                    controller: passwordController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                    ),
                  ),
                ),
                FlatButton(
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> forgotPass()),
                    );
                  },
                  textColor: Colors.black,
                  child: Text('Forgot Password', style: TextStyle(
                    fontFamily: 'montserrat'))
                ),

                Container(
                    height: 50,
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            side: BorderSide(color: Colors.black)
                        ),
                      textColor: Colors.white,
                      color: Colors.black,
                      child: Text('Login', style: TextStyle(
                        fontFamily: 'montserrat1')),
                      onPressed: () async {
                         try {
                                UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                                 email: loginController.text,
                                    password: passwordController.text
                                     );
                                         Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> homePage1()),
                                                                  );
                                             Fluttertoast.showToast(
                                             msg: "Login successsful!",
                                             toastLength: Toast.LENGTH_LONG,
                                             gravity: ToastGravity.BOTTOM,
                                             timeInSecForIosWeb: 1,
                                             backgroundColor: Colors.blue,
                                             textColor: Colors.white,
                                             fontSize: 16.0
                                               );
                            } on FirebaseAuthException catch (e) {
                                                    if (e.code == 'user-not-found') {
                                                      Fluttertoast.showToast(
                                                          msg: "No user found for that email!",
                                                          toastLength: Toast.LENGTH_LONG,
                                                          gravity: ToastGravity.BOTTOM,
                                                          timeInSecForIosWeb: 1,
                                                          backgroundColor: Colors.blue,
                                                          textColor: Colors.white,
                                                          fontSize: 16.0
                                                      );
                                                            } else if (e.code == 'wrong-password') {
                                                      Fluttertoast.showToast(
                                                          msg: "Wrong password! Please re-check your password and try again!",
                                                          toastLength: Toast.LENGTH_LONG,
                                                          gravity: ToastGravity.BOTTOM,
                                                          timeInSecForIosWeb: 1,
                                                          backgroundColor: Colors.blue,
                                                          textColor: Colors.white,
                                                          fontSize: 16.0
                                                      );
                                                              }

                                                                Fluttertoast.showToast(
                                                                    msg: "Wrong username or password!",
                                                                    toastLength: Toast.LENGTH_LONG,
                                                                    gravity: ToastGravity.BOTTOM,
                                                                    timeInSecForIosWeb: 1,
                                                                    backgroundColor: Colors.blue,
                                                                    textColor: Colors.white,
                                                                    fontSize: 16.0
                                                                       );
                                                          }
                      }


                    )),

                Container(
                    child: Row(
                      children: <Widget>[
                        Text('Do not have an account?', style: TextStyle(
                      fontFamily: 'montserrat')),
                        FlatButton(
                          textColor: Colors.black,
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
                              fontFamily: 'montserrat',
                            fontSize: 17),
                          ),
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> signup()),
                            );
                          },
                        )
                      ],
                      mainAxisAlignment: MainAxisAlignment.center,
                    )),

              ],
            )));
  }
}
