import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:podcast_app/pages/upload.dart';
import 'package:podcast_app/pages/studio.dart';
import 'files.dart';
import 'package:podcast_app/pages/profile.dart';




class HomePage extends StatefulWidget{
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{
  final navigationKey = GlobalKey<CurvedNavigationBarState>();
  int index = 1;

  final pages = [
    UploadPage(),
    StudioPage(),
    FilesPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context){
    final items = <Widget>[
      Icon(Icons.cloud_upload, size: 30),
      Icon(Icons.mic, size: 30),
      Icon(Icons.audio_file, size: 30),
      Icon(Icons.person, size: 30),
    ];

    return Scaffold(
        extendBody: true,
        backgroundColor: Colors.white,
        body: pages[index],
        bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(
              iconTheme: IconThemeData(color: Colors.white)
          ),
          child: CurvedNavigationBar(
            key: navigationKey,
            buttonBackgroundColor: Colors.amber,
            color: Colors.lightBlueAccent,
            backgroundColor: Colors.transparent,
            height: 60,
            animationCurve: Curves.easeInOut,
            animationDuration: Duration(milliseconds: 320),
            index: index,
            items: items,
            onTap: (index) => setState(() => this.index = index),
          ),
        )
    );
  }
}

