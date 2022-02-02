require "sinatra"
require "sinatra/reloader"
require "tilt/erubis"

before do
  @table_of_contents = File.readlines("data/toc.txt")
end

helpers do
  def chapter_content(num)
    File.read("data/chp#{num}.txt")
  end

  def in_paragraphs(chpter_content)
    chpter_content.split("\n\n")
  end

  def highlight(paragraph, search_term)
    paragraph.gsub(search_term, %(<strong>#{search_term}</strong>))
  end
end

not_found do
  redirect "/"
end

get "/" do  # assign a route to the "/" URL
  File.read "public/template.html"  # Sinatra executes the body of this block & the return value is sent to the user's browser
  @title = "The Adventures of Sherlock Holmes"

  erb :home
end

get "/chapters/:number" do
  chp_number = params[:number].to_i
  chp_name = @table_of_contents[chp_number - 1]

  redirect "/" unless (1..@table_of_contents.size).cover? chp_number
  @title = "Chapter #{chp_number}: #{chp_name}"

  @chapter_contents = chapter_content(chp_number)

  erb :chapter
end

get "/search" do
  @search_term = params[:query]

  # create hash whose:
  #   > keys are integers that represent the chapter numbers that contain
  #       at least one paragraph with the searched term
  #   > values are hashes where each subhash has one key/value pair where the
  #      key represents the paragraph's integer index (corresponds with the
  #      paragraph id attribute) and where each subhash's key's corresponding
  #      value is the paragraph content
  @chptr_and_matching_paragraphs = [1,2,3].each_with_object({}) do |num, hash|
    chapter = chapter_content(num)
    if @search_term.nil? == false && chapter.include?(@search_term)
      in_paragraphs(chapter).each_with_index do |p, index|
        if p.include?(@search_term)
          if hash.keys.include?(num)
            hash[num] << {index => p }
          else
            hash[num] = [{index => p}]
          end
        end
      end
    end
  end
  
  @relevant_chp_nums = @chptr_and_matching_paragraphs.keys

  erb :search_form
end
