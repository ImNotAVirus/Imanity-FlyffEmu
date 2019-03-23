defmodule LoginServer.Types.FlyffString do
  @moduledoc """
  Define a custom string type for FlyFF protocol
  """

  use ElvenGard.Helpers.Type

  @impl ElvenGard.Helpers.Type
  @spec encode(String.t(), list) :: bitstring
  def encode(str, _opts) do
    <<byte_size(str)::little-size(32), str::binary>>
  end

  @impl ElvenGard.Helpers.Type
  @spec decode(bitstring, list) :: {String.t(), bitstring}
  def decode(bin, _opts) do
    <<
      length::little-size(32),
      content::binary-size(length),
      rest::binary
    >> = bin

    {content, rest}
  end
end
