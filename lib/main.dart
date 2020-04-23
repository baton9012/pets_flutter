import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:petsflutter/screens/add_user.dart';
import 'package:petsflutter/screens/detail_info.dart';
import 'package:petsflutter/screens/user_list.dart';

void main() => runApp(
      new MaterialApp(
        theme: ThemeData.dark(),
        debugShowCheckedModeBanner: false,
        home: SafeArea(
          child: UserList(),
        ),
      ),
    );
