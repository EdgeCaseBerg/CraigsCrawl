#!/usr/bin/env ruby

require 'net/http'
require 'parser'
=begin
crawler.rb
:file
This class crawls the web and loads up the website then attempts to grab a bunch of data for the parser to take care of
We can specify how many pages we want simply by manipulating the url /apa/index/#00.html to get 1000 results really fast. 
http://burlington.craigslist.org/apa/index200.html
=end

		#GOD HELP ME I'M USING REVERSE INDENTATION
class Crawler
	attr_accessor :pagesToCrawl
	attr_accessor :host
	attr_accessor :basePage
	attr_accessor :startPage
	attr_accessor :currentResult
	attr_accessor :fileToWrite

	def initialize(pages=9,host='burlington.craigslist.org',base='/apa/index',start='/apa/index.html',fileName="dump.txt")
		@pagesToCrawl = pages
		@host = host
		@basePage =  base
		@startPage = start
		@currentResult = nil
		@fileToWrite = fileName
	end

	def crawl(page)
=begin
crawl
Crawls a single page.
:page The page to crawl 
=end
		@currentResult = Net::HTTP.get(@host, page)
	end

	def craigsCrawl()
=begin
craigsCrawl
This function crawls the base page first, then iterates through however many pages we've requested from craigslist.
:none No Parameters
=end

		#generate list of pages to be crawled
		pages = [@startPage,genPages()].flatten

		#Crawl each page and pass it to the parser (parser on todo list)
		allPostings = Array.new
		parser = Parser.new
		pages.each do |page|
			puts "Crawling " + page
			crawl(page)
			posts = parser.findPostings(@currentResult)
			posts.each{|post| allPostings << post}
		end

		writeDataSet(allPostings.flatten)
	end

	def genPages()
=begin
genPages
Generates an array of page names created from the basePage. The pages will be in the form of basePage100.html ... up to basePage(pagesToCrawl)00.html
:none No Parameters
=end
		pages = Array.new
		(1..(pagesToCrawl-1)).each{|i| pages << @basePage + i.to_s() + '00' + '.html'  }
		#Ruby probably wants me to just say pages and let it's magic handle it but I really do prefer an explicit return
		return pages
	end

	def writeDataSet(dataset=nil)
=begin 
writeDataSet
Writes data collected from crawls to the fileToWrite
:dataset The dataset to be written out
=end
		if( dataset != nil)
			fd = File.new (@fileToWrite,'a')
			dataset.each do |post|
				puts post.inspect
				fd.puts( post['title']+ ', ' + post['location'] )
			end
			fd.close()
		end

	end
	 
end
	


if __FILE__ == $0
	c = Crawler.new(pages=1)
	puts c.genPages()
	c.craigsCrawl()
end