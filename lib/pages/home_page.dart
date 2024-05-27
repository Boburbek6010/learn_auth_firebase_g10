import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:learn_auth_firebase_g10/data/mock_data.dart';
import 'package:learn_auth_firebase_g10/models/item.dart';
import 'package:learn_auth_firebase_g10/services/auth_service.dart';

class HomePage extends StatefulWidget {
  final User? user;

  const HomePage({super.key, this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isAds = false;
  String text = "";
  double padding = 10;
  double borderRadius = 10;
  String backColor = "red";
  final remoteConfig = FirebaseRemoteConfig.instance;

  Map<String, Color> colors = {
    "red":Colors.red,
    "yellow":Colors.yellow,
    "blue":Colors.blue,
  };

  Future<void> fetchData() async {
    remoteConfig.setDefaults({
      "isAds": true,
      "bannerText": "",
      "padding": 0,
      "borderRadius": 0,
      "backColor": "yellow",
    });
    await activateData();
    remoteConfig.onConfigUpdated.listen((changes) async {
      await activateData();
    });
  }

  Future<void> activateData() async {
    await remoteConfig.fetchAndActivate();
    isAds = remoteConfig.getBool("isAds");
    text = remoteConfig.getString("bannerText");
    padding = remoteConfig.getDouble("padding");
    borderRadius = remoteConfig.getDouble("borderRadius");
    backColor = remoteConfig.getString("backColor");
    // colors.forEach((key, value) {
    //   if(backColor == key){
    //
    //     log(backColor);
    //   }else{
    //     backColor = "red";
    //   }
    // });

    log(isAds.toString());
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors[backColor],
      appBar: AppBar(
        title: const Text("Home Page"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              await AuthService.logOut();
            },
            icon: const Icon(Icons.logout),
          ),
          IconButton(
            onPressed: () async {
              await AuthService.deleteAccount();
            },
            icon: const Icon(Icons.delete),
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(padding),
        child: Stack(
          children: [
            GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4, mainAxisSpacing: 10, crossAxisSpacing: 20, childAspectRatio: 1),
              itemBuilder: (_, __) {
                return MainItem(
                  item: listItem[__],
                  borderRadius: borderRadius,
                );
              },
              itemCount: listItem.length,
            ),
            if (isAds)
              Container(
                alignment: Alignment.center,
                height: 60,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.red,
                ),
                child: Text(
                  text,
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
              )
          ],
        ),
      ),
    );
  }
}

class MainItem extends StatelessWidget {
  final Item item;
  final double borderRadius;
  const MainItem({super.key, required this.item, required this.borderRadius});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        color: Colors.grey,
      ),
      child: Column(
        children: [
          Expanded(
            flex: 4,
            child: Image.asset("assets/img.png"),
          ),
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Text(item.name),
                Text(item.size),
                Text(item.price.toString()),
              ],
            ),
          )
        ],
      ),
    );
  }
}

/// For crashlytics

/*
Center(
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
 */
