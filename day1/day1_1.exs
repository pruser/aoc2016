defmodule Day1 do
  def process(steps) do
    process({{0,0}, :up}, steps)
  end

  defp read(str) do
    case str do
      "R" <> num -> {:r, Integer.parse(num) |> elem(0)}
      "L" <> num -> {:l, Integer.parse(num) |> elem(0)}
    end
  end

  defp process({point, orientation}, [head | tail]) do
      {d, n} = read(head)
      transform(point, orientation, {d, n}) |> process(tail)
  end

  defp process({point, _}, []) do
    point
  end

  defp transform(pos, :up, {dir, steps}) do
    {x, y} = pos
    case dir do
      :r -> {{x, y+steps}, :right}
      :l -> {{x, y-steps}, :left}
    end
  end

  defp transform(pos, :down, {dir, steps}) do
    {x, y} = pos
    case dir do
      :r -> {{x, y-steps}, :left}
      :l -> {{x, y+steps}, :right}
    end
  end
  
  defp transform(pos, :left, {dir, steps}) do
    {x, y} = pos
    case dir do
      :r -> {{x+steps, y}, :up}
      :l -> {{x-steps, y}, :down}
    end
  end
  
  defp transform(pos, :right, {dir, steps}) do
    {x, y} = pos
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
data |> String.split(", ") |> Day1.process |> distance.() |> IO.puts

