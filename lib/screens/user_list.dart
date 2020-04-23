import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:petsflutter/models/user.dart';
import 'package:petsflutter/screens/detail_info.dart';
import 'package:petsflutter/utils/data_base_helper.dart';
import 'package:sqflite/sqflite.dart';

import 'add_user.dart';

class UserList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => UserListState();
}

class UserListState extends State<UserList> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<User> users;

  @override
  Widget build(BuildContext context) {
    if (users == null) {
      users = List<User>();
      updateListView();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Users'),
      ),
      body: ListView.builder(
        itemBuilder: (context, i) {
          if (users.length != null) {
            return ListTile(
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconButton(
                    color: Colors.black26,
                    icon: Icon(
                      Icons.edit,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      navigateToAddUser(users[i], 'Edit User');
                    },
                  ),
                  IconButton(
                    color: Colors.black26,
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      _delete(context, users[i]);
                    },
                  ),
                ],
              ),
              title: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Name: ${users[i].name} ${users[i].lastname}',
                      style: TextStyle(
                          fontFamily: 'Josefin Sans',
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0),
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    Text(
                      'Count of pets: ${users[i].numpet}',
                      style: TextStyle(fontFamily: 'Josefin Sans'),
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    Text(
                      'Mail: ${users[i].mail}',
                      style: TextStyle(fontFamily: 'Josefin Sans'),
                    ),
                  ],
                ),
              ),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return AboutUser(users[i]);
                }));
              },
            );
          }
          return null;
        },
        itemCount: users != null && users.length != null ? users.length : 0,
      ),
      floatingActionButton: FloatingActionButton.extended(
        elevation: 5.0,
        backgroundColor: Colors.green,
        onPressed: () {
          navigateToAddUser(User('','','',0), 'Add user');
        },
        label: Text('Add new user'),
        icon: Icon(Icons.add),
      ),
    );
  }

  void navigateToAddUser(User user, String title) async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return AddUserForm(user, title);
    }));
    if (result) {
      updateListView();
    }
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initialDatabase();
    dbFuture.then((database) {
      Future<List<User>> userListFuture = databaseHelper.getUserList();
      userListFuture.then((userList) {
        setState(() {
          this.users = userList;
        });
      });
    });
  }

  void _delete(BuildContext context, User user) async {
    int result = await databaseHelper.deleteUser(user.id);
    if (result != 0) {
      _showSnackBar(context, 'User Successfully Deleted');
      updateListView();
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackbar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackbar);
  }
}
