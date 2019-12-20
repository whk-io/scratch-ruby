#! /usr/bin/env ruby

require 'open3'
system "clear"

container_files=[]

# fetch from ENV or you can set the path to your binary
ruby_path = ENV["PATH"].split(':')[0] + "/ruby"

Open3.popen3("sleep 1; ldd #{ruby_path}") do |stdout, stderr, status, thread|
  while line=stderr.gets do
    if line.include? "=>"
      container_files << (line.split('=>')[1].split(' ')[0])
    end
  end
end

# uses bundler to get path to project gems
APP_GEMS=`bundle list --paths`
so_files=[]
app_gems = APP_GEMS.split(' ')

app_gems.each do |gem|
   so_files << `find #{gem} -name *.so`
end

# ldd examine each gem .so file for static libraries
# append any detected to container_files array
so_files.each do |so_file|
  Open3.popen3("sleep 1; ldd #{so_file}") do |stdout, stderr, status, thread|
    while line=stderr.gets do
      if line.include? "=>"
        container_files << (line.split('=>')[1].split(' ')[0])
      end
    end
  end
end

# remote duplicates from array
container_files = container_files.uniq

# print Dockerfile COPY commands to stdout
container_files.each do |file|
  puts "COPY --from=ruby #{file} #{file}"
end