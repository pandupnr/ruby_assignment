#!/usr/bin/env ruby
#Pandu Kumar C

require 'rubygems'
require 'aws-sdk-v1'

if $argc == 0
  puts "Usage Option : pass file names as argument for uploading"  
else
         
   #getting instance to the S3 interface 
   AWS::config(
				:access_key_id     => '********************',
				:secret_access_key => '********************')
   s3 = AWS::S3.new

   
   bucket = s3.buckets['pandutest']
   puts "bucket exists? => #{bucket.exists?}"
   
   
   
   #upload each file 
   i = 0
   while i < ARGV.length do
      file_name = ARGV[i]
	  puts "uploading...#{file_name}"
	  
	  key = File.basename(file_name)
	  s3_file = bucket.objects[key].write(:file => file_name)
	  
	  
	  #bucket.acl = :public_read    #does bucket need to be public??
	  s3_file.acl = :public_read
	  object = bucket.objects[key]
      
      #uploading done....give url to access the file	  
	  puts "use the below url to access the file"
	  puts object.public_url
	  i += 1
   end       
    

end