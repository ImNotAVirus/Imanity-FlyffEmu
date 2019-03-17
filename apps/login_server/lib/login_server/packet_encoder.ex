defmodule LoginServer.PacketEncoder do
  @moduledoc """
  Encode and decode a Login packet
  """

  use ElvenGard.Helpers.PacketEncoder

  require Logger

  @impl true
  @spec encode(String.t()) :: binary
  def encode(data) do
    data
  end

  @impl true
  @spec decode(binary) :: [binary]
  def decode(data) do
    <<
      0x5E::size(8),
      _length_hash::size(32),
      packet_length::little-size(32),
      _data_hash::size(32),
      rest::binary
    >> = data

    real_length = packet_length - 4

    <<
      packet_type::little-size(32),
      params::binary-size(real_length)
    >> = rest

    IO.puts("Length: #{inspect(packet_length)}")
    IO.puts("packet_type: #{inspect(packet_type)}")
    IO.puts("params len: #{inspect(byte_size(params))}")
    [packet_type, params]
  end
end
