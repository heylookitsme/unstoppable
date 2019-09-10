require "csv"
require "rubygems"
require "down"
require "fileutils"

class ImportPhotos

  def self.read_data
    file = File.join(Rails.root, 'importdatacsv', 'user.csv')
    user_table = File.read(file)
    user_csv = CSV.parse(user_table, :headers => true)
    profile_hash = ImportProfileData.read_data
    
    user_csv.each do |row|
        user_hash = row.to_hash
        dirsaved =  Rails.root.join('importedphotos')
       
        
        profile_hash.each do |profile|
          if profile["user"].to_i == user_hash["pk"].to_i
            url = profile["profile_image_url"]
            image_file_name = profile["profile_image_cloudinary_id"]
            unless url.blank? || url == "NULL"
              puts dirsaved
              puts "url = #{url}"
              puts " image name = #{image_file_name}"
              tempfile = Down.download(url)
              puts "printing tempfile"
              puts tempfile.path
              #puts "#{tempfile.original_filename}"
              #FileUtils.mv(tempfile.path, "./importedphotos/#{image_file_name}")

              user = User.find_by_email(user_hash["email"])
              break if user.blank?
              profile = user.profile
              puts "user = #{user.inspect}"
              puts "profile = #{profile.inspect}"
              #medium.image.attach(io: file, filename: 'some-image.jpg')
              #profile.avatar.attach(io: file, filename: "./importedphotos/x.png")
              profile.avatar.attach(io: File.open("./importedphotos/x.png"), filename: "x.png", content_type: "image/png")
              profile.save!
            end
          end
        end
    end
  end
end
