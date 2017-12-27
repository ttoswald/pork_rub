#!/usr/bin/env ruby

require 'rubygems'
require 'nokogiri'
require 'open-uri'

num_args = ARGV.count

if num_args == 0
  istart = 1
  iend = 12
else
  istart = "#{ARGV[0]}"
  iend = "#{ARGV[0]}"
end



members = Hash.new("does not exist")
members = {
  leagueid: 917761,
  iain: 1,
  james: 2,
  tris: 3,
  marcus: 4,
  randy: 5,
  steve: 5,
  scott: 6,
  jon: 6,  
  jc: 7,
  travis: 8,
  kelby: 9,
  grant: 10,
  kelton: 11,
  mike: 12,
}

#puts members[istart.to_sym]

result_all=[]
for team in 0...num_args
  puts"*******************************"
  puts "***Team #{ARGV[team].capitalize}***"
  puts"*******************************"

  uri = "http://games.espn.com/ffl/schedule?leagueId=#{members[:leagueid]}&teamId=#{members[ARGV[team].to_sym]}"
  doc = Nokogiri::HTML(open(uri))
  scores = doc.search('nobr')

  result=[]
  record_wl=[]
  score_my=[]
  score_opponent=[]
  for i in 0..12
    puts scores[i].content
    result_wl = scores[i].content.split
    result_score = result_wl[1].split('-')
    record_wl = record_wl << result_wl[0]
    score_my = score_my << result_score[0].to_f
    score_opponent = score_opponent << result_score[1].to_f
    result = result << [result_wl[0], result_score[0], result_score[1]]
  end
  result_all = result_all << result
=begin
  tot_my = 0
  for i in 0..12
    tot_my += result_all[0][i][1].to_f
  end
  tot_my = tot_my.round(1)
=end
  
  tot_my = score_my.inject { |sum, n| sum + n }
  avg_my = tot_my / score_my.count
  score_diff = []
  score_my.zip(score_opponent) { |x,y| score_diff << x - y }
  diff_pos = []
  diff_neg =[]
  score_diff.each do |diff|
    diff_pos << diff if diff > 0
    diff_neg << diff if diff < 0
  end
  
  puts"*******************************"
  puts "Win-Loss-Tie record: #{record_wl.count("W")} - #{record_wl.count("L")} - #{record_wl.count("T")}"
  puts "Total points: #{tot_my.round(1)}"
  puts "Average score: #{avg_my.round(1)}"  
  puts "Highest score: #{score_my.max}"
  puts "Lowest score: #{score_my.min}"
  puts "Widest margin of victory: #{score_diff.max.round(1)}" if score_diff.max > 0
  puts "Slimmest margin of victory: #{diff_pos.min.round(1)}"
  puts "Slimmest margin of defeat: #{diff_neg.max.round(1)}"
  puts "Widest margin of defeat: #{score_diff.min.round(1)}" if score_diff.min < 0

end

i = 0
result_all.each do |team|
  team.each do |week|
    #puts week.each {|element| element}.join(" ")
  end
  i += 1
end



def total_my(*scores)
  total = 0
  scores.each {|score| total += score}
  return total
end

#puts total_my(1,4,6)



def lowest_score()



end
