import 'package:flutter/material.dart';

class VideoCell extends StatelessWidget {
  final video;

  VideoCell(this.video);

  @override
  Widget build(BuildContext context) {
    return new Column(
      children: <Widget>[
        new Container(
          padding: new EdgeInsets.all(8.0),
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
           //   new Image.network(video["imageUrl"]),
              new Container(
                height: 1.0,
              ),
              new Text(
                video["name"]
              ),
              new Text(
                video["date"]
              )
            ],
          ),
        ),
        new Divider()
      ],
    );
  }
}
