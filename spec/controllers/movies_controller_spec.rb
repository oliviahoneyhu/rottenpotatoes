require 'spec_helper'
require 'rails_helper'

describe MoviesController do
    describe 'happy path' do
        before :each do
            @m=double(Movie, :title => "Star Wars", :director => "director", :id => "1")
            Movie.stub(:find).with("1").and_return(@m)
        end
        
        it 'should generate route for similar movies' do
            expect(:post => movie_similar_path(1)).to route_to(:action => "similar", :controller => "movies", :movie_id => "1")
        end
        
        it 'should call the model method that finds similar movies' do
            fake_results = [double('Movie'), double('Movie')]
            expect(Movie).to receive(:same_directors).with('director').and_return(fake_results)
            get :similar, :movie_id => "1"
        end
        
        it 'should select the Similar template for rendering and show the results' do
            Movie.stub(:same_directors).with('director').and_return(@m)
            get :similar, :movie_id => "1"
            expect(response).to render_template('similar')
            assigns(:movies).should == @m
        end
    end
    
    describe 'sad path' do
        before :each do
            @m=double(Movie, :title => "Star Wars", :director => nil, :id => "1")
            Movie.stub(:find).with("1").and_return(@m)
        end
        
        it 'should generate route for similar movies' do
            expect(:post => movie_similar_path(1)).to route_to(:action => "similar", :controller => "movies", :movie_id => "1")
        end
        
        it 'should render the homepage and have a flash notice' do
            get :similar, :movie_id => "1"
            expect(response).to redirect_to(movies_path)
            expect(flash[:notice]).not_to be_blank
        end
    end
    
    describe 'create' do
        before :each do
            Movie.create(title: 'Star Wars', rating: 'PG', director: 'George Lucas', release_date: '1977-05-25')
            @movies = Movie.all
        end
        
        it 'should create a new movie' do
            movie = {title: 'THX-1138', director: 'George Lucas',rating: 'R', release_date: '1971-03-11'}
            post :create, movie: movie
            expect(flash[:notice]).to eq("#{movie[:title]} was successfully created.")
            expect(response).to redirect_to(movies_path)
            expect(@movies.count).to eq(2)
        end
    end
    
    describe 'destroy' do
        before :each do
            @m=double(Movie, :title => "Star Wars", :director => "director", :id => "10")
            Movie.stub(:find).with("10").and_return(@m)
        end
        
        it 'should destroy a movie' do
            expect(@m).to receive(:destroy)
            delete :destroy, :id => "10"
        end
    end
  
end