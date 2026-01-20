import 'package:flutter/material.dart';

class GameSchedulePage extends StatelessWidget {
  const GameSchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> matches = [
      {
        'teamA': 'Nepal',
        'teamB': 'England',
        'date': '11/17/2025',
        'ground': 'TU Ground, Kathmandu',
      },
      {
        'teamA': 'India',
        'teamB': 'Pakistan',
        'date': '11/18/2025',
        'ground': 'Kirtipur International Cricket Stadium',
      },
      {
        'teamA': 'Australia',
        'teamB': 'New Zealand',
        'date': '11/19/2025',
        'ground': 'Kirtipur',
      },
      {
        'teamA': 'South Africa',
        'teamB': 'West Indies',
        'date': '11/20/2025',
        'ground': 'TU Ground',
      },
      {
        'teamA': 'Sri Lanka',
        'teamB': 'Bangladesh',
        'date': '11/21/2025',
        'ground': 'Kirtipur',
      },
      {
        'teamA': 'Afghanistan',
        'teamB': 'Ireland',
        'date': '11/22/2025',
        'ground': 'Mulpani Cricket Ground',
      },
      {
        'teamA': 'Nepal',
        'teamB': 'Scotland',
        'date': '11/23/2025',
        'ground': 'TU Ground',
      },
      {
        'teamA': 'USA',
        'teamB': 'Canada',
        'date': '11/24/2025',
        'ground': 'Kirtipur',
      },
      {
        'teamA': 'Oman',
        'teamB': 'Namibia',
        'date': '11/25/2025',
        'ground': 'Mulpani',
      },
      {
        'teamA': 'Netherlands',
        'teamB': 'Uganda',
        'date': '11/26/2025',
        'ground': 'TU Ground',
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF003262),
      appBar: AppBar(
        backgroundColor: const Color(0xFF003262),
        elevation: 0,
        title: const Text(
          'T20 World Cup Schedule',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: const Icon(Icons.arrow_back, color: Colors.white),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: matches.length,
        itemBuilder: (context, index) {
          final match = matches[index];
          final isEven = index % 2 == 0;

          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1A2A44), // Dark navy card
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.08)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        match['teamA']!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 9),
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(20),
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
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.calendar_month,
                            color: Color(0xFFFDB515), size: 20),
                        const SizedBox(width: 8),
                        Text(
                          match['date']!,
                          style: const TextStyle(
                            color: Color(0xFFFDB515),
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.stadium,
                            color: Color(0xFFFDB515), size: 20),
                        const SizedBox(width: 8),
                        Text(
                          match['ground']!,
                          style: const TextStyle(
                            color: Color(0xFFFDB515),
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
