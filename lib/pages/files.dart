import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';


class FilesPage extends StatefulWidget{
  const FilesPage({Key? key}) : super(key: key);

  @override
  _FilesPageState createState() => _FilesPageState();
}

class _FilesPageState extends State<FilesPage>{
  late Future<ListResult> futureFiles;
  Map<int, double> downloadProgress = {};

  @override
  void initState(){
    super.initState();
    futureFiles = FirebaseStorage.instance.ref('/files').listAll();
  }

  @override
  Widget build(BuildContext context){

    return Scaffold(
        backgroundColor: Color(0xFFA2B38B),
        body: FutureBuilder<ListResult>(
          future: futureFiles,
          builder: (context, snapshot){
            if(snapshot.hasData){
              final files = snapshot.data!.items;
              return ListView.builder(
                itemCount: files.length,
                itemBuilder: (context, index){
                  final file = files[index];
                  double? progress = downloadProgress[index];
                  return ListTile(
                    title: Text(file.name,
                      style: TextStyle(
                          color: Colors.white
                      ),),
                    subtitle: progress != null
                        ? LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.black,
                    ):null,
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.download,
                        color: Colors.white,
                      ),
                      onPressed: () => downloadFile(index, file),
                    ),
                  );
                },
              );
            }else if(snapshot.hasError){
              return const Center (child: Text('Error occured'),);
            }else{
              return const Center (child: CircularProgressIndicator(),);
            }
          },
        )
    );
  }
  Future downloadFile(int index, Reference ref) async{
    final url = await ref.getDownloadURL();

    final tempDir = await getTemporaryDirectory();
    final path = '${tempDir.path}/${ref.name}';
    await Dio().download(
        url,
        path,
        onReceiveProgress: (received, total){
          double progress = received / total;
          setState(() {
            downloadProgress[index] = progress;
          });
        });


    if(url.contains('.wav')){
      await GallerySaver.saveVideo(path, toDcim: true);
    }else if(url.contains('.mp4')){
      await GallerySaver.saveVideo(path, toDcim: true);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Downloaded ${ref.name}')),

    );
  }
}
