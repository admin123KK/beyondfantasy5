import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF003262),
      appBar: AppBar(
        backgroundColor: const Color(0xFF003262),
        elevation: 0,
        leading: const Icon(Icons.menu, color: Colors.white, size: 28),
        title: const Text(
          'Beyond Fantasy',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Icon(Icons.search, color: Colors.white, size: 26),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child:
                Icon(Icons.notifications_none, color: Colors.white, size: 26),
          ),
          SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFFEAECED),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 24, 16, 100),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Live Match title
                        const Text(
                          'Live Match',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Live Match Card
                        Container(
                          padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            children: [
                              Stack(
                                clipBehavior: Clip.none,
                                alignment: Alignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      // Nepal side
                                      const Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 32,
                                            backgroundImage: const NetworkImage(
                                              'https://upload.wikimedia.org/wikipedia/commons/thumb/9/9b/Flag_of_Nepal.svg/1200px-Flag_of_Nepal.svg.png',
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          const Text(
                                            'NEPAL',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),

                                      // VS
                                      const Text(
                                        'VS',
                                        style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFFFDB515),
                                        ),
                                      ),

                                      // England side with LIVE badge above avatar
                                      Stack(
                                        alignment: Alignment.topCenter,
                                        clipBehavior: Clip.none,
                                        children: [
                                          const Column(
                                            children: [
                                              const SizedBox(
                                                  height:
                                                      10), // space for badge above
                                              Row(
                                                children: [
                                                  const Text(
                                                    'ENGLAND',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 12),
                                                  CircleAvatar(
                                                    radius: 32,
                                                    backgroundImage:
                                                        const NetworkImage(
                                                      'https://upload.wikimedia.org/wikipedia/en/thumb/b/be/Flag_of_England.svg/1200px-Flag_of_England.svg.png',
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),

                                          // LIVE badge positioned above England avatar
                                          Positioned(
                                            top: -20,
                                            right: 0,
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 10,
                                                vertical: 4,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Colors.red,
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.red
                                                        .withOpacity(0.4),
                                                    blurRadius: 6,
                                                    offset: const Offset(0, 2),
                                                  ),
                                                ],
                                              ),
                                              child: const Text(
                                                'LIVE',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),

                              const SizedBox(height: 24),

                              // Scores
                              const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        '180/4',
                                        style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        '(20)',
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        '90/3',
                                        style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        '(12.3)',
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ],
                              ),

                              const SizedBox(height: 24),

                              // ICC tag at bottom
                              Center(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF003262),
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20)),
                                  ),
                                  child: const Text(
                                    'ICC Men\'s T20 World Cup',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Upcoming Matches
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Upcoming Matches',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: const Text(
                                'See all',
                                style: TextStyle(color: Color(0xFFFDB515)),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 140,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              _buildUpcomingMatchCard(
                                league: 'T20 World Cup',
                                team1Flag:
                                    'https://upload.wikimedia.org/wikipedia/commons/3/3e/Flag_of_New_Zealand.svg',
                                team1: 'NEWZEALAND',
                                team2Flag:
                                    'https://upload.wikimedia.org/wikipedia/commons/1/11/Flag_of_Sri_Lanka.svg',
                                team2: 'SRILANKA',
                                time: '10h 10min',
                              ),
                              const SizedBox(width: 16),
                              _buildUpcomingMatchCard(
                                league: 'T20 World Cup',
                                team1Flag:
                                    'https://upload.wikimedia.org/wikipedia/commons/thumb/9/9b/Flag_of_Nepal.svg/1200px-Flag_of_Nepal.svg.png',
                                team1: 'NEPAL',
                                team2Flag:
                                    'https://upload.wikimedia.org/wikipedia/commons/1/11/Flag_of_Sri_Lanka.svg',
                                team2: 'SRILANKA',
                                time: 'Upcoming',
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Trending News
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Trending News',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: const Text(
                                'See all',
                                style: TextStyle(color: Color(0xFFFDB515)),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Nepal eyes big win Over England on their first T20 World Cup',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                '10min ago',
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFFFDB515),
        selectedItemColor: Colors.black87,
        unselectedItemColor: Colors.black54,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home, size: 28), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.sports_cricket, size: 28), label: 'Matches'),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today, size: 28), label: 'Calendar'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person, size: 28), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildUpcomingMatchCard({
    required String league,
    required String team1Flag,
    required String team1,
    required String team2Flag,
    required String team2,
    required String time,
  }) {
    return Container(
      width: 220,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            league,
            style: const TextStyle(fontSize: 13, color: Color(0xFF003262)),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CircleAvatar(
                radius: 24,
                backgroundImage: NetworkImage(team1Flag),
              ),
              const Text(
                'vs',
                style: TextStyle(fontSize: 14, color: Color(0xFFFDB515)),
              ),
              CircleAvatar(
                radius: 24,
                backgroundImage: NetworkImage(team2Flag),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '$team1          $team2',
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                time,
                style: const TextStyle(fontSize: 10, color: Colors.green),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
