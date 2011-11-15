#!/usr/bin/env ruby
require 'optparse'

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: git-commit-with-branch -b <branch-name> [-c git-commit options]"

  opts.on('-b', '--branch=NAME', 'Name of newly created branch') do |branch|
    options[:branch] = branch
  end

  options[:commit_option_string] = ""
  opts.on('-c', '--commit-options=GIT_COMMIT_OPTIONS') do |options_string|
    options[:commit_option_string] = options_string
  end

  options[:auto_push] = false
  opts.on('-p', '--[no-]push', 'Automatically push after commit') do |push|
    options[:auto_push] = push
  end

  opts.on('-h', '--help', 'Display this screen') do
     puts opts
     exit
   end
end.parse!

puts "In #{`pwd`}"

exec_options = {
  :in => STDIN,
  :out => STDOUT,
  :err => STDERR
}

puts "Creating branch: #{options[:branch]}"
system "git branch #{options[:branch]}", exec_options
puts "Checking out new branch"
system "git checkout #{options[:branch]}", exec_options
puts "Running `git commit` with options: #{options[:commit_option_string]}"
system "git commit #{options[:commit_option_string]}", exec_options

if options[:auto_push]
  puts "Pushing branch: #{options[:branch]} to remote: origin"
  system "git push origin #{options[:branch]}", exec_options
end