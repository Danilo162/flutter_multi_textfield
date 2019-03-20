class Contact {

  int id;
  String _adresse;
  String _date;
  String _etat;

  Contact(this._adresse, this._date, this._etat);
  Contact.map(dynamic obj) {
    this._adresse = obj["adresse"];
    this._date = obj["date"];
    this._etat = obj["etat"];
  }

  String get adresse => _adresse;

  String get date => _date;

  String get etat => _etat;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["adresse"] = _adresse;
    map["date"] = _date;
    map["etat"] = _etat;

    return map;
  }

  void setContactId(int id) {
    this.id = id;
  }
}
