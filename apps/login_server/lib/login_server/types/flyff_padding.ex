defmodule LoginServer.Types.FlyffPadding do
  @moduledoc """
  Define a custom padding type for FlyFF protocol
  """

  use ElvenGard.Helpers.Type

  @impl ElvenGard.Helpers.Type
  @spec encode(term, list) :: bitstring
  def encode(val, opts) do
    bits = Keyword.get(opts, :bits)
    bytes = Keyword.get(opts, :bytes)
    size = if bits != nil, do: bits, else: bytes * 8

    <<val::size(size)>>
  end

  @impl ElvenGard.Helpers.Type
  @spec decode(bitstring, list) :: {bitstring, bitstring}
  def decode(bin, opts) do
    fill = Keyword.get(opts, :fill)
    bits = Keyword.get(opts, :bits)
    bytes = Keyword.get(opts, :bytes)

    case {fill, bits, bytes} do
      {true, _, _} ->
        {bin, <<>>}

      {_, bits, _} when is_integer(bits) ->
        <<val::size(bits), rest::binary>> = bin
        {val, rest}

      {_, _, bytes} when is_integer(bytes) ->
        <<val::binary-size(bytes), rest::binary>> = bin
        {val, rest}
    end
  end
end
