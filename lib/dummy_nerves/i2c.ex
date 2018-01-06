defmodule DummyNerves.I2C do
  use GenServer

  @moduledoc """
  Stand in for Elixir Ale's Gpio in development and test mode
  """

  defmodule State do
    @moduledoc false
    defstruct port: nil, address: 0, devname: nil, register: [0, 0, 0, 0, 0, 0]
  end

  defstruct devname: nil, address: 0

  def start_link(devname, address, _opts \\ nil) do
    GenServer.start_link(__MODULE__, [devname, address])
  end

  @doc """
  Just change the value of the 'pin' to the value. Can be read by #read/2
  """
  def write(pid, value) do
    GenServer.call(pid, {:write, value})
  end

  @doc """
  Read the value of the pin. Can be set by #write/1. Defaults to zero.
  """
  def read(pid, length) do
    GenServer.call(pid, {:read, length})
  end

  def init([devname, address]) do
    state = %State{port: 1, address: address, devname: devname}
    {:ok, state}
  end

  def handle_call({:read, count}, _from, state) do
    resp = Enum.take(state.register, count)
    |> :binary.list_to_bin()
    {:reply, resp, state}
  end

  def handle_call({:write, data}, _from, state) when data == <<153>> do
    updated = [153, 21 | state.register]
    |> Enum.take(6)

    {:reply, :ok, %{state | register: updated}}
  end

  def handle_call({:write, data}, _from, state) do
    data = :binary.bin_to_list(data)
    updated = [data | state.register]
    |> Enum.take(6)

    {:reply, :ok, %{state | register: updated}}
  end

end