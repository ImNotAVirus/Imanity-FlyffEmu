defmodule LoginServer.PacketEncoder do
  @moduledoc """
  Encode and decode a Login packet
  """

  use ElvenGard.Helpers.PacketEncoder

  require Logger

  @impl true
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

  @impl true
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

  @impl true
  def post_decode({packet_type, params}, client) do
    IO.puts("packet_type (0xFC/252 : CERTIFY): #{inspect(packet_type)}")
    IO.puts("params: #{inspect(params)}")

    args =
      %{bin: params}
      |> read_string(:build_date)
      |> read_string(:username)

    IO.puts("Args: #{inspect(args)}")

    # def error_code(_), do: error_code(:server_error)
    status_code = :server_error
    render = LoginServer.Actions.AuthViews.render(:login_error, %{status_code: status_code})

    Client.send(client, render)

    [packet_type, params]
  end

  ## Temp functions

  def read_string(%{bin: bin} = args, name) do
    <<
      length::little-size(32),
      content::binary-size(length),
      rest::binary
    >> = bin

    Map.put(%{args | bin: rest}, name, content)
  end

  def read_string(bin) do
    <<
      length::little-size(32),
      content::binary-size(length),
      rest::binary
    >> = bin

    {content, rest}
  end
end
