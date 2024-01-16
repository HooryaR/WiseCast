import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:podcast_app/model/usermodel.dart';
import 'package:podcast_app/pages/login.dart';

import 'home.dart';

class SignupPage extends StatefulWidget{
   const SignupPage({Key? key}) : super(key:key);
   @override
   _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage>{

  //form key
  final _formKey = GlobalKey<FormState>();
  //editing controllers:
  final firstNameEditingController = new TextEditingController();
  final lastNameEditingController = new TextEditingController();
  final emailEditingController = new TextEditingController();
  final passwordEditingController = new TextEditingController();
  final confirmPasswordEditingController = new TextEditingController();

  //firebase
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    //First name field
    final firstNameField = TextFormField(
      autofocus: false,
      controller: firstNameEditingController,
      keyboardType: TextInputType.name,
      validator: (value){
        RegExp regexp = new RegExp(r'^.{3,}$');
        if(value == null || value.isEmpty){
          return 'First name is required';
        }
        if(!regexp.hasMatch(value)){
          return 'Enter valid name(Min. 3 Characters)';
        }
        return null;
      },
      onSaved: (value){
        firstNameEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.person),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "First Name",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )
      ),
    );

    //Last name field
    final lastNameField = TextFormField(
      autofocus: false,
      controller: lastNameEditingController,
      keyboardType: TextInputType.name,
      validator: (value){
        RegExp regexp = new RegExp(r'^.{3,}$');
        if(value == null || value.isEmpty){
          return 'Last name is required';
        }
        if(!regexp.hasMatch(value)){
          return 'Enter valid name(Min. 3 Characters)';
        }
        return null;
      },
      onSaved: (value){
        lastNameEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.person),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Last Name",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )
      ),
    );

    //Email field
    final emailField = TextFormField(
      autofocus: false,
      controller: emailEditingController,
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
        emailEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.email),
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
      controller: passwordEditingController,
      obscureText: true,
      validator: (value){
        RegExp regexp = new RegExp(r'^.{6,}$');
        if(value == null || value.isEmpty){
          return 'Password is required for Login';
        }
        if(!regexp.hasMatch(value)){
          return 'Enter valid password(Min. 6 Characters)';
        }
      },
      onSaved: (value){
        passwordEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.lock),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Password",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )
      ),
    );

    //Confirm password field
    final confirmPasswordField = TextFormField(
      autofocus: false,
      controller: confirmPasswordEditingController,
      obscureText: true,
      validator: (value){
        if(confirmPasswordEditingController.text !=
            passwordEditingController.text){
          return 'Passwords Do not Match';
        }
        return null;
      },
      onSaved: (value){
        confirmPasswordEditingController.text = value!;
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.lock),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Confirm Password",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )
      ),
    );

    //Signup button
    final signUpButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.lightBlueAccent,
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: (){
          signUp(emailEditingController.text, passwordEditingController.text);
        },
        child: const Text("Signup",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),),
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
                    firstNameField,
                    const SizedBox(height: 20,),
                    lastNameField,
                    const SizedBox(height: 20,),
                    emailField,
                    const SizedBox(height: 20,),
                    passwordField,
                    const SizedBox(height: 20,),
                    confirmPasswordField,
                    const SizedBox(height: 20,),
                    signUpButton,
                    const SizedBox(height: 15,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text("Already have an account? "),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                LoginPage()));
                          },
                          child: const Text("Login", style: TextStyle(
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

  //Signup Function
  void signUp(String email, String password) async{
    if(_formKey.currentState!.validate()){
      await _auth.createUserWithEmailAndPassword(email: email, password: password)
          .then((value)=>{postDetailsToFireStore()})
          .catchError((e){
        Fluttertoast.showToast(msg: e!.message);
      });
    }
  }

  postDetailsToFireStore() async{
    //Calling the firebase firestore
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;
    //Calling usermodel
    UserModel userModel = UserModel();
    //Sending the values
    //Writing all the values
    userModel.email = user!.email;
    userModel.uid = user.uid;
    userModel.firstName = firstNameEditingController.text;
    userModel.lastName = lastNameEditingController.text;

    await firebaseFirestore
    .collection("users")
    .doc(user.uid)
    .set(userModel.toMap());
    Fluttertoast.showToast(msg: 'Account created Successfully!');
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (context) => HomePage()),
            (route) => false);
  }
}
