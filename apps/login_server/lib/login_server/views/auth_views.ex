defmodule LoginServer.Actions.AuthViews do
  @moduledoc """
  Define views (server to client packets) for the authentification part
  """

  # TODO: Write ElvenGard `__using__` for views (just add a default render)
  # use ElvenGard.Helpers.Views

  # All errors codes
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

  def render(:login_error, %{status_code: status_code}) do
    protocol = 0x000000FE
    packet = <<error_code(status_code)::little-size(32)>>
    {protocol, packet}
  end
end
