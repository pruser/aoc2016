defmodule Day1 do
  def process(steps) do
    process({{0,0}, :up}, steps)
  end

  defp read(str) do
    case str do
      "R" <> num -> {:r, String.to_integer(num)}
      "L" <> num -> {:l, String.to_integer(num)}
    end
  end

  defp process({point, orientation}, [head | tail]) do
      {d, n} = read(head)
      transform(point, orientation, {d, n}) |> process(tail)
  end

  defp process({point, _}, []) do
    point
  end

  defp transform({x, y}, :up, {dir, steps}) do
    case dir do
      :r -> {{x, y+steps}, :right}
      :l -> {{x, y-steps}, :left}
    end
  end

  defp transform({x, y}, :down, {dir, steps}) do
    case dir do
      :r -> {{x, y-steps}, :left}
      :l -> {{x, y+steps}, :right}
    end
  end
  
  defp transform({x, y}, :left, {dir, steps}) do
    case dir do
      :r -> {{x+steps, y}, :up}
      :l -> {{x-steps, y}, :down}
    end
  end
  
  defp transform({x, y}, :right, {dir, steps}) do
    case dir do
      :r -> {{x-steps, y}, :down}
      :l -> {{x+steps, y}, :up}
    end
  end
end

fname = System.argv() |> List.first

if not File.exists?(fname) do
  raise "wrong file name"
end

distance = fn({x, y}) -> x+y end

{:ok, data} = File.read(fname)
data |> String.split([", ", "\n"], trim: true) |> Day1.process |> distance.() |> IO.puts

