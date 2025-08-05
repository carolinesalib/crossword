# Rails Crossword Puzzles

An interactive crossword puzzle application built with Rails 8 and Tailwind CSS. Test your Rails knowledge with themed crossword puzzles covering various aspects of Ruby on Rails development.

## Features

- **5 Rails-themed crossword puzzles** covering different topics:
  - Rails Generators
  - Active Record Basics
  - Enumerable Methods
  - Routing and Requests
  - Rails Configuration

- **Interactive crossword grid** with:
  - Click-to-focus navigation
  - Auto-advance to next cell
  - Answer validation
  - Visual feedback for correct/incorrect answers

- **Beautiful UI** built with Tailwind CSS:
  - Responsive design
  - Modern gradient backgrounds
  - Hover effects and transitions
  - Clean, accessible interface

## Getting Started

### Prerequisites

- Ruby 3.2+
- Rails 8.0+
- SQLite3

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd crossword
```

2. Install dependencies:
```bash
bundle install
```

3. Set up the database:
```bash
rails db:create
rails db:migrate
```

4. Seed the database with crossword puzzles:
```bash
rails crosswords:seed
```

5. Start the development server:
```bash
bin/dev
```

6. Visit `http://localhost:3000` in your browser

## How to Play

1. **Browse Puzzles**: Start at the home page to see all available puzzles
2. **Select a Puzzle**: Click "Start Puzzle" on any puzzle card
3. **Solve the Crossword**:
   - Click on any cell to start typing
   - Use arrow keys or tab to navigate
   - Click on clues in the sidebar to jump to that word
   - Use "Check Answers" to validate your progress
   - Use "Clear Grid" to start over

## Data Structure

The application uses two main models:

### Puzzle
- `title`: Puzzle name
- `description`: Brief description of the topic
- `grid_size`: Size of the crossword grid (e.g., 10x10)

### Clue
- `puzzle_id`: References the parent puzzle
- `number`: Clue number in the grid
- `direction`: "across" or "down"
- `row`/`col`: Starting position in the grid
- `answer`: The correct answer
- `clue_text`: The clue text

## Adding New Puzzles

1. Add puzzle data to `lib/data/rails_crosswords.json`
2. Run `rails crosswords:seed` to load the new puzzles

## Future Enhancements

- User authentication and progress tracking
- Timer functionality
- Hint system
- Score tracking
- More puzzle categories
- Mobile-optimized interface

## Technology Stack

- **Backend**: Rails 8.0.2
- **Database**: SQLite3
- **Frontend**: Tailwind CSS
- **JavaScript**: Vanilla JS (no framework)
- **Asset Pipeline**: Propshaft
- **Development Server**: `bin/dev` (includes Tailwind CSS watcher)

## Development

The application follows Rails conventions and best practices:

- RESTful routing
- Model validations
- Responsive design
- Accessible UI components
- Clean separation of concerns

## License

This project is open source and available under the [MIT License](LICENSE).
