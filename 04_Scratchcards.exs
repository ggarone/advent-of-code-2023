# --- Day 4: Scratchcards ---
# https://adventofcode.com/2023/day/4

defmodule Scratchcards do
  defstruct id: nil, winningNumbers: [], playedNumbers: [], value: 0

  def read_from_file(filename) do
    case File.stat(filename) do
      {:ok, %{size: size}} when size > 0 ->
        filename
        |> File.stream!()
        |> Stream.map(&String.trim/1)
        |> populate_struct()
      {:ok, _} ->
        {:error, "File is empty"}
      {:error, reason} ->
        {:error, "Could not read file: #{reason}"}
    end
  end

  def populate_struct(content) do
    cards = content
    |> Enum.with_index(1)
    |> Enum.map(fn {line, id} ->
      [_, numbers] = String.split(line, ":", trim: true)
      [winningNumbersString, playedNumbersString] = String.split(numbers, "|", trim: true)

      winningNumbers = winningNumbersString
      |> String.split(" ", trim: true)
      |> is_digit_and_convert_to_integer()

      playedNumbers = playedNumbersString
      |> String.split(" ", trim: true)
      |> is_digit_and_convert_to_integer()

      %Scratchcards{id: id, winningNumbers: winningNumbers, playedNumbers: playedNumbers}
    end)

    {_updated_cards, total_value} = compute_value(cards)
    # IO.inspect(updated_cards, label: "Updated Cards")
    IO.inspect(total_value, label: "Total Value")

  end

  defp compute_value(cards) do
    updated_cards = Enum.map(cards, fn card ->
        %Scratchcards{id: id, winningNumbers: winningNumbers, playedNumbers: playedNumbers} = card

        # Check for common elements
        common_numbers = Enum.filter(winningNumbers, &(&1 in playedNumbers))
        value = floor(Enum.reduce(common_numbers,1,fn _,acc -> acc*2 end) / 2)

        %Scratchcards{id: id, winningNumbers: winningNumbers, playedNumbers: playedNumbers, value: value}
      end)

    total_value = Enum.sum(Enum.map(updated_cards, & &1.value))
    {updated_cards, total_value}
  end

  defp is_digit_and_convert_to_integer(char_list) do
      char_list
      |> Enum.filter(&(String.match?(&1, ~r/^\d+$/)))
      |> Enum.map(&String.to_integer/1)
  end
end

Scratchcards.read_from_file("04_cards.txt")
