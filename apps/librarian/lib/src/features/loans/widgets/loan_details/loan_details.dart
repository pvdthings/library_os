import 'package:flutter/material.dart';
import 'package:librarian_app/src/features/borrowers/models/borrower_model.dart';
import 'package:librarian_app/src/widgets/detail.dart';
import 'package:librarian_app/src/features/loans/models/thing_summary_model.dart';
import 'package:librarian_app/src/utils/media_query.dart';
import 'package:librarian_app/src/widgets/no_image.dart';

class LoanDetails extends StatelessWidget {
  const LoanDetails({
    super.key,
    required this.borrower,
    required this.things,
    required this.checkedOutDate,
    required this.dueDate,
    this.isOverdue = false,
    this.notes,
  });

  final BorrowerModel? borrower;
  final List<ThingSummaryModel> things;
  final String? notes;
  final DateTime checkedOutDate;
  final DateTime dueDate;
  final bool isOverdue;

  @override
  Widget build(BuildContext context) {
    final bool isMobileScreen = isMobile(context);
    final double cardElevation = isMobileScreen ? 1 : 0;

    final borrowerCard = Card(
      elevation: cardElevation,
      child: Column(
        children: [
          const Detail(
            useListTile: true,
            prefixIcon: Icon(Icons.person),
            label: 'Borrower',
          ),
          Detail(
            useListTile: true,
            label: 'Name',
            value: borrower!.name,
          ),
          Detail(
            useListTile: true,
            label: 'Email',
            placeholderText: '-',
            value: borrower!.email,
          ),
          Detail(
            useListTile: true,
            label: 'Phone',
            placeholderText: '-',
            value: borrower!.phone,
          ),
        ],
      ),
    );

    final thingsCard = Card(
      elevation: cardElevation,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Detail(
            useListTile: true,
            label: 'Thing',
            prefixIcon: Icon(Icons.build_rounded),
          ),
          Container(
            clipBehavior: Clip.antiAlias,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              color: Colors.black45,
              shape: BoxShape.rectangle,
            ),
            height: 240,
            child: _ThingImage(urls: things[0].images),
          ),
        ],
      ),
    );

    final datesCard = Card(
      elevation: cardElevation,
      child: Column(
        children: [
          Detail(
            useListTile: true,
            prefixIcon: Builder(
              builder: (_) {
                if (!isOverdue) {
                  return const Icon(Icons.calendar_month);
                }

                return const Tooltip(
                  message: 'Overdue',
                  child: Icon(
                    Icons.warning_rounded,
                    color: Colors.amber,
                  ),
                );
              },
            ),
            label: 'Dates',
          ),
          Detail(
            useListTile: true,
            label: 'Checked Out',
            value:
                '${checkedOutDate.month}/${checkedOutDate.day}/${checkedOutDate.year}',
          ),
          Detail(
            useListTile: true,
            label: isOverdue ? 'Due Back (Overdue)' : 'Due Back',
            value: '${dueDate.month}/${dueDate.day}/${dueDate.year}',
          ),
        ],
      ),
    );

    final notesCard = Card(
      elevation: cardElevation,
      child: Column(
        children: [
          const Detail(
            useListTile: true,
            prefixIcon: Icon(Icons.notes),
            label: 'Notes',
          ),
          Detail(
            useListTile: true,
            value: notes,
            placeholderText: '-',
          ),
        ],
      ),
    );

    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            children: [
              FractionallySizedBox(
                widthFactor: isMobileScreen ? 1 : 0.5,
                child: thingsCard,
              ),
              FractionallySizedBox(
                widthFactor: isMobileScreen ? 1 : 0.5,
                child: datesCard,
              ),
              FractionallySizedBox(
                widthFactor: isMobileScreen ? 1 : 0.5,
                child: notesCard,
              ),
              FractionallySizedBox(
                widthFactor: isMobileScreen ? 1 : 0.5,
                child: borrowerCard,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ThingImage extends StatelessWidget {
  const _ThingImage({required this.urls});

  final List<String> urls;

  @override
  Widget build(BuildContext context) {
    if (urls.isEmpty) {
      return const Center(
        child: NoImage(),
      );
    }
    return Image.network(
      urls[0],
      fit: BoxFit.contain,
      height: 240,
      loadingBuilder: (context, child, event) {
        if (event == null) {
          return child;
        }

        final progress =
            event.cumulativeBytesLoaded / (event.expectedTotalBytes ?? 1);

        return Center(
          child: CircularProgressIndicator(value: progress),
        );
      },
    );
  }
}
