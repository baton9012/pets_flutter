import 'dart:math';

import 'package:flutter/material.dart';
import 'package:petsflutter/models/user.dart';
import 'package:petsflutter/utils/data_base_helper.dart';
import 'package:form_field_validator/form_field_validator.dart';

class AddUserForm extends StatefulWidget {

  final String title;
  final User user;

  AddUserForm(this.user, this.title);

  @override
  State<StatefulWidget> createState() => AddUserFormState(title, user);
}

class AddUserFormState extends State<AddUserForm> {
  String title;
  User user;
  AddUserFormState(this.title, this.user);
  final mailValidator = MultiValidator([
    RequiredValidator(errorText: 'Enter mail'),
    EmailValidator(errorText: 'Enter correct mail')
  ]);
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController mailController = TextEditingController();
  DatabaseHelper databaseHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {

    nameController.text = user.name;
    lastnameController.text = user.lastname;
    mailController.text = user.mail;

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              moveToUserList();
            }),
      ),
      body: Container(
        padding: EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              Center(
                child: buildTextField('User name'),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: buildTextFormField(
                    'Enter your name', 'User name', nameController, true),
              ),
              Center(
                child: buildTextField('User lastname'),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: buildTextFormField(
                    'Enter your lastname', 'User lastname', lastnameController, false),
              ),
              Center(
                child: buildTextField('User mail'),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: mailController,
                  validator: mailValidator,
                  style: TextStyle(fontFamily: 'Josefin Sans'),
                  decoration: InputDecoration(
                    labelText: 'User mail',
                    labelStyle: TextStyle(fontSize: 16.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged:(value){
                    _updateMail();
                  }
                ),
              ),
              Container(
                padding: EdgeInsets.only(
                  top: 8.0,
                  left: 8.0,
                  right: 8.0,
                ),
                child: RaisedButton(
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      _save(nameController.text, lastnameController.text,
                          mailController.text, Random().nextInt(5) + 1);
                    }
                  },
                  child: Text(
                    title,
                    style: TextStyle(fontSize: 16.0),
                  ),
                  color: Colors.green,
                  textColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void moveToUserList() {
    Navigator.pop(context, true);
  }

  Widget buildTextField(String label) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 20.0,
        fontFamily: 'Josefin Sans',
      ),
    );
  }

  Widget buildTextFormField(String error, String label, TextEditingController controller, bool field) {
    return TextFormField(
      controller: controller,
      style: TextStyle(fontFamily: 'Josefin Sans'),
      validator: (String value) {
        if (value.isEmpty) return error;
        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(fontSize: 16.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
      ),
      onChanged: (value) {
        if(field){
          _updateName();
        } else {
          _updateLasrtName();
        }
      },
    );
  }

  void _updateName(){
    user.name = nameController.text;
  }

  void _updateLasrtName(){
    user.lastname = lastnameController.text;
  }

  void _updateMail(){
    user.mail = mailController.text;
  }

  void _save(String name, String lastname, String mail, int numPet) async {
    int result;
    if(user.id != null){
      result = await databaseHelper.updateUser(user);
      prepareAlertDialog(0, result);
    } else {
      result = await databaseHelper.insertUser(User(name, lastname, mail, numPet));
      prepareAlertDialog(1, result);
    }
  }

  void prepareAlertDialog(int type, int result){
    if (result != 0 && type == 0) {
      _showAlertDialog('You edited a user');
    } else if(result != 0 && type == 1){
      _showAlertDialog('You added a user');
    } else {
      _showAlertDialog('Ooops! Something wrong');
    }
  }

  void _showAlertDialog(String message) {
    AlertDialog alertDialog = AlertDialog(
      content: Container(
        height: 18.0,
        child: Center(
          child: Text(
            message,
            style: TextStyle(fontFamily: 'Josefin Sans'),
          ),
        ),
      ),
      actions: <Widget>[
        RaisedButton(
          onPressed: () {
            Navigator.of(context).pop();
            moveToUserList();
          },
          color: Colors.green,
          child: Text(
            'OK',
            style: TextStyle(fontFamily: 'Josefin Sans'),
          ),
        ),
      ],
    );
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => alertDialog,
    );
  }
}
