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


  def self.followers_for_question_id(question_id)
    users = QuestionsDatabase.instance.execute(<<-SQL, question_id)

    SELECT
      u.*
    FROM
      question_follows q
    JOIN users u
      ON q.author_id = u.id
    WHERE
      question_id = ?
    SQL

    users.map { |user| User.new(user) }
  end

  def self.followed_questions_for_author_id(author_id)
    questions = QuestionsDatabase.instance.execute(<<-SQL, author_id)

    SELECT
      q.*
    FROM
      question_follows qf
    JOIN  questions q
      ON qf.question_id = q.id
    WHERE
      q.author_id = ?
    SQL

    questions.map { |question| Question.new(question) }
  end

  def self.most_followed_questions(n)
    questions = QuestionsDatabase.instance.execute(<<-SQL,n)

    SELECT
      q.*
    FROM
      question_follows qf
    JOIN  questions q
      ON qf.question_id = q.id
    GROUP BY
      q.id
    ORDER BY
      COUNT(qf.author_id)
    LIMIT
      ?
    SQL

    questions.map { |question| Question.new(question) }

  end



  attr_accessor :author_id, :question_id
  attr_reader :id

  def initialize(options = {})
    @id = options['id']
    @author_id = options['author_id']
    @question_id = options['question_id']
  end
end
