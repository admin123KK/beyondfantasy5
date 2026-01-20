import 'package:flutter/material.dart';

class FantasySelect extends StatefulWidget {
  const FantasySelect({super.key});

  @override
  State<FantasySelect> createState() => _FantasySelectState();
}

class _FantasySelectState extends State<FantasySelect> {
  // Sample player data for both teams
  final List<Map<String, dynamic>> teamA = [
    {'name': 'Rohit Sharma', 'role': 'BAT', 'selected': false},
    {'name': 'Virat Kohli', 'role': 'BAT', 'selected': false},
    {'name': 'Shubman Gill', 'role': 'BAT', 'selected': false},
    {'name': 'KL Rahul', 'role': 'WK', 'selected': false},
    {'name': 'Hardik Pandya', 'role': 'AR', 'selected': false},
    {'name': 'Ravindra Jadeja', 'role': 'AR', 'selected': false},
    {'name': 'Jasprit Bumrah', 'role': 'BOWL', 'selected': false},
    {'name': 'Mohammed Siraj', 'role': 'BOWL', 'selected': false},
    {'name': 'Kuldeep Yadav', 'role': 'BOWL', 'selected': false},
    {'name': 'Yashasvi Jaiswal', 'role': 'BAT', 'selected': false},
    {'name': 'Axar Patel', 'role': 'AR', 'selected': false},
    {'name': 'Rishabh Pant', 'role': 'WK', 'selected': false},
    {'name': 'Suryakumar Yadav', 'role': 'BAT', 'selected': false},
    {'name': 'Arshdeep Singh', 'role': 'BOWL', 'selected': false},
  ];

  final List<Map<String, dynamic>> teamB = [
    {'name': 'Aasif Sheikh', 'role': 'WK', 'selected': false},
    {'name': 'Kushal Bhurtel', 'role': 'BAT', 'selected': false},
    {'name': 'Rohit Paudel', 'role': 'BAT', 'selected': false},
    {'name': 'Dipendra Singh Airee', 'role': 'AR', 'selected': false},
    {'name': 'Kushal Malla', 'role': 'AR', 'selected': false},
    {'name': 'Gulsan Jha', 'role': 'AR', 'selected': false},
    {'name': 'Sandeep Lamichhane', 'role': 'BOWL', 'selected': false},
    {'name': 'Karan KC', 'role': 'BOWL', 'selected': false},
    {'name': 'Sompal Kami', 'role': 'BOWL', 'selected': false},
    {'name': 'Lalit Rajbanshi', 'role': 'BOWL', 'selected': false},
    {'name': 'Anil Sah', 'role': 'WK', 'selected': false},
    {'name': 'Bhuwan Karki', 'role': 'AR', 'selected': false},
    {'name': 'Gulshan Kumar Jha', 'role': 'AR', 'selected': false},
    {'name': 'Abinash Bohara', 'role': 'BOWL', 'selected': false},
  ];

  int get selectedCount =>
      teamA.where((p) => p['selected']).length +
      teamB.where((p) => p['selected']).length;

  bool get canCreateTeam => selectedCount == 11;

  void togglePlayer(int teamIndex, int playerIndex) {
    setState(() {
      final team = teamIndex == 0 ? teamA : teamB;
      final player = team[playerIndex];

      // Prevent selecting more than 7 from one team
      final teamSelected = team.where((p) => p['selected']).length;
      if (!player['selected'] && teamSelected >= 7) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Maximum 7 players from one team')),
        );
        return;
      }

      player['selected'] = !player['selected'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF003262),
      appBar: AppBar(
        backgroundColor: const Color(0xFF003262),
        elevation: 0,
        title: const Text(
          'Create Fantasy Team',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: const Icon(Icons.arrow_back, color: Colors.white),
      ),
      body: Column(
        children: [
          // Team selection area
          Expanded(
            child: Row(
              children: [
                // Team A (Left)
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        color: const Color(0xFFFDB515).withOpacity(0.2),
                        child: const Center(
                          child: Text(
                            'Team A - Nepal',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: teamA.length,
                          itemBuilder: (context, i) {
                            final player = teamA[i];
                            return _buildPlayerTile(player, i, 0);
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                // Divider
                Container(
                  width: 1,
                  color: Colors.white.withOpacity(0.2),
                ),

                // Team B (Right)
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        color: const Color(0xFFFDB515).withOpacity(0.2),
                        child: const Center(
                          child: Text(
                            'Team B - England',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: teamB.length,
                          itemBuilder: (context, i) {
                            final player = teamB[i];
                            return _buildPlayerTile(player, i, 1);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Bottom bar: Selected count + Create button
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1A2A44),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Selected: $selectedCount / 11',
                      style: TextStyle(
                        color: selectedCount == 11
                            ? Colors.greenAccent
                            : Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Bench: ${selectedCount > 11 ? selectedCount - 11 : 0} / 4',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: canCreateTeam
                        ? () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Team Created Successfully!')),
                            );
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          canCreateTeam ? const Color(0xFFFDB515) : Colors.grey,
                      foregroundColor: Colors.black87,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 4,
                    ),
                    child: Text(
                      canCreateTeam
                          ? 'Create Team & Join Contest'
                          : 'Select 11 Players',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerTile(
      Map<String, dynamic> player, int index, int teamIndex) {
    final isSelected = player['selected'] as bool;

    return GestureDetector(
      onTap: () => togglePlayer(teamIndex, index),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFFDB515).withOpacity(0.25)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFFFDB515) : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: const Color(0xFFFDB515).withOpacity(0.3),
              child: Text(
                player['role'],
                style: const TextStyle(
                  color: Color(0xFFFDB515),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                player['name'],
                style: TextStyle(
                  color: isSelected ? const Color(0xFFFDB515) : Colors.white,
                  fontSize: 15,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle,
                  color: Color(0xFFFDB515), size: 20),
          ],
        ),
      ),
    );
  }
}
