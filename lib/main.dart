import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To do list',
      home: Scaffold(
        appBar: AppBar(title: Text('To do list')),
        body: ListView.builder(
            itemCount: 12,
            itemBuilder: (BuildContext context, int index) {
//              return ;
              return Dismissible(
                  key: UniqueKey(),
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment(-0.9, 0),
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  onDismissed: (direction) {},
                  direction: DismissDirection.startToEnd,
                  child: ListTile(
                    trailing: Checkbox(value: true, onChanged: (param) {}),
                    title: Text('Item $index'),
                  ));
            }),
      ),
    );
  }
}
