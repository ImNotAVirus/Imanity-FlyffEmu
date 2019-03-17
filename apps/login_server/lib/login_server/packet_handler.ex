defmodule LoginServer.PacketHandler do
  @moduledoc """
  Received packet handler.
  """

  use ElvenGard.Helpers.Packet

  default_packet do
    Logger.warn("Unknown packet header #{inspect(packet_name)} with args: #{inspect(args)}")
    {:halt, {:error, :unknown_header}, client}
  end
end
