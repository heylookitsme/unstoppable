require "csv"
require "rubygems"
class ImportProfileData

  def self.read_data
    file = File.join(Rails.root, 'importdatacsv', 'profile.csv')
    profile_table = File.read(file)
    profile_csv = CSV.parse(profile_table, :headers => true)
    profile_csv.each do |row|
      profile_hash = row.to_hash
      puts profile_hash
    end

    p = Profile.new
    return profile_csv
  end

end