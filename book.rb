require "sinatra"
require "sinatra/reloader"
require 'tilt/erubis'

before do
  @chapters = File.readlines("data/toc.txt")
end

helpers do
  def slugify(text)
    text.downcase.gsub(/\s+/, "-").gsub(/[^\w-]/, "")
  end

  def in_paragraphs(text)
    result = ""
    text.split("\n\n").map do |line|
      result << "<p>#{line}</p>"
    end
    result
  end
end

get "/" do
  @title = "Books, Y'all!"

  erb :home
end

get "/chapters/:number" do
  number = params[:number].to_i
  chapter_name = @chapters[number - 1]
  @title = "Chapter #{number}: #{chapter_name}"

  @chapter_content = File.read("data/chp#{number}.txt")

  erb :chapter
end

get "/show/:name" do
  params[:name]
end
