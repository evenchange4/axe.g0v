# ruby axe-03.rb

require 'nokogiri'
require 'open-uri'
require 'json'

array = []
cookie= ""
pages = 76
pages.times do |i|
  if i == 1
    uri   = "http://axe-level-1.herokuapp.com/lv3"
    first = open(uri)
    cookie = first.meta['set-cookie'].split('; ',2)[0]
    doc   = Nokogiri::HTML(first)
  else
    uri   = "http://axe-level-1.herokuapp.com/lv3/?page=next"
    doc   = Nokogiri::HTML(open(uri, "Cookie" => cookie))
  end

  data  = doc.css('.table tr')
  keys  = data.shift.css('td').map do |value|
            case value.text
            when '鄉鎮' then :town
            when '村里' then :village
            when '姓名' then :name
            end
          end

  data.each do |tr|
    hash = {}
    td = tr.css('td')
    td.each_with_index do |column, i|
      hash[keys[i]] = column.text
    end
    array << hash
  end
end

puts array.to_json