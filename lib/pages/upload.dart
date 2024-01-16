import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:podcast_app/api/firebaseapi.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

class UploadPage extends StatefulWidget{
  const UploadPage({Key? key}) : super(key: key);

  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage>{
  UploadTask? task;
  File? file;

  @override
  Widget build(BuildContext context){
    final fileName = file != null ? basename(file!.path) : 'No File Selected';

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
                  'UPLOAD',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(20, 240, 20, 20),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                        minimumSize: const Size(200,50),
                        primary: Colors.lightBlueAccent,
                        onPrimary: Colors.white
                        ), icon: const Icon(Icons.attach_file),
                        label: const Text(
                        'Select File',
                        style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                        ),
                        ), onPressed: () {
                          selectFile();
                      }
                      ),
                      const SizedBox(height: 8),
                      Text(
                        fileName,
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                              minimumSize: Size(200,50),
                              primary: Colors.lightBlueAccent,
                              onPrimary: Colors.white
                          ), icon: const Icon(Icons.cloud_upload),
                          label: const Text(
                            'Upload File',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold
                            ),
                          ), onPressed: () {
                            uploadFile();
                      }
                      ),
                      const SizedBox(height: 8),
                      task != null ? buildUploadStatus(task!) : Container(),
                    ],
                  ),
                ),
              )
            ],
          ),
        )
    );
  }

  Future selectFile() async{
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    if(result == null) return;
    final path = result.files.single.path!;

    setState(()=> file = File(path));

  }

  Future uploadFile() async{
    if(file == null) return;
    final fileName = basename(file!.path);
    final destination = 'files/$fileName';

    task = FirebaseApi.uploadFile(destination, file!);
    setState(() {});

    if(task == null) return;

    final snapshot = await task!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();

    print('Download-Link: $urlDownload');
  }

  Widget buildUploadStatus(UploadTask task) => StreamBuilder<TaskSnapshot>(
    stream: task.snapshotEvents,
    builder: (context, snapshot) {
      if(snapshot.hasData){
        final snap = snapshot.data;
        final progress = snap!.bytesTransferred / snap.totalBytes;
        final percentage = (progress*100).toStringAsFixed(2);
        return Text(
          '$percentage %',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        );
      }else{
        return Container();
      }
    },
  );
}