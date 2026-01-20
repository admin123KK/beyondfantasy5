import 'package:flutter/material.dart';

class RankingPage extends StatefulWidget {
  const RankingPage({super.key});

  @override
  State<RankingPage> createState() => _RankingPageState();
}

class _RankingPageState extends State<RankingPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 0);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF003262),
      appBar: AppBar(
        backgroundColor: const Color(0xFF003262),
        elevation: 0,
        title: const Text(
          'Rankings',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: const Icon(Icons.arrow_back, color: Colors.white),
      ),
      body: Column(
        children: [
          Container(
            color: const Color(0xFFFDB515),
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.black87,
              unselectedLabelColor: Colors.black54,
              indicatorColor: Colors.black87,
              indicatorWeight: 4,
              tabs: const [
                Tab(text: 'Daily'),
                Tab(text: 'Weekly'),
                Tab(text: 'Global'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildLeaderboardList(),
                _buildLeaderboardList(),
                _buildLeaderboardList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeaderboardList() {
    final List<Map<String, dynamic>> rankings = [
      {'name': 'Hari Shyam', 'points': 8125},
      {'name': 'Virat Parash', 'points': 6740},
      {'name': 'Ramesh Thapa', 'points': 5980},
      {'name': 'Suresh Lama', 'points': 5215},
      {'name': 'Bikram Gurung', 'points': 4890},
      {'name': 'Dipak Joshi', 'points': 4520},
      {'name': 'Anil Karki', 'points': 3980},
      {'name': 'Nischal Rai', 'points': 3675},
      {'name': 'Karan Basnet', 'points': 3410},
      {'name': 'Prabin Shrestha', 'points': 3125},
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Header row
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: const Color(0xFF003262),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Row(
            children: [
              Expanded(
                flex: 5,
                child: Text(
                  'Name',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  'Rank',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  'Points',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // Ranking rows
        ...List.generate(rankings.length, (index) {
          final rank = rankings[index];
          final rankNumber = index + 1;
          final backgroundColor =
              (index % 2 == 0) ? const Color(0xFFFFF9E6) : Colors.white;

          // Calculate leading by points (example: difference from next rank)
          final int leadBy = index < rankings.length - 1
              ? (rank['points'] as int) - (rankings[index + 1]['points'] as int)
              : 0;

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Name
                    Expanded(
                      flex: 5,
                      child: Row(
                        children: [
                          if (rankNumber <= 3)
                            const Padding(
                              padding: EdgeInsets.only(right: 6),
                              child: Text(
                                '⭐',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          Text(
                            rank['name'] as String,
                            style: TextStyle(
                              fontSize: rankNumber <= 3 ? 17 : 16,
                              fontWeight: rankNumber <= 3
                                  ? FontWeight.bold
                                  : FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Rank (middle)
                    Expanded(
                      flex: 2,
                      child: Center(
                        child: Text(
                          '$rankNumber',
                          style: TextStyle(
                            fontSize: rankNumber <= 3 ? 20 : 18,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFFFDB515),
                          ),
                        ),
                      ),
                    ),

                    // Points
                    Expanded(
                      flex: 3,
                      child: Text(
                        '${rank['points']}',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: rankNumber <= 3 ? 20 : 18,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFFDB515),
                        ),
                      ),
                    ),
                  ],
                ),

                // Show leading by for top 3
                if (rankNumber <= 3 && leadBy > 0) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Leading by $leadBy points',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ],
            ),
          );
        }),
      ],
    );
  }
}
