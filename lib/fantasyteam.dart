import 'dart:convert';

import 'package:beyondfantasy/api.dart'; // your ApiConstants file
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class GlobalFantasyTeamsPage extends StatefulWidget {
  const GlobalFantasyTeamsPage({super.key});

  @override
  State<GlobalFantasyTeamsPage> createState() => _GlobalFantasyTeamsPageState();
}

class _GlobalFantasyTeamsPageState extends State<GlobalFantasyTeamsPage> {
  List<Map<String, dynamic>> leaderboard = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchLeaderboard();
  }

  Future<void> _fetchLeaderboard() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final response = await http.get(
        Uri.parse(ApiConstants.fantasyleaderboardEndPoint),
        headers: {
          'Content-Type': 'application/json',
          // Add auth header if required:
          // 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> leaderboardData = data['leaderboard'] ?? [];

        List<Map<String, dynamic>> tempList = leaderboardData.map((item) {
          String fullTeamName = item['team_name'] as String? ?? 'Unnamed Team';
          String shortTeamName = fullTeamName.length > 30
              ? '${fullTeamName.substring(0, 25)}..'
              : fullTeamName;

          return {
            'id': item['id'],
            'creator': item['user']?['name'] as String? ?? 'Unknown User',
            'teamName': shortTeamName,
            'points': int.tryParse(item['total_points'].toString()) ?? 0,
            'rank': 0, // will calculate after sorting
          };
        }).toList();

        // Sort by points (highest first)
        tempList.sort((a, b) => b['points'].compareTo(a['points']));

        // Assign ranks
        for (int i = 0; i < tempList.length; i++) {
          tempList[i]['rank'] = i + 1;
        }

        setState(() {
          leaderboard = tempList;
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = 'Failed to load leaderboard: ${response.statusCode}';
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

  @override
  Widget build(BuildContext context) {
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
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: Color(0xFFFDB515)))
                : _error != null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _error!,
                              style: const TextStyle(
                                  color: Colors.redAccent, fontSize: 16),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: _fetchLeaderboard,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFDB515),
                                foregroundColor: Colors.black87,
                              ),
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      )
                    : leaderboard.isEmpty
                        ? const Center(
                            child: Text(
                              'No teams found in leaderboard',
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 18),
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: leaderboard.length,
                            itemBuilder: (context, index) {
                              final team = leaderboard[index];

                              final creator =
                                  team['creator'] as String? ?? 'Unknown User';
                              final teamName =
                                  team['teamName'] as String? ?? 'Unnamed Team';
                              final points = team['points'] as int? ?? 0;
                              final rank = team['rank'] as int? ?? (index + 1);

                              return Card(
                                color: const Color(0xFF1A1A3D),
                                elevation: 13,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                margin: const EdgeInsets.only(bottom: 12),
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Creator

                                      Row(
                                        children: [
                                          const Icon(Icons.person,
                                              color: Color(0xFFFDB515),
                                              size: 18),
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

                                      // Team name (max 20 chars shown)
                                      Text(
                                        teamName,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 12),

                                      // Rank & Points
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              const Icon(Icons.emoji_events,
                                                  color: Color(0xFFFDB515),
                                                  size: 18),
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
