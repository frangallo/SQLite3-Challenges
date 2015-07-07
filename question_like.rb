class QuestionLike

  def self.find_by_id(id)
    like = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        question_likes
      WHERE
        id = ?
      SQL

    raise "Error, too many elements" if like.length > 1

    QuestionLike.new(like.first)
  end


  attr_accessor :author_id, :question_id
  attr_reader :id

  def initialize(options = {})
    @id = options['id']
    @author_id = options['author_id']
    @question_id = options['question_id']
  end
end
