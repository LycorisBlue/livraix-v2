import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:livraix/widgets/notifications/widget.notifications.dart';
import 'package:livraix/widgets/widgets.dart';

part 'screen.home.dart';

class DriverProfileHeader extends StatelessWidget {
  final String driverName;
  final String driverCode;
  final String location;
  final bool isAvailable;
  final String? profileImageUrl;

  const DriverProfileHeader({
    super.key,
    required this.driverName,
    required this.driverCode,
    required this.location,
    required this.isAvailable,
    this.profileImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      color: const Color(0xFF074F24),
      child: Column(
        children: [
          const SizedBox(height: 35),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Votre position',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontFamily: 'Gilroy',
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    location,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Gilroy',
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(
                  CupertinoIcons.bell_fill,
                  color: Colors.white,
                  size: 24,
                ),
                onPressed: () {
                  context.pushNamed(NotificationScreen.name);
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.white.withOpacity(0.9),
                backgroundImage: profileImageUrl != null ? NetworkImage(profileImageUrl!) : null,
                child: profileImageUrl == null
                    ? const Icon(
                        CupertinoIcons.person_fill,
                        color: Color(0xFF074F24),
                        size: 30,
                      )
                    : null,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      driverName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Gilroy',
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      driverCode,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 14,
                        fontFamily: 'Gilroy',
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isAvailable ? Colors.white.withOpacity(0.2) : Colors.grey.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  isAvailable ? 'DISPONIBLE' : 'INDISPONIBLE',
                  style: TextStyle(
                    color: isAvailable ? Colors.white : Colors.grey[400],
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Gilroy',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DeliveryRouteItem extends StatelessWidget {
  final String label;
  final String location;
  final String? distance;
  final String? duration;
  final bool isOrigin;
  final bool isDestination;

  const DeliveryRouteItem({
    super.key,
    required this.label,
    required this.location,
    this.distance,
    this.duration,
    this.isOrigin = false,
    this.isDestination = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isOrigin
                    ? Colors.green
                    : isDestination
                        ? const Color(0xFF074F24)
                        : Colors.grey,
                border: Border.all(
                  color: isOrigin
                      ? Colors.green
                      : isDestination
                          ? const Color(0xFF074F24)
                          : Colors.grey,
                  width: 1,
                ),
              ),
            ),
            if (!isDestination)
              Container(
                width: 2,
                height: 40,
                color: Colors.grey.withOpacity(0.5),
              ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontFamily: 'Gilroy',
                ),
              ),
              const SizedBox(height: 4),
              Text(
                location,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  fontFamily: 'Gilroy',
                ),
              ),
              if (distance != null && duration != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    '$distance · $duration',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                      fontFamily: 'Gilroy',
                    ),
                  ),
                ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ],
    );
  }
}

class DeliveryCard extends StatelessWidget {
  final String title;
  final String id;
  final String pickupDate;
  final String pickupWeight;
  final String origin;
  final String destination;
  final String? distance;
  final String? duration;
  final VoidCallback? onTap;

  const DeliveryCard({
    super.key,
    required this.title,
    required this.id,
    required this.pickupDate,
    required this.pickupWeight,
    required this.origin,
    required this.destination,
    this.distance,
    this.duration,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    fontFamily: 'Gilroy',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Colis ID: $id',
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontFamily: 'Gilroy',
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF074F24).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    pickupDate,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF074F24),
                      fontFamily: 'Gilroy',
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Pickup: $pickupWeight',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                    fontFamily: 'Gilroy',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            DeliveryRouteItem(
              label: 'De',
              location: origin,
              distance: distance,
              duration: duration,
              isOrigin: true,
            ),
            DeliveryRouteItem(
              label: 'Livré à',
              location: destination,
              isDestination: true,
            ),
          ],
        ),
      ),
    );
  }
}
