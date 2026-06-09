import 'package:flutter/material.dart';

import 'home_models.dart';

const List<NewsItem> homeNewsItems = [
  NewsItem(
    tag: 'QUIZ',
    title: 'Ganha moedas com o Quiz Semanal',
    subtitle:
        'Resolve o quiz todas as semanas e acumula moedas para trocares por explicações.',
    date: '',
  ),
  NewsItem(
    tag: 'SWIPE',
    title: 'Troca conhecimento na aba Match',
    subtitle:
        'Procura explicações no que precisas e oferece as tuas competências. Quando chegares a acordo, envia as moedas na aba Mensagens através dos 3 pontos no canto superior direito.',
    date: '',
  ),
  NewsItem(
    tag: 'FÓRUM',
    title: 'Usa o Fórum antes de gastar moedas',
    subtitle:
        'Consulta as dúvidas já respondidas na tua escola e ajuda outros estudantes respondendo às questões deles.',
    date: '',
  ),
];

const List<LeaderboardItem> homeLeaderboardItems = [
  LeaderboardItem(
    title: 'Top 5 — Mais Moedas',
    subtitle: 'Ranking geral de moedas acumuladas',
    icon: Icons.workspace_premium_outlined,
    field: 'coins',
    valueSuffix: 'moedas',
  ),
  LeaderboardItem(
    title: 'Top 5 — Quizzes',
    subtitle: 'Quem mais quizzes completou',
    icon: Icons.emoji_events_outlined,
    field: 'quizzesDone',
    valueSuffix: 'quizzes',
  ),
];
