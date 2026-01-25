import 'package:flutter/material.dart';

class FantasySelect extends StatefulWidget {
  const FantasySelect({super.key});

  @override
  State<FantasySelect> createState() => _FantasySelectState();
}

class _FantasySelectState extends State<FantasySelect> {
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

  int get teamASelected => teamA.where((p) => p['selected']).length;
  int get teamBSelected => teamB.where((p) => p['selected']).length;

  bool get canCreateTeam =>
      selectedCount == 11 && teamASelected <= 7 && teamBSelected <= 7;

  void togglePlayer(int teamIndex, int playerIndex) {
    setState(() {
      final team = teamIndex == 0 ? teamA : teamB;
      final player = team[playerIndex];

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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Team selection area
          Expanded(
            child: Row(
              children: [
                // Team A (Left)
                Expanded(
                  child: _buildTeamColumn(
                    team: teamA,
                    teamName: 'Nepal',
                    teamIndex: 0,
                    accentColor: const Color(0xFF003262),
                  ),
                ),

                // Vertical divider
                Container(width: 1, color: Colors.white.withOpacity(0.15)),

                // Team B (Right)
                Expanded(
                  child: _buildTeamColumn(
                    team: teamB,
                    teamName: 'England',
                    teamIndex: 1,
                    accentColor: const Color(0xFF003262),
                  ),
                ),
              ],
            ),
          ),

          // Bottom fixed bar
          Container(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFF1A2A44),
                  const Color(0xFF0F1E33),
                ],
              ),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(24)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  blurRadius: 12,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
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
                      'Team A: $teamASelected / 7 • Team B: $teamBSelected / 7',
                      style:
                          const TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed: canCreateTeam
                        ? () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('Team Created! Ready to join contest'),
                                backgroundColor: Colors.green,
                              ),
                            );
                            // TODO: Save team & navigate to contest
                          }
                        : null,
                    icon: const Icon(Icons.check_circle, size: 20),
                    label: Text(
                      canCreateTeam
                          ? 'Create Team & Join'
                          : 'Select 11 Players',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: canCreateTeam
                          ? const Color(0xFFFDB515)
                          : Colors.grey[600],
                      foregroundColor: Colors.black87,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      elevation: canCreateTeam ? 6 : 0,
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

  Widget _buildTeamColumn({
    required List<Map<String, dynamic>> team,
    required String teamName,
    required int teamIndex,
    required Color accentColor,
  }) {
    final selectedInTeam = team.where((p) => p['selected']).length;

    return Column(
      children: [
        // Team Header
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                accentColor,
                accentColor.withOpacity(0.7),
              ],
            ),
          ),
          child: Center(
            child: Text(
              '$teamName ($selectedInTeam/7)',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),

        // Player List
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: team.length,
            itemBuilder: (context, i) {
              final player = team[i];
              return _buildPlayerTile(player, i, teamIndex);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPlayerTile(
      Map<String, dynamic> player, int index, int teamIndex) {
    final isSelected = player['selected'] as bool;
    final role = player['role'] as String;

    Color roleColor;
    switch (role) {
      case 'BAT':
        roleColor = Colors.blueAccent;
        break;
      case 'BOWL':
        roleColor = Colors.redAccent;
        break;
      case 'AR':
        roleColor = Colors.purpleAccent;
        break;
      case 'WK':
        roleColor = Colors.orangeAccent;
        break;
      default:
        roleColor = Colors.grey;
    }

    return GestureDetector(
      onTap: () => togglePlayer(teamIndex, index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? roleColor.withOpacity(0.25)
              : const Color(0xFF1A2A44),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? roleColor : Colors.transparent,
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: roleColor.withOpacity(0.4),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            // Role Badge
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: roleColor.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                role,
                style: TextStyle(
                  color: roleColor,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Player Name
            Expanded(
              child: Text(
                player['name'],
                style: TextStyle(
                  color: isSelected ? roleColor : Colors.white,
                  fontSize: 15,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                ),
              ),
            ),

            // Selection Indicator
            if (isSelected)
              const Icon(Icons.check_circle,
                  color: Color(0xFFFDB515), size: 24),
          ],
        ),
      ),
    );
  }
}
