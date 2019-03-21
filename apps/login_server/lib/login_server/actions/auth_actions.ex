defmodule LoginServer.Actions.AuthActions do
  @moduledoc """
  Define actions for the authentification part
  """

  alias ElvenGard.Structures.Client
  alias LoginServer.Actions.AuthViews

  @doc """
  Greeting are the first message sent by the server when the client logged in
  """
  @spec send_greetings(Client.t()) :: :ok | {:error, atom()}
  def send_greetings(%Client{} = client) do
    client_id = 42
    packet = AuthViews.render(:greetings, %{client_id: client_id})

    Client.send(client, packet)
  end

  @doc """
  If logged successfully, send clusters and channels info to client
  """
  @spec send_channel_list(Client.t(), String.t()) :: :ok | {:error, atom()}
  def send_channel_list(client, username) do
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

  @doc """
  Can be use if credentials are incorrects, player banned, etc...

  Error types list (atoms):
  - :already_connected
  - :service_down
  - :account_banned
  - :invalid_password
  - :invalid_username
  - :invalid_credentials
  - :verification_required
  - :under_maintenance
  - :wrongpw_15secs
  - :wrongpw_15mins
  - :server_verif_error
  """
  @spec send_login_error(Client.t(), atom) :: :ok | {:error, atom()}
  def send_login_error(%Client{} = client, error_type) do
    render = AuthViews.render(:login_error, %{error_type: error_type})
    Client.send(client, render)
  end
end
