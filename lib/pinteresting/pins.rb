require 'mechanize'

module Pinteresting
  class Pins

    def self.search(search_term, count=50)
      puts "Searching Pinterest for #{count} #{search_term}..."
      a = Mechanize.new
      retrieve_pins(search_term, a, count)
      # parse(search_term, a, count)
    end

    def self.retrieve_pins(search_term, a, count)
      puts "And we're hoping to get #{count} for you."
      page_number = 1

      parsed_pages = []
      until enough_pins?(parsed_pages, count)
        puts "searching #{page_number} pages"
        parsed_pages << parse(search_term, a, page_number)
        page_number += 1
      end
      parsed_pages.inject(&:+)
    end

    def self.enough_pins?(parsed_pages, count)
      all_pins = parsed_pages.inject(&:+) || []
      all_pins.count >= count
    end

    def self.parse(search_term, a, page_number)
      page = get_search_term_page(search_term, a, page_number)
      pins = get_pins(page)
      parse_pins(pins)
    end

    def self.get_search_term_page(search_term, a, page_number)
      a.get("http://pinterest.com/search/pins/?q=#{search_term}&page=#{page_number}")
    end

    def self.get_pins(page)
      page.search('//div[@class="pin"]')
    end

    def self.parse_pins(pins)
      pins.map {|pin| parse_pin(pin)}
    end

    def self.parse_pin(pin)
      {
        :image_url => parse_pin_image_url(pin),
        :repins => parse_pin_repins(pin),
        :pinterest_id => parse_pin_id(pin),
        :url => parse_pin_url(pin),
        :pinner => parse_pin_pinner(pin),
        :likes => parse_pin_likes(pin),
        :description => parse_pin_description(pin)
      }
    end

    # ERMAHGERD:
    # The search results always give back a small thumb image... such as:
    #   http://media-cache-is0.pinimg.com/236x/56/31/8f/56318fadfe347e3a458869dd43390a52.jpg
    #
    # After the domain, the first part is always the pixel wide followed by an 'x'. If you swap that out with
    # "originals" you will get back the original (full size) image URL... such as:
    #   http://media-cache-is0.pinimg.com/originals/56/31/8f/56318fadfe347e3a458869dd43390a52.jpg
    def self.parse_pin_image_url(pin)
      image_url_parts = pin.search(".//a[@class='PinImage ImgLink']/img/@src").text.split('/')
      image_url_parts[3] = "originals"
      image_url_parts.join('/')
    end

    def self.parse_pin_repins(pin)
      pin_repins = pin.search(".//p[@class='stats colorless']/span[@class='RepinsCount']").text
      pin_repins[/(\d+)/,1]
    end

    def self.parse_pin_id(pin)
      # pin_id = pin.search(".//div[@class='PinHolder']/a/@href").text
      # pin_id = pin.attributes["data-id"].value
      pin.search("./@data-id").text
    end

    def self.parse_pin_url(pin)
      # TODO RYAN -- How can I DRY this up?
      pin_url = pin.search("./@data-id").text
      "http://pinterest.com/pin/#{pin_url}"
    end

    def self.parse_pin_pinner(pin)
      pin.search(".//div[@class='convo attribution clearfix']/a/@href").text
    end

    def self.parse_pin_likes(pin)
      pin_likes = pin.search(".//p[@class='stats colorless']/span[@class='LikesCount']").text
      pin_likes[/(\d+)/,1]
    end

    def self.parse_pin_description(pin)
      pin.search(".//p[@class='description']").text
    end

  end
end
