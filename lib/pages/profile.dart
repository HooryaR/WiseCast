import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:podcast_app/model/usermodel.dart';
import 'package:podcast_app/pages/login.dart';

class ProfilePage extends StatefulWidget{
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>{
  //To get the user who is logged
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  File? image;

  late Future<ListResult> futureFiles;

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
    .collection("users")
    .doc(user!.uid)
    .get()
    .then((value){
      this.loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });
    futureFiles = FirebaseStorage.instance.ref('/files').list();
  }

  //For displaying user name or email can do
  //Text ("${loggedInUser.firstName}, etc"

  //For logging out
  //Logout button for onPressed: () { logout(context) }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Color(0xFFA2B38B),
        body: Center(
          child: Column(
            children: <Widget>[
              Container(
                height: 60,
                width: 500,
                color: Colors.lightBlueAccent,
                padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: const Text(
                  'PROFILE',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20
                  ),
                ),
              ),
              Container(
                alignment: Alignment.topRight,
                padding: EdgeInsets.all(5),
                child: GestureDetector(
                  onTap: () {
                    logout(context);
                  },
                  child: const Text("Logout", style: TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                      fontSize: 15),),
                ),
              ),
              Container(
                alignment: Alignment.center,
                  padding: EdgeInsets.fromLTRB(20, 140, 20, 20),
                  child: Text ("${loggedInUser.firstName} ${loggedInUser.lastName}",
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                  ),
                )
              ),
              Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.fromLTRB(20, 10, 10, 20),
                  child: Text ("${loggedInUser.email}",
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                    ),
                  )
              ),
              image != null ? ClipOval(
                child: Image.file(
                  image!,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              )
              : FlutterLogo(size: 100),
              SizedBox(height: 16),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            minimumSize: Size(100,40),
                            primary: Colors.lightBlueAccent,
                            onPrimary: Colors.white
                        ), icon: const Icon(Icons.image),
                        label: const Text(
                          'Gallery',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold
                          ),
                        ), onPressed: () async {
                          pickImage(ImageSource.gallery);
                    }
                    ),
                    SizedBox(width: 15),
                    ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            minimumSize: Size(100,40),
                            primary: Colors.lightBlueAccent,
                            onPrimary: Colors.white
                        ), icon: const Icon(Icons.camera),
                        label: const Text(
                          'Camera',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold
                          ),
                        ), onPressed: () async {
                          pickImage(ImageSource.camera);
                    }
                    ),
                  ]
              ),

            ],
          ),

        )
    );
  }

  //Logout function
  Future<void> logout(BuildContext context) async{
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginPage()));
  }

  Future pickImage(ImageSource source) async{
    try{
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;

     // final imageTemporary = File(image.path);
      final imagePermanent = await saveImagePermanently(image.path);

      setState(() => this.image = imagePermanent);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }

  }

  Future<File> saveImagePermanently(String imagePath) async {
    final directory = await getApplicationDocumentsDirectory();
    final name = basename(imagePath);
    final image = File('${directory.path}/$name');
    return File(imagePath).copy(image.path);
  }

}