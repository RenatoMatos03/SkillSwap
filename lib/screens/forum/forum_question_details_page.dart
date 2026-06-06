import 'package:flutter/material.dart';
import '../../models/forum/comment_model.dart';
import '../../widgets/forum/widgets_forum.dart';

class ForumQuestionDetailsPage extends StatefulWidget {
  const ForumQuestionDetailsPage({super.key});

  @override
  State<ForumQuestionDetailsPage> createState() => _ForumQuestionDetailsPageState();
}

class _ForumQuestionDetailsPageState extends State<ForumQuestionDetailsPage> {
  final FocusNode _commentFocusNode = FocusNode();
  final TextEditingController _commentController = TextEditingController();
  
  // ESTADOS NOVOS:
  bool _isQuestionOwner = true; // Simulação: O user atual é o dono desta pergunta!
  bool _sortDescending = true;  // Começa do mais votado para o menos votado
  CommentModel? _replyingTo;    // Guarda o comentário a que estamos a responder

  @override
  void initState() {
    super.initState();
    _sortComments();
  }

  void _sortComments() {
    _commentsTree.sort((a, b) {
      if (a.isSolution && !b.isSolution) return -1;
      if (!a.isSolution && b.isSolution) return 1;
      return _sortDescending 
          ? b.votes.compareTo(a.votes) 
          : a.votes.compareTo(b.votes);
    });
  }

  final List<CommentModel> _commentsTree = [
    CommentModel(
      id: "1", userName: "Ana Ferreira", userInitials: "AF", badge: "LEIC-D", time: "há 2h", votes: 12, isSolution: true,
      text: "Para normalizar até à 3FN, segue estes 3 passos: 1FN — Todos os atributos devem ser atómicos, sem grupos repetitivos nem tabelas dentro de tabelas. 2FN — Elimina dependências parciais; cada atributo não-chave deve depender da chave primária completa (só relevante quando a chave é composta). 3FN — Elimina dependências transitivas; atributos não-chave não podem depender de outros atributos não-chave. Exemplo prático: na tabela Encomenda(IdEncomenda, IdProduto, NomeProduto, Quantidade), o NomeProduto depende apenas do IdProduto — viola a 2FN. Separa para uma tabela Produto separada!",
      replies: [
        CommentModel(
          id: "1.1", userName: "Miguel Ramos", userInitials: "MR", badge: "LEIC-D", time: "há 2h", votes: 3,
          text: "Obrigado Ana! Ficou muito mais claro com o exemplo da tabela Encomenda. Era exactamente isso que não estava a perceber — confundia dependência parcial com transitiva.",
          replies: [
            CommentModel(
              id: "1.1.1", userName: "Ana Ferreira", userInitials: "AF", badge: "LEIC-D", time: "há 1h", votes: 1,
              text: "Ainda bem que ajudou! Qualquer dúvida sobre as formas normais, apita.",
            )
          ]
        ),
      ],
    ),
    CommentModel(
      id: "2", userName: "João Costa", userInitials: "JC", badge: "LEIC-D", time: "há 4h", votes: 8,
      text: "Complementando o que a Ana disse, uma forma de memorizar é o \"juramento\": cada atributo não-chave deve depender \"da chave, toda a chave, e nada mais que a chave\". Esse nada mais que a chave é exactamente a 3FN. Simples mas eficaz para o exame!",
    ),
  ];

  @override
  void dispose() {
    _commentFocusNode.dispose();
    _commentController.dispose();
    super.dispose();
  }

  // Acionado quando clicas no botão "Responder" de um comentário
  void _focusInputForReply(CommentModel comment) {
    setState(() {
      _replyingTo = comment;
    });
    _commentFocusNode.requestFocus();
  }

  // Inverte a ordem dos comentários principais
  void _toggleSort() {
    setState(() {
      _sortDescending = !_sortDescending;
      _sortComments();
    });
  }

  void _submitComment() {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;

    final newComment = CommentModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userName: "Tu (Eu)",
      userInitials: "TU",
      badge: "LEIC-T",
      time: "agora",
      votes: 0,
      text: text,
      isSolution: false,
      replies: [],
    );

    setState(() {
      if (_replyingTo != null) {
        _replyingTo!.replies.add(newComment);
      } else {
        _commentsTree.add(newComment);
        _sortComments();
      }
      _commentController.clear();
      _replyingTo = null;
    });
    
    _commentFocusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const ForumAppBar(title: "Base de Dados"),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                const QuestionFullBody(),
                const SizedBox(height: 32),
                _buildCommentsHeader(),
                const SizedBox(height: 16),
                
                ..._commentsTree.map((comment) => CommentItem(
                  comment: comment,
                  onReply: _focusInputForReply,
                  isQuestionOwner: _isQuestionOwner, // Informa se o user é o dono
                  onSolutionToggled: () {
                    setState(() {
                      _sortComments();
                    });
                  },
                )),
              ],
            ),
          ),
          CommentInput(
            controller: _commentController,
            focusNode: _commentFocusNode,
            replyingTo: _replyingTo,
            onCancelReply: () {
              setState(() { _replyingTo = null; });
            },
            onSubmit: _submitComment,
          ),
        ],
      ),
    );
  }

  Widget _buildCommentsHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Comentários (${_commentsTree.length})", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1D204B))),
        InkWell(
          onTap: _toggleSort, // Clicável para ordenar
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(
              children: [
                Text(
                  _sortDescending ? "Mais votados" : "Menos votados", 
                  style: const TextStyle(color: Color(0xFF009191), fontSize: 12, fontWeight: FontWeight.bold)
                ),
                Icon(_sortDescending ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up, size: 16, color: const Color(0xFF009191)),
              ],
            ),
          ),
        )
      ],
    );
  }
}
