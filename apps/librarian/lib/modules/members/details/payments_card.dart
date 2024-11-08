import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:librarian_app/modules/members/providers/borrowers_repository_provider.dart';
import 'package:librarian_app/modules/members/providers/selected_borrower_provider.dart';
import 'package:librarian_app/widgets/details_card/card_body.dart';
import 'package:librarian_app/widgets/details_card/card_header.dart';
import 'package:librarian_app/widgets/details_card/details_card.dart';
import 'package:librarian_app/widgets/hint_text.dart';

class PaymentsCard extends ConsumerWidget {
  const PaymentsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repository = ref.read(borrowersRepositoryProvider.notifier);

    return FutureBuilder(
      future: repository.getPayments(ref.watch(selectedBorrowerProvider)!.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _LoadingCardPlaceholder();
        }

        final payments = snapshot.data ?? [];

        return DetailsCard(
          header: const CardHeader(title: 'Payments'),
          body: payments.isNotEmpty
              ? ListView.separated(
                  itemBuilder: (context, i) {
                    return _PaymentListTile(
                      cash: payments[i].cash,
                      date: payments[i].date,
                    );
                  },
                  itemCount: payments.length,
                  separatorBuilder: (context, index) =>
                      const Divider(height: 1),
                  shrinkWrap: true,
                )
              : const CardBody(child: HintText('No recorded payments.')),
        );
      },
    );
  }
}

class _PaymentListTile extends StatelessWidget {
  const _PaymentListTile({required this.cash, required this.date});

  final double? cash;
  final DateTime date;

  static final DateFormat _dateFormat = DateFormat.yMMMMd('en_US');

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(_dateFormat.format(date)),
      subtitle: cash != null ? Text('\$ $cash') : const Text('Unknown amount'),
    );
  }
}

class _LoadingCardPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const DetailsCard(
      body: CardBody(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
