import 'package:flutter/material.dart';
import 'drawer_menu_item.dart';
import '../screens/home/about_us_page.dart';

/// Drawer lateral de navegação principal da aplicação.
class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 20,
                    backgroundColor: Color(0xFF009191),
                    child: Text("MR", style: TextStyle(color: Colors.white)),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Maria Rodrigues",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "LEIC - 2º Ano",
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.grey),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
            const Divider(),

            DrawerMenuItem(
              icon: Icons.person_outline,
              title: 'Ver Perfil',
              onTap: () {
              },
            ),
            DrawerMenuItem(
              icon: Icons.history,
              title: 'Histórico',
              onTap: () {},
            ),
            DrawerMenuItem(
              icon: Icons.settings_outlined,
              title: 'Definições',
              onTap: () {},
            ),
            DrawerMenuItem(
              icon: Icons.info_outline,
              title: 'About Us',
              onTap: () {
                Navigator.pop(context);

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AboutUsPage()),
                );
              },
            ),

            const Spacer(),
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "SkillSwap v1.0.0",
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
