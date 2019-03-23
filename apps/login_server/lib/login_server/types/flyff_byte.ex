defmodule LoginServer.Types.FlyffByte do
  @moduledoc """
  Define a custom byte type (uint8_t) for FlyFF protocol
  """

  use ElvenGard.Helpers.Type

  @impl ElvenGard.Helpers.Type
  @spec encode(integer, list) :: bitstring
  def encode(byte, _opts) do
    <<byte::size(8)>>
  end

  @impl ElvenGard.Helpers.Type
  @spec decode(bitstring, list) :: {integer, bitstring}
  def decode(bin, _opts) do
    <<
      byte::size(8),
      rest::binary
    >> = bin

    {byte, rest}
  end
end
