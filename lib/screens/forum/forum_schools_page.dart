import 'package:flutter/material.dart';
import '../../models/forum/school.dart';
import '../../widgets/forum/widgets_forum.dart';
import 'forum_courses_page.dart';

class ForumSchoolsPage extends StatelessWidget {
  ForumSchoolsPage({super.key});

  final List<School> schools = [
    School(acronym: "ESTS", name: "Escola Superior de Tecnologia de Setúbal", coursesCount: 8, icon: Icons.computer),
    School(acronym: "ESE", name: "Escola Superior de Educação", coursesCount: 5, icon: Icons.menu_book),
    School(acronym: "ESCE", name: "Escola Superior de Ciências Empresariais", coursesCount: 9, icon: Icons.bar_chart),
    School(acronym: "ESTB", name: "Escola Superior de Tecnologia do Barreiro", coursesCount: 6, icon: Icons.settings),
    School(acronym: "ESS", name: "Escola Superior de Saúde", coursesCount: 7, icon: Icons.local_hospital),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Escolas do IPS", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1D204B))),
                Text("5 escolas", style: TextStyle(color: Colors.grey[500], fontSize: 14)),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.85,
                ),
                itemCount: schools.length,
                itemBuilder: (context, index) {
                  return SchoolCard(
                    school: schools[index],
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ForumCoursesPage(schoolName: schools[index].acronym),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}