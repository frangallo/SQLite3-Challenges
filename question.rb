class Question
  def self.find_by_id(id)
    question = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        questions
      WHERE
        id = ?
      SQL

    raise "Error, too many elements" if question.length > 1

    Question.new(question.first)
  end

  attr_accessor :title, :body, :author_id
  attr_reader :id

  def initialize(options = {})
    @id = options['id']
    @title = options['title']
    @body = options['body']
    @author_id = options['author_id']
  end
end
