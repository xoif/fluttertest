import 'package:flutter/material.dart';
import 'package:fluttertest/CashBook.dart';

void main() {
  runApp(new MaterialApp(
      title: 'Tip Calculator',
      home: new MyApp(),
      theme: new ThemeData(
      primaryColor: Colors.red,
    )
  ));
}

class MyApp extends StatelessWidget {

  double billAmount = 0.0;
  double tipPercentage = 0.0;

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.display1;

    // Create first input field
    Text addCashBook = new Text("Neues Kassenbuch", style: textStyle, textAlign: TextAlign.left);

    Icon cashBookIcon = new Icon(Icons.add, size: 128.0, color: textStyle.color);

    Text existingCashBook = new Text("Bestehendes Kassenbuch:", style: textStyle);

    // Create another input field
    TextField existingTokenTextField = new TextField(
      decoration: new InputDecoration(
        labelText: "Gib dein Token ein",
        hintText: "15",
      ),
        keyboardType: TextInputType.number,
        onChanged: (String value) {
          try {
            tipPercentage = double.parse(value);
          } catch (exception) {
            tipPercentage = 0.0;
          }
        }
    );

    // Create button
    RaisedButton calculateButton = new RaisedButton(
        child: new Text("Go"),
        onPressed: () {
          // Calculate tip and total
          double calculatedTip = billAmount * tipPercentage / 100.0;
          double total = billAmount + calculatedTip;

// Generate dialog
          Navigator.of(context).push(new MaterialPageRoute<Null>(
            builder: (BuildContext context) {
              return new Scaffold(
                body: new Center(
                  child: new CashBook(),
                ),
              );
            },
          ));
        }
    );

    Container container = new Container(
        padding: const EdgeInsets.all(16.0),
        child: new Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              addCashBook,
              new Container(
                alignment: FractionalOffset.center,
                child: cashBookIcon,
              ),
              new Container(
                height: 100.0,
              ),
              existingCashBook,
              existingTokenTextField,
              new Container(
                alignment: FractionalOffset.center,
                child: calculateButton,
              ),
            ]
        )
    );

    AppBar appBar = new AppBar(title: new Text("CashBook App"));
    Scaffold scaffold = new Scaffold(appBar: appBar,
        body: container);

    return scaffold;
  }
}
