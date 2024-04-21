import 'package:flutter/material.dart';

class DesktopDashboard extends StatelessWidget {
  const DesktopDashboard({
    super.key,
    required this.child,
    this.leading,
    this.selectedIndex = 0,
    this.onDestinationSelected,
  });

  final Widget child;
  final Widget? leading;
  final int selectedIndex;
  final void Function(int)? onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        NavigationRail(
          labelType: NavigationRailLabelType.selected,
          leading: leading,
          destinations: const [
            NavigationRailDestination(
              selectedIcon: Icon(Icons.handshake),
              icon: Icon(Icons.handshake_outlined),
              label: Text('Loans'),
              padding: EdgeInsets.symmetric(vertical: 8),
            ),
            NavigationRailDestination(
              selectedIcon: Icon(Icons.people),
              icon: Icon(Icons.people_outlined),
              label: Text('Borrowers'),
              padding: EdgeInsets.symmetric(vertical: 8),
            ),
            NavigationRailDestination(
              selectedIcon: Icon(Icons.build),
              icon: Icon(Icons.build_outlined),
              label: Text('Things'),
              padding: EdgeInsets.symmetric(vertical: 8),
            ),
            NavigationRailDestination(
              selectedIcon: Icon(Icons.electric_bolt),
              icon: Icon(Icons.electric_bolt_outlined),
              label: Text('Actions'),
              padding: EdgeInsets.symmetric(vertical: 8),
            ),
          ],
          selectedIndex: selectedIndex,
          onDestinationSelected: (index) {
            onDestinationSelected?.call(index);
          },
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(right: 8, bottom: 8),
            child: child,
          ),
        ),
      ],
    );
  }
}
