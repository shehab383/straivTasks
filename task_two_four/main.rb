# frozen_string_literal: false

# TASK 2
a = %w[bed pillow bed pillow table bed pillow door light minibar light chair chair
       light light hairdryer soap]
h = a.tally
#-ve value to reverse ordering from ascending to descending
h = h.sort_by { |_key, value| -value }.to_h
p h

# TASK 4
require 'base64'

# open the given file and initialize a variable with its data
file = File.open('base64.txt')
base_64_encoded_data = file.read

# split into  file info and data
base_64_encoded_data = base_64_encoded_data.split(',')

# extract file type
filetype = /(png|jpg|jpeg|gif|PNG|JPG|JPEG|GIF)/.match(base_64_encoded_data.first)[0]

filename = 'any_name'

# attach the file type at the end of the file name
file = filename << '.' << filetype

# create file and decode
File.open(file, 'w+') do |f|
  f.write(Base64.decode64(base_64_encoded_data.last))
end
