import 'package:beyondfantasy/pageone.dart';
import 'package:flutter/material.dart';

class Welcomepage extends StatefulWidget {
  const Welcomepage({super.key});

  @override
  State<Welcomepage> createState() => _WelcomepageState();
}

class _WelcomepageState extends State<Welcomepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F034E),
      body: SafeArea(
        child: Column(
          children: [
            Spacer(),
            // Top text section
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 60),
              child: Column(
                children: [
                  const Text(
                    'DREAM IT BUILD IT\n WIN BIG',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 40,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Join the ultimate fantasy league experience and \ncompete for massive cash prizes every week.',
                    style: TextStyle(
                      color: Color(0xFFFDB515),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            Center(
              child: Container(
                width: double.infinity,
                height: 250,
                decoration: BoxDecoration(
                  color: Color(0xFF0F034E),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Image.asset(
                  'assets/images/welcome.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Spacer(),
            const SizedBox(height: 40),

            // Get Started button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Pageone()),
                  );
                },
                child: Container(
                  height: 40,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color(0xFFFDB515),
                  ),
                  child: const Center(
                    child: Text(
                      "Get Started",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
