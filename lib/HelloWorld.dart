import 'package:flutter/material.dart';

class HelloWorld extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {

    Center center = new Center(
        widthFactor: 15.0,
        heightFactor: 15.0,
        child: new Text("hallo"));


    AppBar appBar = new AppBar(
        title: new Text("Testapp"),
        leading: new IconButton(
          icon: new Icon(Icons.menu),
          tooltip: 'Navigation menu',
          onPressed: null,
        ),
      actions: <Widget>[
        new IconButton(
          icon: new Icon(Icons.search),
          tooltip: 'Search',
          onPressed: null,
        ),
      ],
    );
    Scaffold scaffold = new Scaffold(appBar: appBar,
        body: center);

    return scaffold;
  }



}