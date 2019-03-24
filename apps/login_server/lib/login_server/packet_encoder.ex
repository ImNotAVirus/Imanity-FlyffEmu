defmodule LoginServer.PacketEncoder do
  @moduledoc """
  Encode and decode a Login packet
  """

  use ElvenGard.Helpers.PacketEncoder

  require Logger

  alias LoginServer.Types.FlyffString

  @impl ElvenGard.Helpers.PacketEncoder
  @spec encode({non_neg_integer, binary}) :: binary
  def encode({packet_id, data}) do
    length = byte_size(data) + 4

    <<
      0x5E::size(8),
      length::little-size(32),
      packet_id::little-size(32),
      data::binary
    >>
  end

  @impl ElvenGard.Helpers.PacketEncoder
  @spec decode(binary) :: {non_neg_integer(), binary()}
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

    {packet_type, params}
  end

  #
  # TODO: Define custom behaviour for binary packets
  #

  @impl ElvenGard.Helpers.PacketEncoder
  def post_decode({0x000000FC, params}, _client) do
    {build_date, rest1} = FlyffString.decode(params, [])
    {username, rest2} = FlyffString.decode(rest1, [])
    {padding, _rest} = ElvenGard.Types.ElvenPadding.decode(rest2, fill: true)

    params = %{
      build_date: build_date,
      username: username,
      padding: padding
    }

    {0x000000FC, params}
  end
end
