import 'package:beyondfantasy/loginpage.dart';
import 'package:flutter/material.dart';

// Page 1
class Pageone extends StatelessWidget {
  const Pageone({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F034E),
      body: SafeArea(
        child: Column(
          children: [
            const Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'PICK YOUR PLAYER',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFDB515),
                        fontSize: 35,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      'AND LEAD THE WORLD',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 35,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            Image.asset(
              'assets/images/pageone.png',
              fit: BoxFit.contain,
            ),
            // Bottom bar: progress dots + Skip
            const SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        height: 6,
                        width: 33,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFDB515),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      const SizedBox(width: 5),
                      Container(
                        height: 6,
                        width: 33,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(148, 253, 180, 21),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      const SizedBox(width: 5),
                      Container(
                        height: 6,
                        width: 33,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(170, 116, 94, 49),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const Pagetwo()),
                      );
                    },
                    child: const Text(
                      'Skip',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Page 2
class Pagetwo extends StatelessWidget {
  const Pagetwo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F034E),
      body: SafeArea(
        child: Column(
          children: [
            // Main content - centered vertically
            const Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    // Text(
                    //   'YOUR STRATEGY',
                    //   style: TextStyle(
                    //     color: Color(0xFFFDB515),
                    //     fontSize: 37,
                    //     fontWeight: FontWeight.bold,
                    //   ),
                    //   textAlign: TextAlign.center,
                    // ),
                    // Text(
                    //   'YOUR TEAM YOUR VICTORY',
                    //   style: TextStyle(
                    //     color: Colors.white,
                    //     fontSize: 37,
                    //     fontWeight: FontWeight.bold,
                    //   ),
                    //   textAlign: TextAlign.center,
                    // ),
                  ],
                ),
              ),
            ),
            Image.asset(
              'assets/images/pageone.png',
              fit: BoxFit.contain,
            ),
            const Text(
              ' " YOUR STRATEGY ',
              style: TextStyle(
                color: Color(0xFFFDB515),
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const Text(
              ' YOUR TEAM YOUR VICTORY "',
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 300,
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        height: 6,
                        width: 33,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(145, 254, 190, 52),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      const SizedBox(width: 5),
                      Container(
                        height: 6,
                        width: 33,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFDB515),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      const SizedBox(width: 5),
                      Container(
                        height: 6,
                        width: 33,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(162, 234, 176, 50),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const Pagethree()),
                      );
                    },
                    child: const Text(
                      'Skip',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Page 3
class Pagethree extends StatelessWidget {
  const Pagethree({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F034E),
      body: SafeArea(
        child: Column(
          children: [
            // Main content - centered
            const Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'JOIN THE FANTASY',
                      style: TextStyle(
                        color: Color(0xFFFDB515),
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      'CHALLANGE THE WORLD',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 38,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            Image.asset(
              'assets/images/ausmisson.png',
              fit: BoxFit.contain,
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        height: 6,
                        width: 33,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(147, 234, 176, 50),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      const SizedBox(width: 5),
                      Container(
                        height: 6,
                        width: 33,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(168, 253, 180, 21),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      const SizedBox(width: 5),
                      Container(
                        height: 6,
                        width: 33,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFDB515),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginPage()),
                      );
                    },
                    child: const Text(
                      'Skip',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
