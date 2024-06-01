class ParticipationTicket {
  final int eventId;
  final int volunteerId;
  final bool attended;

  ParticipationTicket(
      {required this.eventId,
      required this.volunteerId,
      required this.attended});
}
