import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:llb20/views/conditions_cell.dart';
import 'package:llb20/views/player_cell.dart';
import 'package:html/parser.dart' show parse;



class llb_t_info extends StatefulWidget {
  final String tdata;
  final String tag;
  llb_t_info({
    Key? key,
    required this.tdata,
    required this.tag
  }) : super(key: key);

  @override
  _CupertinoSegmentedControlDemoState createState() =>
      _CupertinoSegmentedControlDemoState();
}

class _CupertinoSegmentedControlDemoState extends State<llb_t_info> {

  final Map<int, Widget> logoWidgets = const <int, Widget>{
    0: Text('Игроки'),
    1: Text('Описание'),
    2: Text('Сетка'),
  };
  var _isLoading = true;
  var icons;

  var videos;
  var par;
  var draw_url = "http://1.u0156265.z8.ru/old/img.png";
  var conditions;
  var tid;

  _fetchData() async {

    print("Attempting to fetch data from network"+par);

    if(par=="draw") {
      print("draw");
      final draw_url = Uri.parse(
          "http://1.u0156265.z8.ru/old/index.php?id=42&get=draw&tid="+tid);
      final draw_response = await http.get(draw_url);

      if (draw_response.statusCode == 200) {
         print(draw_response.body);
        setState(() {
          _isLoading = false;
          // print("TUT"+draw_img);
          this.draw_url = "http://1.u0156265.z8.ru/old/t_images/"+tid+"_img.png";
        });
      }
    }
    if(par=="condition") {
      final url = Uri.parse(
          "http://1.u0156265.z8.ru/old/index.php?id=42&get=" + par + "&tid="+tid);
      final response = await http.get(url);


      if (response.statusCode == 200) {
        // print(response.body);
        var document = parse(response.body);
        var titems = document.querySelectorAll('.field-label-inline-first');
      //  items.forEach((element) {
      //    print(element.parent!.text+":"+element.text);
      //  });
        setState(() {
          _isLoading = false;
          this.conditions = titems;
        });
      }
    }
    if(par=="tplayers") {
print("http://1.u0156265.z8.ru/old/index.php?id=42&get="+par+"&tid="+tid);
        final url = Uri.parse("http://1.u0156265.z8.ru/old/index.php?id=42&get="+par+"&tid="+tid);
        final response = await http.get(url);



        if (response.statusCode == 200) {
          // print(response.body);

          final map = json.decode(response.body);
          final playersJson = map["players"];

          // videosJson.forEach((video) {
          //   print(video["name"]);
          // });

          setState(() {
            _isLoading = false;
            this.videos = playersJson;
          });
        }
        }
      }


  @override
  void initState() {
    this.tid = widget.tdata;
    this.par = "tplayers";
    // TODO: implement initState
    super.initState();
    _fetchData();

  }

  t_info()  {

    final Map<int, Widget> icons = <int, Widget>{
      0: Center(child:
      ListView.builder(
        itemCount: this.videos != null ? this.videos
            .length : 0,
        itemBuilder: (context, i) {
          final video = this.videos[i];
          return new FlatButton(
            padding: new EdgeInsets.all(0.0),
            child: new PlayerCell(video),
            onPressed: () {
              print("Video cell tapped: $i");
            /*  Navigator.push(context,
                  new MaterialPageRoute(
                      builder: (context) => new Home()
                  )
              );*/
            },
          );
        },
      )
      ),
      1: Center(child:
    FittedBox(
    child:  Image.network(this.draw_url),
    fit: BoxFit.fill,
    )
      ),
      2: Center(child:
       ListView.builder(
        itemCount: this.conditions != null ? this.conditions
            .length : 0,
        itemBuilder: (context, i) {
           final condition = this.conditions[i];
          return new FlatButton(
            padding: new EdgeInsets.all(0.0),
            child: new ConditionsCell(condition),
            onPressed: () {
              print("Video cell tapped: $i");
              /*  Navigator.push(context,
                  new MaterialPageRoute(
                      builder: (context) => new Home()
                  )
              );*/
            },
          );
        },
      )
      ),
    };
    this.icons = icons;
  }

  int sharedValue = 0;
  num _stackToView = 1;
  void _handleLoad(String value) {
    setState(() {
      _stackToView = 0;
    });
  }
  @override
  Widget build(BuildContext context) {

    //final tid = ModalRoute.of(context)!.settings.arguments ;
   // this.tid = tid;
   // print(tid);
    t_info();
    return new MaterialApp(
      home: new Scaffold(
        appBar: AppBar(
          leading: BackButton(
            onPressed: () => Navigator.pop(context, false),
          ),
          title: Text(widget.tdata),
        ),
        body:
        Column(
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.all(10.0),
            ),
            SizedBox(
              width: 500.0,
              child: CupertinoSegmentedControl<int>(
                children: logoWidgets,
                onValueChanged: (int val) {
    switch(val) {
      case 0:
        this.par = "tplayers";
        break;
      case 1:
        this.par = "draw";
        break;
      case 2:
        this.par = "condition";
        break;
    }
                  setState(() {
                    print(val);
                    _fetchData();
                  //  if(val==1) { get_draw(); }
                    sharedValue = val;
                });
                },
                groupValue: sharedValue,
              ),
            ),
            Expanded(
              child: this.icons[sharedValue],
              //child: this.icons ,
            ),
          ],
        ),
      ),
    );
  }
}