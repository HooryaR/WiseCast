import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:podcast_app/pages/signup.dart';

import 'home.dart';

class LoginPage extends StatefulWidget{
  const LoginPage({Key? key}):super(key:key);
  
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>{

  //form key
  final _formKey = GlobalKey<FormState>();

  //text controller
  final TextEditingController  emailController = new TextEditingController();
  final TextEditingController  passwordController = new TextEditingController();

  //firebase
  final _auth = FirebaseAuth.instance;


  @override
  Widget build(BuildContext context){
    //Email field
    final emailField = TextFormField(
      autofocus: false,
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      validator: (value){
        if(value == null || value.isEmpty){
          return 'Email is required for Login';
        }
        // regex for email validation
        if(!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)){
          return 'Please enter a valid email';
        }
        return null;
      },
      onSaved: (value){
        emailController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.mail),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Email",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        )
      ),
    );

    //Password field
    final passwordField = TextFormField(
      autofocus: false,
      controller: passwordController,
      obscureText: true,
      validator: (value){
        RegExp regexp = new RegExp(r'^.{6,}$');
        if(value == null || value.isEmpty){
          return 'Password is required for Login';
        }
        if(!regexp.hasMatch(value)){
          return 'Password is incorrect';
        }
      },
      onSaved: (value){
        passwordController.text = value!;
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
          focusColor: Colors.white,
          prefixIcon: const Icon(Icons.lock),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Password",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )
      ),
    );

    //Login button
    final logInButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.lightBlueAccent,
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          //Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => StudioPage()));
          logIn(emailController.text, passwordController.text);
        },
        child: const Text("Login",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),)

      ),
    );

    return Scaffold(
      backgroundColor: Color(0xFFEDE6DB),
      body: Container(
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Container(
            color: Color(0xFFEDE6DB),
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 200,
                      child: ClipRRect(
                        child: Image.asset("assets/logo.png"),
                        borderRadius: BorderRadius.circular(100),
                      ),),
                    const SizedBox(height: 45,),
                    emailField,
                    const SizedBox(height: 25,),
                    passwordField,
                    const SizedBox(height: 35,),
                    logInButton,
                    const SizedBox(height: 15,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text("Don't have an account? "),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                SignupPage()));
                          },
                          child: const Text("Sign up", style: TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                            fontSize: 15),),)
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  //Login Function
  void logIn(String email, String password) async{
    if(_formKey.currentState!.validate()){
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((uid)=> {
          Fluttertoast.showToast(msg: "Login Successful"),
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomePage())),
      }).catchError((e){
        Fluttertoast.showToast(msg: e!.message);
      });
    }
  }
}
