defmodule LoginServer.Types.FlyffInteger do
  @moduledoc """
  Define a custom integer type (uint32_t) for FlyFF protocol
  """

  use ElvenGard.Helpers.Type

  @impl ElvenGard.Helpers.Type
  @spec encode(integer) :: bitstring
  def encode(int) do
    <<int::little-size(32)>>
  end

  @impl ElvenGard.Helpers.Type
  @spec decode(bitstring) :: {integer, bitstring}
  def decode(bin) do
    <<
      int::little-size(32),
      rest::binary
    >> = bin

    {int, rest}
  end
end
