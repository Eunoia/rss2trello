require 'rss'

class Feed < ActiveRecord::Base
  include ActionView::Helpers::DateHelper
  belongs_to :user

  def push_to_trello
    puts 'configuring trello'
    Trello.configure do |config|
      config.developer_public_key = "85ed83dd4e226fd8fe5254352a698552"
      config.member_token = self.user.token
    end
    now = DateTime.now
    puts 'getting rss feed'
    feed = RSS::Parser.parse(Net::HTTP.get(URI::parse(self.url)))
    puts 'sorting and filtering RSS feed'
    items = feed.items.select{ |i| i.date>self.last_retrived }.sort! { |a,b| b.date <=> a.date }
    puts "#{items.length} items to be added to list"
    if !items.empty?
      last_time = Time.now
      items.each do |item|
        puts "adding #{CGI.unescapeHTML(item.title)[0..60]} to trello"
        puts "#{ distance_of_time_in_words(item.date,last_time)} since last item"
        card = Trello::Card.create({
          name: CGI.unescapeHTML(item.title),
          list_id: self.list_id,
          desc: item.link
        })
        card.pos = 0
        card.add_comment(CGI.unescapeHTML(item.description))
        card.save
      end
      self.update_attribute(:last_retrived, items.first.date)
    end
    {msg: "#{items.length} items added to list", items: items}
  end
end
