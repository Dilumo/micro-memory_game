# Micro Memory Game

**Micro Memory Game** é um jogo de memória desenvolvido com o **Godot Engine**. O objetivo do jogo é encontrar todos os pares de cartas correspondentes no menor tempo possível.

## 📁 Estrutura do Projeto

```
.gitattributes
.gitignore
.godot/
resources/
scenes/
scripts/
user/
```

## 🎮 Como Jogar

1. Inicie o jogo a partir do menu principal.
2. Clique nas cartas para virá-las.
3. Encontre os pares de cartas correspondentes.
4. Complete todos os níveis para vencer o jogo.

## ✨ Funcionalidades

- **Níveis Progressivos**: A dificuldade aumenta a cada nível.
- **Sistema de Pontuação**: Pontos são atribuídos para cada par encontrado.
- **Temporizador**: O tempo é limitado para completar cada nível.
- **Animações e Sons**: Feedback visual e auditivo para interações do jogador.
- **Seleção de Imagens Personalizadas**: No menu principal, você pode selecionar imagens do seu computador para usar no jogo de memória.

## 🖥️ Scripts Principais

- [`memory_game.gd`](scripts/memory_game.gd): Controla a lógica principal do jogo.
- [`card.gd`](scripts/card.gd): Controla o comportamento das cartas.
- [`main_menu.gd`](scripts/main_menu.gd): Controla o menu principal.
- [`game_over.gd`](scripts/game_over.gd): Controla a tela de *game over*.
- [`game_management.gd`](scripts/game_management.gd): Gerencia o estado do jogo e as transições entre cenas.

## 🎨 Recursos

- **Imagens**: Localizadas na pasta `resources/images/`.
- **Sons**: Localizados na pasta `resources/sfx/`.
- **Fontes**: Localizadas na pasta `resources/fonts/`.

## 🚀 Como Executar

1. Clone o repositório:
   ```sh
   git clone https://github.com/Dilumo/micro-memory_game.git
   ```
2. Abra o projeto no **Godot Engine**.
3. Execute a cena principal:
   ```
   res://scenes/main_menu.tscn
   ```

## 🤝 Contribuição

1. Faça um fork do projeto.
2. Crie uma branch para sua feature:
   ```sh
   git checkout -b feature/nova-feature
   ```
3. Commit suas mudanças:
   ```sh
   git commit -am "Adiciona nova feature"
   ```
4. Faça um push para a branch:
   ```sh
   git push origin feature/nova-feature
   ```
5. Abra um **Pull Request**.

## 📜 Licença

Este projeto está licenciado sob a licença **MIT**. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.

## 📬 Contato

Para mais informações, entre em contato com **Dilumos Games**. 
