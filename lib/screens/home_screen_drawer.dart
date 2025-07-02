import 'package:eshop/constants.dart';
import 'package:eshop/provider/user_provider.dart';
import 'package:eshop/screens/change-phone_number.dart';
import 'package:eshop/screens/change_display_name.dart';
import 'package:eshop/screens/change_display_picture.dart';
import 'package:eshop/screens/change_email_screen.dart';
import 'package:eshop/screens/change_password_screen.dart';
import 'package:eshop/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

class HomeScreenDrawer extends ConsumerStatefulWidget {
  const HomeScreenDrawer({super.key});

  @override
  ConsumerState<HomeScreenDrawer> createState() => _HomeScreenDrawerState();
}

class _HomeScreenDrawerState extends ConsumerState<HomeScreenDrawer> {
  bool _editAccountExpanded = true;
  bool _sellerExpanded = true;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey[100],
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Header
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.grey[300]),
            child: ref
                .watch(userInfoProvider)
                .when(
                  data: (user) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 35,
                        backgroundColor: Colors.white,
                        backgroundImage: (user['photoUrl'] ?? '').isNotEmpty
                            ? NetworkImage(user['photoUrl'])
                            : null,
                        child: (user['photoUrl'] ?? '').isEmpty
                            ? Text(
                                user['name']?.substring(0, 1).toUpperCase() ??
                                    '?',
                                style: const TextStyle(
                                  fontSize: 24,
                                  color: kPrimaryColor,
                                ),
                              )
                            : null,
                      ),

                      const SizedBox(height: 10),
                      Text(
                        user['name'] ?? "No Name",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: SizeConfig.screenWidth * 0.04,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      Text(
                        user['email'] ?? "No Email",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: SizeConfig.screenWidth * 0.04,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (err, _) => Text(
                    "Error loading user",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
          ),

          // Edit Account
          _buildExpansionTile(
            icon: LucideIcons.user2,
            title: 'Edit Account',
            expanded: !_editAccountExpanded,
            onExpandToggle: () {
              setState(() {
                _editAccountExpanded = !_editAccountExpanded;
              });
            },
            children: [
              _buildSubTile("Change Display Picture"),
              _buildSubTile("Change Display Name"),
              _buildSubTile("Change Phone Number"),
              _buildSubTile("Change Email"),
              _buildSubTile("Change Password"),
            ],
          ),

          _buildDivider(),

          // Manage Addresses & Orders
          ListTile(
            leading: const Icon(LucideIcons.mapPin),
            title: const Text(
              'Manage Addresses',
              style: TextStyle(fontFamily: 'Poppins'),
            ),
            onTap: () {},
          ),

          _buildDivider(),

          ListTile(
            leading: const Icon(LucideIcons.clipboardList),
            title: const Text(
              'My Orders',
              style: TextStyle(fontFamily: 'Poppins'),
            ),
            onTap: () {},
          ),

          _buildDivider(),

          // I am Seller
          _buildExpansionTile(
            icon: LucideIcons.building2,
            title: 'I am Seller',
            expanded: !_sellerExpanded,
            onExpandToggle: () {
              setState(() {
                _sellerExpanded = !_sellerExpanded;
              });
            },
            children: [
              _buildSubTile("Add New Product"),
              _buildSubTile("Manage My Products"),
            ],
          ),

          _buildDivider(),

          ListTile(
            leading: const Icon(LucideIcons.logOut),
            title: const Text(
              'Sign out',
              style: TextStyle(fontFamily: 'Poppins'),
            ),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildExpansionTile({
    required IconData icon,
    required String title,
    required bool expanded,
    required VoidCallback onExpandToggle,
    required List<Widget> children,
  }) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: Colors.deepPurple),
          title: Text(title, style: const TextStyle(fontFamily: 'Poppins')),
          trailing: Icon(
            expanded ? Icons.expand_less : Icons.expand_more,
            color: Colors.deepPurple,
          ),
          onTap: onExpandToggle,
        ),
        if (expanded) ...children,
      ],
    );
  }

  Widget _buildSubTile(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(fontFamily: 'Poppins', fontSize: 14),
        ),
        onTap: () {
          if (title == "Change Display Picture") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ChangeDisplayPicture(),
              ),
            );
          } else if (title == "Change Display Name") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ChangeDisplayNameScreen(),
              ),
            );
          } else if (title == "Change Phone Number") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ChangePhoneNumberScreen(),
              ),
            );
          } else if (title == "Change Email") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ChangeEmailScreen(),
              ),
            );
          } else if (title == "Change Password") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ChangePasswordScreen(),
              ),
            );
          }
          // Add more navigation logic for other titles as needed
        },
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(thickness: 1, height: 8, color: Colors.black12);
  }
}
