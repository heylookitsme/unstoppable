json.profiles @profiles, partial: 'profiles/profile', as: :profile
number_of_profiles = {number_of_profiles: @profiles_size}
json.merge! number_of_profiles