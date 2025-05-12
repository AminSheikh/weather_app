class Rain {
  final double? threeHour;

  Rain({this.threeHour});

  factory Rain.fromJson(Map<String, dynamic> json) {
    return Rain(
      threeHour: json.containsKey('3h') ? json['3h'].toDouble() : null,
    );
  }
}
