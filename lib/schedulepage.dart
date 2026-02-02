import 'dart:convert';

import 'package:beyondfantasy/api.dart'; // your ApiConstants file
import 'package:beyondfantasy/fantasyselection.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GameSchedulePage extends StatefulWidget {
  const GameSchedulePage({super.key});

  @override
  State<GameSchedulePage> createState() => _GameSchedulePageState();
}

class _GameSchedulePageState extends State<GameSchedulePage> {
  List<dynamic> _upcomingMatches = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchMatches();
  }

  Future<void> _fetchMatches() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final response = await http.get(
        Uri.parse(ApiConstants.matchesEndPoint),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> allMatches =
            data is List ? data : data['data'] ?? [];

        // Filter only upcoming matches
        final upcoming = allMatches.where((match) {
          final isUpcoming = match['match']?['is_upcoming'] as bool?;
          return isUpcoming == true;
        }).toList();

        setState(() {
          _upcomingMatches = upcoming;
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = 'Failed to load matches: ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Error fetching matches: $e';
        _isLoading = false;
      });
    }
  }

  String _formatDateTime(String? isoDate) {
    if (isoDate == null || isoDate.isEmpty) return 'Date not available';
    try {
      final dateTime = DateTime.parse(isoDate).toLocal();
      final formatter = DateFormat('dd MMM yyyy, h:mm a');
      return formatter.format(dateTime);
    } catch (e) {
      return isoDate;
    }
  }

  Future<void> _saveMatchId(String matchId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_fantasy_match_id', matchId);
    debugPrint('Saved fantasy_match_id: $matchId');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F034E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F034E),
        elevation: 0,
        title: const Text(
          'Upcoming Matches',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
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
                        onPressed: _fetchMatches,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFDB515),
                          foregroundColor: Colors.black87,
                        ),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : _upcomingMatches.isEmpty
                  ? const Center(
                      child: Text(
                        'No upcoming matches found',
                        style: TextStyle(color: Colors.white70, fontSize: 18),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _upcomingMatches.length,
                      itemBuilder: (context, index) {
                        final match = _upcomingMatches[index];

                        final teamA =
                            match['home_team'] as String? ?? 'Unknown';
                        final teamB =
                            match['away_team'] as String? ?? 'Unknown';
                        final dateTime =
                            _formatDateTime(match['match_date'] as String?);
                        final venue =
                            match['match_details']?['venue'] as String? ??
                                'Unknown Venue';
                        const league = 'ICC Women\'s World Cup';
                        final fantasyMatchId =
                            match['fantasy_match_id']?.toString() ?? '';

                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0F034E),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: Colors.white.withOpacity(0.08)),
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
                                    dateTime,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Text(
                                      teamA,
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
                                        horizontal: 16, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: Colors.redAccent,
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    child: const Text(
                                      'VS',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      teamB,
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
                              const SizedBox(height: 12),

                              // League + Ground
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.emoji_events,
                                          color: Color(0xFFFDB515), size: 18),
                                      const SizedBox(width: 6),
                                      Text(
                                        league,
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
                                        venue,
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

                              // Create Team button
                              Align(
                                alignment: Alignment.centerRight,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    // Save fantasy_match_id before going to team creation
                                    if (fantasyMatchId.isNotEmpty) {
                                      await _saveMatchId(fantasyMatchId);
                                    }

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const FantasySelect(),
                                      ),
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content:
                                              Text('Opening Team Creator...')),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFFDB515),
                                    foregroundColor: Colors.black87,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 8),
                                    minimumSize: const Size(0, 36),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    elevation: 2,
                                  ),
                                  child: const Text(
                                    'Create Team',
                                    style: TextStyle(
                                      fontSize: 12,
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

  Future<void> _saveMatchesId(String matchId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_fantasy_match_id', matchId);
    debugPrint('Saved fantasy_match_id: $matchId');
  }
}
