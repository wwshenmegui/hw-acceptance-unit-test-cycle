require 'rails_helper'

describe Movie do
    describe '.find_with_same_director' do
        let!(:movie1) { FactoryGirl.create(:movie, title: 'Star Wars', director: 'George Lucas') }
        let!(:movie2) { FactoryGirl.create(:movie, title: 'Blade Runner', director: 'Ridley Scott') }
        let!(:movie3) { FactoryGirl.create(:movie, title: "THX-1138", director: 'George Lucas') }
        let!(:movie4) { FactoryGirl.create(:movie, title: "Alien") }
        
        context 'director exists' do
            it 'find movies with same director correctly' do
                expect(Movie.find_with_same_director(movie1.director)).to include(movie1,movie3)
                expect(Movie.find_with_same_director(movie1.director)).to_not include(movie2)
                expect(Movie.find_with_same_director(movie2.director)).to include(movie2)
            end
        end
        
        context 'director does not exists' do
            it 'handles sad path' do
                expect(Movie).to receive(:where).with(director: movie4.director).and_return(nil)
                Movie.find_with_same_director movie4.director
            end
        end
    end
    
    describe '.all_ratings' do
        it 'return all ratings' do
            expect(Movie.all_ratings).to match(%w(G PG PG-13 NC-17 R))
        end
    end
end