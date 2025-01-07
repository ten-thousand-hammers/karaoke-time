all_songs = Song.where(plays: 1..).each_with_object({}) do |song, data|
  attributes = song.attributes
  attributes["created_at"] = attributes["created_at"].to_s
  attributes["updated_at"] = attributes["updated_at"].to_s

  underscored_name = song.name.downcase.tr(" ", "_").tr("',•|()[]-", "").delete("🎤").gsub("_&_", "_and_")
  data[underscored_name] = attributes
end
File.write(Rails.root.join("test", "fixtures", "songs.yml"), all_songs.to_yaml)
