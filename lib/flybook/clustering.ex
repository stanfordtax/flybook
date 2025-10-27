defmodule Flybook.Clustering do
  def cluster do
    Node.set_cookie(teams_cookie())

    case Node.connect(teams_node()) do
      true -> :ok
      _ -> {:error, "Tried to connect to #{inspect(teams_node())}"}
    end
  end

  def teams_node(), do: teams_node(app_server_env())

  def teams_node("dev"), do: :"st@127.0.0.1"

  def teams_node(env) when env in ["staging", "production"] do
    {:ok, [fly_machine | _]} = Flybook.FlyClient.machines(fly_app_name())
    ip = fly_machine["private_ip"]
    :"#{fly_app_name()}@#{ip}"
  end

  def teams_cookie,
    do: String.to_atom(System.fetch_env!("LB_RELEASE_COOKIE"))

  defp fly_app_name,
    do: System.fetch_env!("LB_FLY_APP")

  defp app_server_env,
    do: System.fetch_env!("LB_APP_SERVER_ENV")
end
