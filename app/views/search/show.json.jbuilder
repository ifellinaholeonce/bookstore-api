json.books(@books) do |book|
  json.id book.id
  json.title book.title
  json.price book.price
  json.author do
    json.id book.author.id
    json.name book.author.name
  end
end
json.authors(@authors) do |author|
  json.id author.id
  json.name author.name
end
