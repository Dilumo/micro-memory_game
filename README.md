# Micro Memory Game

**Micro Memory Game** is a memory game developed using the **Godot Engine**. The goal of the game is to find all matching card pairs in the shortest time possible.

## 📁 Project Structure

```
.gitattributes
.gitignore
.godot/
resources/
scenes/
scripts/
user/
```

## 🎮 How to Play

1. Start the game from the main menu.
2. Click on the cards to flip them.
3. Find all matching card pairs.
4. Complete all levels to win the game.

## ✨ Features

- **Progressive Levels**: Difficulty increases with each level.
- **Scoring System**: Points are awarded for each matching pair.
- **Timer**: Complete each level within the time limit.
- **Animations and Sounds**: Visual and auditory feedback for player interactions.
- **Custom Image Selection**: Use your own images for the memory game by uploading them from the main menu.

## 🖥️ Main Scripts

- [`memory_game.gd`](scripts/memory_game.gd): Controls the main game logic.
- [`card.gd`](scripts/card.gd): Manages card behavior.
- [`main_menu.gd`](scripts/main_menu.gd): Handles the main menu.
- [`game_over.gd`](scripts/game_over.gd): Manages the game-over screen.
- [`game_management.gd`](scripts/game_management.gd): Manages game state and scene transitions.

## 🎨 Resources

- **Images**: Located in the `resources/images/` folder.
- **Sounds**: Located in the `resources/sfx/` folder.
- **Fonts**: Located in the `resources/fonts/` folder.

## 🚀 How to Run

1. Clone the repository:
   ```sh
   git clone https://github.com/Dilumo/micro-memory_game.git
   ```
2. Open the project in **Godot Engine**.
3. Run the main scene:
   ```
   res://scenes/main_menu.tscn
   ```

## 🤝 Contribution

1. Fork the project.
2. Create a new branch for your feature:
   ```sh
   git checkout -b feature/new-feature
   ```
3. Commit your changes:
   ```sh
   git commit -am "Add new feature"
   ```
4. Push the branch:
   ```sh
   git push origin feature/new-feature
   ```
5. Open a **Pull Request**.

## 📜 License

This project is licensed under the **MIT License**. See the [LICENSE](LICENSE) file for details.

## 📬 Contact

For more information, get in touch by [LinkedIn](https://www.linkedin.com/in/diego-manarim-465414294/).
