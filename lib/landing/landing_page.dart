import 'package:flutter/material.dart';
import 'package:untitled2/common/colors.dart';
import 'package:untitled2/home/home_page.dart';
import 'package:untitled2/ui/screens/login_screen.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'assets/images/landing.jpg',
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 1,
          child: Container(
            height: 340,
            //color: Colors.green.withOpacity(0.5),
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'recycle \nfor us',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    inherit: false,
                    fontSize: 75,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) => const LoginScreen(),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 22, horizontal: 30),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(35),
                          color: GlassesColors.lightYellow,
                        ),
                        child: const Text(
                          'Start now',
                          style: TextStyle(
                            inherit: false,
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        color: Colors.white,
                      ),
                      child: const Icon(
                        Icons.arrow_forward_rounded,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
