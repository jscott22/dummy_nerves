defmodule DummyNerves.Camera do

  def next_frame() do
    Path.expand('../../static/dummy.png', __DIR__)
    |> File.read!()
  end
  
end