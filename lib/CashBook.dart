// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CashBook extends StatefulWidget {
  String token;

  Cashbook(String tokenParameter) {
    token = tokenParameter;
  }

  @override
  CashBookState createState() => new CashBookState();
}

class CashBookState extends State<CashBook> {
  final GlobalKey<AnimatedListState> _listKey = new GlobalKey<
      AnimatedListState>();
  ListModel<TransactionObject> _list;
  TransactionObject _selectedItem;

  @override
  void initState() {
    super.initState();
    _list = new ListModel<TransactionObject>(
      listKey: _listKey,
      initialItems: <TransactionObject>[
        new TransactionObject("Startguthaben", 0.0)],
      removedItemBuilder: _buildRemovedItem,
    );
    //_nextItem = 3;
  }

  // Used to build list items that haven't been removed.
  Widget _buildItem(BuildContext context, int index,
      Animation<double> animation) {
    return new TransactionItem(
      animation: animation,
      tag: _list[index].tag,
      amount: _list[index].amount,
      selected: _selectedItem == _list[index],
      onTap: () {
        setState(() {
          _selectedItem = _selectedItem == _list[index] ? null : _list[index];
        });
      },
    );
  }

  // Used to build an item after it has been removed from the list. This method is
  // needed because a removed item remains  visible until its animation has
  // completed (even though it's gone as far this ListModel is concerned).
  // The widget will be used by the [AnimatedListState.removeItem] method's
  // [AnimatedListRemovedItemBuilder] parameter.
  Widget _buildRemovedItem(String tag, double amount, BuildContext context,
      Animation<double> animation) {
    return new TransactionItem(
      animation: animation,
      tag: tag,
      amount: amount,
      selected: false,
      // No gesture detector here: we don't want removed items to be interactive.
    );
  }

  // Insert the "next item" into the list model.
  void _insert() {
    String tag;
    double amount;
    int type;
    bool positiveIsActivated = false;
    bool negativeIsActivated = false;

    IconButton positiveIcon =  new IconButton(
      icon: const Icon(Icons.add_circle),
      iconSize: 30.0,
      color: positiveIsActivated? Colors.grey : Colors.green,
      disabledColor: Colors.grey,
      onPressed: () {
        type = 1;
        setState(() => positiveIsActivated = !positiveIsActivated);
      },
      tooltip: 'add a positive transaction',
    );
    IconButton negativeIcon =  new IconButton(
      icon: const Icon(Icons.remove_circle),
      iconSize: 30.0,
      color: negativeIsActivated ? Colors.grey : Colors.red,
      onPressed: () {
        type = -1;
        setState(() => negativeIsActivated = !negativeIsActivated);
      },
      tooltip: 'add a negative transaction',
    );
    SimpleDialog dialog = new SimpleDialog(
        contentPadding: const EdgeInsets.all(16.0),
        children: <Widget>[
          new Text("Füge eine neue Transaction hinzu: ", style: Theme
              .of(context)
              .textTheme
              .title),
          new Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                positiveIcon,
                negativeIcon
              ]
          ),
          new TextField(
              decoration: new InputDecoration(
                labelText: "Gib einen Tag an",
                hintText: "Maxi",
              ),
              keyboardType: TextInputType.text,
              onChanged: (String value) {
                tag = value;
              }
          ),
          new TextField(
              decoration: new InputDecoration(
                labelText: "Gib den Betrag an",
                hintText: "15.0",
              ),
              keyboardType: TextInputType.number,
              onChanged: (String value) {
                amount = double.parse(value);
              }
          ),
          new RaisedButton(
              child: new Text("Go"),
              onPressed: () {
                if (tag != null && amount != null && type != null) {
                  _list.insert(0, new TransactionObject(tag, type * amount));
                  Navigator.of(context).pop();
                }
              }
          )
        ]
    );

    // Show dialog
    showDialog(context: context, child: dialog);
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: const Text('Your CashBook'),
          actions: <Widget>[
            new IconButton(
              icon: const Icon(Icons.add_circle),
              onPressed: _insert,
              tooltip: 'insert a new item',
            ),
          ],
        ),
        body: new Padding(
          padding: const EdgeInsets.all(16.0),
          child: new AnimatedList(
            key: _listKey,
            initialItemCount: _list.length,
            itemBuilder: _buildItem,
          ),
        ),
      ),
    );
  }
}

