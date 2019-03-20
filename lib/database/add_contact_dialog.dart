import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_multi_textfield/database/database_hepler.dart';
import 'package:flutter_multi_textfield/database/model/Contact.dart';
import 'package:flutter_multi_textfield/database/model/user.dart';
import 'package:flutter_multi_textfield/main.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddContactDialog {
  final teAdresse = TextEditingController();
  final teDate = TextEditingController();
  final teEtat = TextEditingController();
  Contact contact;

  static const TextStyle linkStyle = const TextStyle(
    color: Colors.blue,
    decoration: TextDecoration.underline,
  );

  Widget buildAboutDialog(
      BuildContext context, _myHomePageState, Contact contact) {
    if (contact != null) {
      this.contact=contact;
      teAdresse.text = contact.adresse;
      teDate.text = contact.date;
      teEtat.text = contact.etat;
    }

    return new AlertDialog(
      title: new Text('Modification de '+this.contact.adresse),
      content: new SingleChildScrollView(
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            getTextField("Enter first name", teAdresse),
            getTextField("DD-MM-YYYY",teDate),
            getTextField("Enter last name",teEtat),
            new GestureDetector(
              onTap: () {
                editContact();
                _myHomePageState.displayRecord();
                Navigator.of(context).pop();
              },
              child: new Container(
                margin: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                child: getAppBorderButton(
                    "Edit", EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getTextField(
      String inputBoxName, TextEditingController inputBoxController) {
    var loginBtn = new Padding(
      padding: const EdgeInsets.all(5.0),
      child: new TextFormField(
        controller: inputBoxController,
        decoration: new InputDecoration(
          hintText: inputBoxName,
        ),
      ),
    );

    return loginBtn;
  }

  Widget getAppBorderButton(String buttonLabel, EdgeInsets margin) {
    var loginBtn = new Container(
      margin: margin,
      padding: EdgeInsets.all(8.0),
      alignment: FractionalOffset.center,
      decoration: new BoxDecoration(
        border: Border.all(color: const Color(0xFF28324E)),
        borderRadius: new BorderRadius.all(const Radius.circular(6.0)),
      ),
      child: new Text(
        buttonLabel,
        style: new TextStyle(
          color: const Color(0xFF28324E),
          fontSize: 20.0,
          fontWeight: FontWeight.w300,
          letterSpacing: 0.3,
        ),
      ),
    );
    return loginBtn;
  }

  Future editContact() async {
    var db = new DatabaseHelper();
    bool resul= false;
    var contact = new Contact(teAdresse.text, teDate.text, teEtat.text);
    contact.setContactId(this.contact.id);
    resul =  await db.updateContact(contact);
    if(resul){
      String textt = teAdresse.text;
      toaster("Modification de $textt effectuée ");
    }
    return resul;

  }
  static toaster(String text){
    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }
}
