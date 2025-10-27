defmodule Flybook.FlyClient do
  def machines(fly_app_name) do
    case Req.get(new(), url: "/v1/apps/#{fly_app_name}/machines") do
      {:ok, %Req.Response{status: 200} = response} ->
        {:ok, response.body}

      {:ok, %Req.Response{status: status, body: body}} ->
        {:error,
         "Error when calling Fly API.\n HTTP response status: #{status}\n HTTP response body: \n\t#{body}"}

      {:error, exception} ->
        {:error, "Exception calling Fly API: #{inspect(exception)}"}
    end
  end

  def new do
    Req.new(
      base_url: "https://api.machines.dev",
      auth: {:bearer, System.fetch_env!("LB_FLY_TOKEN")}
    )
  end
end
