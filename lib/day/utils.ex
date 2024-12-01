defmodule AdventOfCode.Utils do
  def read_input(path) do
    Path.join([File.cwd!(), "inputs", path])
    |> File.read!()
  end
end
