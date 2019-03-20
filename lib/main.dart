import 'package:flutter/material.dart';
import 'package:flutter_multi_textfield/add_screen.dart';
import 'package:flutter_multi_textfield/anchored_overlay.dart';
import 'package:flutter_multi_textfield/bottom_button.dart';
import 'package:flutter_multi_textfield/database/add_contact_dialog.dart';
import 'package:flutter_multi_textfield/database/database_hepler.dart';
import 'package:flutter_multi_textfield/database/list.dart';
import 'package:flutter_multi_textfield/database/model/Contact.dart';
import 'package:flutter_multi_textfield/fab_with_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:material_search/material_search.dart';

void main() => runApp(MyApp());
abstract class HomeContract {
  void screenUpdate();
}
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  HomeContract _view;
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
  List<Contact> contact;
  String _lastSelected = 'TAB: 0';
  TextEditingController searchController = new TextEditingController();
  String filter;
  var db = new DatabaseHelper();

  @override initState() {
    searchController.addListener(() {
      setState(() {
        filter = searchController.text;
      });
    });
  }

  void _selectedTab(int index) {
    setState(() {
      _lastSelected = 'TAB: $index';
    });
  }

  void _selectedFab(int index) {
    setState(() {
      _lastSelected = 'FAB: $index';
    });
  }

  @override void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter layout demo',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Flutter layout demo'),
        ),
        body: new Column(children: <Widget>[
          new Padding(
            padding: new EdgeInsets.all(8.0),
            child: new TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search Contacts',
                contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(32.0)),
              ),
            ),
          ),
          new Expanded(
              child:
              new FutureBuilder<List<Contact>>(
                future: db.getContact(),
                builder: (context, AsyncSnapshot<List<Contact>> snapshot) {
                  if (snapshot.hasError) print(snapshot.error);
                  if (snapshot.hasData) {
                    return ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          Contact contact = snapshot.data[index];
                          return new Card(
                            child: new Container(
                                child: new Center(
                                  child: new Row(
                                    children: <Widget>[
                                      new CircleAvatar(
                                        radius: 30.0,
                                        child: new Text(getShortName(contact)),
                                        backgroundColor: const Color(
                                            0xFF20283e),
                                      ),
                                      new Expanded(
                                        child: new Padding(
                                          padding: EdgeInsets.all(10.0),
                                          child: new Column(
                                            crossAxisAlignment: CrossAxisAlignment
                                                .start,
                                            children: <Widget>[
                                              new Text(
                                                contact.adresse +
                                                    " " +
                                                    contact.etat,
                                                // set some style to text
                                                style: new TextStyle(
                                                    fontSize: 20.0,
                                                    color: Colors
                                                        .lightBlueAccent),
                                              ),
                                              new Text(
                                                "DATE: " + contact.date,
                                                // set some style to text
                                                style: new TextStyle(
                                                    fontSize: 20.0,
                                                    color: Colors.amber),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      new Column(
                                        mainAxisAlignment: MainAxisAlignment
                                            .spaceBetween,
                                        children: <Widget>[
                                          new IconButton(
                                              icon: const Icon(
                                                Icons.edit,
                                                color: const Color(0xFF167F67),
                                              ),
                                              onPressed: () =>
                                                  edit(contact, context)
                                          ),

                                          new IconButton(
                                            icon: const Icon(
                                                Icons.delete_forever,
                                                color: const Color(0xFF167F67)),
                                            onPressed: () =>
                                                delete(contact),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                padding: const EdgeInsets.fromLTRB(
                                    10.0, 0.0, 0.0, 0.0)),
                          );
                        });
                  }
                  else {
                    return Center(child: new CircularProgressIndicator());
                  }
                },
              ))
        ]),
        bottomNavigationBar: FABBottomAppBar(
          centerItemText: 'A',
          color: Colors.grey,
          selectedColor: Colors.red,
          notchedShape: CircularNotchedRectangle(),
          onTabSelected: _selectedTab,
          items: [
            FABBottomAppBarItem(iconData: Icons.menu, text: 'Accueil'),
            FABBottomAppBarItem(iconData: Icons.layers, text: 'Add Dinamic field'),
            FABBottomAppBarItem(iconData: Icons.dashboard, text: 'Bottom'),
            FABBottomAppBarItem(iconData: Icons.info, text: 'Bar'),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: _buildFab(context), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }

  String getShortName(Contact Contact) {
    String shortName = "";
    if (!Contact.adresse.isEmpty) {
      shortName = Contact.adresse.substring(0, 1) + ".";
    }

    if (!Contact.date.isEmpty) {
      shortName = shortName + Contact.date.substring(0, 1);
    }
    return shortName;
  }

  delete(Contact contact) async {
    int resul;
    resul = await db.deleteContact(contact);
    if (resul != 0) {
      AddContactDialog.toaster("Suppression effectuée");
    }
    updateScreen();
    return resul;
  }

  updateScreen() {
    Navigator.of(context)
        .push(new MaterialPageRoute(builder: (context) => MyApp()));
  }

  edit(Contact contact, BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) =>
          new AddContactDialog().buildAboutDialog(context, context, contact),
    );
    updateScreen();
  }
  Widget _buildFab(BuildContext context) {
    final icons = [ Icons.sms, Icons.mail, Icons.phone];
    return AnchoredOverlay(
      showOverlay: true,
      overlayBuilder: (context, offset) {
        return CenterAbout(
          position: Offset(offset.dx, offset.dy - icons.length * 35.0),
          child: FabWithIcons(
            icons: icons,
            onIconTapped: _selectedFab,
          ),
        );
      },
      child: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        child: Icon(Icons.add),
        elevation: 2.0,
      ),
    );
  }
}

