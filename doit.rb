require 'rubygems'
require 'uri'
require 'net/http'
require 'nokogiri'
require 'pp'

YHOO_COOKIE = "add your yahoo cookie here (grab it from request headers cookie)"

LEAGUE_ID = '69523'


#
# Part 1: grab matchup pages and save them in local files (allows iteration on stats logic without
# having to hit the net again)
#
def refresh_files(week_start, week_end)
  (week_start..week_end).each do |w|
    teams = (1..10).to_a
    teams.each do |t|
      fname = html_fname(w, 1, t)
      puts "refreshing #{fname} ..."
      html = fetch_html(w, 1, t)
      File.open(fname, 'w') {|f| f.write(html)}
      puts 'done'
    end
  end
end

def html_fname(w, t1, t2)
  "html/week_#{w.to_s.rjust(2, '0')}_#{t1.to_s.rjust(2, '0')}_v_#{t2.to_s.rjust(2, '0')}.html"
end

def fetch_html(week, team1, team2)
  url = URI.parse("http://basketball.fantasysports.yahoo.com/nba/#{LEAGUE_ID}/matchup?week=#{week}&mid1=#{team1}&mid2=#{team2}")
  puts url.request_uri
  req = Net::HTTP::Get.new(url.request_uri, {"Cookie" => YHOO_COOKIE})
  res = Net::HTTP.start(url.host, url.port) {|http| http.request(req) }
  res.body
end

#
# part 2: extract & parse the html into stats, crunch them into wins & losses vs each team
#

# summarizes the wins / losses for each stat category by week for a given team
def summarize_win_loss_close(weekly_stats, team_name = 'Domestic Shorthairs')
  weekly_stats.group_by {|r| r[:week]}.map do |week, rs|
    puts "week: #{week}"
    team_row = rs.select {|r| r[:team_name] == team_name}[0]
    others = rs.reject {|r| r[:team_name] == team_name}
    ws = others.map do |ot|
      rs = [:fg, :ft, :tpm, :pts, :reb, :ast, :st, :blk, :to].map do |key|
        win_fn, close_fn = win_specs[key]
        kv = team_row[key]
        ov = ot[key]
        winner = win_fn.call(kv, ov)
        close_result = close_fn.call(kv, ov) ? 1 : 0
        winner ? [1, 0, close_result] : [0, 1, close_result]
      end
      rs
    end.inject do |memo, row|
      memo.zip(row).map {|t1, t2| t1.zip(t2).map { |el1, el2| el1 + el2 } }
    end
    team_vals = [:fg, :ft, :tpm, :pts, :reb, :ast, :st, :blk, :to].map {|k| team_row[k]}
    with_vals = team_vals.zip(ws).flatten

    [week].concat(with_vals)
  end
end

#
# For each stat column defines what it means to be a win, and what it means to be 'close'
# e.g for points, I win if I have more points than my opponent, and it's close if the delta
# is less than 20 for the week
#
def win_specs
  #key: [win_fn, close_fn]
  {fg: [lambda { |a, b| a > b }, lambda { |a, b| (a - b).abs < 0.05 }],
   ft: [lambda { |a, b| a > b }, lambda { |a, b| (a - b).abs < 0.1 }],
   tpm: [lambda { |a, b| a > b }, lambda { |a, b| (a - b).abs < 10 }],
   pts: [lambda { |a, b| a > b }, lambda { |a, b| (a - b).abs < 20 }],
   reb: [lambda { |a, b| a > b }, lambda { |a, b| (a - b).abs < 20 }],
   ast: [lambda { |a, b| a > b }, lambda { |a, b| (a - b).abs < 10 }],
   st: [lambda { |a, b| a > b }, lambda { |a, b| (a - b).abs < 5 }],
   blk: [lambda { |a, b| a > b }, lambda { |a, b| (a - b).abs < 5 }],
   to: [lambda { |a, b| a < b }, lambda { |a, b| (a - b).abs < 5 }]
  }
end


# extracts stats from all html files into a flat list of hashes each containing
# the column values as well as the week number, e.g
# {:week => 2,
#  :team_name => "The team"
#  :pts => 230,
#  ...
# }
def gather_weekly_stats(week_start, week_end)
  (week_start..week_end).map do |w|
    (1..10).map do |t|
      fname = html_fname(w, 1, t)
      extract_html(File.read(fname)).map do |res|
        res.update(:week => w)
      end
    end
  end.flatten.to_a.uniq {|r| [r[:week], r[:team_name]]}
end

# parses html into columns of stats
def extract_html(html)
  doc = Nokogiri::HTML(html)
  rows = doc.css('#matchup-wall-header tbody tr').map do |tr|
    tr.css('td').map {|td| td.text}
  end
  rows.map do |row|
    Hash[row_specs.zip(row).map {|spec, el| [spec[0], spec[1].call(el)] }]
  end
end

# Given a row of strings, how to parse each column into the data we want
# (just string or float conversion depending)
def row_specs
  [
      [:team_name, lambda {|el| el}],
      [:fg, lambda {|el| el.to_f}],
      [:ft, lambda {|el| el.to_f}],
      [:tpm, lambda {|el| el.to_i}],
      [:pts, lambda {|el| el.to_i}],
      [:reb, lambda {|el| el.to_i}],
      [:ast, lambda {|el| el.to_i}],
      [:st, lambda {|el| el.to_i}],
      [:blk, lambda {|el| el.to_i}],
      [:to, lambda {|el| el.to_i}],
  ]
end


def main
  # uncomment `refresh_files` when there are new stats to gather
  #refresh_files(9, 9)

  weekly_stats = gather_weekly_stats(1, 9)
  final_rows = summarize_win_loss_close(weekly_stats)

  puts final_rows.map {|r| r.join(', ')}.join("\n")
end

if __FILE__ == $0
  main
end