/// Keeps a Dart List in sync with an AnimatedList.
///
/// The [insert] and [removeAt] methods apply to both the internal list and the
/// animated list that belongs to [listKey].
///
/// This class only exposes as much of the Dart List API as is needed by the
/// sample app. More list methods are easily added, however methods that mutate the
/// list must make the same changes to the animated list in terms of
/// [AnimatedListState.insertItem] and [AnimatedList.removeItem].
class ListModel<E> {
  ListModel({
    @required this.listKey,
    @required this.removedItemBuilder,
    Iterable<E> initialItems,
  })
      : assert(listKey != null),
        assert(removedItemBuilder != null),
        _items = new List<E>.from(initialItems ?? <E>[]);

  final GlobalKey<AnimatedListState> listKey;
  final dynamic removedItemBuilder;
  final List<E> _items;

  AnimatedListState get _animatedList => listKey.currentState;

  void insert(int index, E item) {
    _items.insert(index, item);
    _animatedList.insertItem(index);
  }

  E removeAt(int index) {
    final E removedItem = _items.removeAt(index);
    if (removedItem != null) {
      _animatedList.removeItem(
          index, (BuildContext context, Animation<double> animation) {
        return removedItemBuilder(removedItem, context, animation);
      });
    }
    return removedItem;
  }

  int get length => _items.length;

  E operator [](int index) => _items[index];

  int indexOf(E item) => _items.indexOf(item);
}

/// Displays its integer item as 'item N' on a Card whose color is based on
/// the item's value. The text is displayed in bright green if selected is true.
/// This widget's height is based on the animation parameter, it varies
/// from 0 to 128 as the animation varies from 0.0 to 1.0.
class TransactionItem extends StatelessWidget {
  const TransactionItem({
    Key key,
    @required this.animation,
    this.onTap,
    @required this.tag,
    @required this.amount,
    this.selected: false
  })
      : assert(animation != null),
        assert(amount != null),
        assert(selected != null),
        super(key: key);

  final Animation<double> animation;
  final VoidCallback onTap;
  final String tag;
  final double amount;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme
        .of(context)
        .textTheme
        .display1;
    if (selected)
      textStyle = textStyle.copyWith(color: Colors.lightGreenAccent[400]);
    return new Padding(
      padding: const EdgeInsets.all(2.0),
      child: new SizeTransition(
        axis: Axis.vertical,
        sizeFactor: animation,
        child: new GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: new SizedBox(
            height: 128.0,
            child: new Card(
              color: Colors.primaries[amount.toInt() % Colors.primaries.length],
              child: new Center(
                child: new Text(tag + " $amount €", style: textStyle),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TransactionObject {
  String tag;
  double amount;

  TransactionObject(String tag, double amount) {
    this.tag = tag;
    this.amount = amount;
  }
}


/*
Sample Catalog

Title: AnimatedList

Summary: In this app an AnimatedList displays a list of cards which stays
in sync with an app-specific ListModel. When an item is added to or removed
from the model, a corresponding card items animate in or out of view
in the animated list.

Description:
Tap an item to select it, tap it again to unselect. Tap '+' to insert at the
selected item, '-' to remove the selected item. The tap handlers add or
remove items from a `ListModel<E>`, a simple encapsulation of `List<E>`
that keeps the AnimatedList in sync. The list model has a GlobalKey for
its animated list. It uses the key to call the insertItem and removeItem
methods defined by AnimatedListState.

Classes: AnimatedList, AnimatedListState

Sample: AnimatedListSample

See also:
  - The "Components-Lists: Controls" section of the material design specification:
    <https://material.io/guidelines/components/lists-controls.html#>
*/
