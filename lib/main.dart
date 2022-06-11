import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'views/video_cell.dart';
import 'llb_t_info.dart';
import 'create_tournament.dart';
import 'ch_t_info.dart';
//import 'helpers/route.dart';
//1jun
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
  var icons2;
  // final serTab =  detail().AppWithTab;
  var llbTourneys;
  var chTourneys;
  var allTourneys;
  var par = "next";

  _fetchData() async {

    print("Attempting to fetch data from network");
    String password = '4ivkqNaDIX4EYlBMg2jPDEXetsm3KhQciinltHgN';
    final url = Uri.parse("http://1.u0156265.z8.ru/old/index.php?id=42&get="+par);
    final response = await http.get(url);
    final url2 = Uri.parse(
        "https://sergannn:"+password+"@api.challonge.com/v1/tournaments.json");
    var response2 = await http.get(url2);
    print(response.body);
    if (response.statusCode == 200 || response2.statusCode==200) {
      // print(response.body);
      final map2= json.decode(response2.body);
      final map = json.decode(response.body);
      final chTourneys = map2;
      final llbTourneys = map["tourneys"];

      // videosJson.forEach((video) {
      //   print(video["name"]);
      // });

      setState(() {
        _isLoading = false;
        this.llbTourneys = llbTourneys;
        this.chTourneys = chTourneys;
        this.allTourneys= llbTourneys + chTourneys;
      });
    }

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchData();
  }
   ch_tourneys()
   {
     // print(this.videos.length);

     final Map<int, Widget> icons = <int, Widget>{
       0: Center(child:
       ListView.builder(
         itemCount: this.chTourneys != null ? this.chTourneys
             .length : 0,
         itemBuilder: (context, i) {
           final video = this.chTourneys[i];
           return new FlatButton(
               padding: new EdgeInsets.all(0.0),
               child: new VideoCell(video["tournament"]),
               onPressed: ()  {
                 print("Video cell tapped: $i");
                 if( video["tournament"]["id"]!=null) {

                   Navigator.push(
                       context,
                       new MaterialPageRoute(
                         builder: (context) => new ch_t_info(tdata: video["tournament"]["id"].toString(), tag: "ch"),
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
     this.icons2 = icons;


   }
   llb_tourneys() {
       // print(this.videos.length);

     final Map<int, Widget> icons = <int, Widget>{
       0: Center(child:
       ListView.builder(
         itemCount: this.llbTourneys != null ? this.llbTourneys
             .length : 0,
         itemBuilder: (context, i) {
           final video = this.llbTourneys[i];
           return new FlatButton(
             padding: new EdgeInsets.all(0.0),
             child: new VideoCell(video),
             onPressed: ()  {
               print("Video cell tapped: $i");
               if( video["nid"]!=null) {

                 Navigator.push(
                     context,
                     new MaterialPageRoute(
                       builder: (context) => new llb_t_info(tdata: video["nid"], tag: "llb"),
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
    llb_tourneys();
    ch_tourneys();
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
            Expanded(
              child: this.icons2[0]
            )
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
                context,
                new MaterialPageRoute(
                  builder: (context) => new FormWidgetsDemo(),
                ));
          },
          label: const Text('Создать турнир'),
         // icon: const Icon(Icons.thumb_up),
          backgroundColor: Colors.pink,
        ),
      ),
    );
  }
}
