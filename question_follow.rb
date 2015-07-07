class QuestionFollow
  def self.find_by_id(id)
    follow = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        question_follows
      WHERE
        id = ?
      SQL

    raise "Error, too many elements" if follow.length > 1

    QuestionFollow.new(follow.first)
  end


  attr_accessor :author_id, :question_id
  attr_reader :id

  def initialize(options = {})
    @id = options['id']
    @author_id = options['author_id']
    @question_id = options['question_id']
  end
end
