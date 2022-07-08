import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:y/screens/drawer.dart';
import 'package:y/utility/colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ChooseColor(0).bodyBackgroundColor,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: ChooseColor(0).redColor,
            statusBarIconBrightness: Brightness.light),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "Welcome",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: ChooseColor(0).redColor,
      ),
      drawer: const AppDrawer(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Align(alignment: Alignment.center, child: Text("Welcome to Y"))
        ],
      ),
    );
  }
}
