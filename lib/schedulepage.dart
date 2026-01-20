import 'package:beyondfantasy/fantasyselection.dart';
import 'package:flutter/material.dart';

class GameSchedulePage extends StatelessWidget {
  const GameSchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample matches (Nepal Premier League + World Cup style)
    final List<Map<String, String>> matches = [
      {
        'teamA': 'Karnali Yaks',
        'teamB': 'Janakpur Bolts',
        'date': '12/7/2025, 3:30 PM',
        'ground': 'Kirtipur',
        'league': 'Nepal Premier League 2025',
      },
      {
        'teamA': 'Kathmandu Gorkhas',
        'teamB': 'Pokhara Avengers',
        'date': '12/8/2025, 7:00 PM',
        'ground': 'TU Ground',
        'league': 'Nepal Premier League 2025',
      },
      {
        'teamA': 'Nepal',
        'teamB': 'India',
        'date': '12/10/2025, 2:00 PM',
        'ground': 'Kirtipur',
        'league': 'ICC T20 World Cup',
      },
      {
        'teamA': 'Australia',
        'teamB': 'England',
        'date': '12/11/2025, 7:30 PM',
        'ground': 'Kirtipur',
        'league': 'ICC T20 World Cup',
      },
      {
        'teamA': 'Sri Lanka',
        'teamB': 'Bangladesh',
        'date': '12/12/2025, 3:00 PM',
        'ground': 'Mulpani',
        'league': 'ICC T20 World Cup',
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF003262),
      appBar: AppBar(
        backgroundColor: const Color(0xFF003262),
        elevation: 0,
        title: const Text(
          'Match Schedule',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: const Icon(Icons.arrow_back, color: Colors.white),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: matches.length,
        itemBuilder: (context, index) {
          final match = matches[index];

          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1A2A44),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.08)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.35),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Date & Time
                Row(
                  children: [
                    const Icon(Icons.access_time,
                        color: Color(0xFFFDB515), size: 18),
                    const SizedBox(width: 6),
                    Text(
                      match['date']!,
                      style: const TextStyle(
                        color: Color(0xFFFDB515),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Teams VS
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        match['teamA']!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: const Text(
                        'VS',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        match['teamB']!,
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // League + Ground
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.emoji_events,
                            color: Color(0xFFFDB515), size: 18),
                        const SizedBox(width: 6),
                        Text(
                          match['league']!,
                          style: const TextStyle(
                            color: Color(0xFFFDB515),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.location_on,
                            color: Color(0xFFFDB515), size: 18),
                        const SizedBox(width: 6),
                        Text(
                          match['ground']!,
                          style: const TextStyle(
                            color: Color(0xFFFDB515),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Small cute Create Fantasy Team button
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FantasySelect()));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Opening Team Creator...')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFDB515),
                      foregroundColor: Colors.black87,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      minimumSize: const Size(0, 40), // compact size
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 3,
                    ),
                    child: const Text(
                      'Create Fantasy Team ',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
