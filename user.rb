class User

  def self.find_by_id(id)
    user = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        users
      WHERE
        id = ?
      SQL

    raise "Error, too many elements" if user.length > 1

    User.new(user.first)
  end

  def self.find_by_name(fname, lname)
    users = QuestionsDatabase.instance.execute(<<-SQL, fname, lname)
      SELECT
        *
      FROM
        users
      WHERE
        fname = ? AND lname = ?
      SQL

      users.map { |user| User.new(user) }

  end

  attr_accessor :lname, :fname
  attr_reader :id

  def initialize(options = {})
    @id = options['id']
    @fname = options[:fname]
    @lname = options[:lname]
  end

  def save
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

  def authored_questions
    Question.find_by_author_id(id)
  end

  def authored_replies
    Reply.find_by_author_id(id)
  end

  def followed_questions
    QuestionFollow.followed_questions_for_author_id(id)
  end

  def liked_questions
    QuestionLike::liked_questions_for_author_id(id)
  end

  def average_karma
    users = QuestionsDatabase.instance.execute(<<-SQL, id)
    SELECT
      (CAST(COUNT(ql.author_id) AS FLOAT) / COUNT(DISTINCT(q.id))) AS avg
    FROM
      questions q
    LEFT OUTER JOIN question_likes ql
      ON q.id = ql.question_id
    WHERE
      q.author_id = ?
    SQL

    users.first["avg"]
  end
end
