class DataFile < ActiveRecord::Base
  def self.save(upload)
    upload_filename =  upload.original_filename
    
    extension = File.extname(upload_filename).gsub(/^\.+/, '')
    name = upload_filename.gsub(/\.#{extension}$/, '')
    
    # Downcase string
    name.downcase!
    # Remove apostrophes so isn't changes to isnt
    name.gsub!(/'/, '')
    # Replace any non-letter or non-number character with a space
    name.gsub!(/[^A-Za-z0-9]+/, ' ')
    # Remove spaces from beginning and end of string
    name.strip!
    # Replace groups of spaces with single hyphen
    name.gsub!(/\ +/, '-')
    
    filename = name + "." + extension

    directory = "public/data"
    # create the file path
    path = File.join(directory, filename)
    # write the file
    File.open(path, "wb") { |f| f.write(upload.read) }
    
    return filename 
  end
end