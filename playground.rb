# @title = "Books, Y'all!"
# @chapters = IO.readlines("data/toc.txt")
# @chapters.each do |chapter|
#   puts chapter
# end

def in_paragraphs(text)
  result = ""
  text.split("\n\n").each do |line|
    result << "<p>#{line}</p>"
  end
  result
end
chapter_content = File.read("data/chp1.txt")

result = in_paragraphs(chapter_content)
p result
