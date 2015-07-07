DROP TABLE IF EXISTS users;

CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname VARCHAR(255) NOT NULL,
  lname VARCHAR(255) NOT NULL
);

DROP TABLE IF EXISTS questions;

CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  body TEXT NOT NULL,
  author_id INTEGER NOT NULL,

  FOREIGN KEY (author_id) REFERENCES users(id)
);

DROP TABLE IF EXISTS question_follows;

CREATE TABLE question_follows (
  id INTEGER PRIMARY KEY,
  author_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,
  FOREIGN KEY (author_id) REFERENCES users(id)
  FOREIGN KEY (question_id) REFERENCES questions(id)
);

DROP TABLE IF EXISTS replies;

CREATE TABLE replies (
  id INTEGER PRIMARY KEY,
  question_id INTEGER NOT NULL,
  parent_id INTEGER,
  author_id INTEGER NOT NULL,
  body TEXT NOT NULL,

  FOREIGN KEY (author_id) REFERENCES users(id)
  FOREIGN KEY (question_id) REFERENCES questions(id)
  FOREIGN KEY (parent_id) REFERENCES replies(id)
);

DROP TABLE IF EXISTS question_likes;

CREATE TABLE question_likes (
  id INTEGER PRIMARY KEY,
  author_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,
  FOREIGN KEY (author_id) REFERENCES users(id)
  FOREIGN KEY (question_id) REFERENCES questions(id)
);

INSERT INTO
  users(fname, lname)
VALUES
  ("Dough", "Funny"), ("Frank", "Stevens"), ("Michael", "Smith");

INSERT INTO
  questions(title, body, author_id)
VALUES
  ("Weather?", "What is the weather going to be?", 1),
  ("Time?", "What is the time?", 2),
  ("Favorite food?", "What is your favorite food?", 2);

INSERT INTO
  replies(question_id, parent_id, author_id, body)
VALUES
  (1, null, 3, "Cloudy"),
  (1, 1, 2, "No, actually sunny?"),
  (2, null, 1, "6:30");

INSERT INTO
  question_follows(question_id, author_id)
VALUES
  (2,3),
  (3,3),
  (2,2);

INSERT INTO
  question_likes(question_id, author_id)
VALUES
  (1,2),
  (1,3),
  (2,2);
