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
    super('questions')

    self.results_as_hash = true
    self.type_translation = true
  end

  def save(*variables)
    if id.nil?
      QuestionsDatabase.instance.execute(<<-SQL, fname, lname)
      INSERT INTO
        users(fname, lname)
      VALUES
        (?, ?)
      SQL
      @id = QuestionsDatabase.instance.last_insert_row_id
    else
      QuestionsDatabase.instance.execute(<<-SQL, fname, lname, id)
      UPDATE
        users
      SET
        fname = ?,
        lname = ?
      WHERE
        id = ?
      SQL
      end
  end
end

if __FILE__ == $PROGRAM_NAME
   a = User.find_by_id(2)
   p a.instance_variables

end
