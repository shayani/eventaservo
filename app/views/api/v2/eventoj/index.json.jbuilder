json.array! @eventoj do |e|
  json.titolo e.title
  json.priskribo e.description
  json.urbo e.city
  json.lando e.country.name
  json.reta e.online
  json.ligilo e.ligilo
end
