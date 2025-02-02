require "open-uri"
require "fileutils"

AVATAR_COUNT = 12
AVATAR_DIR = File.join(File.dirname(__FILE__), "../public/images/avatars")
FileUtils.mkdir_p(AVATAR_DIR)

# Using DiceBear's "adventurer" style which creates fun, consistent avatars
STYLES = ["adventurer-neutral"]

puts "Generating #{AVATAR_COUNT} avatars..."

AVATAR_COUNT.times do |i|
  avatar_num = i + 1
  style = STYLES[i % STYLES.length]

  # Generate a consistent seed for each avatar number
  seed = "karaoketime#{avatar_num}"

  url = "https://api.dicebear.com/9.x/#{style}/png?seed=#{seed}&backgroundColor=ffdfbf,ffd5dc,c0aede,bde4f4,b6e3f4"
  output_path = File.join(AVATAR_DIR, "avatar_#{avatar_num}.png")

  puts "Downloading avatar #{avatar_num}..."
  # rubocop:disable Security/Open
  URI.open(url) do |image|
    File.binwrite(output_path, image.read)
  end
  # rubocop:enable Security/Open
end

puts "Done! Generated #{AVATAR_COUNT} avatars in #{AVATAR_DIR}"
