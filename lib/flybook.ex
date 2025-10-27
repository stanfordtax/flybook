defmodule Flybook do
  def connect do
    import Kino.Shorts

    clustering_flame = frame(placeholder: false) |> Kino.render()

    Kino.Frame.render(clustering_flame, "Connecting to Teams...")

    case Flybook.Clustering.cluster() do
      :ok ->
        Kino.Frame.render(
          clustering_flame,
          "Connected to Teams ✅ (app server env: #{System.fetch_env!("LB_APP_SERVER_ENV")})"
        )

      {:error, error_message} ->
        Kino.Frame.clear(clustering_flame)

        error_message =
          Kino.Text.new("Problem while connecting to Teams: #{error_message}",
            style: [color: "red"]
          )

        Kino.render(error_message)
        Kino.interrupt!(:error, "Try again?")
    end
  end

  defdelegate teams_node, to: Flybook.Clustering
  defdelegate teams_cookie, to: Flybook.Clustering
end
