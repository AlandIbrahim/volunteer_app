class Organization {
  final int id;
  final String name;
  final String address;
  final String businessLicense;
  final bool isGovernmental;

  Organization({
    required this.id,
    required this.name,
    required this.address,
    required this.businessLicense,
    required this.isGovernmental,
  });
}
