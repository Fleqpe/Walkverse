class XpSystem {
  // Function to calculate the level and remaining XP
  static Map<String, int> calculateLevel(int totalXp) {
    int level = 0;
    int xpForNextLevel = 1000;

    while (totalXp >= xpForNextLevel) {
      totalXp -= xpForNextLevel;
      level++;
      xpForNextLevel += 1000;
    }

    return {
      'level': level,
      'remainingXp': totalXp,
    };
  }

  // Function to calculate weekly step goal based on level
  static int calculateWeeklyGoal(int level) {
    return 7000 + (level * 2000);
  }

  // Function to calculate monthly step goal based on level
  static int calculateMonthlyGoal(int level) {
    return 30000 + (level * 10000);
  }
}
