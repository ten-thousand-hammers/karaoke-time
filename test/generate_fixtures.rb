all_songs = Song.where(plays: 1..).reduce({}) do |data, song|
  attributes = song.attributes
  attributes["created_at"] = attributes["created_at"].to_s
  attributes["updated_at"] = attributes["updated_at"].to_s

  underscored_name = song.name.downcase.gsub(" ", "_").tr("',•|()[]-", "").gsub("🎤", "").gsub("_&_", "_and_")
  data[underscored_name] = attributes

  data
end
File.open(Rails.root.join("test", "fixtures", "songs.yml"), 'w') do |file|
  file.write(all_songs.to_yaml)
end
