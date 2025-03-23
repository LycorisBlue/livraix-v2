class QuotationItem {
  final String description;
  final double weight;
  final int quantity;
  final double unitPrice;
  final double totalPrice;

  QuotationItem({
    required this.description,
    required this.weight,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
  });
}
class Quotation {
  final String id;
  final String companyName;
  final String companyLogo;
  final String companyAddress;
  final String companyEmail;
  final String companyPhone;
  final String clientName;
  final String clientAddress;
  final String clientEmail;
  final String pickupLocation;
  final String destination;
  final List<QuotationItem> items;
  final double totalAmount;
  final DateTime validUntil;

  Quotation({
    required this.id,
    required this.companyName,
    required this.companyLogo,
    required this.companyAddress,
    required this.companyEmail,
    required this.companyPhone,
    required this.clientName,
    required this.clientAddress,
    required this.clientEmail,
    required this.pickupLocation,
    required this.destination,
    required this.items,
    required this.totalAmount,
    required this.validUntil,
  });
}