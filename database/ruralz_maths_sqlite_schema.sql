PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS topics (
  id INTEGER PRIMARY KEY,
  name TEXT NOT NULL UNIQUE,
  sort_order INTEGER NOT NULL UNIQUE,
  created_at TEXT
);
CREATE TABLE IF NOT EXISTS tests (
  id INTEGER PRIMARY KEY,
  topic_id INTEGER NOT NULL,
  test_number INTEGER NOT NULL,
  title TEXT NOT NULL,
  duration_minutes INTEGER NOT NULL DEFAULT 90,
  question_count INTEGER NOT NULL DEFAULT 50,
  created_at TEXT,
  FOREIGN KEY(topic_id) REFERENCES topics(id)
);
CREATE TABLE IF NOT EXISTS questions (
  id INTEGER PRIMARY KEY,
  test_id INTEGER NOT NULL,
  question_text TEXT NOT NULL,
  option_a TEXT NOT NULL,
  option_b TEXT NOT NULL,
  option_c TEXT NOT NULL,
  option_d TEXT NOT NULL,
  correct_option TEXT NOT NULL,
  explanation TEXT,
  source_type TEXT,
  source_year INTEGER,
  source_shift TEXT,
  difficulty TEXT,
  sort_order INTEGER NOT NULL,
  created_at TEXT,
  FOREIGN KEY(test_id) REFERENCES tests(id)
);
CREATE INDEX IF NOT EXISTS idx_tests_topic_id ON tests(topic_id);
CREATE INDEX IF NOT EXISTS idx_questions_test_id ON questions(test_id);
CREATE INDEX IF NOT EXISTS idx_questions_test_sort ON questions(test_id, sort_order);
