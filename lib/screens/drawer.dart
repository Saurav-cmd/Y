import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:y/controllers/auth_controller.dart';
import 'package:y/utility/colors.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthController aC = Get.put(AuthController());
    return Drawer(
      child: Column(
        children: [
          AppBar(
            backgroundColor: ChooseColor(0).redColor,
            title: const Text('Hello There!'),
            centerTitle: true,
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.white),
          ),
          const Divider(),
          ListTile(
            leading: const Text(
              'Forum',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
            ),
            trailing: const Icon(
              Icons.forum_outlined,
              size: 25,
            ),
            onTap: () {
              Navigator.of(context).pushNamed("Reply_screen");
            },
          ),
          const Divider(),
          ListTile(
            leading: const Text(
              "Profile",
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
            ),
            trailing: const Icon(Icons.contact_page_outlined, size: 25),
            onTap: () {
              Navigator.of(context).pushNamed("Profile_screen");
            },
          ),
          const Divider(),
          ListTile(
            leading: const Text(
              "Logout",
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
            ),
            trailing: const Icon(Icons.exit_to_app, size: 25),
            onTap: () {
              aC.logout(context);
            },
          )
        ],
      ),
    );
  }
}
