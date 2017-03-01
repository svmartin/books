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
end # end helpers

# Calls the block for each chapter, passing that chapter's number, name, and
# contents.
def each_chapter(&block)
  @chapters.each_with_index do |name, index|
    number = index + 1
    chp_contents = File.read("data/chp#{number}.txt")
    yield(number, name, chp_contents)
  end
end

# This method returns an Array of Hashes representing chapters that match the
# specified query. Each Hash contain values for its :name and :number keys.
def chapters_matching(query)
  results = []

  return results unless query

  each_chapter do |number, name, chp_contents|
    results << {number: number, name: name} if chp_contents.include?(query)
  end

  results # returns an array of hashes
end

get "/search" do
  @results = chapters_matching(params[:query])
  erb :search
end

not_found do
  redirect "/"
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
