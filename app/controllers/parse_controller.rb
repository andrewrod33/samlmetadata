class ParseController < ApplicationController
  
  def home
  end

  def upload
  	'require nokogiri'
  	uploaded_file = params[:file]
	file_content = uploaded_file.read

	doc = Nokogiri::XML(file_content)
	# f.close

	@acsTypeList = doc.xpath("//md:AssertionConsumerService//@Binding")
	@acsList = doc.xpath("//md:AssertionConsumerService//@Location")
	@sloList = doc.xpath("//md:SingleLogoutService//@Location").text.gsub("http", "\nhttp")
	@audience = doc.root["entityID"]
	@nameID = doc.xpath("//md:NameIDFormat").text.gsub("urn", "\nurn")

	@acsFinal = []
	@acsUrlValidator = []

	puts "Consumer URL/ACS URL"
	for i in 0..@acsTypeList.length
	  if @acsTypeList[i].to_s == "urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST"
	  	@acsFinal.push(@acsList[i])
	  	puts @acsList[i]
	  end
	end


	puts "ACS URL Validator:"
	for i in 0..@acsFinal.length
	  @acsUrlValidator.push("^" + @acsFinal[i].to_s.gsub(".","\\.").gsub("/","\\/").gsub("?","\\?") + ".*$")
	end
	
	  end
	end
