class Reply

  def self.find_by_id(id)
    reply = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        replies
      WHERE
        id = ?
      SQL

    raise "Error, too many elements" if reply.length > 1

    Reply.new(reply.first)
  end

  attr_accessor :author_id, :question_id, :parent_id, :body
  attr_reader :id

  def initialize(options = {})
    @id = options['id']
    @author_id = options['author_id']
    @question_id = options['question_id']
    @parent_id = options['parent_id']
    @body = options['body']
  end
end
