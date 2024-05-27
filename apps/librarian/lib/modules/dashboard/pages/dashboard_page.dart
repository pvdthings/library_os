import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/modules/authentication/providers/auth_service_provider.dart';
import 'package:librarian_app/modules/authentication/providers/user_tray.dart';
import 'package:librarian_app/modules/borrowers/widgets/layouts/borrowers_desktop_layout.dart';
import 'package:librarian_app/modules/borrowers/widgets/borrowers_list/searchable_borrowers_list.dart';
import 'package:librarian_app/modules/borrowers/widgets/needs_attention_view.dart';
import 'package:librarian_app/modules/dashboard/providers/end_drawer_provider.dart';
import 'package:librarian_app/modules/dashboard/widgets/create_menu_item.dart';
import 'package:librarian_app/modules/things/widgets/layouts/inventory_desktop_layout.dart';
import 'package:librarian_app/modules/things/pages/inventory_details_page.dart';
import 'package:librarian_app/modules/things/widgets/inventory_list/searchable_inventory_list.dart';
import 'package:librarian_app/modules/things/widgets/dialogs/create_thing_dialog.dart';
import 'package:librarian_app/modules/loans/pages/checkout_page.dart';
import 'package:librarian_app/modules/loans/pages/loan_details_page.dart';
import 'package:librarian_app/modules/loans/widgets/loans_list/searchable_loans_list.dart';
import 'package:librarian_app/modules/loans/widgets/layouts/loans_desktop_layout.dart';
import 'package:librarian_app/modules/updates/widgets/update_dialog_controller.dart';
import 'package:librarian_app/modules/updates/notifiers/update_notifier.dart';
import 'package:librarian_app/utils/media_query.dart';
import 'package:librarian_app/modules/actions/widgets/actions.dart'
    as librarian_actions;

import '../widgets/desktop_dashboard.dart';

class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _DashboardPageState();
  }
}

class _DashboardPageState extends ConsumerState<DashboardPage> {
  final _createButtonKey = GlobalKey<State>();
  final _updateNotifier = UpdateNotifier.instance;

  @override
  void initState() {
    super.initState();
    _updateNotifier.addListener(() {
      UpdateDialogController(context)
          .showUpdateDialog(_updateNotifier.newerVersion!);
    });
  }

  int _moduleIndex = 0;

  late final List<DashboardModule> _modules = [
    DashboardModule(
      title: 'Loans',
      desktopLayout: const LoansDesktopLayout(),
      mobileLayout: SearchableLoansList(
        onLoanTapped: (loan) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const LoanDetailsPage(),
            ),
          );
        },
      ),
    ),
    DashboardModule(
      title: 'Borrowers',
      desktopLayout: const BorrowersDesktopLayout(),
      mobileLayout: SearchableBorrowersList(
        onTapBorrower: (borrower) {
          Navigator.push(context, MaterialPageRoute(builder: (_) {
            return Scaffold(
              appBar: AppBar(title: Text(borrower.name)),
              body: NeedsAttentionView(borrower: borrower),
            );
          }));
        },
      ),
    ),
    DashboardModule(
      title: 'Things',
      desktopLayout: const InventoryDesktopLayout(),
      mobileLayout: SearchableInventoryList(
        onThingTapped: (thing) {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const InventoryDetailsPage(),
          ));
        },
      ),
    ),
    const DashboardModule(
      title: 'Actions',
      desktopLayout: librarian_actions.Actions(),
      mobileLayout: null,
    ),
  ];

  final _menuController = MenuController();

  @override
  Widget build(BuildContext context) {
    final mobile = isMobile(context);
    final module = _modules[_moduleIndex];

    final menuAnchor = MenuAnchor(
      controller: _menuController,
      style: MenuStyle(
        backgroundColor: WidgetStatePropertyAll(Theme.of(context).primaryColor),
      ),
      menuChildren: [
        createMenuItem(
          context: context,
          leadingIcon: const Icon(Icons.handshake_rounded),
          text: 'Create Loan',
          onTap: () async {
            _menuController.close();
            setState(() => _moduleIndex = 0);
            await Future.delayed(const Duration(milliseconds: 150), () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CheckoutPage(),
                ),
              );
            });
          },
        ),
        createMenuItem(
          context: context,
          leadingIcon: const Icon(Icons.build_rounded),
          text: 'Create Thing',
          onTap: () async {
            _menuController.close();
            setState(() => _moduleIndex = 2);
            await Future.delayed(const Duration(milliseconds: 150), () {
              showDialog(
                context: context,
                builder: (context) => const CreateThingDialog(),
              );
            });
          },
        ),
      ],
      child: FloatingActionButton(
        mini: !mobile,
        key: _createButtonKey,
        onPressed: () {
          _menuController.isOpen
              ? _menuController.close()
              : _menuController.open();
        },
        child: const Icon(Icons.add),
      ),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          appBar: AppBar(
            title: Text(module.title),
            backgroundColor: isMobile(context) ? null : Colors.transparent,
            centerTitle: mobile,
            actions: [
              if (!mobile) ...[
                _UpdateButton(),
                const SizedBox(width: 32),
                const UserTray(),
                const SizedBox(width: 32),
              ],
              IconButton(
                onPressed: () {
                  ref.read(authServiceProvider).signOut();
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil('/', (route) => false);
                },
                icon: const Icon(Icons.logout),
                tooltip: 'Log out',
              ),
              const SizedBox(width: 16),
            ],
            elevation: 0,
            scrolledUnderElevation: isMobile(context) ? 1 : 0,
          ),
          body: mobile
              ? SafeArea(child: module.mobileLayout!)
              : DesktopDashboard(
                  selectedIndex: _moduleIndex,
                  onDestinationSelected: (index) {
                    setState(() => _moduleIndex = index);
                  },
                  leading: menuAnchor,
                  child: module.desktopLayout,
                ),
          bottomNavigationBar: mobile
              ? NavigationBar(
                  selectedIndex: _moduleIndex,
                  onDestinationSelected: (index) {
                    setState(() => _moduleIndex = index);
                  },
                  destinations: const [
                    NavigationDestination(
                      selectedIcon: Icon(Icons.handshake),
                      icon: Icon(Icons.handshake_outlined),
                      label: "Loans",
                    ),
                    NavigationDestination(
                      selectedIcon: Icon(Icons.people),
                      icon: Icon(Icons.people_outlined),
                      label: "Borrowers",
                    ),
                    NavigationDestination(
                      selectedIcon: Icon(Icons.build),
                      icon: Icon(Icons.build_outlined),
                      label: "Things",
                    ),
                  ],
                )
              : null,
          endDrawer: ref.watch(endDrawerProvider).drawer,
          floatingActionButton: mobile ? menuAnchor : null,
        );
      },
    );
  }
}

class DashboardModule {
  const DashboardModule({
    required this.title,
    required this.desktopLayout,
    required this.mobileLayout,
  });

  final String title;
  final Widget desktopLayout;
  final Widget? mobileLayout;
}

class _UpdateButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: UpdateNotifier.instance,
      builder: (context, _) {
        final newVersion = UpdateNotifier.instance.newerVersion;

        if (newVersion == null) {
          return const SizedBox.shrink();
        }

        return IconButton(
          onPressed: () {
            UpdateDialogController(context).showUpdateDialog(newVersion);
          },
          tooltip: 'Update Available',
          icon: const Icon(Icons.update, color: Colors.amber),
        );
      },
    );
  }
}
