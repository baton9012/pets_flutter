class User {
  int _id;
  String _name;
  String _lastname;
  String _mail;
  int _numpet;

  User(this._name, this._lastname, this._mail, this._numpet);

  List<User> getAllUsers() {
    return List<User>();
  }

  int get id => _id;

  String get name => _name;

  String get lastname => _lastname;

  String get mail => _mail;

  int get numpet => _numpet;

  set id(int id) => this._id = id;

  set name(String name) => this._name = name;

  set lastname(String lastname) => this._lastname = lastname;

  set mail(String mail) => this._mail = mail;

  set numpet(int numpet) => this._numpet = numpet;

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if(id != null) {
      map['id'] = _id;
    }
    map['name'] = _name;
    map['lastname'] = _lastname;
    map['mail'] = _mail;
    map['numpet'] = _numpet;
  }

  User.formMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._name = map['name'];
    this._lastname = map['lastname'];
    this._mail = map['mail'];
    this._numpet = map['numpet'];
  }
}