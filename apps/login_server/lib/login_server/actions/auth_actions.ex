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
end
