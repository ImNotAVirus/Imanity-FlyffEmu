defmodule LoginServer.Types.FlyffString do
  @moduledoc """
  Define a custom string for FlyFF protocol
  """

  use ElvenGard.Helpers.Type

  @impl ElvenGard.Helpers.Type
  @spec encode(String.t()) :: bitstring
  def encode(str) do
    <<byte_size(str)::little-size(32), str::binary>>
  end

  @impl ElvenGard.Helpers.Type
  @spec decode(bitstring) :: {String.t(), bitstring}
  def decode(bin) do
    <<
      length::little-size(32),
      content::binary-size(length),
      rest::binary
    >> = bin

    {content, rest}
  end
end
