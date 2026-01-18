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
      backgroundColor: Color(0xFF003262),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 200),
              child: Column(
                children: [
                  Text(
                    'DREAM IT BUILD IT\n WIN BIG',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 40),
                  ),
                  Text(
                    'Join the ultimate fantasy league experience\n and compete for massive cash prizes every week.',
                    style: TextStyle(color: Color(0xFFFDB515)),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const Pageone()));
                },
                child: Container(
                  height: 33,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color(0xFFFDB515)),
                  child: const Center(
                      child: Text(
                    'Get Started',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
