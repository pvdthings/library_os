import 'package:flutter/material.dart';
import 'package:librarian_app/core/models/member_model.dart';
import 'package:librarian_app/utils/format.dart';
import 'package:librarian_app/widgets/detail.dart';
import 'package:librarian_app/core/models/item_summary_model.dart';
import 'package:librarian_app/utils/media_query.dart';
import 'package:librarian_app/widgets/no_image.dart';

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

  final MemberModel? borrower;
  final List<ItemSummaryModel> things;
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
      margin: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
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
            value:
                borrower!.phone != null ? formatPhone(borrower!.phone!) : null,
          ),
          Detail(
            useListTile: true,
            label: 'Member Since',
            placeholderText: '-',
            value: borrower!.joinDate != null
                ? formatDateForHumans(borrower!.joinDate!)
                : null,
          ),
        ],
      ),
    );

    final thingsCard = Card(
      elevation: cardElevation,
      margin: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Detail(
            useListTile: true,
            label: 'Thing',
            prefixIcon: Icon(Icons.build_rounded),
          ),
          Expanded(
            child: Container(
              clipBehavior: Clip.antiAlias,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                color: Colors.black45,
                shape: BoxShape.rectangle,
              ),
              height: 240,
              child: _ThingImage(urls: things[0].images),
            ),
          ),
        ],
      ),
    );

    final datesCard = Card(
      elevation: cardElevation,
      margin: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
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
      margin: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
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

    final children = [thingsCard, datesCard, notesCard, borrowerCard];

    return LayoutBuilder(
      builder: (context, constraints) {
        if (isMobileScreen) {
          return ListView.separated(
            itemCount: children.length,
            padding: const EdgeInsets.all(16.0),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Container(
                constraints: BoxConstraints(
                  maxHeight: constraints.maxHeight / 2,
                ),
                child: children[index],
              );
            },
            separatorBuilder: (context, index) {
              return const SizedBox(height: 16);
            },
          );
        }

        return GridView.count(
          padding: const EdgeInsets.all(16.0),
          childAspectRatio: Size(
            constraints.maxWidth - 48,
            constraints.maxHeight - 48,
          ).aspectRatio,
          crossAxisCount: isMobileScreen ? 1 : 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          shrinkWrap: true,
          children: children,
        );
      },
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
