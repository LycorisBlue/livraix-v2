import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';

class DeliveryDetails extends StatelessWidget {
  final String title;
  final String id;
  final String route;
  final String distance;
  final String duration;
  final String date;
  final String weight;
  final VoidCallback onMakeOffer;
  final VoidCallback onAccept;
  final VoidCallback onDecline;
  final LatLng originCoords;
  final LatLng destinationCoords;

  const DeliveryDetails({
    Key? key,
    required this.title,
    required this.id,
    required this.route,
    required this.distance,
    required this.duration,
    required this.date,
    required this.weight,
    required this.onMakeOffer,
    required this.onAccept,
    required this.onDecline,
    required this.originCoords,
    required this.destinationCoords,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails de la livraison'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Carte
          SizedBox(
            height: 200,
            width: double.infinity,
            child: FlutterMap(
              options: MapOptions(
                initialCenter: destinationCoords,
                initialZoom: 11.0,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.livraix.app',
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: destinationCoords,
                      width: 40,
                      height: 40,
                      child: const Icon(
                        Icons.location_on,
                        color: Colors.red,
                        size: 40,
                      ),
                    ),
                    Marker(
                      point: originCoords,
                      width: 40,
                      height: 40,
                      child: const Icon(
                        Icons.location_on,
                        color: Colors.green,
                        size: 40,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Informations sur la route
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            color: const Color(0xFF074F24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  route,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Gilroy',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$distance · $duration',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    fontFamily: 'Gilroy',
                  ),
                ),
              ],
            ),
          ),

          // Contenu principal - Détails de la livraison
          Expanded(
            child: Container(
              color: Colors.white,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Titre et ID
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        fontFamily: 'Gilroy',
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Colis ID: $id',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        fontFamily: 'Gilroy',
                      ),
                    ),
                    const SizedBox(height: 16),
                
                    // Informations de livraison
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF074F24).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            date,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF074F24),
                              fontFamily: 'Gilroy',
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Pickup · $weight',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                            fontFamily: 'Gilroy',
                          ),
                        ),
                      ],
                    ),
                
                    // Séparateur
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Divider(height: 1, color: Colors.grey),
                    ),
                
                    // Section d'informations supplémentaires
                    _buildInfoSection(
                      title: 'Caractéristiques de la livraison',
                      items: [
                        InfoItem(
                          icon: Icons.inventory_2_outlined,
                          title: 'Type de chargement',
                          value: 'Fragile',
                        ),
                        InfoItem(
                          icon: Icons.scale_outlined,
                          title: 'Poids total',
                          value: weight,
                        ),
                        InfoItem(
                          icon: Icons.local_shipping_outlined,
                          title: 'Type de véhicule requis',
                          value: 'Camion benne',
                        ),
                      ],
                    ),
                
                    const SizedBox(height: 20),
                
                    // Instructions supplémentaires
                    const Text(
                      'Instructions',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF074F24),
                        fontFamily: 'Gilroy',
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: const Text(
                        'Manipuler avec précaution. La livraison contient des objets fragiles.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                          fontFamily: 'Gilroy',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Actions
          Container(
            padding: const EdgeInsets.all(20),
            height: 250,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Bouton d'offre
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: onMakeOffer,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF074F24),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Gilroy',
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Faire une offre'),
                    ),
                  ),
              
                  const SizedBox(height: 12),
              
                  // Boutons Accepter/Refuser
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: onAccept,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade100,
                            foregroundColor: Colors.green.shade800,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            textStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Gilroy',
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('Accepter'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: onDecline,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.shade100,
                            foregroundColor: Colors.red.shade800,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            textStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Gilroy',
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('Refuser'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection({required String title, required List<InfoItem> items}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF074F24),
            fontFamily: 'Gilroy',
          ),
        ),
        const SizedBox(height: 12),
        ...items
            .map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF074F24).withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          item.icon,
                          color: const Color(0xFF074F24),
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                              fontFamily: 'Gilroy',
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            item.value,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                              fontFamily: 'Gilroy',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ))
            .toList(),
      ],
    );
  }
}

class InfoItem {
  final IconData icon;
  final String title;
  final String value;

  InfoItem({
    required this.icon,
    required this.title,
    required this.value,
  });
}

// Composant pour afficher l'écran avec animation
class DeliveryDetailsScreen extends StatelessWidget {
  final String title;
  final String id;
  final String route;
  final String distance;
  final String duration;
  final String date;
  final String weight;
  final VoidCallback onMakeOffer;
  final VoidCallback onAccept;
  final VoidCallback onDecline;
  final LatLng originCoords;
  final LatLng destinationCoords;

  const DeliveryDetailsScreen({
    Key? key,
    required this.title,
    required this.id,
    required this.route,
    required this.distance,
    required this.duration,
    required this.date,
    required this.weight,
    required this.onMakeOffer,
    required this.onAccept,
    required this.onDecline,
    required this.originCoords,
    required this.destinationCoords,
  }) : super(key: key);

  static void show(
    BuildContext context, {
    required String title,
    required String id,
    required String route,
    required String distance,
    required String duration,
    required String date,
    required String weight,
    required VoidCallback onMakeOffer,
    required VoidCallback onAccept,
    required VoidCallback onDecline,
    required LatLng originCoords,
    required LatLng destinationCoords,
  }) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DeliveryDetailsScreen(
          title: title,
          id: id,
          route: route,
          distance: distance,
          duration: duration,
          date: date,
          weight: weight,
          onMakeOffer: onMakeOffer,
          onAccept: onAccept,
          onDecline: onDecline,
          originCoords: originCoords,
          destinationCoords: destinationCoords,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DeliveryDetails(
      title: title,
      id: id,
      route: route,
      distance: distance,
      duration: duration,
      date: date,
      weight: weight,
      onMakeOffer: onMakeOffer,
      onAccept: onAccept,
      onDecline: onDecline,
      originCoords: originCoords,
      destinationCoords: destinationCoords,
    );
  }
}
