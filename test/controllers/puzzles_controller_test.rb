require "test_helper"

class PuzzlesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get puzzles_path
    assert_response :success
  end

  test "should get show" do
    get puzzle_path(puzzles(:one))
    assert_response :success
  end
end
