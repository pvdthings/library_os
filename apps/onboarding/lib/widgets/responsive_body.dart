import 'package:flutter/material.dart';

class ResponsiveBody extends StatelessWidget {
  const ResponsiveBody({super.key, this.child});

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth >= 1024) {
            return Center(
              child: FractionallySizedBox(
                widthFactor: 1 / 2,
                child: child,
              ),
            );
          }

          return child ?? const SizedBox.shrink();
        },
      ),
    );
  }
}
