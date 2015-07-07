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

  attr_accessor :id, :lname, :fname

  def initialize(options = {})
    @id = options['id']
    @fname = options['fname']
    @lname = options['lname']
  end
end
