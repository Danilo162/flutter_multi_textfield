import 'package:flutter/material.dart';
import 'package:flutter_multi_textfield/database/database_hepler.dart';
import 'package:flutter_multi_textfield/database/list.dart';
import 'package:flutter_multi_textfield/database/model/Contact.dart';
import 'package:fluttertoast/fluttertoast.dart';


class AddScreen extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: myAddScreen(title: 'Flutter Demo Home Page'),
    );
  }
}

class myAddScreen extends StatefulWidget {
  myAddScreen({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<myAddScreen> {
  int count = 0;
  List<String> litems = [];
  var textEditingControllers = <TextEditingController>[];
  final myController = TextEditingController();
  Contact contact;
  var data = "";
  @override  initState() {
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: _buildActions(),
      ),

      body: Center(
        child: SingleChildScrollView(child:Column(children: createTexttextfields(),) ,)
      ),
    floatingActionButton: FloatingActionButton(
    onPressed: () {
    debugPrint('FAB clicked');
    addRecord(false);
  //  print(getAllValue());
    },
      tooltip: 'Get all data',
      child: Icon(Icons.add),), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
  List<Widget> createTexttextfields (){
    List <String> list =  new List();

    list.add("AYEKPA ABLE DANIEL");
    list.add("fff@gmail.com");
    list.add("ddddd@gmail.com");
    list.add("MANC KOUL");
    print(list);
    var textFields = <Container>[];
    list.forEach((i) {
      var textEditingController = new TextEditingController(text: "$i");
      textEditingControllers.add(textEditingController);
      return textFields.add( new Container(
              color: Colors.white,
              child: ListTile(
                leading: const Icon(Icons.phone),
                title:new TextField(controller: textEditingController,
                  onEditingComplete: (){
                    toaster("hgcgkjjjjjjjjjjjjjjjjjjj");
                    setState(() {
                      toaster(textEditingController.text);
                      print("--------------NEWVALUE-------------"+textEditingController.text);
                    });

                  },
                ),
              )
      ));
    });
    return textFields;
  }
  getAllValue(){
    textEditingControllers.forEach((f){
      print(f.text);
    });
  }

  Future addRecord(bool isEdit) async {
    int resul;
    bool upade = false;
    var db = new DatabaseHelper();
    textEditingControllers.forEach((f){

    });
    var j = 0;
    for(var i = 0 ;i<textEditingControllers.length;i++){
      var contat = new Contact(textEditingControllers[i].text, "20/12/1991","2");
      resul =  await db.saveContact(contat);
      if(resul != 0){
        j++;
      }
    }

     print(j);
     showAlertDialog("id du text"," Nombre de contact enregistré " +j.toString(),context);
   // }
  }
  static void showAlertDialog(String title, String message,BuildContext context) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(
        context: context,
        builder: (_) => alertDialog
    );
  }

  List<Widget> _buildActions() {
    return <Widget>[
      new IconButton(
        icon: const Icon(
          Icons.group_add,
          color: Colors.white,
        ),
        onPressed: (){
          Navigator.push(
            context,
          //  MaterialPageRoute(builder: (context) => ContactList(contact,data)),
            MaterialPageRoute(builder: (context) => ContactList()),
          );
        },
      ),
    ];
  }
  @override
  void dispose() {
   // list.clear();
    super.dispose();
  }

  toaster(String text)  {
    Fluttertoast.showToast(
        msg:text,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: Colors.blue,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

}
