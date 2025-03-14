import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/dashboard/providers/create_loan_controller.dart';
import 'package:librarian_app/dashboard/providers/invalidate_module.dart';
import 'package:librarian_app/dashboard/providers/workspace.dart';
import 'package:librarian_app/dashboard/widgets/end_drawer.dart';
import 'package:librarian_app/core/services/auth_service.dart';
import 'package:librarian_app/modules/authentication/providers/user_tray.dart';
import 'package:librarian_app/modules/members/details/needs_attention_page.dart';
import 'package:librarian_app/dashboard/layouts/members_desktop_layout.dart';
import 'package:librarian_app/modules/members/list/searchable_members_list.dart';
import 'package:librarian_app/dashboard/widgets/create_menu_item.dart';
import 'package:librarian_app/dashboard/layouts/inventory_desktop_layout.dart';
import 'package:librarian_app/modules/things/maintenance/view.dart';
import 'package:librarian_app/modules/things/details/inventory_details_page.dart';
import 'package:librarian_app/modules/things/details/inventory/inventory_list/searchable_inventory_list.dart';
import 'package:librarian_app/modules/things/create/create_thing_dialog.dart';
import 'package:librarian_app/modules/loans/details/loan_details_page.dart';
import 'package:librarian_app/modules/loans/list/searchable_loans_list.dart';
import 'package:librarian_app/dashboard/layouts/loans_desktop_layout.dart';
import 'package:librarian_app/modules/updates/widgets/update_dialog_controller.dart';
import 'package:librarian_app/modules/updates/notifiers/update_notifier.dart';
import 'package:librarian_app/utils/media_query.dart';
import 'package:librarian_app/modules/actions/widgets/actions.dart'
    as librarian_actions;

import '../module.dart';
import '../widgets/desktop_dashboard.dart';
import '../widgets/update_button.dart';

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
    _updateNotifier.addListener(showUpdateDialog);
  }

  void showUpdateDialog() {
    if (kDebugMode) {
      return;
    }

    UpdateDialogController(context)
        .showUpdateDialog(_updateNotifier.newerVersion!);
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
      title: 'Members',
      desktopLayout: const MembersDesktopLayout(),
      mobileLayout: SearchableMembersList(
        onTapBorrower: (borrower) {
          Navigator.push(context, MaterialPageRoute(builder: (_) {
            return NeedsAttentionPage(member: borrower);
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
      title: 'Item Repair',
      desktopLayout: MaintenanceView(),
      mobileLayout: null,
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
    final ws = ref.watch(workspace);
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
          tooltip: ws.hasItem
              ? 'Another "Create Loan" window is already in use.'
              : null,
          onTap: ws.hasItem
              ? null
              : () async {
                  _menuController.close();
                  setState(() => _moduleIndex = 0);
                  await Future.delayed(const Duration(milliseconds: 150), () {
                    ref.read(createLoan).createLoan(context);
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
                const UpdateButton(),
                const SizedBox(width: 32),
                const UserTray(),
                const SizedBox(width: 16),
              ],
              IconButton(
                onPressed: () => AuthService.instance.signOut(),
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
                    invalidateModule(ref, index);
                  },
                  leading: menuAnchor,
                  child: module.desktopLayout,
                ),
          bottomNavigationBar: mobile
              ? NavigationBar(
                  selectedIndex: _moduleIndex,
                  onDestinationSelected: (index) {
                    setState(() => _moduleIndex = index);
                    invalidateModule(ref, index);
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
                      label: "Members",
                    ),
                    NavigationDestination(
                      selectedIcon: Icon(Icons.build),
                      icon: Icon(Icons.build_outlined),
                      label: "Things",
                    ),
                  ],
                )
              : null,
          endDrawer: const EndDrawer(),
          floatingActionButton: mobile ? menuAnchor : null,
        );
      },
    );
  }
}
