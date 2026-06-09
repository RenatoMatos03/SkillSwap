import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/user_profile.dart';
import '../../services/user_service.dart';
import '../profile/profile_page.dart';

/// Ecrã de ligações do utilizador com acesso ao WhatsApp e transferência de moedas.
class MessagesPage extends StatelessWidget {
  const MessagesPage({super.key});

  String _getInitials(String name) {
    if (name.isEmpty) return "?";
    List<String> names = name.trim().split(" ");
    if (names.length == 1) return names[0][0].toUpperCase();
    return "${names[0][0]}${names.last[0]}".toUpperCase();
  }

  String _getShortCourse(String course) {
    if (course.isEmpty) return "Curso";
    return course.split(' ').first;
  }

  /// Abre o WhatsApp com o número de telefone do utilizador selecionado.
  Future<void> _openWhatsApp(BuildContext context, String phoneNumber) async {
    if (phoneNumber.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Número indisponível.')));
      return;
    }
    String cleanNumber = phoneNumber.replaceAll(RegExp(r'[^0-9]'), '');
    final Uri whatsappUrl = Uri.parse("https://wa.me/$cleanNumber");

    try {
      await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Não foi possível abrir o WhatsApp.')),
        );
      }
    }
  }

  /// Mostra diálogo para transferir moedas e avaliar o utilizador selecionado.
  void _showGiveCoinsDialog(BuildContext context, UserProfile otherUser) {
    final TextEditingController amountController = TextEditingController();
    double currentRating = 5.0;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Text("Avaliar ${otherUser.name.split(' ').first}"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: "Quantidade de moedas",
                      prefixIcon: Icon(Icons.copyright),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    "Avaliação: ${currentRating.toInt()} estrelas",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Slider(
                    value: currentRating,
                    min: 1,
                    max: 5,
                    divisions: 4,
                    activeColor: Colors.amber,
                    label: currentRating.toInt().toString(),
                    onChanged: (val) {
                      setDialogState(() {
                        currentRating = val;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text("Cancelar"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final amount = int.tryParse(amountController.text) ?? 0;
                    final myUid = FirebaseAuth.instance.currentUser?.uid;
                    if (amount > 0 && myUid != null) {
                      final messenger = ScaffoldMessenger.of(context);
                      try {
                        await UserService().transferCoins(
                          senderUid: myUid,
                          receiverUid: otherUser.uid,
                          amount: amount,
                          rating: currentRating,
                        );
                        if (dialogContext.mounted) Navigator.pop(dialogContext);
                      } catch (e) {
                        messenger.showSnackBar(SnackBar(content: Text(e.toString())));
                      }
                    }
                  },
                  child: const Text("Enviar"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final myUid = FirebaseAuth.instance.currentUser?.uid;
    if (myUid == null) {
      return const Center(
        child: Text("Faz login para veres as tuas ligações."),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "As Minhas Ligações",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(myUid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: CircularProgressIndicator());
          }

          final myMatchesUids = List<String>.from(
            (snapshot.data!.data() as Map<String, dynamic>?)?['matches'] ?? [],
          );
          if (myMatchesUids.isEmpty) {
            return const Center(child: Text("Ainda sem ligações."));
          }

          return FutureBuilder<QuerySnapshot>(
            future: FirebaseFirestore.instance
                .collection('users')
                .where(
                  FieldPath.documentId,
                  whereIn: myMatchesUids.take(30).toList(),
                )
                .get(),
            builder: (context, matchSnapshot) {
              if (!matchSnapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final profiles = matchSnapshot.data!.docs
                  .map(
                    (d) => UserProfile.fromMap(
                      d.id,
                      d.data() as Map<String, dynamic>,
                    ),
                  )
                  .toList();

              return ListView.separated(
                itemCount: profiles.length,
                separatorBuilder: (_, _) =>
                    const Divider(height: 1, indent: 70),
                itemBuilder: (ctx, i) {
                  final p = profiles[i];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: p.photoUrl.isNotEmpty
                          ? NetworkImage(p.photoUrl)
                          : null,
                      child: p.photoUrl.isEmpty
                          ? Text(_getInitials(p.name))
                          : null,
                    ),
                    title: Text(
                      p.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      "${_getShortCourse(p.course)} · Toca para abrir o WhatsApp",
                    ),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'coins') {
                          _showGiveCoinsDialog(context, p);
                        } else if (value == 'profile') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => Scaffold(
                                appBar: AppBar(
                                  title: Text(p.name),
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.black,
                                  elevation: 0,
                                ),
                                body: ProfilePage(profile: p, readOnly: true),
                              ),
                            ),
                          );
                        }
                      },
                      itemBuilder: (_) => [
                        const PopupMenuItem(
                          value: 'coins',
                          child: Row(
                            children: [
                              Icon(Icons.copyright, size: 18),
                              SizedBox(width: 8),
                              Text("Dar moedas"),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'profile',
                          child: Row(
                            children: [
                              Icon(Icons.person_outline, size: 18),
                              SizedBox(width: 8),
                              Text("Ver perfil"),
                            ],
                          ),
                        ),
                      ],
                    ),
                    onTap: () => _openWhatsApp(context, p.phoneNumber),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
