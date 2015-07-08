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

  def self.likers_for_question_id(question_id)
    likers = QuestionsDatabase.instance.execute(<<-SQL, question_id)

    SELECT
      u.*
    FROM
      users u
    JOIN question_likes q
      ON u.id = q.author_id
    WHERE
      q.question_id = ?
    SQL

    likers.map {|liker| User.new(liker)}
  end

  def self.num_likes_for_question_id(question_id)
    num_likes = QuestionsDatabase.instance.execute(<<-SQL, question_id)

    SELECT
      COUNT(*)
    FROM
      question_likes q
    WHERE
      q.question_id = ?
    SQL

    num_likes.first["COUNT(*)"]
  end

  def self.liked_questions_for_author_id(author_id)
    liked_questions = QuestionsDatabase.instance.execute(<<-SQL, author_id)

    SELECT
      q.*
    FROM
      question_likes ql
    JOIN
      questions q
      ON q.id = ql.question_id
    WHERE
      ql.author_id = ?
    SQL

    liked_questions.map { |question| Question.new(question) }
  end

  def self.most_liked_questions(n)
    liked_questions = QuestionsDatabase.instance.execute(<<-SQL, n)

    SELECT
      q.*
    FROM
      questions q
    JOIN
      question_likes ql
      ON ql.question_id = q.id
    GROUP BY
      ql.question_id
    ORDER BY
      COUNT(ql.author_id)
    LIMIT
      ?
    SQL

      liked_questions.map {|liked_question| Question.new(liked_question)}
  end


  attr_accessor :author_id, :question_id
  attr_reader :id

  def initialize(options = {})
    @id = options['id']
    @author_id = options['author_id']
    @question_id = options['question_id']
  end

end
