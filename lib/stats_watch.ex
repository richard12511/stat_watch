defmodule StatsWatch do

  def column_names, do: ~w(DateTime Subscribers Videos Views) |> Enum.join(",")

  def get_stats do
    {:ok, %{body: body}} = stats_url |> HTTPoison.get
    now = %{DateTime.utc_now | microsecond: {0, 0}} |> DateTime.to_string

    %{items: [%{statistics: stats} | _]} = Poison.decode!(body, keys: :atoms)
    [now, stats.subscriberCount, stats.videoCount, stats.viewCount] |> Enum.join(", ")
  end

  defp stats_url do
    youtube_api_v3 = "https://www.googleapis.com/youtube/v3/"
    channel = "id=" <> "UCp5Nix6mJCoLkH_GqcRRp1A"
    key = "key=" <> "AIzaSyBniTqF3UEBArvjoNsJn__et3IXFf0vXP4"
    "#{youtube_api_v3}channels?#{channel}&#{key}&part=statistics"
  end

end
