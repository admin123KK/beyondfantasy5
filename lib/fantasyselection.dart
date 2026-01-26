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
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: const Color(0xFF1A2A44),
            child: const Column(
              children: [
                Text(
                  'Nepal vs India',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
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
            child: Row(
              children: [
                Expanded(child: _buildTeamColumn(teamA, 'Nepal', 0)),
                Container(
                    width: 1.5,
                    color: const Color(0xFFFDB515).withOpacity(0.3)),
                Expanded(child: _buildTeamColumn(teamB, 'India', 1)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF1A2A44), Color(0xFF0D1B2E)],
              ),
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            ),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFDB515).withOpacity(0.25),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Selected: $selectedCount / 11',
                          style: TextStyle(
                            color: selectedCount == 11
                                ? const Color(0xFFFDB515)
                                : Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        'A: $teamASelected • B: $teamBSelected',
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 13),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton.icon(
                      onPressed: canCreateTeam
                          ? () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Team created! Redirecting to your teams...'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const MyCreatedTeamsPage(),
                                ),
                              );
                            }
                          : null,
                      icon: const Icon(Icons.check_circle_outline, size: 22),
                      label: Text(
                        canCreateTeam
                            ? 'Create & Join Contest'
                            : 'Select 11 Players',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: canCreateTeam
                            ? const Color(0xFFFDB515)
                            : Colors.grey[700],
                        foregroundColor: Colors.black87,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        elevation: canCreateTeam ? 8 : 0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamColumn(
      List<Map<String, dynamic>> team, String teamName, int teamIndex) {
    final selectedInTeam = team.where((p) => p['selected']).length;

    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: const BoxDecoration(
            color: Color(0xFF1A2A44),
            border: Border(
                bottom: BorderSide(color: const Color(0xFFFDB515), width: 3)),
          ),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  teamName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFDB515),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '$selectedInTeam / 7',
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(12),
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

    Color roleColor = Colors.grey;
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
    }

    return GestureDetector(
      onTap: () => togglePlayer(teamIndex, index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
        decoration: BoxDecoration(
          color: isSelected
              ? roleColor.withOpacity(0.18)
              : const Color(0xFF1A2A44),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFFFDB515) : Colors.transparent,
            width: 1.8,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFFFDB515).withOpacity(0.35),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: roleColor.withOpacity(0.25),
                shape: BoxShape.circle,
                border: Border.all(color: roleColor, width: 1.5),
              ),
              alignment: Alignment.center,
              child: Text(
                role,
                style: TextStyle(
                  color: roleColor,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                player['name'],
                style: TextStyle(
                  color: isSelected ? const Color(0xFFFDB515) : Colors.white,
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                ),
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle,
                  color: Color(0xFFFDB515), size: 26),
          ],
        ),
      ),
    );
  }
}

class MyCreatedTeamsPage extends StatelessWidget {
  const MyCreatedTeamsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy data - your own created teams (replace with real data later)
    final List<Map<String, dynamic>> myTeams = [
      {
        'name': 'Aakash XI',
        'captain': 'Virat Kohli',
        'viceCaptain': 'Rohit Sharma',
        'players': 11,
      },
      {
        'name': 'Nepal Power',
        'captain': 'Rohit Paudel',
        'viceCaptain': 'Kushal Malla',
        'players': 11,
      },
      {
        'name': 'All-rounders Only',
        'captain': 'Hardik Pandya',
        'viceCaptain': 'Dipendra Singh Airee',
        'players': 11,
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF003262),
      appBar: AppBar(
        backgroundColor: const Color(0xFF003262),
        elevation: 0,
        title: const Text(
          'My Teams',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Match Info Header (same match info as in FantasySelect)

          Expanded(
            child: myTeams.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.sports_cricket,
                            size: 80, color: Colors.white54),
                        SizedBox(height: 16),
                        Text(
                          'No teams created yet',
                          style: TextStyle(color: Colors.white70, fontSize: 20),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Go back and create your first team!',
                          style: TextStyle(color: Colors.white54, fontSize: 16),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: myTeams.length,
                    itemBuilder: (context, index) {
                      final team = myTeams[index];
                      return Card(
                        color: const Color(0xFF1A2A44),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    team['name'],
                                    style: const TextStyle(
                                      color: Color(0xFFFDB515),
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Captain: ${team['captain']} • VC: ${team['viceCaptain']}',
                                style: const TextStyle(
                                    color: Colors.white70, fontSize: 14),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Players: ${team['players']}/11',
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 14),
                              ),
                              const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '12/10/2025, 2:00 PM • Kirtipur',
                                    style: TextStyle(
                                        color: Color(0xFFFDB515), fontSize: 14),
                                  ),
                                  Text(
                                    ' • ICC T20 World Cup',
                                    style: TextStyle(color: Color(0xFFFDB515)),
                                  ),
                                ],
                              ),
                              const Text(
                                'Nepal vs India',
                                style: TextStyle(color: Color(0xFFFDB515)),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  OutlinedButton(
                                    onPressed: () {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text('Editing team...')),
                                      );
                                    },
                                    style: OutlinedButton.styleFrom(
                                      side: const BorderSide(
                                          color: Color(0xFFFDB515)),
                                      foregroundColor: const Color(0xFFFDB515),
                                    ),
                                    child: const Text('Edit'),
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
