#!/usr/bin/env ruby
#Pandu Kumar C

require 'rubygems'
require 'streamio-ffmpeg'

$transcoded_movie = nil 	
$argc = ARGV.length

if $argc == 0
  puts "Usage Option : pass file name as argument for transcoding"
  puts " number of thumbnails to generate "
else
  
  #transcoding method
  def transcode(file_name)
    
     puts "transcoding.....#{file_name}" 	 
	  
     #taking 16:9 aspect ratio for 360p as source video is having the same aspect ratio 
     #512kbps bit rate is sufficient to maintain high quality
     options = {video_codec: "libx264", frame_rate: 24, resolution: "640x360", video_bitrate: 512,  
	            keyframe_interval: 96, x264_vprofile: "high",
				audio_codec: "aac -strict -2", audio_bitrate: 384, audio_channels: 2, threads: 2}
	 
	 movie = FFMPEG::Movie.new(file_name)
	 
	 $transcoded_movie = movie.transcode("transcoded_movie.mp4", options)
	 
	 puts "transcoding done...."
	 puts "transcoded movie video codec #{$transcoded_movie.video_codec}"
	 puts "audio codec #{$transcoded_movie.audio_codec}"
     puts "resolution #{$transcoded_movie.resolution}"
  end  #end of transcode
  
  
  #screenshots generation method
    
  def screenshots(num_thumbnail_imgs)
      puts "transcoded_movie thumbnail generation"
	  puts "number of thumbnails #{num_thumbnail_imgs}"
	  
	  
	  #skipping some frames from begining and ending to take screenshots
	  init_time = 15
      seek_t = ($transcoded_movie.duration - init_time*2) / num_thumbnail_imgs.to_i
      	  
	  
	  i = 0
	  
	  while i < num_thumbnail_imgs.to_i do
         filename = "thumbnail_#{i}.jpg"
      
    	 #, preserve_aspect_ratio: :width
         # keeping 160x90 to preserve aspect ratio 16:9 
		 
		 puts "generating #{filename}"
         
		 $transcoded_movie.screenshot(filename, seek_time: (init_time + seek_t * i), resolution: '160x90')
		 i += 1
      end #end while	  
  end  #end method screenshots 
  
  
  #main program entry
   
  #calling transcoder method   
  transcode ARGV[0]
  
  #calling thumbnail/screenshots generation
  screenshots ARGV[1]
 
  
end #end if

