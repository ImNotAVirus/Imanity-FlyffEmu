defmodule LoginServer.Types.FlyffShort do
  @moduledoc """
  Define a custom short type (uint16_t) for FlyFF protocol
  """

  use ElvenGard.Helpers.Type

  @impl ElvenGard.Helpers.Type
  @spec encode(integer) :: bitstring
  def encode(short) do
    <<short::little-size(16)>>
  end

  @impl ElvenGard.Helpers.Type
  @spec decode(bitstring) :: {integer, bitstring}
  def decode(bin) do
    <<
      short::little-size(16),
      rest::binary
    >> = bin

    {short, rest}
  end
end
