require 'rest-client'
require 'json'

class GitHub
  # Quick'n'dirty
  def self.get_language(owner)
    languages_counter = {}
    
    response = RestClient.get("https://api.github.com/users/#{owner}/repos") do |response, request, result|
      return nil if response.code != 200
      repos = JSON.parse(response.to_str)
      repos.each do |repo|
    
        lang = repo['language']

        if !lang.nil?
          if languages_counter.key?(lang)
            languages_counter[lang] = languages_counter[lang] + 1
          else
            languages_counter[lang] = 1
          end
        end
      end
    end

    languages_counter.sort_by {|_,v| v}.reverse[0][0]
  end

  # More accurate but slow because too many HTTP requests
  def self.get_favourite_language(owner)
    base_url = 'https://api.github.com'
    languages_counter = {}
    
    repos_response = RestClient.get("#{base_url}/users/#{owner}/repos") # TODO handle errors
    
    repos = JSON.parse(repos_response.to_str) # TODO rescue on error
    repos.each do |repo|
      languages_response = RestClient.get("https://api.github.com/repos/#{owner}/#{repo['name']}/languages")

      languages = JSON.parse(languages_response.to_str)
      languages.keys.each do |key|

        if languages_counter.key?(key)
          languages_counter[key] = languages_counter[key] + 1
        else
          languages_counter[key] = 1
        end
      end
    end

    languages_counter.sort_by {|_,v| v}.reverse[0][0]
  end
end
