import 'package:flutter/material.dart';

class PointTablePage extends StatefulWidget {
  const PointTablePage({super.key});

  @override
  State<PointTablePage> createState() => _PointTablePageState();
}

class _PointTablePageState extends State<PointTablePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Selected tournament (default focus on ICC Men's T20 2026)
  String selectedTournament = "ICC Men's T20 World Cup 2026";

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFF0F034E), // exact dark blue from your image
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F034E),
        elevation: 0,
        title: Row(
          children: [
            const Text(
              'Point Table',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 22,
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
          // Tab Bar for Groups A, B, C, D
          Container(
            color: const Color(0xFF1A1A3D),
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              indicatorColor: const Color(0xFFFDB515),
              indicatorWeight: 4,
              labelColor: const Color(0xFFFDB515),
              unselectedLabelColor: Colors.white70,
              labelStyle:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              tabs: const [
                Tab(text: 'Group A'),
                Tab(text: 'Group B'),
                Tab(text: 'Group C'),
                Tab(text: 'Group D'),
              ],
            ),
          ),

          // Tab content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildGroupTable(groupAData, 'GROUP A'),
                _buildGroupTable(groupBData, 'GROUP B'),
                _buildGroupTable(groupCData, 'GROUP C'),
                _buildGroupTable(groupDData, 'GROUP D'),
              ],
            ),
          ),
        ],
      ),

      // Small floating "Tournament Select" button
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            backgroundColor: const Color(0xFF1A1A3D),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            builder: (context) => Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Select Tournament',
                    style: TextStyle(
                      color: Color(0xFFFDB515),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    leading: const Icon(Icons.sports_cricket,
                        color: Color(0xFFFDB515)),
                    title: const Text('ICC Men\'s T20 World Cup 2026',
                        style: TextStyle(color: Colors.white)),
                    onTap: () {
                      setState(() =>
                          selectedTournament = 'ICC Men\'s T20 World Cup 2026');
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.sports_cricket,
                        color: Color(0xFFFDB515)),
                    title: const Text('U19 Mens World Cup',
                        style: TextStyle(color: Colors.white)),
                    onTap: () {
                      setState(() => selectedTournament = 'U19 Mens World Cup');
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.sports_cricket,
                        color: Color(0xFFFDB515)),
                    title: const Text('U19 Womens World Cup',
                        style: TextStyle(color: Colors.white)),
                    onTap: () {
                      setState(
                          () => selectedTournament = 'U19 Womens World Cup');
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          );
        },
        label: Text(
          selectedTournament.length > 20
              ? '${selectedTournament.substring(0, 17)}...'
              : selectedTournament,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
        icon: const Icon(Icons.filter_list),
        backgroundColor: const Color(0xFFFDB515),
        foregroundColor: Colors.black,
        elevation: 8,
      ),
    );
  }

  Widget _buildGroupTable(
      List<Map<String, dynamic>> groupData, String groupName) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Group title
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              groupName,
              style: const TextStyle(
                color: Color(0xFFFDB515),
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ),

          // Table container
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A3D),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                  color: const Color(0xFFFDB515).withOpacity(0.4), width: 1.5),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Table(
                columnWidths: const {
                  0: FlexColumnWidth(0.9), // POS
                  1: FlexColumnWidth(1.4), // TEAM
                  2: FlexColumnWidth(1.0), // PLD
                  3: FlexColumnWidth(1.8), // NRR
                  4: FlexColumnWidth(1.0), // PTS
                },
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: [
                  // Header row (purple like your image)
                  TableRow(
                    decoration: BoxDecoration(
                      color: const Color(0xFFFDB515),
                    ),
                    children: [
                      _buildHeaderCell('Pos.'),
                      _buildHeaderCell('TEAM'),
                      _buildHeaderCell('PLD'),
                      _buildHeaderCell('NRR'),
                      _buildHeaderCell('PTS'),
                    ],
                  ),

                  // Data rows
                  ...groupData.map((team) {
                    bool isQualified = team['pos'].toString().startsWith('Q');
                    return TableRow(
                      children: [
                        _buildCell(
                            team['pos'],
                            isQualified
                                ? const Color(0xFFFDB515)
                                : Colors.white,
                            bold: isQualified),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 8),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 14,
                                backgroundImage: NetworkImage(team['flag']),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                team['team'],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        _buildCell('${team['pld']}', Colors.white),
                        _buildCell(
                            team['nrr'],
                            team['nrr'].startsWith('+')
                                ? Colors.greenAccent
                                : Colors.redAccent),
                        _buildCell('${team['pts']}', Colors.white, bold: true),
                      ],
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildCell(String text, Color color, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 15,
          fontWeight: bold ? FontWeight.bold : FontWeight.normal,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

final List<Map<String, dynamic>> groupAData = [
  {
    'pos': 'Q1',
    'team': 'IND',
    'flag': 'https://flagcdn.com/w40/in.png',
    'pld': 3,
    'nrr': '+3.240',
    'pts': 6
  },
  {
    'pos': 'Q2',
    'team': 'BAN',
    'flag': 'https://flagcdn.com/w40/bd.png',
    'pld': 3,
    'nrr': '+0.374',
    'pts': 4
  },
  {
    'pos': 'Q3',
    'team': 'IRE',
    'flag': 'https://flagcdn.com/w40/ie.png',
    'pld': 3,
    'nrr': '-0.778',
    'pts': 2
  },
  {
    'pos': '4',
    'team': 'USA',
    'flag': 'https://flagcdn.com/w40/us.png',
    'pld': 3,
    'nrr': '-3.244',
    'pts': 0
  },
];

// Placeholder for other groups (replace with real data)
final List<Map<String, dynamic>> groupBData = groupAData;
final List<Map<String, dynamic>> groupCData = groupAData;
final List<Map<String, dynamic>> groupDData = groupAData;
