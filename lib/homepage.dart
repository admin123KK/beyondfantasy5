import 'dart:convert';

import 'package:beyondfantasy/api.dart';
import 'package:beyondfantasy/fantasyteam.dart';
import 'package:beyondfantasy/loginpage.dart';
import 'package:beyondfantasy/pointtable.dart';
import 'package:beyondfantasy/proiflepage.dart';
import 'package:beyondfantasy/rankingpage.dart';
import 'package:beyondfantasy/schedulepage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  // Upcoming matches
  List<Map<String, dynamic>> upcomingMatches = [];
  bool _matchesLoading = true;
  String? _matchesError;

  @override
  void initState() {
    super.initState();
    _fetchUpcomingMatches();
  }

  Future<void> _fetchUpcomingMatches() async {
    setState(() {
      _matchesLoading = true;
      _matchesError = null;
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

        // Filter upcoming matches
        final upcoming = allMatches.where((match) {
          return match['match']?['is_upcoming'] == true;
        }).toList();

        // Clean team names and calculate time/date
        final formattedMatches = upcoming.map((match) {
          String home =
              (match['home_team'] as String?)?.replaceAll(' Women', '') ??
                  'Unknown';
          String away =
              (match['away_team'] as String?)?.replaceAll(' Women', '') ??
                  'Unknown';

          // Add "W" suffix for women's matches
          if (match['league']?.toString().toLowerCase().contains('women') ==
                  true ||
              match['home_team']?.toString().toLowerCase().contains('women') ==
                  true) {
            home += ' W';
            away += ' W';
          }

          final dateStr = match['match_date'] as String?;
          String displayTime = 'Upcoming';
          String displayDate = 'Upcoming';

          if (dateStr != null) {
            try {
              final matchTime = DateTime.parse(dateStr).toLocal();
              final now = DateTime.now();
              final diff = matchTime.difference(now);

              if (diff.isNegative) {
                displayTime = 'Started';
                displayDate = 'Live/Completed';
              } else {
                if (diff.inHours > 0) {
                  displayTime = '${diff.inHours}h ${diff.inMinutes % 60}m';
                } else if (diff.inMinutes > 0) {
                  displayTime = '${diff.inMinutes}m';
                } else {
                  displayTime = 'Soon';
                }
                displayDate = DateFormat('dd MMM yyyy').format(matchTime);
              }
            } catch (e) {
              displayTime = 'Upcoming';
              displayDate = 'Upcoming';
            }
          }

          return {
            'league': 'ICC Women\'s World Cup',
            'team1': home,
            'team1Flag': _getFlagUrl(home.replaceAll(' W', '')),
            'team2': away,
            'team2Flag': _getFlagUrl(away.replaceAll(' W', '')),
            'time': displayTime,
            'date': displayDate,
          };
        }).toList();

        setState(() {
          upcomingMatches = formattedMatches;
          _matchesLoading = false;
        });
      } else {
        setState(() {
          _matchesError = 'Failed to load matches';
          _matchesLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _matchesError = 'Error: $e';
        _matchesLoading = false;
      });
    }
  }

  // Flag URL (sharp quality)
  String _getFlagUrl(String teamName) {
    final lower = teamName.toLowerCase().trim();
    String code = 'xx';

    if (lower.contains('england'))
      code = 'gb-eng';
    else if (lower.contains('sri lanka'))
      code = 'lk';
    else if (lower.contains('australia'))
      code = 'au';
    else if (lower.contains('south africa'))
      code = 'za';
    else if (lower.contains('west indies'))
      code = 'wi';
    else if (lower.contains('new zealand'))
      code = 'nz';
    else if (lower.contains('india'))
      code = 'in';
    else if (lower.contains('pakistan'))
      code = 'pk';
    else if (lower.contains('bangladesh')) code = 'bd';

    return 'https://flagcdn.com/h40/$code.png'; // h40 = sharper
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F034E),
      drawer: const UserDrawer(),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F034E),
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white, size: 28),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: const Text(
          'Beyond Fantasy',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Icon(Icons.search, color: Colors.white, size: 26),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child:
                Icon(Icons.notifications_none, color: Colors.white, size: 26),
          ),
          SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFFEAECED),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 24, 16, 100),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Live Match title
                        const Text(
                          'Live Match',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Live match card (kept exactly as is)
                        Container(
                          padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            children: [
                              Stack(
                                clipBehavior: Clip.none,
                                alignment: Alignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 32,
                                            backgroundImage: AssetImage(
                                                'assets/images/nepal.png'),
                                            backgroundColor: Colors.white,
                                          ),
                                          SizedBox(width: 12),
                                          Text(
                                            'NEPAL',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Text(
                                        'VS',
                                        style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFFFDB515),
                                        ),
                                      ),
                                      Stack(
                                        alignment: Alignment.topCenter,
                                        clipBehavior: Clip.none,
                                        children: [
                                          const Column(
                                            children: [
                                              SizedBox(height: 10),
                                              Row(
                                                children: [
                                                  Text(
                                                    'ENGLAND',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  SizedBox(width: 12),
                                                  CircleAvatar(
                                                    radius: 32,
                                                    backgroundImage: AssetImage(
                                                        'assets/images/england.png'),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Positioned(
                                            top: -20,
                                            right: 0,
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 4),
                                              decoration: BoxDecoration(
                                                color: Colors.red,
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.red
                                                        .withOpacity(0.4),
                                                    blurRadius: 6,
                                                    offset: const Offset(0, 2),
                                                  ),
                                                ],
                                              ),
                                              child: const Text(
                                                'LIVE',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                              const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        '180/4',
                                        style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        '(20)',
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        '90/3',
                                        style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        '(12.3)',
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                              Center(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24, vertical: 8),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF0F034E),
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20),
                                    ),
                                  ),
                                  child: const Text(
                                    'ICC Men\'s T20 World Cup',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Upcoming Matches Section
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Upcoming Matches',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const GameSchedulePage()),
                                );
                              },
                              child: const Text(
                                'See all',
                                style: TextStyle(color: Color(0xFFFDB515)),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        SizedBox(
                          height: 140,
                          child: _matchesLoading
                              ? const Center(
                                  child: CircularProgressIndicator(
                                      color: Color(0xFFFDB515)))
                              : _matchesError != null
                                  ? Center(
                                      child: Text(_matchesError!,
                                          style: const TextStyle(
                                              color: Colors.redAccent)))
                                  : upcomingMatches.isEmpty
                                      ? const Center(
                                          child: Text(
                                            'No upcoming matches',
                                            style: TextStyle(
                                                color: Colors.black54,
                                                fontSize: 16),
                                          ),
                                        )
                                      : ListView(
                                          scrollDirection: Axis.horizontal,
                                          children: upcomingMatches
                                              .asMap()
                                              .entries
                                              .map((entry) {
                                            final index = entry.key;
                                            final match = entry.value;
                                            final displayText = index == 0
                                                ? match['time']
                                                : match['date'];

                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 16),
                                              child: _buildUpcomingMatchCard(
                                                league: match['league'],
                                                team1Flag: match['team1Flag'],
                                                team1: match['team1'],
                                                team2Flag: match['team2Flag'],
                                                team2: match['team2'],
                                                time: displayText,
                                              ),
                                            );
                                          }).toList(),
                                        ),
                        ),

                        const SizedBox(height: 10),

                        // Trending News - kept exactly as it was
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Trending News',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: const Text(
                                'See all',
                                style: TextStyle(color: Color(0xFFFDB515)),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 9),
                        Container(
                          height: 320,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image(
                                image: NetworkImage(
                                    'https://media.cricnepal.com/assets/Nepal-men-team-acknowledge-fans.webp'),
                                fit: BoxFit.fill,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  'Nepal eyes big win Over England on their first T20 World Cup',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  '10min ago',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 9),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF0F034E),
        selectedItemColor: const Color(0xFFFDB515),
        unselectedItemColor: Colors.white,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
          if (index == 1) {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => const GameSchedulePage()));
          } else if (index == 2) {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => const RankingPage()));
          } else if (index == 3) {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => ProfilePage()));
          }
        },
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home, size: 28), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.sports_cricket, size: 28), label: 'Matches'),
          BottomNavigationBarItem(
              icon: Icon(Icons.stacked_bar_chart_outlined, size: 28),
              label: 'Calendar'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person, size: 28), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildUpcomingMatchCard({
    required String league,
    required String team1Flag,
    required String team1,
    required String team2Flag,
    required String team2,
    required String time,
  }) {
    return Container(
      width: 220,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            league,
            style: const TextStyle(fontSize: 13, color: Color(0xFF003262)),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: Colors.white,
                backgroundImage: NetworkImage(team1Flag.isNotEmpty
                    ? team1Flag
                    : 'https://flagcdn.com/h40/xx.png'),
              ),
              const Text(
                'vs',
                style: TextStyle(fontSize: 14, color: Color(0xFFFDB515)),
              ),
              CircleAvatar(
                radius: 24,
                backgroundColor: Colors.white,
                backgroundImage: NetworkImage(team2Flag.isNotEmpty
                    ? team2Flag
                    : 'https://flagcdn.com/h40/xx.png'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '$team1          $team2',
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  time,
                  style: const TextStyle(fontSize: 10, color: Colors.green),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Keep UserDrawer unchanged (as per your request)
class UserDrawer extends StatefulWidget {
  const UserDrawer({super.key});

  @override
  State<UserDrawer> createState() => _UserDrawerState();
}

class _UserDrawerState extends State<UserDrawer> {
  String _name = 'Loading...';
  String _email = 'Loading...';
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
    _confirmLogout();
  }

  Future<void> _confirmLogout() async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title:
            const Text('Logout', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('No', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Yes', style: TextStyle(color: Colors.red)),
          ),
        ],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );

    if (confirmed == true && mounted) {
      _performLogout();
    }
  }

  Future<void> _performLogout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token != null && token.isNotEmpty) {
        await http.post(
          Uri.parse(ApiConstants.logoutEndPoint),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );
      }

      await prefs.remove('auth_token');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Logged out successfully'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Logout failed: ${e.toString()}'),
            backgroundColor: Colors.red),
      );
    }
  }

  Future<void> _fetchUserProfile() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null || token.isEmpty) {
        throw Exception('No token found');
      }

      final response = await http.get(
        Uri.parse(ApiConstants.profileEndPoint),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final user = data['user'] ?? data;

        setState(() {
          _name = user['name'] ?? 'User';
          _email = user['email'] ?? 'No email';
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load profile: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Color(0xFF0F034E),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/beyondfantasy.png'),
                  fit: BoxFit.cover),
              gradient: LinearGradient(
                colors: [Color(0xFF0F034E), Color(0xFF0F034E)],
              ),
            ),
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: Colors.black87))
                : _error != null
                    ? Center(
                        child: Text(
                          'Error: $_error',
                          style: const TextStyle(color: Colors.redAccent),
                          textAlign: TextAlign.center,
                        ),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 90),
                          Text(
                            'ID_$_name',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            _email,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 10),
                          ),
                        ],
                      ),
          ),
          ListTile(
            leading: const Icon(Icons.home, color: Colors.white),
            title: const Text('Home', style: TextStyle(color: Colors.white)),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.sports_cricket, color: Colors.white),
            title: const Text('Matches', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => GameSchedulePage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.list_alt, color: Colors.white),
            title: const Text('Point Table',
                style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => PointTablePage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.stacked_bar_chart_outlined,
                color: Colors.white),
            title: const Text('Fantasy Rankings',
                style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => RankingPage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.group_work_sharp, color: Colors.white),
            title: const Text('Fantasy Teams',
                style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const GlobalFantasyTeamsPage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.person, color: Colors.white),
            title: const Text('Profile', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => ProfilePage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.redAccent),
            title: const Text('Logout', style: TextStyle(color: Colors.red)),
            onTap: () {
              _confirmLogout();
            },
          ),
        ],
      ),
    );
  }
}
