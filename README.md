# SkillSwap

**SkillSwap** é uma aplicação Flutter criada para apoiar a aprendizagem colaborativa entre estudantes. O projeto combina autenticação, um painel de notícias, fórum académico e um quiz educativo em uma experiência móvel moderna.

## Índice

- [Visão geral](#visão-geral)
- [Funcionalidades](#funcionalidades)
- [Arquitetura do projeto](#arquitetura-do-projeto)
- [Tecnologias usadas](#tecnologias-usadas)
- [Setup e execução](#setup-e-execução)
- [Configuração Firebase](#configuração-firebase)
- [Estado atual](#estado-atual)
- [Estrutura de pastas](#estrutura-de-pastas)

## Visão geral

SkillSwap oferece um protótipo de plataforma para apoiar o intercâmbio de conhecimentos entre pares, com foco em estudantes do Instituto Politécnico de Setúbal (IPS). A app apresenta:

- fluxo de autenticação com login, registo e verificação de email;
- painel inicial com feed de notícias e leaderboard;
- navegação por abas para fórum e quiz;
- interface mobile com componentes reutilizáveis e navegação fluida.

## Funcionalidades

### Autenticação

- Login com email institucional e password
- Registo com confirmação de password
- Verificação de email via código OTP
- Recuperação de password com validação de email

### Home

- Saudação personalizada ao utilizador
- Carrossel de notícias com indicadores de página
- Cards de leaderboard com estatísticas
- Menu lateral com atalhos para perfil, histórico, definições e About Us
- Barra de navegação inferior com suporte para Home, Match, Mensagens, Fórum e Quiz

### Fórum

- Seleção de escolas do IPS
- Navegação para listas de cursos por escola
- Layout preparado para evolução do fórum

### Quiz

- Tela de introdução ao quiz semanal
- Informações de tempo, número de perguntas e nível
- Início de quiz de exemplo com perguntas mock

## Arquitetura do projeto

O projeto segue uma divisão modular para facilitar desenvolvimentos futuros:

- `lib/main.dart` — entrada principal da app e inicialização do Firebase
- `firebase_options.dart` — configuração gerada pelo FlutterFire para cada plataforma
- `lib/screens/` — telas agrupadas por domínio de funcionalidade
- `lib/services/` — lógica de negócio e integrações Firebase
- `lib/widgets/` — componentes de UI reutilizáveis
- `lib/theme/` — tokens de cores e estilos globais
- `lib/models/` — definição de modelos de dados simples

## Tecnologias usadas

- Flutter 3 / Dart 3
- Firebase Core
- Firebase Authentication
- Cloud Firestore
- Cupertino Icons
- Flutter Lints

## Setup e execução

### Pré-requisitos

- Flutter instalado e configurado no sistema
- Android Studio ou VS Code com Flutter plugin
- Emulador ou dispositivo físico configurado

### Passos

```powershell
flutter pub get
flutter run
```

### Comandos úteis

- `flutter analyze` — análise de código
- `flutter pub outdated` — verificar dependências desatualizadas
- `flutter test` — executar testes (quando implementados)

## Configuração Firebase

O projeto inclui a configuração básica do Firebase via `firebase_options.dart`. Para reproduzir o ambiente localmente, verifique:

- `android/app/google-services.json`
- `ios/Runner/GoogleService-Info.plist`
- `lib/firebase_options.dart`

## Estado atual

- Interface de login e registo implementada
- Verificação de email com código OTP disponível
- Recuperação de password com validação de email implementada
- Feed de notícias e leaderboard baseados em dados mock
- Menu lateral e navegação inferior construídos
- Algumas funcionalidades ainda são placeholders e exibem mensagens informativas

## Estrutura de pastas

- `lib/screens/auth/` — autenticação e fluxo de onboarding
- `lib/screens/home/` — dashboard principal e navegação home
- `lib/screens/forum/` — seleção de escolas e cursos do fórum
- `lib/screens/quiz/` — fluxo de quiz educativo
- `lib/services/` — serviços de integração com Firebase
- `lib/widgets/` — componentes de UI reutilizáveis
- `lib/theme/` — definições de estilo e cores
- `lib/models/` — modelos de dados para componentes
