import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int count = 0;
  List<String> litems = [];
  final List<TextEditingController> eCtrl = new List();
  final TextEditingController controller = new TextEditingController(text: "");
  final List<TextEditingController> textEditingController = new List();
  final myController = TextEditingController();
  List<String> tempList = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child:
        ListView.builder(
          itemCount: 6,
          itemBuilder: (BuildContext context, int position) {
            return Container(
              color: Colors.white,
              child: ListTile(
                leading: const Icon(Icons.phone),
                title: new TextField(
                  decoration: new InputDecoration(
                    hintText: "Contact",
                  ),
                  keyboardType: TextInputType.multiline,
                  maxLines: 1,
                  onChanged: (String text){
                    String _selected;
                    setState((){
                      _selected = text;
                      tempList.add(_selected);
                    });
                    return tempList;
                  },
                ),

              ),
            );
          },
        )
      ),
    floatingActionButton: FloatingActionButton(
    onPressed: () {
    debugPrint('FAB clicked');
    print(tempList.toString());
    },
      tooltip: 'Get all data',
      child: Icon(Icons.add),), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

}
