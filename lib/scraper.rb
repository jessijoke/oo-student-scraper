require 'nokogiri'
require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    doc = Nokogiri::HTML(open(index_url))
    student_list = []
    doc.css("div.roster-cards-container").each { |card|
      card.css(".student-card a").each do |student|
        profile_link = "#{student.attr('href')}"
        location = student.css('.student-location').text
        name = student.css('.student-name').text
        student_list << {:name => name, :location => location, :profile_url => profile_link}
      end
    }
    student_list
  end


  def self.scrape_profile_page(profile_url)
    doc = Nokogiri::HTML(open(profile_url))
    student_info = {}
    doc.css("div.social-icon-container a").each { |el| 
      if el["href"].include?("twitter")
        student_info[:twitter] = el["href"]
      elsif el["href"].include?("linkedin")
        student_info[:linkedin] = el["href"]
      elsif el["href"].include?("github")
        student_info[:github] = el["href"]
      else
        student_info[:blog] = el["href"] 
      end
    }
    student_info[:profile_quote] = doc.css("div.profile-quote").text.strip
    student_info[:bio] = doc.css("div.description-holder p").text.strip
    student_info
  end

end


#
#puts doc.css(".headline-26OIBN").text.strip
#headings = doc.css(".title-oE5vT4")
#headings.each { |el| puts el.text.strip }


#title = project.css("h2.bbcard_name strong a").text
#      projects[title.to_sym] = {
#        :image_link => project.css("div.project-thumbnail a img").attribute("src").value,
#        :description => project.css("p.bbcard_blurb").text,
#        :location => project.css("ul.project-meta span.location-name").text,
#        :percent_funded => project.css("ul.project-stats li.first.funded strong").text.gsub("%","").to_i
#      }
#binding.pry

    #doc.css("").each { |el|
      #icons = []

      #el.css('img.social-icon').each { |social| icons << social.text }
      #profile_quote = el.css('div.profile-quote').text.strip
      #bio = el.css('div.description-holder').text.strip
      #twitter
      #linkedin
      #github
      #blog
      #profile_quote
      #bio
      #student_list << {:twitter => icons[0], :linkedin => social[1], :github => social[2], :blog => social[3], :profile_quote => profile_quote, :bio => bio}
    #}