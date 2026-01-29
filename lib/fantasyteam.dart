import 'package:flutter/material.dart';

class GlobalFantasyTeamsPage extends StatelessWidget {
  const GlobalFantasyTeamsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy data: fantasy teams created by other users (global competitors)
    final List<Map<String, dynamic>> globalTeams = [
      {
        'creator': 'Ramesh Thapa',
        'teamName': 'Royal Strikers',
        'captain': 'Jasprit Bumrah',
        'viceCaptain': 'Hardik Pandya',
        'players': 11,
        'points': 284,
        'rank': 1,
      },
      {
        'creator': 'Suresh Lama',
        'teamName': 'Spin Masters',
        'captain': 'Kuldeep Yadav',
        'viceCaptain': 'Ravindra Jadeja',
        'players': 11,
        'points': 265,
        'rank': 3,
      },
      {
        'creator': 'Bikram Gurung',
        'teamName': 'Death Overs XI',
        'captain': 'Arshdeep Singh',
        'viceCaptain': 'Mohammed Siraj',
        'players': 11,
        'points': 231,
        'rank': 8,
      },
      {
        'creator': 'Dipak Joshi',
        'teamName': 'Power Hitters',
        'captain': 'Rishabh Pant',
        'viceCaptain': 'Suryakumar Yadav',
        'players': 11,
        'points': 198,
        'rank': 12,
      },
      {
        'creator': 'Anil Karki',
        'teamName': 'Nepal Dominators',
        'captain': 'Rohit Paudel',
        'viceCaptain': 'Kushal Malla',
        'players': 11,
        'points': 176,
        'rank': 19,
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF0F034E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F034E),
        elevation: 0,
        title: const Row(
          children: [
            Text(
              'Global Fantasy Teams',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Optional match context header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: const Color(0xFF0F034E),
            child: const Column(
              children: [
                Text(
                  'Nepal vs India',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  '12/10/2025, 2:00 PM • Kirtipur • ICC T20 World Cup',
                  style: TextStyle(color: Color(0xFFFDB515), fontSize: 14),
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: globalTeams.length,
              itemBuilder: (context, index) {
                final team = globalTeams[index];

                // Safe access with fallback values
                final creator = team['creator'] as String? ?? 'Unknown User';
                final teamName = team['teamName'] as String? ?? 'Unnamed Team';
                final captain = team['captain'] as String? ?? 'N/A';
                final viceCaptain = team['viceCaptain'] as String? ?? 'N/A';
                final players = team['players'] as int? ?? 0;
                final points = team['points'] as int? ?? 0;
                final rank = team['rank'] as int? ?? 0;

                return Card(
                  color: const Color(0xFF0F034E),
                  elevation: 13,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Creator
                        Row(
                          children: [
                            const Icon(Icons.person,
                                color: Color(0xFFFDB515), size: 18),
                            const SizedBox(width: 8),
                            Text(
                              'Created by $creator',
                              style: const TextStyle(
                                color: Color(0xFFFDB515),
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Team name
                        Text(
                          teamName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Captain & VC
                        Text(
                          'C: $captain • VC: $viceCaptain',
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 14),
                        ),
                        const SizedBox(height: 8),

                        // Players count
                        Text(
                          'Players: $players/11',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 14),
                        ),
                        const SizedBox(height: 12),

                        // Rank & Points
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.emoji_events,
                                    color: Color(0xFFFDB515), size: 18),
                                const SizedBox(width: 6),
                                Text(
                                  'Global Rank: #$rank',
                                  style: const TextStyle(
                                    color: Color(0xFFFDB515),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              '$points pts',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
