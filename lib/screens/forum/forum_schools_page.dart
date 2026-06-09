import 'package:flutter/material.dart';
import '../../models/forum/school.dart';
import '../../services/forum_service.dart';
import '../../widgets/forum/widgets_forum.dart';
import 'forum_courses_page.dart';

class ForumSchoolsPage extends StatelessWidget {
  const ForumSchoolsPage({super.key});

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
            Expanded(
              child: StreamBuilder<List<School>>(
                stream: ForumService().getSchoolsStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator(color: Color(0xFF009191)));
                  }
                  
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text("Nenhuma escola encontrada.\nAdiciona-as no Firebase!", 
                      textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
                    );
                  }

                  final schools = snapshot.data!;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Escolas do IPS", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1D204B))),
                          Text("${schools.length} escolas", style: TextStyle(color: Colors.grey[500], fontSize: 14)),
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