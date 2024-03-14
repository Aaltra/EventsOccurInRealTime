
class Seat {
  final String id;
  final int number;
  final DateTime timeSlot;
  final bool taken;

  const Seat({
    required this.id,
    required this.number,
    required this.timeSlot,
    required this.taken,
  });

factory Seat.fromJson(Map<String, dynamic> json) {
  return Seat(
    id: json['id'],
    number: json['number'],
    timeSlot: DateTime.parse(json['timeSlot']),
    taken: json['taken'] == true
  );
}

}

