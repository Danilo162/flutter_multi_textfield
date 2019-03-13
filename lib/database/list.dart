import 'package:flutter/material.dart';
import 'package:flutter_multi_textfield/database/database_hepler.dart';
import 'package:flutter_multi_textfield/database/model/Contact.dart';
import 'package:flutter_multi_textfield/home_presenter.dart';

class ContactList extends StatelessWidget {
  List<Contact> contact;
  HomePresenter homePresenter;
//  ContactList(List<Contact> this.contact,
//    HomePresenter this.homePresenter, {
//    Key key,
//  }) : super(key: key);
  //contact = await getUser();
  Future<List<Contact>> getContact() {
    return db.getContact();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter layout demo',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Flutter layout demo'),
        ),
        body:new FutureBuilder<List<Contact>>(
          future:  db.getContact(),
          builder: (context,AsyncSnapshot<List<Contact>> snapshot) {
            if (snapshot.hasError) print(snapshot.error);
            if (snapshot.hasData) {
              print("***snop");
//              print(snapshot.co.);
              print("***snop");
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
                                  backgroundColor: const Color(0xFF20283e),
                                ),
                                new Expanded(
                                  child: new Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: new Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        new Text(
                                          contact.adresse +
                                              " " +
                                              contact.etat,
                                          // set some style to text
                                          style: new TextStyle(
                                              fontSize: 20.0,
                                              color: Colors.lightBlueAccent),
                                        ),
                                        new Text(
                                          "DATE: " + contact.date,
                                          // set some style to text
                                          style: new TextStyle(
                                              fontSize: 20.0, color: Colors.amber),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                new Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    new IconButton(
                                        icon: const Icon(
                                          Icons.edit,
                                          color: const Color(0xFF167F67),
                                        ),
                                        onPressed: () {}
//                              => edit(contact[index], context)

                                    ),

                                    new IconButton(
                                      icon: const Icon(Icons.delete_forever,
                                          color: const Color(0xFF167F67)),
                                      onPressed: () =>
                                          homePresenter.delete(contact),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          padding: const EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0)),
                    );
                  });
            }
            else{
              return Center(child: new CircularProgressIndicator());
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () async {

          },
        ),
      ),
    );

  }

  displayRecord() {
    homePresenter.updateScreen();
  }
//  edit(Contact Contact, BuildContext context) {
//    showDialog(
//      context: context,
//      builder: (BuildContext context) =>
//          new AddContactDialog().buildAboutDialog(context, this, true, Contact),
//    );
//    homePresenter.updateScreen();
//  }

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
}
