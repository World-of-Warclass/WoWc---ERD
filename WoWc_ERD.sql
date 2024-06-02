-- World of Warclass ERD

CREATE TABLE institutions (
    id SERIAL NOT NULL PRIMARY KEY,
    name VARCHAR(60) NOT NULL,
    email VARCHAR(320) NOT NULL UNIQUE,
    phone_number INT NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

CREATE TABLE users (
    id SERIAL NOT NULL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    paternal_surname VARCHAR(50) NOT NULL,
    maternal_surname VARCHAR(50) NOT NULL,
    email VARCHAR(320) NOT NULL UNIQUE,
    username VARCHAR(30) NOT NULL UNIQUE,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

CREATE TABLE teachers (
    id SERIAL NOT NULL PRIMARY KEY,
    user_id INT NOT NULL,
    institution_id INT NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    CONSTRAINT fk_teachers_user_id FOREIGN KEY (user_id) REFERENCES users (id),
    CONSTRAINT fk_teachers_institution_id FOREIGN KEY (institution_id) REFERENCES institutions (id)
);

CREATE TABLE courses (
    id SERIAL NOT NULL PRIMARY KEY,
    name VARCHAR(60) NOT NULL,
    description TEXT NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

CREATE TABLE inscriptions (
    id SERIAL NOT NULL PRIMARY KEY,
    user_id INT NOT NULL,
    course_id INT NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    CONSTRAINT fk_inscriptions_user_id FOREIGN KEY (user_id) REFERENCES users (id),
    CONSTRAINT fk_inscriptions_course_id FOREIGN KEY (course_id) REFERENCES courses (id)
);

CREATE TABLE quests (
    id SERIAL NOT NULL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    description TEXT NOT NULL,
    experience_reward INT NULL,
    gold_reward INT NULL,
    course_id INT NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    CONSTRAINT fk_quests_course_id FOREIGN KEY (course_id) REFERENCES courses (id)
);

CREATE TABLE teachers_courses (
    id SERIAL NOT NULL PRIMARY KEY,
    teacher_id INT NOT NULL,
    course_id INT NOT NULL,
    CONSTRAINT fk_teachers_courses_teacher_id FOREIGN KEY (teacher_id) REFERENCES teachers (id),
    CONSTRAINT fk_teachers_courses_course_id FOREIGN KEY (course_id) REFERENCES courses (id)
);

CREATE TABLE teachers_courses_quests (
    id SERIAL NOT NULL PRIMARY KEY,
    teacher_course_id INT NOT NULL,
    quest_id INT NOT NULL,
    CONSTRAINT fk_teachers_courses_quests_teacher_course_id FOREIGN KEY (teacher_course_id) REFERENCES teachers_courses (id),
    CONSTRAINT fk_teachers_courses_quests_quest_id FOREIGN KEY (quest_id) REFERENCES quests (id)
);

CREATE TABLE groups (
    id SERIAL NOT NULL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    course_id INT NOT NULL,
    CONSTRAINT fk_groups_course_id FOREIGN KEY (course_id) REFERENCES courses (id)
);

CREATE TABLE classes (
    id SERIAL NOT NULL PRIMARY KEY,
    name VARCHAR(20) NOT NULL,
    health INT NOT NULL,
    energy INT NOT NULL
);

-- Add index to classes table
CREATE INDEX idx_classes_name ON classes(name);

CREATE TABLE characters (
    id SERIAL NOT NULL PRIMARY KEY,
    name VARCHAR(20) NOT NULL,
    experience INT DEFAULT 0 NOT NULL,
    gold INT DEFAULT 0 NOT NULL,
    energy INT DEFAULT 0 NOT NULL,
    group_id INT NULL,
    class_id INT NOT NULL,
    inscription_id INT NOT NULL,
    appearance JSON NOT NULL,
    CONSTRAINT fk_characters_group_id FOREIGN KEY (group_id) REFERENCES groups (id),
    CONSTRAINT fk_characters_class_id FOREIGN KEY (class_id) REFERENCES classes (id),
    CONSTRAINT fk_characters_inscription_id FOREIGN KEY (inscription_id) REFERENCES inscriptions (id)
);

CREATE TABLE characters_quests (
    id SERIAL NOT NULL PRIMARY KEY,
    quest_id INT NOT NULL,
    character_id INT NOT NULL,
    CONSTRAINT fk_characters_quests_quest_id FOREIGN KEY (quest_id) REFERENCES quests (id),
    CONSTRAINT fk_characters_quests_character_id FOREIGN KEY (character_id) REFERENCES characters (id)
);

CREATE TABLE quests_history (
    id SERIAL NOT NULL PRIMARY KEY,
    course_id INT NOT NULL,
    character_quest_id INT NOT NULL,
    sum_experience INT,
    sum_gold INT,
    CONSTRAINT fk_quests_history_course_id FOREIGN KEY (course_id) REFERENCES courses (id),
    CONSTRAINT fk_quests_history_character_quest_id FOREIGN KEY (character_quest_id) REFERENCES characters_quests (id)
);

-- Add indices to quests_history table
CREATE INDEX idx_quests_history_course_id ON quests_history(course_id);
CREATE INDEX idx_quests_history_character_quest_id ON quests_history(character_quest_id);

CREATE TABLE skills (
    id SERIAL NOT NULL PRIMARY KEY,
    name VARCHAR(30) NOT NULL,
    description TEXT NOT NULL,
    energy_cost INT NOT NULL,
    required_level INT NOT NULL,
    class_id INT NOT NULL,
    CONSTRAINT fk_skills_class_id FOREIGN KEY (class_id) REFERENCES classes (id)
);

CREATE TABLE events (
    id SERIAL NOT NULL PRIMARY KEY,
    name VARCHAR(30) NOT NULL,
    description TEXT NOT NULL,
    experience INT,
    gold INT,
    health INT,
    energy INT,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

-- Add index to events table
CREATE INDEX idx_events_name ON events(name);

CREATE TABLE teachers_courses_events (
    id SERIAL NOT NULL PRIMARY KEY,
    teacher_course_id INT NOT NULL,
    event_id INT NOT NULL,
    CONSTRAINT fk_teachers_courses_events_teacher_course_id FOREIGN KEY (teacher_course_id) REFERENCES teachers_courses (id),
    CONSTRAINT fk_teachers_courses_events_event_id FOREIGN KEY (event_id) REFERENCES events (id)
);

CREATE TABLE characters_events (
    id SERIAL NOT NULL PRIMARY KEY,
    event_id INT NOT NULL,
    character_id INT NOT NULL,
    CONSTRAINT fk_characters_events_event_id FOREIGN KEY (event_id) REFERENCES events (id),
    CONSTRAINT fk_characters_events_character_id FOREIGN KEY (character_id) REFERENCES characters (id)
);

CREATE TABLE quizzes (
    id SERIAL NOT NULL PRIMARY KEY,
    question TEXT NOT NULL,
    answers TEXT NOT NULL
);

CREATE TABLE teachers_courses_quizzes (
    id SERIAL NOT NULL PRIMARY KEY,
    teacher_course_id INT NOT NULL,
    quiz_id INT NOT NULL,
    CONSTRAINT fk_teachers_courses_quizzes_teacher_course_id FOREIGN KEY (teacher_course_id) REFERENCES teachers_courses (id),
    CONSTRAINT fk_teachers_courses_quizzes_quiz_id FOREIGN KEY (quiz_id) REFERENCES quizzes (id)
);

CREATE TABLE characters_quizzes (
    id SERIAL NOT NULL PRIMARY KEY,
    character_id INT NOT NULL,
    quiz_id INT NOT NULL,
    CONSTRAINT fk_characters_quizzes_character_id FOREIGN KEY (character_id) REFERENCES characters (id),
    CONSTRAINT fk_characters_quizzes_quiz_id FOREIGN KEY (quiz_id) REFERENCES quizzes (id)
);
