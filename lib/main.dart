import 'package:flutter/material.dart';
import 'HelloWorld.dart';

void main() {
  runApp(new MaterialApp(
      title: 'Tip Calculator',
      home: new HelloWorld(),
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

// Create first input field
    TextField billAmountField = new TextField(
        decoration: new InputDecoration(
          labelText: "Bill amount(\$)",
        ),
        keyboardType: TextInputType.number,
        onChanged: (String value) {
          try {
            billAmount = double.parse(value);
          } catch (exception) {
            billAmount = 0.0;
          }
        }
    );

    // Create another input field
    TextField tipPercentageField = new TextField(
      decoration: new InputDecoration(
        labelText: "Tip %",
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
        child: new Text("Calculate"),
        onPressed: () {
          // Calculate tip and total
          double calculatedTip = billAmount * tipPercentage / 100.0;
          double total = billAmount + calculatedTip;

// Generate dialog
          AlertDialog dialog = new AlertDialog(
              content: new Text("Tip: \$$calculatedTip \n"
                  "Total: \$$total")
          );

// Show dialog
          showDialog(context: context, child: dialog);
        }
    );

    Container container = new Container(
        padding: const EdgeInsets.all(16.0),
        child: new Column(
            children: [ billAmountField,
            tipPercentageField,
            calculateButton
            ]
        )
    );

    AppBar appBar = new AppBar(title: new Text("Tip Calculator"));
    Scaffold scaffold = new Scaffold(appBar: appBar,
        body: container);

    return scaffold;
  }
}
