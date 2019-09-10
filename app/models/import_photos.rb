require "csv"
require "rubygems"
require "fileutils"
require 'open-uri'

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
              user = User.find_by_email(user_hash["email"])
              break if user.blank?
              profile = user.profile
              puts "Importing photo for user = #{user.username}"
              #puts "profile = #{profile.inspect}"
              file = open(url)
              profile.avatar.attach(io: file, filename: image_file_name, content_type: 'image/png')
              profile.save!
            end
          end
        end
    end
  end
end
