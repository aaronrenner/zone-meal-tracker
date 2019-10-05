defmodule IntegrationTester do
  @moduledoc """
  Integration tester for ZoneMealTracker
  """

  @type port_number :: :inet.port_number()

  @spec start_zone_meal_tracker_web :: {:ok, port_number}
  def start_zone_meal_tracker_web do
    port_number = get_available_port()

    desired_config =
      [
        zone_meal_tracker_web: Application.get_all_env(:zone_meal_tracker_web)
      ]
      |> Config.Reader.merge(
        zone_meal_tracker_web: [{ZoneMealTrackerWeb.Endpoint, [http: [port: port_number]]}]
      )

    Application.put_all_env(desired_config, persistent: true)

    Application.ensure_all_started(:zone_meal_tracker_web)
  end

  @spec get_available_port :: port_number
  defp get_available_port do
    {:ok, listen_socket} = :gen_tcp.listen(0, [])
    {:ok, port_number} = :inet.port(listen_socket)
    :ok = :gen_tcp.close(listen_socket)
    port_number
  end
end
