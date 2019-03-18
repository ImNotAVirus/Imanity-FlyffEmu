defmodule LoginServer.Actions.AuthViews do
  @moduledoc """
  Define views (server to client packets) for the authentification part
  """

  # TODO: Write ElvenGard `__using__` for views (just add a default render)
  # use ElvenGard.Helpers.Views

  @spec render(atom, map) :: {non_neg_integer, binary}
  def render(:greetings, %{client_id: client_id}) do
    protocol = 0x0000000
    packet = <<client_id::little-size(32)>>
    {protocol, packet}
  end
end
