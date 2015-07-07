require 'singleton'
require 'sqlite3'
require_relative 'question'
require_relative 'question_follow'
require_relative 'question_like'
require_relative 'reply'
require_relative 'user'

class QuestionsDatabase < SQLite3::Database
  include Singleton

  def initialize
    super('questions.db')

    self.results_as_hash = true
    self.type_translation = true
  end
end

if __FILE__ == $PROGRAM_NAME
  # test code goes here
end
