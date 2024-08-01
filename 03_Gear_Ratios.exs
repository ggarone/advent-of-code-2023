# --- Day 3: Gear Ratios ---
# https://adventofcode.com/2023/day/3

defmodule GearRatios do
  defstruct r: 0, c: 0, value: nil, num: nil

  def read_from_file(filename) do
    case File.read(filename) do
      {:ok, content} ->
        content
        |> Parser.parse_file()

      {:error, reason} ->
        IO.puts("Error reading file: #{reason}")
        []
    end
  end

  def populate_num(gears) do
    gears
    |> Enum.chunk_by(fn gear -> gear.r end)
    |> Enum.flat_map(&populate_num_in_row/1)
  end

  defp populate_num_in_row(row) do
    {result, _} =
      Enum.reduce(row, {[], nil}, fn gear, {acc, current_num} ->
        cond do
          is_digit(gear.value) ->
            new_num = (current_num || "") <> gear.value
            {acc, new_num}
          current_num ->
            new_gears = Enum.map(String.length(current_num)..1, fn i ->
              %{gear | c: gear.c - i, value: String.at(current_num, -i), num: current_num}
            end)
            {acc ++ new_gears ++ [gear], nil}
          true ->
            {acc ++ [gear], nil}
        end
      end)

    case result do
      [] -> row
      _ -> result
    end
  end

  def compute_valid_numbers(gears) do
    gears_with_nums = populate_num(gears)
    symbols = Enum.filter(gears_with_nums, &is_symbol/1)

    gears_with_nums
    |> Enum.filter(&(&1.num != nil))
    |> Enum.uniq_by(fn gear -> {gear.r, gear.num} end)
    |> Enum.filter(fn gear ->
      Enum.any?(symbols, fn symbol ->
        abs(symbol.r - gear.r) <= 1 && abs(symbol.c - gear.c) <= String.length(gear.num)
      end)
    end)
    |> Enum.map(&String.to_integer(&1.num))
    |> Enum.sum()
  end

  defp is_digit(char) do
    String.match?(char, ~r/^\d$/)
  end

  defp is_symbol(gear) do
    gear.value != "." && !is_digit(gear.value)
  end
end

defmodule Parser do
  def parse_file(content) do
    content
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.flat_map(&parse_line/1)
  end

  defp parse_line({line, row}) do
    line
    |> String.graphemes()
    |> Enum.with_index()
    |> Enum.map(fn {char, col} ->
      %GearRatios{r: row, c: col, value: char}
    end)
  end
end

# Usage
gears = GearRatios.read_from_file("03_engine_schema.txt")
sum = GearRatios.compute_valid_numbers(gears)
IO.puts("Sum of all part numbers: #{sum}")
