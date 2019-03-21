defmodule LoginServer.Actions.AuthViews do
  @moduledoc """
  Define views (server to client packets) for the authentification part
  """

  # TODO: Write ElvenGard `__using__` for views (just add a default render)
  # use ElvenGard.Helpers.Views

  # All errors codes
  @spec error_code(atom) :: 103 | 109 | 119 | 120 | 121 | 122 | 133 | 134 | 135 | 136
  def error_code(:already_connected), do: 0x67
  def error_code(:service_down), do: 0x6D
  def error_code(:account_banned), do: 0x77
  def error_code(:invalid_password), do: 0x78
  def error_code(:invalid_username), do: 0x79
  def error_code(:invalid_credentials), do: error_code(:invalid_username)
  def error_code(:verification_required), do: 0x7A
  def error_code(:under_maintenance), do: 0x85
  def error_code(:wrongpw_15secs), do: 0x86
  def error_code(:wrongpw_15mins), do: 0x87
  def error_code(:server_verif_error), do: 0x88
  def error_code(_), do: error_code(:server_verif_error)

  #
  # Render functions
  #

  @spec render(atom, map) :: {non_neg_integer, binary}
  def render(:greetings, %{client_id: client_id}) do
    protocol = 0x00000000
    packet = <<client_id::little-size(32)>>
    {protocol, packet}
  end

  def render(:cluster_list, %{cluster_list: cluster_list, username: username}) do
    protocol = 0x000000FD

    frontend_cnt =
      length(cluster_list) +
        Enum.reduce(cluster_list, 0, fn x, acc -> acc + length(x.channels) end)

    prelude = <<
      0::size(32),
      1::size(8),
      make_string(username)::binary,
      frontend_cnt::little-size(32)
    >>

    packet = gen_cluster_list(cluster_list)

    {protocol, <<prelude::binary, packet::binary>>}
  end

  def render(:login_error, %{error_type: error_type}) do
    protocol = 0x000000FE
    packet = <<error_code(error_type)::little-size(32)>>
    {protocol, packet}
  end

  #
  # Private function
  #

  @doc false
  @spec gen_cluster_list(list) :: binary
  defp gen_cluster_list(cluster_list) do
    for x <- cluster_list, into: <<>>, do: gen_cluster(x)
  end

  @doc false
  @spec gen_cluster(struct) :: binary
  defp gen_cluster(cluster) do
    <<
      -1::little-size(32),
      cluster.id::little-size(32),
      make_string(cluster.name)::binary,
      make_string(cluster.host)::binary,
      0::little-size(32),
      0::little-size(32),
      1::little-size(32),
      0::little-size(32),
      gen_channel_list(cluster.id, cluster.channels)::binary
    >>
  end

  @doc false
  @spec gen_channel_list(non_neg_integer, list) :: binary
  defp gen_channel_list(cluster_id, channel_list) do
    for x <- channel_list, into: <<>>, do: gen_channel(cluster_id, x)
  end

  @doc false
  @spec gen_channel(non_neg_integer, struct) :: binary
  defp gen_channel(cluster_id, channel) do
    <<
      cluster_id::little-size(32),
      channel.id::little-size(32),
      make_string(channel.name)::binary,
      make_string(channel.host)::binary,
      0::little-size(32),
      0::little-size(32),
      1::little-size(32),
      channel.capacity::little-size(32)
    >>
  end

  ## Temp functions

  @doc false
  defp make_string(str) do
    <<byte_size(str)::little-size(32), str::binary>>
  end
end
