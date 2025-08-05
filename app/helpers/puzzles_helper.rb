module PuzzlesHelper
  def generate_crossword_grid(puzzle)
    grid_size = puzzle.grid_size
    grid = Array.new(grid_size) { Array.new(grid_size, nil) }

    # Mark all cells that are part of any clue
    puzzle.clues.each do |clue|
      answer_length = clue.answer.length

      if clue.direction == "across"
        # Mark cells for across clue
        answer_length.times do |i|
          col = clue.col + i
          if col < grid_size
            if grid[clue.row][col].nil?
              grid[clue.row][col] = []
            end
            grid[clue.row][col] << {
              clue_id: clue.id,
              direction: clue.direction,
              answer: clue.answer,
              clue_number: clue.number,
              position: i,
              is_start: i == 0
            }
          end
        end
      else # down
        # Mark cells for down clue
        answer_length.times do |i|
          row = clue.row + i
          if row < grid_size
            if grid[row][clue.col].nil?
              grid[row][clue.col] = []
            end
            grid[row][clue.col] << {
              clue_id: clue.id,
              direction: clue.direction,
              answer: clue.answer,
              clue_number: clue.number,
              position: i,
              is_start: i == 0
            }
          end
        end
      end
    end

    grid
  end

  def cell_classes(row, col, cell_data)
    classes = "w-12 h-12 border border-gray-300 flex items-center justify-center relative"
    classes += " bg-gray-100" if cell_data.nil?
    classes
  end

  def get_primary_clue(cell_data)
    return nil if cell_data.nil? || cell_data.empty?

    # If there's only one clue for this cell, use it
    return cell_data.first if cell_data.length == 1

    # If there are multiple clues, prioritize across over down
    across_clue = cell_data.find { |clue| clue[:direction] == "across" }
    return across_clue if across_clue

    # Otherwise return the first clue
    cell_data.first
  end

  def get_all_clues(cell_data)
    return [] if cell_data.nil?
    cell_data
  end
end
