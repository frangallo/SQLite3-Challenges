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

  def self.find_by_author_id(author_id)
    replies = QuestionsDatabase.instance.execute(<<-SQL, author_id)
      SELECT
        *
      FROM
        replies
      WHERE
        author_id = ?
      SQL

      replies.map{ |reply| Reply.new(reply) }
  end

  def self.find_by_question_id(question_id)
    replies = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        *
      FROM
        replies
      WHERE
        question_id = ?
      SQL

      replies.map{ |reply| Reply.new(reply) }
  end

  def self.find_by_parent_id(parent_id)
    replies = QuestionsDatabase.instance.execute(<<-SQL, parent_id)
      SELECT
        *
      FROM
        replies
      WHERE
        parent_id = ?
      SQL

      replies.map{ |reply| Reply.new(reply) }
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

  def save
    if id.nil?
      QuestionsDatabase.instance.execute(<<-SQL, author_id, question_id, parent_id, body)
      INSERT INTO
        replies(author_id, question_id, parent_id, body)
      VALUES
        (?, ?, ?, ?)
      SQL
      @id = QuestionsDatabase.instance.last_insert_row_id
    else
      QuestionsDatabase.instance.execute(<<-SQL, author_id, question_id, parent_id, body, id)
      UPDATE
        replies
      SET
        author_id = ?,
        question_id = ?,
        parent_id = ?,
        body = ?
      WHERE
        id = ?
      SQL
      end
  end

  def author
    User.find_by_id(author_id)
  end

  def question
    Question.find_by_id(question_id)
  end

  def parent_reply
    Reply.find_by_id(parent_id)
  end

  def child_replies
    Reply.find_by_parent_id(id)
  end
end
