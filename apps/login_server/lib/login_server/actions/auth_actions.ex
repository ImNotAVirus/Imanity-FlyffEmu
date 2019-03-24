defmodule LoginServer.Actions.AuthActions do
  @moduledoc """
  Define actions for the authentification part
  """

  alias ElvenGard.Structures.Client
  alias LoginServer.Actions.AuthViews

  @type packet_type :: non_neg_integer
  @type send_result :: :ok | {:error, atom()}
  @type action_return :: {:ok, map} | {:halt, any, Client.t()}

  @doc """
  Greeting are the first message sent by the server when the client logged in
  """
  @spec send_greetings(Client.t()) :: send_result
  def send_greetings(%Client{} = client) do
    client_id = 42
    packet = AuthViews.render(:greetings, %{client_id: client_id})

    Client.send(client, packet)
  end

  @doc """
  Check user credentials and send to him the server list if succeed
  """
  @spec check_credentials(Client.t(), packet_type, map) :: action_return
  def check_credentials(client, _packet_name, params) do
    %{username: username} = params

    if username == "admin" do
      send_channel_list(client, username)
    else
      send_login_error(client, :invalid_credentials)
    end

    {:halt, {:ok, :normal}, client}
  end

  #
  # Private functions
  #

  @doc false
  @spec send_channel_list(Client.t(), String.t()) :: send_result
  defp send_channel_list(client, username) do
    cluster_list = [
      %{
        id: 1,
        name: "My Cluster",
        host: "127.0.0.1",
        channels: [
          %{
            id: 1,
            name: "First Channel",
            host: "127.0.0.1",
            port: 15_000,
            capacity: 200
          },
          %{
            id: 2,
            name: "Second Channel",
            host: "127.0.0.1",
            port: 15_001,
            capacity: 200
          }
        ]
      }
    ]

    opts = %{cluster_list: cluster_list, username: username}
    render = AuthViews.render(:cluster_list, opts)
    Client.send(client, render)
  end

  # Error types list (atoms):
  # - :already_connected
  # - :service_down
  # - :account_banned
  # - :invalid_password
  # - :invalid_username
  # - :invalid_credentials
  # - :verification_required
  # - :under_maintenance
  # - :wrongpw_15secs
  # - :wrongpw_15mins
  # - :server_verif_error
  @doc false
  @spec send_login_error(Client.t(), atom) :: send_result
  defp send_login_error(%Client{} = client, error_type) do
    render = AuthViews.render(:login_error, %{error_type: error_type})
    Client.send(client, render)
  end
end
