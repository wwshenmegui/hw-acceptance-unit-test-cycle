require 'rails_helper'

describe MoviesController do
    describe 'Search movies by the same director' do
        let!(:movie1) { FactoryGirl.create(:movie, title: 'Star Wars', director: 'George Lucas') }
        let!(:movie2) { FactoryGirl.create(:movie, title: 'Blade Runner', director: 'Ridley Scott') }
        let!(:movie3) { FactoryGirl.create(:movie, title: "THX-1138", director: 'George Lucas') }
        let!(:movie4) { FactoryGirl.create(:movie, title: "Alien") }
        
        it 'should call Movie.find_with_same_director' do
            expect(Movie).to receive(:find_with_same_director).with('George Lucas')
            get :search, {title: 'Star Wars'}
        end
        
        it 'should assign similar movies if director exists' do
            movies=[movie1,movie3]
            Movie.stub(:find_with_same_director).with('George Lucas').and_return(movies)
            get :search, {title: 'Star Wars'}
            expect(assigns(:movies)).to include(movie1,movie3)
        end
        
        it 'should redirect to home page if director does not exist' do
            Movie.stub(:find_with_same_director).with(nil).and_return(nil)
            get :search, {title: 'Alien'}
            expect(response).to redirect_to(movies_path)
        end
    end
    
    describe 'GET index' do
        let!(:movie) {FactoryGirl.create(:movie)}
        
        it 'should render the index template' do
            get :index
            expect(response).to render_template('index')
        end
        
        it 'should assign instance variable for title header' do
            get :index, {sort: 'title'}
            expect(assigns(:title_header)).to eql('hilite')
        end
        
        it 'should assign instance variable for release_date' do
            get :index, {sort: 'release_date'}
            expect(assigns(:date_header)).to eql('hilite')
        end
    end
    
    describe 'GET new' do
        let!(:movie) { Movie.new }
    
        it 'should render the new template' do
          get :new
          expect(response).to render_template('new')
    end
    
    describe 'POST #create' do
        it 'creates a new movie' do
          expect {post :create, movie: FactoryGirl.attributes_for(:movie)
          }.to change { Movie.count }.by(1)
        end
    
        it 'redirects to the movie index page' do
          post :create, movie: FactoryGirl.attributes_for(:movie)
          expect(response).to redirect_to(movies_url)
        end
    end
    
    describe 'GET #show' do
        let!(:movie) {FactoryGirl.create(:movie)}
        before(:each) do
            get :show,id: movie.id
        end
        
        it 'should find the movie' do
            expect(assigns(:movie)).to eql(movie)
        end
        
        it 'should render the show template' do
            expect(response).to render_template('show')
        end
    end
    
    describe 'GET #edit' do
        let!(:movie) { FactoryGirl.create(:movie) }
        before do
          get :edit, id: movie.id
        end
    
        it 'should find the movie' do
          expect(assigns(:movie)).to eql(movie)
        end
    
        it 'should render the edit template' do
          expect(response).to render_template('edit')
        end
    end
     
    describe 'PUT #update' do
        let(:movie1) { FactoryGirl.create(:movie) }
        before(:each) do
          put :update, id: movie1.id, movie: FactoryGirl.attributes_for(:movie, title: 'Modified')
        end
    
        it 'updates an existing movie' do
          movie1.reload
          expect(movie1.title).to eql('Modified')
        end
    
        it 'redirects to the movie page' do
          expect(response).to redirect_to(movie_path(movie1))
        end
    end 
    
    describe 'DELETE #destroy' do
        let!(:movie1) { FactoryGirl.create(:movie) }
    
        it 'destroys a movie' do
          expect { delete :destroy, id: movie1.id
          }.to change(Movie, :count).by(-1)
        end
    
        it 'redirects to movies#index after destroy' do
          delete :destroy, id: movie1.id
          expect(response).to redirect_to(movies_path)
        end
    end
    
  end
    
end