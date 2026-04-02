class CounterGroup {
  final String id;
  String name;
  int count;

  CounterGroup({
    required this.id,
    required this.name,
    this.count = 0,
  });

  static const int maxCount = 9999;

  bool get isAtMax => count >= maxCount;

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'count': count,
      };

  factory CounterGroup.fromMap(Map<dynamic, dynamic> map) => CounterGroup(
        id: map['id'] as String,
        name: map['name'] as String,
        count: map['count'] as int? ?? 0,
      );
}

/// Default groups
List<CounterGroup> defaultGroups() => [
      CounterGroup(id: 'g1', name: 'SubhanAllah', count: 0),
      CounterGroup(id: 'g2', name: 'Alhamdulillah', count: 0),
      CounterGroup(id: 'g3', name: 'Allahu Akbar', count: 0),
    ];
