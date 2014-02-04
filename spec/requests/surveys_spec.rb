require 'spec_helper'

describe "Surveys API" do

  describe "GET /surveys" do
    it "returns all the survey results" do
      FactoryGirl.create :survey, mood: "Good"
      FactoryGirl.create :survey, mood: "Bad"

      get "/surveys", {}, { "Accept" => "application/json" }

      expect(response.status).to eq 200

      body = JSON.parse(response.body)
      survey_moods = body.map { |m| m["mood"] }

      expect(survey_moods).to match_array(["Good",
                                           "Bad"])
    end
  end
end