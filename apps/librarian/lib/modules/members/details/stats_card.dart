import 'package:flutter/material.dart';
import 'package:librarian_app/utils/format.dart';
import 'package:librarian_app/widgets/details_card/details_card.dart';

class StatsCard extends StatelessWidget {
  const StatsCard({
    super.key,
    this.keyholder = false,
    this.memberSince,
    this.volunteerHours = 0,
  });

  final bool keyholder;
  final DateTime? memberSince;
  final int volunteerHours;

  @override
  Widget build(BuildContext context) {
    return DetailsCard(
      body: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.card_membership),
            title: const Text('Member Since'),
            subtitle: memberSince != null
                ? Text(formatDateForHumans(memberSince!))
                : const Text('Unknown'),
            enabled: memberSince != null,
          ),
          ListTile(
            leading: Icon(
              Icons.timelapse,
              color: volunteerHours > 0 ? Colors.blue : null,
            ),
            title: const Text('Volunteer Hours'),
            subtitle: Text(formatHours(volunteerHours)),
            enabled: volunteerHours > 0,
          ),
          ListTile(
            leading: Icon(
              Icons.key,
              color: keyholder ? Colors.amber : null,
            ),
            title: const Text('Keyholder'),
            subtitle: keyholder
                ? const Text('24/7 access')
                : const Text('Normal hours'),
            enabled: keyholder,
          ),
        ],
      ),
    );
  }
}
