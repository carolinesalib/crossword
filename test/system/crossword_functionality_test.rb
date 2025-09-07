require "application_system_test_case"

class CrosswordFunctionalityTest < ApplicationSystemTestCase
  def setup
    # Create a proper crossword puzzle for testing
    @puzzle = puzzles(:one)
    @puzzle.update!(
      title: "Test Crossword",
      description: "A simple test puzzle",
      grid_size: 5
    )

    # Create across clue
    @across_clue = clues(:one)
    @across_clue.update!(
      puzzle: @puzzle,
      number: 1,
      direction: "across",
      row: 0,
      col: 0,
      answer: "HELLO",
      clue_text: "A greeting"
    )

    # Create down clue
    @down_clue = clues(:two)
    @down_clue.update!(
      puzzle: @puzzle,
      number: 2,
      direction: "down",
      row: 0,
      col: 0,
      answer: "HAPPY",
      clue_text: "Feeling good"
    )
  end

  # Helper method to slow down tests when running in visible mode
  def slow_down(seconds = 0.5)
    sleep seconds if ENV["VISIBLE_TESTS"]
  end

  def teardown
    if ENV["VISIBLE_TESTS"]
      puts "✅ Test finished: #{@current_test_name}"
      # slow_down(2) # Brief pause to see the final state
    end
  end

  test "user can view crossword puzzle" do
    visit puzzle_path(@puzzle)

    assert_text "Test Crossword"
    assert_text "A simple test puzzle"
    assert_text "Crossword Grid"
    assert_text "Clues"
    assert_text "Across"
    assert_text "Down"
    assert_text "A greeting"
    assert_text "Feeling good"
  end

  # test "user can type letters in crossword grid" do
  #   visit puzzle_path(@puzzle)
  #   slow_down

  #   # Find the first input field and type a letter (use position to avoid ambiguity)
  #   first_input = find("input[data-clue-id='#{@across_clue.id}'][data-position='0']")
  #   first_input.fill_in with: "H"
  #   slow_down

  #   assert_equal "H", first_input.value
  # end

  # test "user can navigate between cells by typing" do
  #   visit puzzle_path(@puzzle)

  #   # Type in first cell
  #   first_input = find("input[data-clue-id='#{@across_clue.id}'][data-position='0']")
  #   first_input.fill_in with: "H"

  #   # Should automatically move to next cell
  #   second_input = find("input[data-clue-id='#{@across_clue.id}'][data-position='1']")
  #   assert second_input.has_css?(":focus")
  # end

  test "user can complete a word across" do
    visit puzzle_path(@puzzle)

    # Type "HELLO" across
    (0..4).each do |position|
      input = find("input[data-clue-id='#{@across_clue.id}'][data-position='#{position}']")
      input.fill_in with: "HELLO"[position]
      # slow_down(0.5) # Longer delay between letters to see each one
    end

    # Verify all cells have correct letters
    (0..4).each do |position|
      input = find("input[data-clue-id='#{@across_clue.id}'][data-position='#{position}']")
      assert_equal "HELLO"[position], input.value
    end
  end

  test "user can complete a word down" do
    visit puzzle_path(@puzzle)

    # Type "HAPPY" down
    (0..4).each do |position|
      input = find("input[data-down-clue-id='#{@down_clue.id}'][data-down-position='#{position}']")
      input.fill_in with: "HAPPY"[position]
      # slow_down(0.5)
    end

    # Verify all cells have correct letters
    (0..4).each do |position|
      input = find("input[data-down-clue-id='#{@down_clue.id}'][data-down-position='#{position}']")
      assert_equal "HAPPY"[position], input.value
    end
  end

  # test "intersecting letters update both directions" do
  #   visit puzzle_path(@puzzle)

  #   # Type "H" in the first cell (intersects both across and down)
  #   first_input = find("input[data-clue-id='#{@across_clue.id}'][data-position='0']")
  #   first_input.fill_in with: "H"

  #   # The same letter should appear in both across and down inputs
  #   across_input = find("input[data-clue-id='#{@across_clue.id}'][data-position='0']")
  #   down_input = find("input[data-clue-id='#{@down_clue.id}'][data-position='0']")

  #   assert_equal "H", across_input.value
  #   assert_equal "H", down_input.value
  # end

  # test "user can click on clues to focus corresponding cells" do
  #   visit puzzle_path(@puzzle)

  #   # Click on the across clue
  #   across_clue_element = find(".clue-item[data-clue-id='#{@across_clue.id}']")
  #   across_clue_element.click

  #   # First cell of that clue should be focused
  #   first_input = find("input[data-clue-id='#{@across_clue.id}'][data-position='0']")
  #   assert first_input.has_css?(":focus")
  # end

  # test "user can check answers and see correct/incorrect feedback" do
  #   visit puzzle_path(@puzzle)

  #   # Fill in correct answer for across clue
  #   (0..4).each do |position|
  #     input = find("input[data-clue-id='#{@across_clue.id}'][data-position='#{position}']")
  #     input.fill_in with: "HELLO"[position]
  #   end

  #   # Fill in incorrect answer for down clue
  #   (0..4).each do |position|
  #     input = find("input[data-clue-id='#{@down_clue.id}'][data-position='#{position}']")
  #     input.fill_in with: "WRONG"[position]
  #   end

  #   # Click check answers button
  #   click_button "Check Answers"

  #   # Across clue should show green (correct)
  #   (0..4).each do |position|
  #     input = find("input[data-clue-id='#{@across_clue.id}'][data-position='#{position}']")
  #     assert input.has_css?(".bg-green-100")
  #   end

  #   # Down clue should show red (incorrect)
  #   (0..4).each do |position|
  #     input = find("input[data-clue-id='#{@down_clue.id}'][data-position='#{position}']")
  #     assert input.has_css?(".bg-red-100")
  #   end
  # end

  test "user can clear the entire grid" do
    visit puzzle_path(@puzzle)

    # Fill in some letters
    first_input = find("input[data-clue-id='#{@across_clue.id}'][data-position='0']")
    first_input.fill_in with: "H"

    # Click clear grid button
    click_button "Clear Grid"

    # All inputs should be empty
    all("input").each do |input|
      assert_equal "", input.value
    end

    # No styling should remain
    all("input").each do |input|
      assert_not input.has_css?(".bg-green-100")
      assert_not input.has_css?(".bg-red-100")
    end
  end

  # test "user can navigate with backspace" do
  #   visit puzzle_path(@puzzle)

  #   # Type in second cell
  #   second_input = find("input[data-clue-id='#{@across_clue.id}'][data-position='1']")
  #   second_input.fill_in with: "E"

  #   # Press backspace in empty cell should go to previous cell
  #   second_input.send_keys [ :backspace ]

  #   first_input = find("input[data-clue-id='#{@across_clue.id}'][data-position='0']")
  #   assert first_input.has_css?(":focus")
  # end

  test "user can use back button to return to puzzles list" do
    visit puzzle_path(@puzzle)

    click_link "Back to Puzzles"

    assert_current_path puzzles_path
    assert_text "Puzzles"
  end

  # test "complete puzzle solution shows congratulations message" do
  #   visit puzzle_path(@puzzle)

  #   # Fill in correct answer for across clue
  #   (0..4).each do |position|
  #     input = find("input[data-clue-id='#{@across_clue.id}'][data-position='#{position}']")
  #     input.fill_in with: "HELLO"[position]
  #   end

  #   # Fill in correct answer for down clue
  #   (0..4).each do |position|
  #     input = find("input[data-clue-id='#{@down_clue.id}'][data-position='#{position}']")
  #     input.fill_in with: "HAPPY"[position]
  #   end

  #   # Click check answers button
  #   click_button "Check Answers"

  #   # Should show congratulations message
  #   assert_text "🎉 Congratulations! You solved the puzzle!"
  # end

  test "input automatically converts to uppercase" do
    visit puzzle_path(@puzzle)

    first_input = find("input[data-clue-id='#{@across_clue.id}'][data-position='0']")
    first_input.fill_in with: "h"

    # Should convert to uppercase
    assert_equal "H", first_input.value
  end
end
