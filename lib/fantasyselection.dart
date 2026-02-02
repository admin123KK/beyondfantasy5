import 'dart:convert';

import 'package:beyondfantasy/api.dart'; // your ApiConstants file
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class FantasySelect extends StatefulWidget {
  const FantasySelect({super.key});

  @override
  State<FantasySelect> createState() => _FantasySelectState();
}

class _FantasySelectState extends State<FantasySelect> {
  List<Map<String, dynamic>> teamA = [];
  List<Map<String, dynamic>> teamB = [];

  String teamAName = 'Loading...';
  String teamBName = 'Loading...';
  String matchDateTime = 'Loading...';
  String venue = 'Loading...';
  String league = 'ICC Women\'s World Cup';

  bool _isLoading = true;
  String? _error;

  int get selectedCount =>
      teamA.where((p) => p['selected'] == true).length +
      teamB.where((p) => p['selected'] == true).length;

  int get teamASelected => teamA.where((p) => p['selected'] == true).length;
  int get teamBSelected => teamB.where((p) => p['selected'] == true).length;

  bool get canCreateTeam =>
      selectedCount == 11 && teamASelected <= 7 && teamBSelected <= 7;

  String? selectedMatchId;

  @override
  void initState() {
    super.initState();
    _loadMatchIdAndFetchPlayers();
  }

  Future<void> _loadMatchIdAndFetchPlayers() async {
    final prefs = await SharedPreferences.getInstance();
    selectedMatchId = prefs.getString('selected_fantasy_match_id');

    if (selectedMatchId == null || selectedMatchId!.isEmpty) {
      setState(() {
        _error = 'No match selected. Go back and choose a match.';
        _isLoading = false;
      });
      return;
    }

    await _fetchPlayers();
  }

  Future<void> _fetchPlayers() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final response = await http.get(
        Uri.parse(ApiConstants.playersEndPoint),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final players = data['players'] as List<dynamic>? ?? [];

        // Clear previous lists
        teamA.clear();
        teamB.clear();

        for (var p in players) {
          final player = {
            'id': p['id'],
            'name': p['name'] as String? ?? 'Unknown Player',
            'role': p['role'] as String? ?? 'Unknown',
            'team': p['team']?['name'] as String? ?? 'Unknown Team',
            'selected': false,
          };

          if (player['team'] == teamAName || teamA.isEmpty) {
            teamA.add(player);
            if (teamAName == 'Loading...') teamAName = player['team'];
          } else {
            teamB.add(player);
            if (teamBName == 'Loading...') teamBName = player['team'];
          }
        }

        // Fetch match details if needed (you can add another API call here if required)
        // For now using dummy match info - you can fetch from match endpoint if needed

        setState(() {
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = 'Failed to load players: ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Error: $e';
        _isLoading = false;
      });
    }
  }

  void togglePlayer(int teamIndex, int playerIndex) {
    setState(() {
      final team = teamIndex == 0 ? teamA : teamB;
      final player = team[playerIndex];

      final teamSelected = team.where((p) => p['selected'] == true).length;

      if (!player['selected'] && teamSelected >= 7) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Maximum 7 players from one team')),
        );
        return;
      }

      player['selected'] = !(player['selected'] ?? false);
    });
  }

  Future<void> _createFantasyTeam() async {
    if (!canCreateTeam) return;

    setState(() => _isLoading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';

      // Collect selected player IDs
      final selectedPlayers = [
        ...teamA.where((p) => p['selected'] == true).map((p) => p['id']),
        ...teamB.where((p) => p['selected'] == true).map((p) => p['id']),
      ];

      // For simplicity: first selected is captain, second is vice-captain
      final captain = selectedPlayers.isNotEmpty ? selectedPlayers[0] : null;
      final viceCaptain =
          selectedPlayers.length > 1 ? selectedPlayers[1] : null;

      final body = {
        "fantasy_match_id": selectedMatchId,
        "team_name": "My Fantasy Team ${DateTime.now().millisecondsSinceEpoch}",
        "playing_11": selectedPlayers,
        "bench_players": [], // optional: can add logic later
        "captain": captain,
        "vice_captain": viceCaptain,
      };

      final response = await http.post(
        Uri.parse(ApiConstants.createfantasyteamEndPoint),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Fantasy team created successfully!'),
            backgroundColor: Colors.green,
          ),
        );

        // Optional: navigate to My Teams or global teams page
        Navigator.pushReplacementNamed(context, '/my-teams'); // or your route
      } else {
        final errorData = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorData['message'] ?? 'Failed to create team'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFF0F034E),
        body:
            Center(child: CircularProgressIndicator(color: Color(0xFFFDB515))),
      );
    }

    if (_error != null) {
      return Scaffold(
        backgroundColor: const Color(0xFF0F034E),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_error!, style: const TextStyle(color: Colors.redAccent)),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _loadMatchIdAndFetchPlayers,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0F034E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F034E),
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
          // Match Info Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: const Color(0xFF0F034E),
            child: Column(
              children: [
                Text(
                  '$teamAName vs $teamBName',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '$matchDateTime • $venue • $league',
                  style:
                      const TextStyle(color: Color(0xFFFDB515), fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          Expanded(
            child: Row(
              children: [
                Expanded(child: _buildTeamColumn(teamA, teamAName, 0)),
                Container(
                    width: 1.5,
                    color: const Color(0xFFFDB515).withOpacity(0.3)),
                Expanded(child: _buildTeamColumn(teamB, teamBName, 1)),
              ],
            ),
          ),

          // Bottom bar
          Container(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF0F034E), Color(0xFF0F034E)],
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
                      onPressed: canCreateTeam ? _createFantasyTeam : null,
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
    final selectedInTeam = team.where((p) => p['selected'] == true).length;

    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: const Color(0xFF0F034E),
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
    final isSelected = player['selected'] == true;
    final role = player['role'] as String? ?? 'Unknown';

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
              : const Color(0xFF0F034E),
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
                      spreadRadius: 2)
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
                    fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                player['name'] as String? ?? 'Unknown Player',
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
