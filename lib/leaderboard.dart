import 'package:flutter/material.dart';
import 'backend/backendtest.dart';

class LeaderboardPage extends StatefulWidget {
  @override
  _LeaderboardPageState createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  final UserStepsService _userStepsService = UserStepsService();
  List<Map<String, dynamic>> _leaderboard = [];
  String filterType = "Dünya"; // Dünya, Arkadaşlar
  String timeFilter = "Yıl"; // Yıl, Ay, Hafta
  String? userId;

  @override
  void initState() {
    super.initState();
    userId = UserSession.userId;
    _fetchLeaderboard();
  }

  Future<void> _fetchLeaderboard() async {
    if (userId == null) return;

    List<Map<String, dynamic>> leaderboard;
    if (filterType == "Dünya") {
      leaderboard = await _userStepsService.getLeaderboardByPeriod(_getPeriod(timeFilter));
    } else if (filterType == "Arkadaşlar") {
      leaderboard = await _userStepsService.getFollowedLeaderboardByPeriod(userId!, _getPeriod(timeFilter));
    } else {
      leaderboard = [];
    }
    setState(() {
      _leaderboard = leaderboard;
    });
  }

  String _getPeriod(String timeFilter) {
    switch (timeFilter) {
      case "Hafta":
        return "weekly";
      case "Ay":
        return "monthly";
      case "Yıl":
        return "yearly";
      default:
        return "yearly";
    }
  }

  void _onFilterTypeChanged(String? type) {
    if (type != null) {
      setState(() {
        filterType = type;
      });
      _fetchLeaderboard();
    }
  }

  void _onTimeFilterChanged(String? period) {
    if (period != null) {
      setState(() {
        timeFilter = period;
      });
      _fetchLeaderboard();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Leaderboard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DropdownButton<String>(
                  value: filterType,
                  items: [
                    DropdownMenuItem(value: 'Dünya', child: Text('Dünya')),
                    DropdownMenuItem(value: 'Arkadaşlar', child: Text('Arkadaşlar')),
                  ],
                  onChanged: _onFilterTypeChanged,
                ),
                DropdownButton<String>(
                  value: timeFilter,
                  items: [
                    DropdownMenuItem(value: 'Yıl', child: Text('Yıl')),
                    DropdownMenuItem(value: 'Ay', child: Text('Ay')),
                    DropdownMenuItem(value: 'Hafta', child: Text('Hafta')),
                  ],
                  onChanged: _onTimeFilterChanged,
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "SIRA",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "KULLANICI ID",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "ADIM",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: _leaderboard.length,
                itemBuilder: (context, index) {
                  final user = _leaderboard[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${index + 1}',
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          user['userId'],
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          '${user['totalSteps']}',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}