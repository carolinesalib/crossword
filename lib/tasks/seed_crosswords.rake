namespace :crosswords do
  desc "Seed the database with Rails crossword puzzles"
  task seed: :environment do
    puts "Seeding crossword puzzles..."

    # Clear existing data
    Clue.destroy_all
    Puzzle.destroy_all

    # Load JSON data
    json_file = Rails.root.join("lib", "data", "rails_crosswords.json")
    puzzles_data = JSON.parse(File.read(json_file))

    puzzles_data.each do |puzzle_data|
      puzzle = Puzzle.create!(
        title: puzzle_data["title"],
        description: puzzle_data["description"],
        grid_size: puzzle_data["grid_size"]
      )

      puzzle_data["clues"].each do |clue_data|
        puzzle.clues.create!(
          number: clue_data["number"],
          direction: clue_data["direction"],
          row: clue_data["row"],
          col: clue_data["col"],
          answer: clue_data["answer"],
          clue_text: clue_data["clue_text"]
        )
      end

      puts "Created puzzle: #{puzzle.title} with #{puzzle.clues.count} clues"
    end

    puts "Seeding complete! Created #{Puzzle.count} puzzles with #{Clue.count} total clues."
  end
end
