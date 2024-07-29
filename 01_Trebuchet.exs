# --- Day 1: Trebuchet?! ---
# https://adventofcode.com/2023/day/1

defmodule Trebuchet do

  def read_from_file(filename) do
    filename
    |> File.stream!()
    |> Enum.map(&String.trim_trailing/1)
  end

  def find_calibration_values(calibration) do
    calibration
    |> Enum.map(&extract_calibration_value/1)
    |> Enum.sum()
  end

  defp extract_calibration_value(line) do
    line
    # Convert the line to graphemes (chars)
    |> String.graphemes()
    # Filter only digit characters
    |> Enum.filter(&is_digit/1)
    |> case do
        [first_digit | rest] when rest != [] ->
          last_digit = List.last(rest)
          String.to_integer("#{first_digit}#{last_digit}")
        [single_digit] ->
          String.to_integer("#{single_digit}#{single_digit}")
        _ -> 0
    end
  end

  defp is_digit(char) do
    String.match?(char, ~r/^\d$/)  # Check if the character is a digit
  end

end

# Usage example
filename = "01_calibration.txt"
calibration_lines = Trebuchet.read_from_file(filename)
total_calibration_value = Trebuchet.find_calibration_values(calibration_lines)
IO.puts("Total Calibration Value: #{total_calibration_value}")
