import 'dart:convert';

import 'package:beyondfantasy/api.dart';
import 'package:beyondfantasy/fantasyteam.dart';
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
  String league = "ICC Women's World Cup";

  bool _isLoading = true;
  String? _error;

  String? selectedMatchId;
  String? userId; // will load from prefs

  int? captainId;
  int? viceCaptainId;

  // Total selected players
  int get totalSelected =>
      teamA.where((p) => p['selected'] == true).length +
      teamB.where((p) => p['selected'] == true).length;

  // First 11 selected = playing
  int get playingCount => totalSelected > 11 ? 11 : totalSelected;

  // After 11 = bench
  int get benchCount => totalSelected > 11 ? totalSelected - 11 : 0;

  // Selected from each team
  int get teamASelectedCount =>
      teamA.where((p) => p['selected'] == true).length;

  int get teamBSelectedCount =>
      teamB.where((p) => p['selected'] == true).length;

  // Check if adding to playing 11 would exceed 6 for the team
  bool _teamExceedsPlayingLimit(int teamIndex) {
    final playingIds = [
      ...teamA.where((p) => p['selected'] == true).map((p) => p['id']),
      ...teamB.where((p) => p['selected'] == true).map((p) => p['id']),
    ].take(11);

    final teamPlaying = playingIds.where((id) {
      final allPlayers = [...teamA, ...teamB];
      final p = allPlayers.firstWhere((pp) => pp['id'] == id, orElse: () => {});
      return p['team'] == (teamIndex == 0 ? teamAName : teamBName);
    }).length;

    return teamPlaying > 6;
  }

  bool get canCreateTeam =>
      totalSelected == 14 && captainId != null && viceCaptainId != null;

  @override
  void initState() {
    super.initState();
    _loadUserAndMatchData();
  }

  Future<void> _loadUserAndMatchData() async {
    final prefs = await SharedPreferences.getInstance();
    selectedMatchId = prefs.getString('selected_fantasy_match_id');
    userId = prefs.getString('user_id') ?? '6'; // fallback if not found

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
        Uri.parse(
            '${ApiConstants.playersEndPoint}?fantasy_match_id=$selectedMatchId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final players = data['players'] as List<dynamic>? ?? [];

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
        _error = 'Error loading players: $e';
        _isLoading = false;
      });
    }
  }

  void togglePlayer(int teamIndex, int playerIndex) {
    setState(() {
      final team = teamIndex == 0 ? teamA : teamB;
      final player = team[playerIndex];

      final currentTotal = totalSelected;
      final willSelect = !(player['selected'] ?? false);

      // Check per-team limit for playing 11 only (when adding to playing)
      if (willSelect &&
          currentTotal < 11 &&
          _teamExceedsPlayingLimit(teamIndex)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Maximum 6 players from one team in playing 11')),
        );
        return;
      }

      // Check total max 14
      if (willSelect && currentTotal >= 14) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Maximum 14 players allowed')),
        );
        return;
      }

      player['selected'] = willSelect;
    });
  }

  void _showSelectionDialog(String type) {
    final playingPlayers = [
      ...teamA.where((p) => p['selected'] == true),
      ...teamB.where((p) => p['selected'] == true),
    ].take(11).toList(); // only from playing 11

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF0F034E),
        title:
            Text('Choose $type', style: const TextStyle(color: Colors.white)),
        content: SizedBox(
          width: double.maxFinite,
          height: 300,
          child: ListView.builder(
            itemCount: playingPlayers.length,
            itemBuilder: (context, i) {
              final player = playingPlayers[i];
              final isCaptain = captainId == player['id'];
              final isVC = viceCaptainId == player['id'];

              return ListTile(
                title: Text(
                  player['name'],
                  style: TextStyle(
                    fontWeight:
                        isCaptain || isVC ? FontWeight.bold : FontWeight.normal,
                    color: isCaptain
                        ? Colors.yellow[700]
                        : isVC
                            ? Colors.yellow[900]
                            : Colors.white,
                  ),
                ),
                subtitle: Text(player['role'],
                    style: const TextStyle(color: Colors.white70)),
                trailing: isCaptain
                    ? const Icon(Icons.star, color: Color(0xFFFDB515))
                    : isVC
                        ? const Icon(Icons.star_half, color: Color(0xFFFDB515))
                        : null,
                onTap: () {
                  setState(() {
                    if (type == 'Captain')
                      captainId = player['id'];
                    else
                      viceCaptainId = player['id'];
                  });
                  Navigator.pop(context);
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Future<void> _createFantasyTeam() async {
    setState(() => _isLoading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';

      final allSelected = [
        ...teamA.where((p) => p['selected'] == true).map((p) => p['id']),
        ...teamB.where((p) => p['selected'] == true).map((p) => p['id']),
      ];

      final playingIds = allSelected.take(11).toList();
      final benchIds = allSelected.skip(11).toList();

      final body = {
        "fantasy_match_id": selectedMatchId,
        "user_id": userId ?? "6",
        "team_name": "My Fantasy Team ${DateTime.now().millisecondsSinceEpoch}",
        "playing_11": playingIds,
        "bench_players": benchIds,
        "captain": captainId,
        "vice_captain": viceCaptainId,
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
            content: Text('Team created successfully!'),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => const GlobalFantasyTeamsPage()),
        );
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
                onPressed: _loadUserAndMatchData,
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
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  '•  $league',
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
                          'Playing: $playingCount / 11 • Bench: $benchCount / 3',
                          style: TextStyle(
                            color: canCreateTeam
                                ? const Color(0xFFFDB515)
                                : Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        'Total: $totalSelected / 14',
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 13),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Captain & Vice-Captain selection (only after 14 selected)
                  if (totalSelected == 14) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        OutlinedButton.icon(
                          onPressed: () => _showSelectionDialog('Captain'),
                          icon: const Icon(Icons.star, size: 18),
                          label: Text(
                            captainId == null
                                ? 'Choose Captain'
                                : 'Change Captain',
                          ),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFFFDB515)),
                            foregroundColor: const Color(0xFFFDB515),
                          ),
                        ),
                        OutlinedButton.icon(
                          onPressed: () => _showSelectionDialog('Vice-Captain'),
                          icon: const Icon(Icons.star_half, size: 18),
                          label: Text(
                            viceCaptainId == null
                                ? 'Choose Vice-Captain'
                                : 'Change Vice-Captain',
                          ),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFFFDB515)),
                            foregroundColor: const Color(0xFFFDB515),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],

                  if (canCreateTeam)
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton.icon(
                        onPressed: _createFantasyTeam,
                        icon: const Icon(Icons.check_circle_outline, size: 22),
                        label: const Text(
                          'Create & Join Contest',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFDB515),
                          foregroundColor: Colors.black87,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                          elevation: 8,
                        ),
                      ),
                    )
                  else if (totalSelected == 14)
                    const Text(
                      'Please choose Captain & Vice-Captain',
                      style: TextStyle(color: Colors.yellow, fontSize: 14),
                      textAlign: TextAlign.center,
                    )
                  else
                    Text(
                      'Select $totalSelected / 14 players',
                      style:
                          const TextStyle(color: Colors.white70, fontSize: 14),
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
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: const BoxDecoration(
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
