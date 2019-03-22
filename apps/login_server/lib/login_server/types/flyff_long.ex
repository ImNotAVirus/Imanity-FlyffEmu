defmodule LoginServer.Types.FlyffLong do
  @moduledoc """
  Define a custom long type (uint64_t) for FlyFF protocol
  """

  use ElvenGard.Helpers.Type

  @impl ElvenGard.Helpers.Type
  @spec encode(integer) :: bitstring
  def encode(long) do
    <<long::little-size(64)>>
  end

  @impl ElvenGard.Helpers.Type
  @spec decode(bitstring) :: {integer, bitstring}
  def decode(bin) do
    <<
      long::little-size(64),
      rest::binary
    >> = bin

    {long, rest}
  end
end
