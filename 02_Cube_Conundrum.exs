# --- Day 2: Cube Conundrum ---
# https://adventofcode.com/2023/day/2

defmodule CubeConundrum do
  defstruct id: nil, blue: 0, red: 0, green: 0
  @red 12
  @green 13
  @blue 14

  def read_from_file(filename) do
    filename
    |> File.stream!()
    |> Stream.map(&String.trim_trailing/1)
    |> Stream.filter(&(&1 != ""))
    |> Enum.map(&populate_map/1)
  end

  defp populate_map(game) do
    [game_id, cubes] = String.split(game, ":", parts: 2)
    id = game_id |> String.split(" ") |> List.last() |> String.to_integer()

    cube_counts = cubes
      |> String.split(";")
      |> Enum.flat_map(&String.split(&1, ","))
      |> Enum.map(&String.trim/1)
      |> Enum.reduce(%{blue: 0, red: 0, green: 0}, fn cube, acc ->
        [count, color] = String.split(cube)
        count = String.to_integer(count)
        color = String.to_atom(color)
        Map.update(acc, color, count, &max(&1, count))
      end)

    struct(CubeConundrum, Map.put(cube_counts, :id, id))
  end

  def compute_sum_possible_games(games) do
    games
    |> Enum.map(&check_if_possible_games/1)
    |> Enum.sum()
  end

  defp check_if_possible_games(%{blue: blue, red: red, green: green} = game) when blue <= @blue and red <= @red and green <= @green do
    game.id
  end

  defp check_if_possible_games(_game), do: 0
end

# Usage example
games_struct = CubeConundrum.read_from_file("02_games.txt")
id_sum = CubeConundrum.compute_sum_possible_games(games_struct)
IO.puts("ID sum of possible games is: #{id_sum}")
