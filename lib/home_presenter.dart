
import 'dart:async';

import 'package:flutter_multi_textfield/database/database_hepler.dart';
import 'package:flutter_multi_textfield/database/model/Contact.dart';


abstract class HomeContract {
  void screenUpdate();
}
var db = new DatabaseHelper();

  Future<List<Contact>> getContact() {
  return db.getContact();
}
class HomePresenter {
  HomeContract _view;
  var db = new DatabaseHelper();

  HomePresenter(this._view);


  delete(Contact contact) {
    var db = new DatabaseHelper();
    db.deleteContact(contact);
    updateScreen();
  }


  updateScreen() {
    _view.screenUpdate();

  }


}
