import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'views/video_cell.dart';

class Body extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return BodyState();
  }
}
class BodyState extends State<Body> {
  Map<int, Widget> map = new Map(); // Cupertino Segmented Control takes children in form of Map.
  late List<Widget> childWidgets; //The Widgets that has to be loaded when a tab is selected.
  int selectedIndex = 0;
  var _isLoading = true;
  // final serTab =  detail().AppWithTab;
  var videos;

  _fetchData() async {
    print("Attempting to fetch data from network");

    final url = Uri.parse("http://1.u0156265.z8.ru/old/index.php?id=42&get=next");
    final response = await http.get(url);

    if (response.statusCode == 20e0) {
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
    super.initState();
    loadCupertinoTabs(); //Method to add Tabs to the Segmented Control.
    loadChildWidgets(); //Method to add the Children as user selected.
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CupertinoSegmentedControl(
          onValueChanged: (value) {
//Callback function executed when user changes the Tabs
            setState(() {
              //selectedIndex = value;
              print(value);
            });
          },
          groupValue: selectedIndex, //The current selected Index or key
          selectedColor:
          Colors.blue, //Color that applies to selecte key or index
          pressedColor: Colors
              .red, //The color that applies when the user clicks or taps on a tab
          unselectedColor: Colors
              .grey, // The color that applies to the unselected tabs or inactive tabs
          padding: EdgeInsets.all(100),
          children: map, //The tabs which are assigned in the form of map
        ),
        getChildWidget(),
      ],
    );
  }
  void loadCupertinoTabs() {
    map = new Map();
    for (int i = 0; i < 4; i++) {
//putIfAbsent takes a key and a function callback that has return a value to that key.
// In our example, since the Map is of type <int,Widget> we have to return widget.
      map.putIfAbsent(
          i,
              () => Text(
            "Tab $i",
            style: TextStyle(color: Colors.white),
          ));
    }
  }
  void loadChildWidgets() {
    childWidgets = [];
    for (int i = 0; i < 4; i++)
      childWidgets.add(
          ListView.builder(
            itemCount: this.videos != null ? this.videos
                .length : 0,
            itemBuilder: (context, i) {
              final video = this.videos[i];
              return new FlatButton(
                padding: new EdgeInsets.all(0.0),
                child: new VideoCell(video),
                onPressed: () {
                  print("Video cell tapped: $i");
                  Navigator.push(context,
                      new MaterialPageRoute(
                          builder: (
                              context) => new DetailPage()
                      )
                  );
                },
              );
            },
          )
      );
  }
  Widget getChildWidget() => childWidgets[selectedIndex];
}

class DetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text("a");
    //  return RealWorldState().serTab;
  }

}