defmodule Day1 do
  def process_part1(steps) do
    process({:ok, {0,0}, :up, []}, steps, fn(_) -> false end)
  end

  def process_part2(steps) do
    process({:ok, {0,0}, :up, []}, steps, &break_condition(&1))
  end

  defp read(str) do
    case str do
      "R" <> num -> {:r, String.to_integer(num)}
      "L" <> num -> {:l, String.to_integer(num)}
    end
  end

  defp process({:ok, _, _, _} = s, [head | tail], break_cond) do
      {d, n} = read(head)
      transform(s, d, n, break_cond) |> process(tail, break_cond)
  end

  defp process({:ok, _, _, _} = s, [], _) do
    s
  end

  defp process({:break, _, _, _} = s, _, _) do
    s
  end

  defp break_condition({_s, position, _ori, visited}) do
    Enum.any?(visited |> Enum.drop(-1), fn(x) -> x == position end)  
  end

  defp transform({_, __pos, ori, _visited} = s, dir, steps, break_cond) do
    new_ori = change_direction(ori, dir)
    do_transform(s, new_ori, steps, break_cond)
  end

  defp do_transform({:ok, _, _, _} = s, _, 0, _) do
    s
  end

  defp do_transform({:break, _, _, _} = s, _, _, _) do
    s
  end

  defp do_transform({p, pos, _ori, visited}, new_ori, steps, break_cond) do
    new_pos = move(pos, new_ori)
    s = {p,  new_pos, new_ori, visited ++ [new_pos]}
    if !break_cond.(s) do
      do_transform(s, new_ori, steps-1, break_cond)
    else 
      {:break, new_pos, new_ori, visited ++ [new_pos]}
    end 
  end


  defp change_direction(:up, dir) do
    case dir do
      :r -> :right
      :l -> :left
    end
  end
  
  defp change_direction(:down, dir) do
    case dir do
      :r -> :left
      :l -> :right
    end
  end

  defp change_direction(:left, dir) do
    case dir do
      :r -> :up
      :l -> :down
    end
  end

  defp change_direction(:right, dir) do
    case dir do
      :r -> :down
      :l -> :up
    end
  end

  defp move({x,y}, :up), do: {x+1, y} 
  defp move({x,y}, :down), do: {x-1, y} 
  defp move({x,y}, :right), do: {x, y+1} 
  defp move({x,y}, :left), do: {x, y-1} 
end

defimpl String.Chars, for: Tuple do 
  def to_string({x, y}) do
    "{" <> Kernel.to_string(x) <> ", " <> Kernel.to_string(y) <> "}"
  end
end

fname = System.argv() |> List.first

if not File.exists?(fname) do
  raise "wrong file name"
end

distance = fn({x,y}) -> abs(x)+abs(y) end

get_result = fn({s, p, _, _}) -> {s, distance.(p)} end



{:ok, data} = File.read(fname)
steps = data |> String.split([", ", "\n"], trim: true) 

steps |> Day1.process_part1 |> get_result.() |> IO.puts
steps |> Day1.process_part2 |> get_result.() |> IO.puts

