import 'package:flutter/material.dart';

class ch_PlayerCell extends StatelessWidget {
  final player;

  ch_PlayerCell(this.player);

  @override
  Widget build(BuildContext context) {
    return new Column(
      children: <Widget>[
        new Container(
          padding: new EdgeInsets.all(8.0),
          child: new Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
           //   new Image.network(video["imageUrl"]),
              new Container(
                height: 1.0,
              ),
             // new Image.network("http://www.llb.su/"+player["avatar"], width: 40),
              new Text(
                player["participant"]["name"]
              ),

             // new Text(player["elo"] ?? ""+" "+player["contact2"])
            ],
          ),
        ),
        new Divider()
      ],
    );
  }
}
