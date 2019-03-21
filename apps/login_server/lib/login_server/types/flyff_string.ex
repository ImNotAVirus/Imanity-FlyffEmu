defmodule LoginServer.Types.FlyffString do
  @moduledoc """
  Define a custom type for FlyFF protocol
  """

  # TODO: Soon, create the Helper.Type behaviour
  # use ElvenGard.Helpers.Types

  # impl ElvenGard.Helpers.Types
  @spec encode(String.t()) :: bitstring
  def encode(str) do
    <<byte_size(str)::little-size(32), str::binary>>
  end

  # impl ElvenGard.Helpers.Types
  @spec decode(bitstring) :: {String.t(), bitstring}
  def decode(bin) do
    <<
      length::little-size(32),
      content::binary-size(length),
      rest::binary
    >> = bin

    {content, rest}
  end

  # TODO: Put this function into __using__
  @spec put_decode(map, atom) :: map
  def put_decode(%{bin: bin} = args, name) do
    {content, rest} = decode(bin)
    Map.put(%{args | bin: rest}, name, content)
  end
end
