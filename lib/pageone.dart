import 'package:beyondfantasy/loginpage.dart';
import 'package:flutter/material.dart';

class Pageone extends StatefulWidget {
  const Pageone({super.key});

  @override
  State<Pageone> createState() => _PageoneState();
}

class _PageoneState extends State<Pageone> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF003262),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 200),
              child: Column(
                children: [
                  Text(
                    'PICK YOUR PLAYER',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFDB515),
                        fontSize: 40),
                  ),
                  Text(
                    'AND LEAD THE WORLD',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 40),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Container(
                    height: 6,
                    width: 33,
                    decoration: BoxDecoration(
                      color: Color(0xFFFDB515),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Container(
                    height: 6,
                    width: 33,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(148, 253, 180, 21),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Container(
                    height: 6,
                    width: 33,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(170, 116, 94, 49),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  const SizedBox(
                    width: 300,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Pagetwo()));
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

class Pagetwo extends StatefulWidget {
  const Pagetwo({super.key});

  @override
  State<Pagetwo> createState() => _PagetwoState();
}

class _PagetwoState extends State<Pagetwo> {
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
                    'YOUR STRATEGY ',
                    style: TextStyle(
                        color: Color(0xFFFDB515),
                        fontSize: 40,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'YOUR TEAM YOUR VICTORY',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                children: [
                  Container(
                    height: 6,
                    width: 33,
                    decoration: BoxDecoration(
                        color: Color.fromARGB(145, 254, 190, 52),
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Container(
                    height: 6,
                    width: 33,
                    decoration: BoxDecoration(
                        color: Color(0xFFFDB515),
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Container(
                    height: 6,
                    width: 33,
                    decoration: BoxDecoration(
                        color: Color.fromARGB(162, 234, 176, 50),
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  const SizedBox(
                    width: 300,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Pagethree()));
                    },
                    child: const Text(
                      'Skip',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class Pagethree extends StatefulWidget {
  const Pagethree({super.key});

  @override
  State<Pagethree> createState() => _PagethreeState();
}

class _PagethreeState extends State<Pagethree> {
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
                    'JOIN THE FANTASY ',
                    style: TextStyle(
                        color: Color(0xFFFDB515),
                        fontSize: 40,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'CHALLANGE THE WORLD',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                children: [
                  Container(
                    height: 6,
                    width: 33,
                    decoration: BoxDecoration(
                        color: Color.fromARGB(147, 234, 176, 50),
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Container(
                    height: 6,
                    width: 33,
                    decoration: BoxDecoration(
                        color: Color.fromARGB(168, 253, 180, 21),
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Container(
                    height: 6,
                    width: 33,
                    decoration: BoxDecoration(
                        color: Color(0xFFFDB515),
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  const SizedBox(
                    width: 300,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => LoginPage()));
                    },
                    child: const Text(
                      'Skip',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
