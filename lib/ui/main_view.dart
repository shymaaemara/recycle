import 'package:flutter/material.dart';
import 'package:untitled16/ui/screens/login_screen.dart';
import 'package:untitled16/ui/screens/sing_up_screen.dart';


class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  PageController controller = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 3,
        controller: controller,
        itemBuilder: (context, index) {
          if (index == 0) {
            return LoginScreen(

            );
          } else if (index == 1) {
            return SingUpScreen(

            );
          }
        },
      ),
    );
  }
}
