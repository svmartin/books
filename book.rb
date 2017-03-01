require "sinatra"
require "sinatra/reloader" if development?
require 'tilt/erubis'

before do
  @chapters = File.readlines("data/toc/toc.txt")
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

not_found do
  redirect "/"
end

get "/search" do
  erb :search
end

get "/" do
  @title = "Books, Y'all!"

  erb :home
end

get "/chapters/:number" do
  number = params[:number].to_i
  file_path = "data/chp#{number}"
  redirect("/") unless File.exist?("#{file_path}.txt")

  chapter_name = @chapters[number - 1]
  @title = "Chapter #{number}: #{chapter_name}"
  @chapter_content = File.read("#{file_path}.txt")

  erb :chapter
end

get "/show/:name" do
  params[:name]
end
