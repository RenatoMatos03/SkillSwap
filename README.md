# SkillSwap

> **Repositório:** https://github.com/RenatoMatos03/SkillSwap

**SkillSwap** é uma aplicação móvel Flutter de aprendizagem colaborativa entre estudantes universitários. Combina um sistema de moedas virtuais, matchmaking por competências, fórum académico, quiz semanal e notificações em tempo real, com backend totalmente integrado no Firebase.

## Índice

- [Visão geral](#visão-geral)
- [Funcionalidades](#funcionalidades)
- [Arquitetura do projeto](#arquitetura-do-projeto)
- [Tecnologias usadas](#tecnologias-usadas)
- [Setup e execução](#setup-e-execução)
- [Configuração Firebase](#configuração-firebase)
- [Estrutura de pastas](#estrutura-de-pastas)

---

## Visão geral

SkillSwap permite que estudantes troquem conhecimento entre si: quem sabe ensina, quem precisa aprende — e as moedas virtuais servem de incentivo. A app foi desenvolvida para o Instituto Politécnico de Setúbal (IPS), com fóruns e cursos organizados por escola.

---

## Funcionalidades

### Autenticação
- Registo com dados pessoais, escola, curso, ano e número de telemóvel
- Login com email e password
- Verificação de email obrigatória
- Recuperação de password por email

### Home
- Saudação personalizada com streak semanal
- Carrossel de dicas de utilização da app
- Leaderboard em tempo real (top 5 por moedas e por quizzes)
- Menu lateral com acesso ao perfil, definições e Sobre Nós
- Sino de notificações com badge de não lidas

### Perfil
- Visualização e edição de dados pessoais (nome, bio, escola, curso, ano, telemóvel)
- Tags de oferta e procura de conhecimento
- Estatísticas: moedas, quizzes realizados, avaliação
- Avatares dinâmicos e foto de perfil
- Opção de ocultar saldo de moedas no perfil
- Modo anónimo por defeito configurável

### Match (Swipe)
- Visualização de perfis de outros estudantes por deslize
- Matchmaking baseado em tags de oferta/procura

### Mensagens
- Lista de ligações estabelecidas
- Abertura direta do WhatsApp com o contacto
- Transferência de moedas com avaliação por estrelas
- Visualização do perfil de outro utilizador (modo leitura)

### Fórum
- Navegação por escolas e cursos do IPS
- Publicação e resposta a dúvidas académicas com sistema de votos
- Marcação de resposta como solução (recompensa 2 moedas ao autor)
- Filtros e ordenação por curso e área temática

### Quiz Semanal
- 10 perguntas de Informática via API externa
- Bloqueio automático após conclusão — desbloqueia na segunda-feira seguinte
- Ganho de 1 moeda por resposta certa
- Ecrã de resultados com precisão e estatísticas detalhadas

### Notificações
- Notificação em tempo real ao receber moedas
- Notificação quando o quiz semanal fica disponível
- Badge com contagem de não lidas; marcadas como lidas ao abrir

### Definições
- Alteração de password
- Toggle para mostrar/ocultar moedas no perfil (guardado por conta)
- Toggle para modo anónimo por defeito
- Terminar sessão
- Eliminar conta

---

## Arquitetura do projeto

```
lib/
├── main.dart                  # Entrada da app e inicialização Firebase
├── firebase_options.dart      # Configuração gerada pelo FlutterFire
├── models/                    # Modelos de dados (UserProfile, quiz, fórum)
├── services/                  # Lógica de negócio e acesso ao Firebase
├── screens/                   # Ecrãs agrupados por domínio
│   ├── auth/                  # Login, registo, verificação, recuperação
│   ├── home/                  # Dashboard, definições, sobre nós
│   ├── profile/               # Perfil e edição
│   ├── swipe/                 # Matchmaking por deslize
│   ├── messages/              # Ligações e transferência de moedas
│   ├── forum/                 # Escolas, cursos, questões, detalhes
│   └── quiz/                  # Ecrã inicial, perguntas, resultados
├── widgets/                   # Componentes de UI reutilizáveis
│   ├── forum/                 # Cards e componentes específicos do fórum
│   ├── profile/               # Widgets de perfil
│   └── quiz/                  # Widgets do quiz
├── theme/                     # Tokens de cores e estilos globais
└── utils/                     # Utilitários (strings, iniciais, etc.)
```

---

## Tecnologias usadas

| Tecnologia | Uso |
|---|---|
| Flutter 3 / Dart 3 | Framework principal |
| Firebase Authentication | Autenticação de utilizadores |
| Cloud Firestore | Base de dados em tempo real |
| Firebase Core | Inicialização Firebase |
| url_launcher | Abertura do WhatsApp |
| flutter_lints | Análise estática de código |

---

## Setup e execução

### Pré-requisitos

- Flutter SDK instalado e no PATH
- Android Studio ou VS Code com o plugin Flutter
- Emulador Android/iOS ou dispositivo físico

### Passos

```bash
git clone https://github.com/RenatoMatos03/SkillSwap
cd SkillSwap
flutter pub get
flutter run
```

### Comandos úteis

```bash
flutter analyze          # Análise estática de código
flutter pub outdated     # Verificar dependências desatualizadas
flutter build apk        # Gerar APK Android
```

---

## Configuração Firebase

O projeto requer os seguintes ficheiros de configuração Firebase (não incluídos no repositório por segurança):

| Plataforma | Ficheiro |
|---|---|
| Android | `android/app/google-services.json` |
| iOS | `ios/Runner/GoogleService-Info.plist` |
| Dart | `lib/firebase_options.dart` |

```bash
flutterfire configure
```
