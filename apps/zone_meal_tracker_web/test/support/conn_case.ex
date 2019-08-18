defmodule ZoneMealTrackerWeb.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common data structures and query the data layer.

  Finally, if the test case interacts with the database,
  it cannot be async. For this reason, every test runs
  inside a transaction which is reset at the beginning
  of the test unless the test case is marked as async.
  """

  use ExUnit.CaseTemplate

  import Mox
  use Phoenix.ConnTest

  alias Plug.Conn
  alias Plug.Session
  alias ZoneMealTrackerWeb.MockAuthentication

  using do
    quote do
      # Import conveniences for testing with connections
      use Phoenix.ConnTest
      alias ZoneMealTrackerWeb.Router.Helpers, as: Routes

      import(unquote(__MODULE__))

      # The default endpoint for testing
      @endpoint ZoneMealTrackerWeb.Endpoint
    end
  end

  setup _tags do
    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end

  def set_initial_auth_status(_) do
    stub(MockAuthentication, :fetch_current_user, fn _ ->
      {:error, :unauthenticated}
    end)

    :ok
  end

  def initialize_session(conn) do
    opts =
      Session.init(
        store: :cookie,
        key: "_zone_meal_tracker_web_key",
        signing_salt: "foo",
        log: :warn
      )

    conn
    |> Map.put(:secret_key_base, String.duplicate("-", 64))
    |> Session.call(opts)
    |> Conn.fetch_session()
  end

  def within_request(%Conn{} = conn, request_fn) when is_function(request_fn, 1) do
    conn
    |> ensure_recycled()
    |> initialize_session()
    |> request_fn.()
    |> send_resp(200, "")
    |> recycle()
  end
end
