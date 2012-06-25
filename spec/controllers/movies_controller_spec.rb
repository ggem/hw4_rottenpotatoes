require 'spec_helper'

describe MoviesController do
  describe 'searching same director movies' do
    before :each do
      @movie = mock('movie1')
      @results = [mock('movie2'), mock('movie3'), mock('movie4')]
    end
    it "should find the movie we're talking about" do
      Movie.should_receive(:find).with("1").and_return(@movie)
      @movie.stub(:find_movies_with_same_director).and_return(@results)
      post :similar_movies, {:id => 1}
    end
    it "should find movies with the same director" do
      Movie.stub(:find).and_return(@movie)
      @movie.should_receive(:find_movies_with_same_director).and_return(@results)
      post :similar_movies, {:id => 1}
    end
    it "should render the 'similar movies' page" do
      Movie.stub(:find).and_return(@movie)
      @movie.stub(:find_movies_with_same_director).and_return(@results)
      post :similar_movies, {:id => 1}
      response.should render_template 'similar_movies'
    end
    it "should make the movies available to the template" do
      Movie.stub(:find).and_return(@movie)
      @movie.stub(:find_movies_with_same_director).and_return(@results)
      post :similar_movies, {:id => 1}
      assigns(:movie).should == @movie
      assigns(:movies).should == @results
    end
  end

  describe 'index should show all the movies' do
    before :each do
      @ratings = Movie.all_ratings
      @ratings_hash = @ratings.inject({}){|h, x| h.merge(x => "1")}
    end
    it 'should make the movies available to the template' do
      Movie.should_receive(:find_all_by_rating).and_return([1,2,3])
      session[:sort] = 'title'
      session[:ratings] = @ratings_hash
      post :index, session
      assigns(:movies).should == [1, 2, 3]
    end
    it 'should sort the movies by title when necessary' do
      Movie.should_receive(:find_all_by_rating).with(@ratings, {:order => :title})
      session[:sort] = 'title'
      session[:ratings] = @ratings_hash
      post :index, session
    end
    it 'should sort the movies by release_date when necessary' do
      Movie.should_receive(:find_all_by_rating).with(@ratings, {:order => :release_date})
      session[:sort] = 'release_date'
      session[:ratings] = @ratings_hash
      post :index, session
    end
    it 'should update the session when sorting changes' do
      session[:sort] = 'release_date'
      session[:ratings] = @ratings_hash
      post :index, {:sort => 'title', :ratings => @ratings_hash}
      session[:sort].should == 'title'
    end
    it 'should update the session when ratings changes' do
      session[:sort] = 'title'
      session[:ratings] = {}
      post :index, {:sort => 'title', :ratings => @ratings_hash}
      session[:ratings].should == @ratings_hash
    end
  end

  describe 'show should show information about a movie' do
    it 'should make the movie available to the template' do
      Movie.stub(:find).and_return(@movie)
      post :show, {:id => 1}
      assigns(:movie).should == @movie
    end
  end

  describe 'create should create movies' do
    it 'should' do
      movie = mock('movie')
      movie.stub(:title).and_return('this movie')
      Movie.should_receive(:create!).with("params").and_return(movie)
      post :create, :movie => "params"
    end
  end

  describe 'destroy should delete movies' do
    it 'should' do
      movie = mock('movie')
      movie.stub(:title).and_return('this movie')
      movie.should_receive(:destroy)
      Movie.should_receive(:find).with("1").and_return(movie)
      post :destroy, :id => 1
    end
  end
end
