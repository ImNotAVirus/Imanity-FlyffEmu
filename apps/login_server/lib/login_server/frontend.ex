defmodule LoginServer.Frontend do
  @moduledoc """
  Documentation for LoginServer.Frontend.
  """

  use ElvenGard.Helpers.Frontend,
    packet_encoder: LoginServer.PacketEncoder,
    packet_handler: LoginServer.PacketHandler,
    port: 23_000

  require Logger
  alias ElvenGard.Structures.Client

  @impl true
  def handle_init(args) do
    port = get_in(args, [:port])
    Logger.info("Login server started on port #{port}")
    {:ok, nil}
  end

  @impl true
  def handle_connection(socket, transport) do
    client = Client.new(socket, transport)
    Logger.info("New connection: #{client.id}")
    {:ok, client}
  end

  @impl true
  def handle_client_ready(%Client{} = client) do
    send_greetings(client)
    {:ok, client}
  end

  @impl true
  def handle_disconnection(%Client{id: id} = client, reason) do
    Logger.info("#{id} is now disconnected (reason: #{inspect(reason)})")
    {:ok, client}
  end

  @impl true
  def handle_message(%Client{id: id} = client, message) do
    Logger.info("New message from #{id} (len: #{byte_size(message)})")
    Logger.info("#{inspect(message)}")
    {:ok, client}
  end

  @impl true
  def handle_error(%Client{id: id} = client, reason) do
    Logger.error("An error occured with client #{id}: #{inspect(reason)}")
    {:ok, client}
  end

  #
  # Private functions
  #

  defp send_greetings(%Client{} = client) do
    protocol = 0x0000000
    client_id = 0x0000042
    packet = <<client_id::little-size(32)>>

    Client.send(client, {protocol, packet})
  end
end
