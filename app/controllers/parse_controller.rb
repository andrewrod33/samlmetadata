class ParseController < ApplicationController
  
  def home
  end

  def upload
  	'require nokogiri'
  	uploaded_file = params[:file]
	file_content = uploaded_file.read
	doc = Nokogiri::XML(file_content)

	if doc.at_css('EntityDescriptor')
      xml2(doc)
	else
      xml1(doc)
	end
	end


  def xml1(doc)
	@acsTypeList = doc.xpath("//md:AssertionConsumerService//@Binding")
	@acsList = doc.xpath("//md:AssertionConsumerService//@Location")
	@sloList = doc.xpath("//md:SingleLogoutService//@Location").text.gsub("http", " http").split(" ")
	@audience = doc.root["entityID"]
	@attribute = doc.xpath("//md:Attribute//@Name").text
	@nameID = doc.xpath("//md:NameIDFormat").text.gsub("urn", "\nurn").split(" ")
	@acsFinal = []
	@acsUrlValidator = []
	@sloFinal = []

	for i in 0..@acsTypeList.length
	  if @acsTypeList[i].to_s == "urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST"
	  	@acsFinal.push(@acsList[i])
	  end
	end

	for i in 0..(@acsFinal.length - 1)
	  @acsUrlValidator.push("^" + @acsFinal[i].to_s.gsub(".","\\.").gsub("/","\\/").gsub("?","\\?") + ".*$")
	end
  end




  def xml2(doc)
  	doc.remove_namespaces!
	@acsTypeList = doc.xpath("//AssertionConsumerService//@Binding")
	@acsList = doc.xpath("//AssertionConsumerService//@Location")
	@sloList = doc.xpath("//SingleLogoutService//@Location").text.gsub("http", " http").split(" ")
	@audience = doc.root["entityID"]
	@attribute = doc.xpath("//Attribute//@Name").text
	@nameID = doc.xpath("//NameIDFormat").text.gsub("urn", "\nurn").split(" ")
	@acsFinal = []
	@acsUrlValidator = []
	@sloFinal = []

	puts "--" * 100
	puts @attribute

	for i in 0..@acsTypeList.length
	  if @acsTypeList[i].to_s == "urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST"
	  	@acsFinal.push(@acsList[i])
	  end
	end

	for i in 0..(@acsFinal.length - 1)
	  @acsUrlValidator.push("^" + @acsFinal[i].to_s.gsub(".","\\.").gsub("/","\\/").gsub("?","\\?") + ".*$")
	end
  end
end