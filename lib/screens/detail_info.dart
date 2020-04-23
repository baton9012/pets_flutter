import 'package:flutter/material.dart';
import 'package:petsflutter/models/user.dart';

class AboutUser extends StatelessWidget {
  User user;
  List<String> userPets = [];
  List<String> pets = ['cat', 'dog', 'raccoon', 'rabbit', 'horse'];

  AboutUser(this.user) {
    for (int i = 0; i < user.numpet; i++) {
      userPets.add(pets[i]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User information"),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Name: ${user.name} ${user.lastname}',
              style: TextStyle(
                fontSize: 32.0,
                fontFamily: 'Josefin Sans',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Mail: ${user.mail}',
              style: TextStyle(
                fontSize: 24.0,
                fontFamily: 'Josefin Sans',
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: userPets.length,
              itemBuilder: (context, i) {
                return Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        userPets[i],
                        style: TextStyle(fontSize: 16.0, fontFamily: 'Josefin Sans',),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
