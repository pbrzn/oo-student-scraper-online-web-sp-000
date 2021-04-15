require 'nokogiri'
require 'open-uri'

class Scraper
  def self.scrape_index_page(index_url)
    doc=Nokogiri::HTML(open(index_url))
    array=[]
    students=doc.css("div.student-card")
    students.each do |student|
      hash={}
      hash[:name]=student.css("h4.student-name").text
      hash[:location]=student.css("p.student-location").text
      hash[:profile_url]=student.css("a").attribute("href").value
      array << hash
    end
    array
  end

  def self.scrape_profile_page(profile_url)
    doc=Nokogiri::HTML(open(profile_url))
    hash={}
    links=doc.css("div.social-icon-container a")
    links.each do |link|
      url=link.attribute("href").value
      if url.include?("twitter")
        hash[:twitter]=url
      elsif url.include?("linkedin")
        hash[:linkedin]=url
      elsif url.include?("github")
        hash[:github]=url
      else
        hash[:blog]=url
      end
      hash[:profile_quote]=doc.css("div.profile-quote").text
      hash[:bio]=doc.css("p").text
    end
    hash
  end
end

