#! /usr/bin/env ruby
# special case some directory names


directory_copies = [
  {
    new: '284-gl-1-2-equivalent-graphs',
    old: '284-equivalent-graphs'
  },{
    new: '266-gl-1-4-independent-and-dependent',
    old: '266-independent-and-dependent-variables'
  },{
    new: '249-gl-2-1-graphs-tell-a',
    old: '249-graphs-tell-a-story'
  },{
    new: '251-gl-2-2-hurricane-katrina',
    old: '251-hurricane-katrina'
  },{
    new: '281-gl-2-3-growing-up',
    old: '281-growing-up'
  }
]

directory_copies.each do |copy|
  move_command = "cp -r ./_site/activities/#{copy[:old]} ./_site/activities/#{copy[:new]}"
  %x[#{move_command}]
  puts move_command
end