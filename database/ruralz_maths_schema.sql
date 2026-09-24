-- Ruralz Maths independent PostgreSQL/SQLite migration baseline
-- Generated from the current Supabase public schema.
-- This file is schema-only; question data export is a separate step.

CREATE TABLE IF NOT EXISTS topics (
  id BIGINT PRIMARY KEY,
  name TEXT NOT NULL UNIQUE,
  sort_order INTEGER NOT NULL UNIQUE,
  created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS tests (
  id BIGINT PRIMARY KEY,
  topic_id BIGINT NOT NULL REFERENCES topics(id),
  test_number INTEGER NOT NULL,
  title TEXT NOT NULL,
  duration_minutes INTEGER NOT NULL DEFAULT 90,
  question_count INTEGER NOT NULL DEFAULT 50,
  created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS questions (
  id BIGINT PRIMARY KEY,
  test_id BIGINT NOT NULL REFERENCES tests(id),
  question_text TEXT NOT NULL,
  option_a TEXT NOT NULL,
  option_b TEXT NOT NULL,
  option_c TEXT NOT NULL,
  option_d TEXT NOT NULL,
  correct_option CHAR(1) NOT NULL CHECK (correct_option IN ('A','B','C','D')),
  explanation TEXT,
  source_type TEXT NOT NULL DEFAULT 'original' CHECK (source_type IN ('original','pyq')),
  source_year INTEGER,
  source_shift TEXT,
  difficulty TEXT CHECK (difficulty IN ('easy','medium','hard')),
  sort_order INTEGER NOT NULL,
  created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_tests_topic_id ON tests(topic_id);
CREATE INDEX IF NOT EXISTS idx_questions_test_id ON questions(test_id);
CREATE INDEX IF NOT EXISTS idx_questions_test_sort ON questions(test_id, sort_order);

-- Optional result tables for a future online account/sync layer.
CREATE TABLE IF NOT EXISTS attempts (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL,
  test_id BIGINT NOT NULL REFERENCES tests(id),
  started_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
  submitted_at TIMESTAMPTZ,
  total_questions INTEGER DEFAULT 50,
  attempted INTEGER DEFAULT 0,
  correct INTEGER DEFAULT 0,
  wrong INTEGER DEFAULT 0,
  unattempted INTEGER DEFAULT 50,
  score NUMERIC DEFAULT 0,
  percentage NUMERIC DEFAULT 0,
  status TEXT DEFAULT 'in_progress' CHECK (status IN ('in_progress','submitted'))
);

CREATE TABLE IF NOT EXISTS attempt_answers (
  id BIGINT PRIMARY KEY,
  attempt_id TEXT NOT NULL REFERENCES attempts(id),
  question_id BIGINT NOT NULL REFERENCES questions(id),
  selected_option CHAR(1) CHECK (selected_option IN ('A','B','C','D')),
  marked_for_review BOOLEAN DEFAULT FALSE,
  is_correct BOOLEAN,
  answered_at TIMESTAMPTZ
);

-- Expected current content volume (verify before/after export):
-- topics: 15; tests: 300; questions: 15000.
