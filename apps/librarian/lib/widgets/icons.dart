import 'package:flutter/material.dart';

const checkedInIcon = Tooltip(
  message: 'Available',
  child: Icon(Icons.circle, color: Colors.green, size: 16),
);

const checkedOutIcon = Tooltip(
  message: 'Unavailable',
  child: Icon(Icons.circle, color: Colors.amber, size: 16),
);

const partnerLocationIcon = Tooltip(
  message: 'Partner Location',
  child: Icon(Icons.circle, color: Colors.grey, size: 16),
);

const hiddenIcon = Tooltip(
  message: 'Hidden',
  child: Icon(Icons.circle, color: Colors.red, size: 16),
);
