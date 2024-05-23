import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:learn_auth_firebase_g10/services/auth_service.dart';

class HomePage extends StatefulWidget {
  final User? user;
  const HomePage({super.key, this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: ()async{
              await AuthService.logOut();
            },
            icon: const Icon(Icons.logout),
          ),
          IconButton(
            onPressed: ()async{
              await AuthService.deleteAccount();
            },
            icon: const Icon(Icons.delete),
          )
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Text("User name: ${widget.user?.displayName}"),
            Text("User email: ${widget.user?.email}"),
            Text("User phone: ${widget.user?.phoneNumber}"),
            const SizedBox(height: 100,),
            TextButton(
              onPressed: () => throw Exception("Bu G10 uchun test"),
              child: const Text("Throw Test Exception"),
            ),
          ],
        ),
      ),
    );
  }
}
