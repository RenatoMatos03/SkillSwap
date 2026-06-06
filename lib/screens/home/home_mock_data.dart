import 'package:flutter/material.dart';

import 'home_models.dart';

const HomeUserProfile homeUserProfile = HomeUserProfile(
  fullName: 'Renato Matos',
  courseLabel: 'LEI · 2º Ano',
  initials: 'RM',
  balance: '100 €',
  greetingName: 'Maria Rodrigues',
  streakText: '3 semanas consecutivas de ajuda!',
);

const List<NewsItem> homeNewsItems = [
  NewsItem(
    tag: 'QUIZ',
    title: 'Quiz desta semana: Bases de Dados',
    subtitle:
        'Testa os teus conhecimentos sobre SQL, normalização e transações.',
    date: '18 May 2026',
  ),
  NewsItem(
    tag: 'PARCERIA',
    title: 'Nova parceria com o Instituto Politécnico de Setúbal',
    subtitle: 'Mais oportunidades e apoio para os teus projetos académicos.',
    date: '19 May 2026',
  ),
  NewsItem(
    tag: 'SISTEMA',
    title: 'Sistema de moedas recebeu uma atualização',
    subtitle: 'Dobra de moedas semanal e novas recompensas disponíveis.',
    date: '20 May 2026',
  ),
];

const List<LeaderboardItem> homeLeaderboardItems = [
  LeaderboardItem(
    title: 'Top 10 — Mais Moedas',
    subtitle: 'Ranking geral de moedas acumuladas',
    icon: Icons.workspace_premium_outlined,
  ),
  LeaderboardItem(
    title: 'Top 10 — Quiz Semanal',
    subtitle: 'Melhores resultados da semana',
    icon: Icons.emoji_events_outlined,
  ),
];
