import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:llb20/views/conditions_cell.dart';
import 'package:llb20/views/player_cell.dart';
import 'package:llb20/views/ch_player_cell.dart';
import 'package:html/parser.dart' show parse;
import 'package:flutter_svg/flutter_svg.dart';


class ch_t_info extends StatefulWidget {
  final String tdata;
  final String tag;
  ch_t_info({
    Key? key,
    required this.tdata,
    required this.tag
  }) : super(key: key);

  @override
  _CupertinoSegmentedControlDemoState createState() =>
      _CupertinoSegmentedControlDemoState();
}

class _CupertinoSegmentedControlDemoState extends State<ch_t_info> {
  final api_url = "sergannn:4ivkqNaDIX4EYlBMg2jPDEXetsm3KhQciinltHgN@api.challonge.com";
  final Map<int, Widget> logoWidgets = const <int, Widget>{
    0: Text('Игроки'),
    1: Text('Описание'),
    2: Text('Сетка'),
  };
  var _isLoading = true;
  var icons;
  var password = '4ivkqNaDIX4EYlBMg2jPDEXetsm3KhQciinltHgN';
  var videos;
  var par;
  var draw_url = "http://1.u0156265.z8.ru/old/img.png";
  var conditions;
  var tid;

  _fetchData() async {

    print("Attempting to fetch data from network"+par);

    if(par=="draw") {
      print("draw");
      final draw_url_old = Uri.parse("https://sergannn:"+password+"@api.challonge.com/v1/tournaments/"+tid+".json");
      print('/v1/tournaments/'+tid+'.json');
      //final draw_url =Uri.https('https://sergannn:'+password+'@api.challonge.com', '/v1/tournaments/'+tid+'.json', {'include_participants': 1});
      final draw_response = await http.get(draw_url_old);

      if (draw_response.statusCode == 200) {
         print(draw_response.body);
        setState(() {
          _isLoading = false;
          // print("TUT"+draw_img);
          this.draw_url = "https://challonge.com/1.svg";
        });
      }
    }
    if(par=="condition") {
      final draw_url_old = Uri.parse("https://sergannn:"+password+"@api.challonge.com/v1/tournaments/"+tid+".json");
      print('/v1/tournaments/'+tid+'.json');
      //final draw_url =Uri.https('https://sergannn:'+password+'@api.challonge.com', '/v1/tournaments/'+tid+'.json', {'include_participants': 1});
      final response = await http.get(draw_url_old);


      if (response.statusCode == 200) {
        final map = json.decode(response.body);
        print(map["tournament"]);
        // final playersJson = map["participants"];
        // print(response.body);
       // var document = parse(response.body);
       // var titems = document.querySelectorAll('.field-label-inline-first');
      //  items.forEach((element) {
      //    print(element.parent!.text+":"+element.text);
      //  });
        setState(() {
          _isLoading = false;
          this.conditions = parse(map["tournament"]["description"]);
        });
      }
    }
    if(par=="tplayers") {
      print('/v1/tournaments/'+tid+'.json');
      final draw_url =Uri.https(api_url, '/v1/tournaments/'+tid+'/participants.json');
      final  response= await http.get(draw_url);
      //final response = await http.get(url);
        print(response.statusCode);
        print("....");

        if (response.statusCode == 200) {
           print(response.body);

          final map = json.decode(response.body);
           print(map);
         // final playersJson = map["participants"];
         // print(playersJson);
          // videosJson.forEach((video) {
          //   print(video["name"]);
          // });

          setState(() {
            _isLoading = false;
            this.videos = map;
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
            child: new ch_PlayerCell(video),
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
      2: Center(child:
    FittedBox(
    child:
    
    Image.network("https://thumbs.dreamstime.com/b/team-tournament-bracket-play-off-template-162039305.jpg"),
    fit: BoxFit.fill,
    )),
      1: Center(child:
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
        this.par = "condition";
        break;
      case 2:
        this.par = "draw";
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