import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'views/video_cell.dart';
import 'home.dart';
//import 'helpers/route.dart';
const Color _colorOne = Color(0x33000000);
const Color _colorTwo = Color(0x24000000);
const Color _colorThree = Color(0x1F000000);

void main() {
  runApp(MaterialApp(
    title: 'Navigation Basics',
    home: CupertinoSegmentedControlDemo(),
  ));
}

class CupertinoSegmentedControlDemo extends StatefulWidget {

  @override
  _CupertinoSegmentedControlDemoState createState() =>
      _CupertinoSegmentedControlDemoState();
}

class _CupertinoSegmentedControlDemoState extends State<CupertinoSegmentedControlDemo> {

  final Map<int, Widget> logoWidgets = const <int, Widget>{
    0: Text('Next'),
    1: Text('Online'),
    2: Text('Results'),
  };
  var _isLoading = true;
  var icons;
  // final serTab =  detail().AppWithTab;
  var videos;
  var par = "next";

  _fetchData() async {

    print("Attempting to fetch data from network");

    final url = Uri.parse("http://1.u0156265.z8.ru/old/index.php?id=42&get="+par);
    final response = await http.get(url);

    if (response.statusCode == 200) {
      // print(response.body);

      final map = json.decode(response.body);
      final videosJson = map["tourneys"];

      // videosJson.forEach((video) {
      //   print(video["name"]);
      // });

      setState(() {
        _isLoading = false;
        this.videos = videosJson;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchData();
  }

   tourneys() {
       // print(this.videos.length);

     final Map<int, Widget> icons = <int, Widget>{
       0: Center(child:
       ListView.builder(
         itemCount: this.videos != null ? this.videos
             .length : 0,
         itemBuilder: (context, i) {
           final video = this.videos[i];
           return new FlatButton(
             padding: new EdgeInsets.all(0.0),
             child: new VideoCell(video),
             onPressed: ()  {
               print("Video cell tapped: $i");
               if( video["nid"]!=null) {

                 Navigator.push(
                     context,
                     new MaterialPageRoute(
                       builder: (context) => new Home(tdata: video["nid"]),
                     ));
               }});
         },
       )
       ),
       1: Center(
         child: FlutterLogo(
           textColor: Colors.teal,
           size: 200.0,
         ),
       ),
       2: Center(
         child: FlutterLogo(
           textColor: Colors.cyan,
           size: 200.0,
         ),
       ),
     };
     this.icons = icons;
   }

  int sharedValue = 0;

  @override
  Widget build(BuildContext context) {
    tourneys();
    return new MaterialApp(
      home: new Scaffold(
        appBar: AppBar(
          title: const Text('Flutter SegmentedControl'),
        ),
        body: Column(
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.all(10.0),
            ),
            SizedBox(
              width: 500.0,
              child: CupertinoSegmentedControl<int>(
                children: logoWidgets,
                onValueChanged: (int val) {
                  setState(() {
                    print(val);
                    switch(val)
                    {
                      case 0:
                        this.par = "next";
                        break;
                      case 1:
                        this.par = "online";
                        break;
                      case 2:
                        this.par = "past";
                        break;
                    }

                    sharedValue = val;

                    _fetchData();
                  });
                },
                groupValue: sharedValue,
              ),
            ),
            Expanded(
             // child: this.icons[sharedValue],
              child: this.icons[0],
                ),
          ],
        ),
      ),
    );
  }
}