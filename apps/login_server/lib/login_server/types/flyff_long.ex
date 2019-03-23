defmodule LoginServer.Types.FlyffLong do
  @moduledoc """
  Define a custom long type (uint64_t) for FlyFF protocol
  """

  use ElvenGard.Helpers.Type

  @impl ElvenGard.Helpers.Type
  @spec encode(integer, list) :: bitstring
  def encode(long, _opts) do
    <<long::little-size(64)>>
  end

  @impl ElvenGard.Helpers.Type
  @spec decode(bitstring, list) :: {integer, bitstring}
  def decode(bin, _opts) do
    <<
      long::little-size(64),
      rest::binary
    >> = bin

    {long, rest}
  end
end
