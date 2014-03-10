class AddDateToSurveyAnswers < ActiveRecord::Migration
  def change
    add_column :survey_answers, :date, :string
  end
end
