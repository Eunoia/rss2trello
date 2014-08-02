json.array!(@feeds) do |feed|
  json.extract! feed, :id, :name, :url, :interval, :description, :last_retrived
  json.url feed_url(feed, format: :json)
end
