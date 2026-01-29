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
      backgroundColor: const Color(0xFF0F034E), // your main app dark blue
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F034E),
        elevation: 0,
        title: const Row(
          children: [
            Text(
              'Rankings',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
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
          // Tab Bar with yellow indicator
          Container(
            color: const Color(0xFFFDB515), // dark card-like background
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.black,
              indicatorColor: Colors.black,
              indicatorWeight: 4,
              labelStyle: const TextStyle(fontWeight: FontWeight.bold),
              tabs: const [
                Tab(text: 'Daily'),
                Tab(text: 'Weekly'),
                Tab(text: 'Global'),
              ],
            ),
          ),

          // Tab content
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
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          decoration: BoxDecoration(
            color: const Color(0xFF0F034E),
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
          final isTop3 = rankNumber <= 3;

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            decoration: BoxDecoration(
              color: isTop3
                  ? const Color(0xFFFDB515).withOpacity(0.25)
                  : const Color(0xFF0F034E),
              borderRadius: BorderRadius.circular(12),
              border: isTop3
                  ? Border.all(color: const Color(0xFFFDB515), width: 1)
                  : null,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Name + rank icon
                    Expanded(
                      flex: 5,
                      child: Row(
                        children: [
                          if (isTop3)
                            const Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: Icon(
                                Icons.star,
                                color: const Color(0xFFFDB515),
                                size: 20,
                              ),
                            ),
                          Text(
                            rank['name'] as String,
                            style: TextStyle(
                              fontSize: isTop3 ? 17 : 16,
                              fontWeight:
                                  isTop3 ? FontWeight.bold : FontWeight.w600,
                              color: isTop3
                                  ? const Color(0xFFFDB515)
                                  : Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Rank number (yellow for top 3)
                    Expanded(
                      flex: 2,
                      child: Center(
                        child: Text(
                          '$rankNumber',
                          style: TextStyle(
                            fontSize: isTop3 ? 22 : 18,
                            fontWeight: FontWeight.bold,
                            color: isTop3
                                ? const Color(0xFFFDB515)
                                : Colors.white70,
                          ),
                        ),
                      ),
                    ),

                    // Points (yellow for top 3)
                    Expanded(
                      flex: 3,
                      child: Text(
                        '${rank['points']}',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: isTop3 ? 20 : 18,
                          fontWeight: FontWeight.bold,
                          color:
                              isTop3 ? const Color(0xFFFDB515) : Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),

                // Leading by points (only for top 3)
                if (isTop3 && index < rankings.length - 1) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Leading by ${(rank['points'] as int) - (rankings[index + 1]['points'] as int)} points',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.white70,
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
