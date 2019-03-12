# spec/support/test_data_serializers.rb
#

module TestDataSerializers

  # Serializes object to yaml file
  def write_test_data object, file_name
    fname = "./spec/factories/#{file_name}.yml"
    fname = "./spec/factories/last_test_data.yml" if fname.blank?
    raise ArgumentError, "File exists '#{fname}' -- delete the current one, or use a different name" if File.exist?(fname)
    raise ArgumentError, "Method requires an object as first params. " if object.blank?
    File.open(fname, "w") do |file|
      Psych.dump(object, file)
    end
  end

  # Restores object from yaml file
  def restore_test_data file_name
    fname = "./spec/factories/#{file_name}.yml"
    fname = "./spec/factories/last_test_data.yml" if fname.blank?
    Psych.load( IO.read(fname) )
  end

  def get_uploaded_test_file
    content = "application/pdf"
    headers = {name: "temperature-and-humidity"}
    temp = ""
    fpath = SknApp.root.join('spec', 'factories', "notes", "DHT22.pdf")
    file = Tempfile.open(["pdf_file",".pdf"])
    file.binmode
    file.write(IO.binread(fpath))
    file.flush
    file.rewind
    # do not close it -- user will close this file
    # Rack::Multipart::UploadedFile.new(tempfile: file, filename: "DHT22.pdf", head: headers, type: content)
    Rack::Multipart::UploadedFile.new(SknApp.root.join('spec', 'factories', "notes", "DHT22.pdf"), content, true)
  end

  def file_download_response
    file_component = get_uploaded_test_file
    rsp = Rack::Response.new(file_component, 200,
                       {"content-type" => "application/pdf",
                              "content-disposition" => 'inline; filename="DHT22.pdf"',
                              "x-request-id" => "f599bc98-4f8b-4e32-b296-9c8307ff4eaf",
                              'x-runtime' => '12.0'}
                      ).finish
    rsp[2] # pluck the actual response
  end

end
