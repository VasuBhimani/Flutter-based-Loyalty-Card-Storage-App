import 'package:uuid/uuid.dart';

class CardModel {
  final String id;
  final String name;
  final String cardNumber;
  final String? barcode;
  final String? qrCode;
  final DateTime? expirationDate;
  final String? issuer;
  final String? logoUrl;
  final Map<String, dynamic>? additionalInfo;
  final DateTime createdAt;
  final DateTime updatedAt;

  CardModel({
    String? id,
    required this.name,
    required this.cardNumber,
    this.barcode,
    this.qrCode,
    this.expirationDate,
    this.issuer,
    this.logoUrl,
    this.additionalInfo,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'cardNumber': cardNumber,
      'barcode': barcode,
      'qrCode': qrCode,
      'expirationDate': expirationDate?.toIso8601String(),
      'issuer': issuer,
      'logoUrl': logoUrl,
      'additionalInfo': additionalInfo,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory CardModel.fromJson(Map<String, dynamic> json) {
    return CardModel(
      id: json['id'],
      name: json['name'],
      cardNumber: json['cardNumber'],
      barcode: json['barcode'],
      qrCode: json['qrCode'],
      expirationDate: json['expirationDate'] != null
          ? DateTime.parse(json['expirationDate'])
          : null,
      issuer: json['issuer'],
      logoUrl: json['logoUrl'],
      additionalInfo: json['additionalInfo'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  CardModel copyWith({
    String? name,
    String? cardNumber,
    String? barcode,
    String? qrCode,
    DateTime? expirationDate,
    String? issuer,
    String? logoUrl,
    Map<String, dynamic>? additionalInfo,
  }) {
    return CardModel(
      id: id,
      name: name ?? this.name,
      cardNumber: cardNumber ?? this.cardNumber,
      barcode: barcode ?? this.barcode,
      qrCode: qrCode ?? this.qrCode,
      expirationDate: expirationDate ?? this.expirationDate,
      issuer: issuer ?? this.issuer,
      logoUrl: logoUrl ?? this.logoUrl,
      additionalInfo: additionalInfo ?? this.additionalInfo,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }
}
