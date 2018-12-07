defmodule StatWatch do

  def column_names, do: ~w(DateTime Subscribers Videos Views Alexa) |> Enum.join(",")

  def update_stats do
    get_stats() |> save_csv
  end

  def get_stats do
    {:ok, %{body: body}} = stats_url() |> HTTPoison.get
    now = %{DateTime.utc_now | microsecond: {0, 0}} |> DateTime.to_string

    %{items: [%{statistics: stats} | _]} = Poison.decode!(body, keys: :atoms)
    [now, stats.subscriberCount, stats.videoCount, stats.viewCount] |> Enum.join(", ")
  end

  def save_csv(row_of_stats) do
    filename = "stats.csv"
    unless File.exists?(filename) do
      File.write!(filename, column_names() <> "\n")
    end
    File.write!(filename, row_of_stats <> "\n", [:append])
  end

  defp stats_url do
    youtube_api_v3 = "https://www.googleapis.com/youtube/v3/"
    channel = "id=" <> "UCp5Nix6mJCoLkH_GqcRRp1A"
    key = "key=" <> "AIzaSyBniTqF3UEBArvjoNsJn__et3IXFf0vXP4"
    "#{youtube_api_v3}channels?#{channel}&#{key}&part=statistics"
  end

end
