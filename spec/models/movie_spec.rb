require 'spec_helper'

describe Movie do
  describe 'searching same director movies' do
    it 'should find movies with the same director' do
      movies_info = [["title 0", "director 0"],
                     ["title 1", "director 0"],
                     ["title 2", "director 0"],
                     ["title 3", "director 1"],
                     ["title 4", "director 1"],
                     ["title 5", "director 2"]]
      movies = movies_info.map do |title, director|
         Movie.create(:title => title, :director => director)
      end
      movies[0].find_movies_with_same_director.map(&:title).should == ["title 0", "title 1", "title 2"]
      movies[3].find_movies_with_same_director.map(&:title).should == ["title 3", "title 4"]
      movies[5].find_movies_with_same_director.map(&:title).should == ["title 5"]
    end

    it "should return nil when movie doesn't have a director" do
      Movie.create(:title => 'title').find_movies_with_same_director.should == nil
    end
  end
end
