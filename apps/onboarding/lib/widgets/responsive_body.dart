import 'package:flutter/material.dart';

class ResponsiveBody extends StatelessWidget {
  const ResponsiveBody({super.key, this.child});

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final form = Padding(
            padding: const EdgeInsets.all(16),
            child: child,
          );

          if (constraints.maxWidth >= 1024) {
            return Center(
              child: FractionallySizedBox(
                widthFactor: 1 / 2,
                child: form,
              ),
            );
          }

          return form;
        },
      ),
    );
  }
}
