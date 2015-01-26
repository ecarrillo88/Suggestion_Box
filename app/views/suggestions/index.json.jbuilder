json.array!(@suggestions) do |suggestion|
  json.extract! suggestion, :id, :title, :author, :email, :comment
  json.url suggestion_url(suggestion, format: :json)
end
