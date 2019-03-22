defmodule LoginServer.Types.FlyffByte do
  @moduledoc """
  Define a custom byte type (uint8_t) for FlyFF protocol
  """

  use ElvenGard.Helpers.Type

  @impl ElvenGard.Helpers.Type
  @spec encode(integer) :: bitstring
  def encode(byte) do
    <<byte::size(8)>>
  end

  @impl ElvenGard.Helpers.Type
  @spec decode(bitstring) :: {integer, bitstring}
  def decode(bin) do
    <<
      byte::size(8),
      rest::binary
    >> = bin

    {byte, rest}
  end
end
