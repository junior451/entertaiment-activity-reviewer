require 'rails_helper'

RSpec.describe "Movies", type: :request do
  let(:user1) { User.create(username:"Jay144", email:"jay1@gmail.com", password:"pass44") }

  before do
    Movie.create(title:"First Movie", thoughts:"it was good", rating:3, is_current:false, user:user1)
    Movie.create(title:"Second Movie", thoughts:"it was great", rating:5, is_current:true, user:user1)
  end

  describe "GET /movies" do
    before { get "/movies" }

    it "returns all movies" do
      expect(JSON.parse(response.body)).to eq(JSON.parse(Movie.all.to_json))
      expect(JSON.parse(response.body).size).to eq(Movie.count)
    end

    it "assigns all movies to the @movies variable" do
      expect(assigns(:movies)).to eq(Movie.all)
    end

    it "returns the correct status" do
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /movie/:id" do
    context "With Valid ID" do
      before { get "/movie/#{Movie.last.id}" }
  
      it "returns a movie based on its ID" do
        movie = Movie.last
  
        expect(JSON.parse(response.body)).to eq(JSON.parse(movie.to_json))
      end
  
      it "assigns the movie to @movie variable" do
        expect(assigns(:movie)).to eq(Movie.last)
      end
  
      it "returns the correct response" do
        expect(response).to have_http_status(:success)
      end
    end

    context "With Invalid ID" do
      before { get "/movie/invalid_id" }

      it "returns the correct error message" do
        expect(response.body).to include("Movie does not exist")
      end

      it "returns the correct status code" do
        expect(response).to have_http_status(404)
      end
    end
  end

  describe "POST /movies" do
    context "With Valid Params" do
      let(:movie_info) { { movie: { title:"Third Movie", thoughts:"Not bad actually", rating: 3, is_current: false, user_id: user1.id } } }

      before { post '/movies', params: movie_info }

      it "Saves the a new movie in the database" do
        saved_movie = Movie.last
        expect(JSON.parse(response.body)).to eq(JSON.parse(saved_movie.to_json))
      end

      it "returns the correct response" do
        expect(response).to have_http_status(:created)
      end
    end

    context "When the movie is set to be the current movie" do
      let(:movie_info) { { movie: { title:"Current Movie", thoughts:"Not bad actually", rating: 3, is_current: true, user_id: user1.id } } }
      
      before { post '/movies', params: movie_info }

      it "sets the movie to be the only current movie" do
        movie = Movie.last
      
        expect(movie.is_current).to be true
        expect(Movie.where(is_current: true).count).to eq(1)
      end
    end
    
    context "With Invalid Params" do
      context "When params values are below the min characters allowed" do
        let(:movie_info) { { movie: { title:"TF", thoughts:"Not", rating: 0, is_current: true } } }
  
        before { post '/movies', params: movie_info }
  
        
        it "returns error messages" do
          expect(JSON.parse(response.body)).to include("Title is too short (minimum is 3 characters)")
          expect(JSON.parse(response.body)).to include("Thoughts is too short (minimum is 5 characters)")
          expect(JSON.parse(response.body)).to include("Rating is not included in the list")
          expect(JSON.parse(response.body)).to include("User must exist", "User can't be blank")
        end
      end

      context "When params values are above the max characters allowed" do
        let(:movie_info) { { movie: { title:"x"*26, thoughts:"x"*101, rating: 9, is_current: true } } }
  
        before { post '/movies', params: movie_info }
  
        it "returns error messages" do
          expect(JSON.parse(response.body)).to include("Title is too long (maximum is 25 characters)")
          expect(JSON.parse(response.body)).to include("Thoughts is too long (maximum is 100 characters)")
          expect(JSON.parse(response.body)).to include("Rating is not included in the list")
        end
      end
    end
  end

  describe "put /movies/:id" do
    context "With valid params" do
      let(:movie_update_info) { { movie: { title:"Updated Title", thoughts:"Updated thoughts", rating:3, is_current: false } } }

      before { put "/movies/#{Movie.last.id}", params: movie_update_info }

      it "Updates the movie associated with the ID" do
        movie = Movie.last
        expect(JSON.parse(response.body)).to eq(JSON.parse(movie.to_json))
      end

      it "returns the correct response" do
        expect(response).to have_http_status(:success)
      end
    end

    context "when movie is set to true to be the current movie" do
      let(:movie_update_info) { { movie: { title:"Updated Title", thoughts:"Updated thoughts", rating:3, is_current: true } } }

      before { put "/movies/#{Movie.first.id}", params: movie_update_info }

      it "should set the movie to be the only current movie" do
        expect(Movie.first.is_current).to be true
        expect(Movie.where(is_current: true).count).to eq(1)
      end

      it "should return the correct response" do
        expect(response).to have_http_status(:success)
      end
      
    end

    context "With invalid params" do
      context "With an invalid ID" do
        let(:movie_update_info) { { movie: { title:"Updated Title", thoughts:"Updated thoughts", rating:3, is_current: true } } }
  
        before { put "/movies/invalid_id", params: movie_update_info }

        it "should raise an invalid id error" do
          expect(JSON.parse(response.body)).to eq({"error"=>"Movie does not exist"})
        end

        it "returns the correct status code" do
          expect(response).to have_http_status(404)
        end
      end

      context "When params values are below the minimum allowed" do
        let(:movie_update_info) { { movie: { title:"Up", thoughts:"Yes", rating:0, is_current: true } } }
        let(:last_movie_before_update) { Movie.last }
  
        before { put "/movies/#{Movie.last.id}", params: movie_update_info }

        it "should return the correct response" do
          expect(JSON.parse(response.body)).to include("Title is too short (minimum is 3 characters)")
          expect(JSON.parse(response.body)).to include("Thoughts is too short (minimum is 5 characters)")
          expect(JSON.parse(response.body)).to include("Rating is not included in the list")
        end

        it "should return the correct status" do
          expect(response).to have_http_status(422)
        end

        it "should not save to the database" do
          last_movie_after_update = Movie.last

          expect(last_movie_before_update).to eq(last_movie_after_update)
        end
      end

      context "When params values are above the maximum allowed" do
        let(:movie_update_info) { { movie: { title:"x"*26, thoughts:"X"*101, rating:9, is_current: true } } }
        let(:last_movie_before_update) { Movie.last }
  
        before { put "/movies/#{Movie.last.id}", params: movie_update_info }

        it "should return the correct response" do
          expect(JSON.parse(response.body)).to include("Title is too long (maximum is 25 characters)")
          expect(JSON.parse(response.body)).to include("Thoughts is too long (maximum is 100 characters)")
          expect(JSON.parse(response.body)).to include("Rating is not included in the list")
        end

        it "should return the correct status" do
          expect(response).to have_http_status(422)
        end

        it "should not save to the database" do
          last_movie_after_update = Movie.last

          expect(last_movie_before_update).to eq(last_movie_after_update)
        end
      end
    end
  end

  describe "DELETE /movies/:id" do
    context "With valid ID" do
      before { delete "/movies/#{Movie.last.id}"}

      it "deletes the movie based on its ID" do
        expect(response.body).to include("Movie Successfully Deleted")
      end

      it "returns a success response status" do
        expect(response).to have_http_status(200)
      end
    end

    context "With invalid ID" do
      before { delete "/movies/invalid_id"}

      it "returns the correct error message" do
        expect(response.body).to include("Movie does not exist")
      end

      it "returns the correct status code" do
        expect(response).to have_http_status(404)
      end
    end
  end
end