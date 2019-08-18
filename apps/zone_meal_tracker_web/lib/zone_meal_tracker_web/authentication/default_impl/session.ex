defmodule ZoneMealTrackerWeb.Authentication.DefaultImpl.Session do
  @moduledoc false

  alias Plug.Conn

  @type login_id :: String.t()

  @login_id_session_key :login_id

  defguardp is_login_id(data) when is_binary(data)

  @spec fetch_login_id(Conn.t()) :: {:ok, login_id} | {:error, :not_found}
  def fetch_login_id(conn) do
    case Conn.get_session(conn, @login_id_session_key) do
      login_id when is_login_id(login_id) ->
        {:ok, login_id}

      nil ->
        {:error, :not_found}
    end
  end

  @spec put_login_id(Conn.t(), login_id) :: Conn.t()
  def put_login_id(conn, login_id) when is_login_id(login_id) do
    Conn.put_session(conn, @login_id_session_key, login_id)
  end

  @spec delete_login_id(Conn.t()) :: Conn.t()
  def delete_login_id(conn) do
    Conn.delete_session(conn, @login_id_session_key)
  end
end
