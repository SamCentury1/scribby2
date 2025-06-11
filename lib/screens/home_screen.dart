import 'package:scribby_flutter_v2/resources/auth_service.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {


    // final authService = AuthService();

    // user email
    // String email = authService.getUserEmail();
    

        
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text("Home Screen"),
        actions: [
          IconButton(
            onPressed: AuthService().signOut,
             
            icon: const Icon(Icons.logout)
          )
        ],
      ),
      body: Column(
        children: [
          Container(
            width: 200,
            height: 50,
            color: Colors.green,
            child: Text(
              "PENIS"
            )
          ),
          Center(
            child: Column(
              children: [],//displayEmails(email),
            ),
          ),
        ],
      ),
    );
  }
}

List<Widget> displayEmails(String email) {
  List<Widget> col = [];
  for (int i=0; i<20; i++) {
    Widget item = Text(email);
    col.add(item);
  }
  return col;
}