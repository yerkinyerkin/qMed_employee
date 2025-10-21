class SectorModel {
  final int sectorId;
  final int number;
  final String address;

  SectorModel({
    required this.sectorId,
    required this.number,
    required this.address,
  });

  factory SectorModel.fromJson(Map<String, dynamic> json) {
    return SectorModel(
      sectorId: json["sector_id"],
      number: json["number"],
      address: json["address"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "sector_id": sectorId,
      "number": number,
      "address": address,
    };
  }
}
