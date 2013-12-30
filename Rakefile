require 'rspec/core/rake_task'
require 'rake/tasklib'
require 'ci/reporter/rake/rspec'
require 'yard'
require 'yard/rake/yardoc_task'

RSpec::Core::RakeTask.new(:spec => %w(ci:setup:rspec)) do |t|
  t.pattern = 'spec/**/*_spec.rb'
end

task :default => :spec

desc 'Analyze for code complexity with metric_fu'
task :metrics do
  if system 'bundle exec metric_fu -r'
    puts "\nOpen up 'tmp/metric_fu/output/index.html' in your browser to see results."
  end
end

namespace :gem do
  task :push do
    puts 'Building gem from gemspec...'
    system('gem build *.gemspec')
    puts 'Pushing up gem to gems.mobme.in...'
    system('scp -P 2200 *.gem mobme@gems.mobme.in:/home/mobme/public_html/gems.mobme.in/gems')
    puts 'Rebuilding index...'
    system('ssh mobme@gems.mobme.in -p 2200 "cd /home/mobme/public_html/gems.mobme.in && /usr/local/rvm/bin/rvm 1.9.2 do gem generate_index"')
    puts 'Done'
  end
end

YARD::Rake::YardocTask.new(:yard) do |y|
  y.options = %w(--output-dir yardoc)
end

namespace :yardoc do
  desc 'generates yardoc files to yardoc/'
  task :generate => :yard do
    puts 'Yardoc files generated at yardoc/'
  end

  desc 'generates and publish yardoc files to yardoc.mobme.in'
  task :publish => :generate do
    project_name = `git config remote.origin.url`.match(/(git@gits?.mobme.in:|git:\/\/gits?.mobme.in\/)(.*).git/).captures.last.split('/').join('-')
    system "rsync -avz yardoc/ mobme@yardoc.mobme.in:/home/mobme/deploy/yardoc.mobme.in/current/#{project_name}"
    puts "Documentation published to http://yardoc.mobme.in/#{project_name}/"
  end
end
