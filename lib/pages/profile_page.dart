import 'package:basic_chat_app/pages/home_page.dart';
import 'package:flutter/material.dart';
import '../helper/screen_nav_helper.dart';
import '../models/app_bar_parameters.dart';
import '../models/drawer_data.dart';
import '../service/auth_service.dart';
import '../widgets/drawer/drawer_widget.dart';
import '../widgets/general_custom_widget.dart';

class ProfilePage extends StatefulWidget {
  final String userName;
  final String email;

  const ProfilePage({super.key, required this.userName, required this.email});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  AuthService authServiceInstance = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      drawer: drawer(),
      body: body(),
    );
  }

  AppBar appBar() {
    return GeneralPurposeWidget.appBar(
      ctx: context,
      appBarParameters: AppBarParameters(
        title: "Profile",
        actions: [],
      ),
    );
  }

  Widget drawer() {
    return DrawerWidget(
      drawerData: DrawerData(
          authServiceInstance: authServiceInstance,
          groupFunction: goToGroupPage,
          profileFunction: () {},
          currentPage: Selected.profile,
          userName: widget.userName),
    );
  }

  void goToGroupPage() {
    ScreenNavHelper.nextScreen(context: context, page: const HomePage());
  }

  Widget body() {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 150, horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Icon(
              Icons.account_circle,
              size: 200,
              color: Colors.grey,
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Full name", style: TextStyle(fontSize: 17)),
                Text(widget.userName, style: const TextStyle(fontSize: 17)),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Email", style: TextStyle(fontSize: 17)),
                Text(widget.email, style: const TextStyle(fontSize: 17)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
