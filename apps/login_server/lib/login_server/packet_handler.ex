defmodule LoginServer.PacketHandler do
  @moduledoc """
  Received packet handler.
  """

  use ElvenGard.Helpers.Packet

  alias LoginServer.Actions.AuthActions
  alias LoginServer.Types.FlyffString

  @desc """
  CERTIFY packet

  First packet received from the client when he logged in.
  Contains the username, password, client build date, etc...
  """
  packet 0x000000FC do
    field :build_date, FlyffString
    field :username, FlyffString

    @desc "TODO: Deserialize it later but currently not used"
    field :unknown, :padding, fill: true

    resolve &AuthActions.check_credentials/3
  end

  default_packet do
    Logger.warn("Unknown packet header #{inspect(packet_name)} with args: #{inspect(args)}")
    {:halt, {:error, :unknown_header}, client}
  end
end
