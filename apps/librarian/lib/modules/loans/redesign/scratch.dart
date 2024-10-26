import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/modules/loans/redesign/loans_provider.dart';
import 'package:librarian_app/modules/things/maintenance/view.dart';
import 'package:librarian_app/utils/media_query.dart';
import 'package:skeletonizer/skeletonizer.dart';

class RedesignedLoans extends StatelessWidget {
  const RedesignedLoans({super.key});

  @override
  Widget build(BuildContext context) {
    final mobile = isMobile(context);
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: Text(
            'Loans',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          bottom: TabBar(
            isScrollable: !mobile,
            tabAlignment: mobile ? TabAlignment.center : TabAlignment.start,
            tabs: const [
              Tab(text: 'All Loans'),
              Tab(text: 'Due Today'),
              Tab(text: 'Overdue'),
            ],
          ),
        ),
        body: const LoansTabBarView(),
      ),
    );
  }
}

class LoansTabBarView extends ConsumerWidget {
  const LoansTabBarView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loanGroups = ref.watch(loansProvider);
    return loanGroups.when(
      data: (data) {
        return TabBarView(
          children: [
            LoansView(data.all),
            LoansView(data.dueToday),
            LoansView(data.overdue),
          ],
        );
      },
      error: (error, stackTrace) {
        return const Text('An error occurred');
      },
      loading: () {
        return const Skeletonizer(child: LoansView([]));
      },
    );
  }
}

class LoansView extends StatelessWidget {
  const LoansView(this._loanGroups, {super.key});

  final List<LoanGroup> _loanGroups;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      controller: ScrollController(),
      crossAxisCount: isMobile(context) ? 1 : 3,
      padding: const EdgeInsets.all(16.0),
      mainAxisSpacing: 16.0,
      crossAxisSpacing: 16.0,
      shrinkWrap: true,
      children: _loanGroups.map((l) {
        return LoanCard(borrowerName: l.borrowerName);
      }).toList(),
    );
  }
}

class LoanCard extends StatelessWidget {
  const LoanCard({
    super.key,
    required this.borrowerName,
  });

  final _items = const [100, 101, 102];

  final String borrowerName;

  @override
  Widget build(BuildContext context) {
    return Card.outlined(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Text(borrowerName),
            subtitle: const Text('Due 10/31/2024'),
          ),
          const Divider(height: 1),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
              padding: const EdgeInsets.all(8.0),
              scrollDirection: Axis.horizontal,
              children: _items.map((i) {
                return ItemCard(
                  number: i,
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
