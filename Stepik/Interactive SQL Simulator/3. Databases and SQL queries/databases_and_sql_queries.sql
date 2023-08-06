-- 94: Вывести студентов, которые сдавали дисциплину «Основы баз данных», указать дату попытки и результат. Информацию вывести по убыванию результатов тестирования.

SELECT 
  name_student, 
  date_attempt, 
  result 
FROM 
  student 
  INNER JOIN attempt USING (student_id) 
  INNER JOIN subject USING (subject_id) 
WHERE 
  name_subject = 'Основы баз данных' 
ORDER BY 
  result DESC

-- 95: Вывести, сколько попыток сделали студенты по каждой дисциплине, а также средний результат попыток, который округлить до 2 знаков после запятой.
--     Под результатом попытки понимается процент правильных ответов на вопросы теста, который занесен в столбец result.
--     В результат включить название дисциплины, а также вычисляемые столбцы Количество и Среднее. Информацию вывести по убыванию средних результатов.

SELECT 
  name_subject, 
  COUNT(result) AS Количество, 
  ROUND(
    AVG(result), 
    2
  ) AS Среднее 
FROM 
  subject 
  LEFT JOIN attempt USING (subject_id) 
GROUP BY 
  name_subject 
ORDER BY 
  Среднее DESC

-- 96: Вывести студентов (различных студентов), имеющих максимальные результаты попыток. Информацию отсортировать в алфавитном порядке по фамилии студента.
--     Максимальный результат не обязательно будет 100%, поэтому явно это значение в запросе не задавать.

SELECT 
  name_student, 
  MAX(result) AS result 
FROM 
  student 
  INNER JOIN attempt USING (student_id) 
GROUP BY 
  name_student 
HAVING 
  MAX(result) IN (
    SELECT 
      MAX(result) 
    FROM 
      attempt
  ) 
ORDER BY 
  name_student;

-- 97: Если студент совершал несколько попыток по одной и той же дисциплине, то вывести разницу в днях между первой и последней попыткой.
--     В результат включить фамилию и имя студента, название дисциплины и вычисляемый столбец Интервал. Информацию вывести по возрастанию разницы.
--     Студентов, сделавших одну попытку по дисциплине, не учитывать.

SELECT 
  name_student, 
  name_subject, 
  DATEDIFF(
    MAX(date_attempt), 
    MIN(date_attempt)
  ) AS Интервал 
FROM 
  student 
  JOIN attempt USING (student_id) 
  JOIN subject USING (subject_id) 
GROUP BY 
  name_student, 
  name_subject 
HAVING 
  DATEDIFF(
    MAX(date_attempt), 
    MIN(date_attempt)
  ) > 0 
ORDER BY 
  Интервал

-- 98: Студенты могут тестироваться по одной или нескольким дисциплинам (не обязательно по всем). Вывести дисциплину и количество уникальных студентов (столбец назвать Количество),
--     которые по ней проходили тестирование . Информацию отсортировать сначала по убыванию количества, а потом по названию дисциплины.
--     В результат включить и дисциплины, тестирование по которым студенты еще не проходили, в этом случае указать количество студентов 0.

SELECT 
  name_subject, 
  COUNT(DISTINCT student_id) AS Количество 
FROM 
  subject 
  LEFT JOIN attempt USING (subject_id) 
GROUP BY 
  name_subject 
ORDER BY 
  Количество DESC, 
  name_subject

-- 99: Случайным образом отберите 3 вопроса по дисциплине «Основы баз данных». В результат включите столбцы question_id и name_question.

SELECT 
  question_id, 
  name_question 
FROM 
  subject 
  JOIN question USING (subject_id) 
WHERE 
  name_subject = 'Основы баз данных' 
ORDER BY 
  RAND() 
LIMIT 
  3

-- 100: Вывести вопросы, которые были включены в тест для Семенова Ивана по дисциплине «Основы SQL» 2020-05-17 (значение attempt_id для этой попытки равно 7).
--      Указать, какой ответ дал студент и правильный он или нет (вывести Верно или Неверно). В результат включить вопрос, ответ и вычисляемый столбец Результат.

SELECT 
  name_question, 
  name_answer, 
  IF(
    is_correct = 0, "Неверно", "Верно"
  ) AS Результат 
FROM 
  question 
  JOIN testing USING (question_id) 
  JOIN answer USING (answer_id) 
WHERE 
  attempt_id = 7

-- 101: Посчитать результаты тестирования. Результат попытки вычислить как количество правильных ответов, деленное на 3 (количество вопросов в каждой попытке) и умноженное на 100.
--      Результат округлить до двух знаков после запятой. Вывести фамилию студента, название предмета, дату и результат. Последний столбец назвать Результат.
--      Информацию отсортировать сначала по фамилии студента, потом по убыванию даты попытки.

SELECT 
  name_student, 
  name_subject, 
  date_attempt, 
  ROUND(
    (
      SUM(answer.is_correct)/ 3
    ) * 100, 
    2
  ) AS Результат 
FROM 
  attempt 
  JOIN student USING (student_id) 
  JOIN subject USING (subject_id) 
  JOIN testing USING (attempt_id) 
  JOIN answer USING (answer_id) 
GROUP BY 
  name_student, 
  name_subject, 
  date_attempt 
ORDER BY 
  name_student ASC, 
  date_attempt DESC;

-- 102: Для каждого вопроса вывести процент успешных решений, то есть отношение количества верных ответов к общему количеству ответов, значение округлить до 2-х знаков после запятой.
--      Также вывести название предмета, к которому относится вопрос, и общее количество ответов на этот вопрос.
--      В результат включить название дисциплины, вопросы по ней (столбец назвать Вопрос), а также два вычисляемых столбца Всего_ответов и Успешность.
--      Информацию отсортировать сначала по названию дисциплины, потом по убыванию успешности, а потом по тексту вопроса в алфавитном порядке.
--      Поскольку тексты вопросов могут быть длинными, обрезать их 30 символов и добавить многоточие "...".

SELECT 
  name_subject, 
  CONCAT(
    LEFT(name_question, 30), 
    '...'
  ) AS Вопрос, 
  COUNT(t.answer_id) AS Всего_ответов, 
  ROUND(
    SUM(is_correct) / COUNT(t.answer_id) * 100, 
    2
  ) AS Успешность 
FROM 
  subject 
  JOIN question USING (subject_id) 
  JOIN testing t USING (question_id) 
  LEFT JOIN answer a USING (answer_id) 
GROUP BY 
  name_subject, 
  Вопрос 
ORDER BY 
  name_subject, 
  Успешность DESC, 
  Вопрос;

-- 103: В таблицу attempt включить новую попытку для студента Баранова Павла по дисциплине «Основы баз данных». Установить текущую дату в качестве даты выполнения попытки.

INSERT INTO attempt (
  student_id, subject_id, date_attempt
) 
SELECT 
  student_id, 
  subject_id, 
  NOW() 
FROM 
  student, 
  subject 
WHERE 
  name_student LIKE 'Баранов Павел' 
  AND name_subject LIKE 'Основы баз данных';

-- 104: Случайным образом выбрать три вопроса (запрос) по дисциплине, тестирование по которой собирается проходить студент, занесенный в таблицу attempt последним, и добавить их в таблицу testing.
--      id последней попытки получить как максимальное значение id из таблицы attempt.

INSERT INTO testing(attempt_id, question_id) 
SELECT 
  attempt_id, 
  question_id 
FROM 
  question 
  JOIN attempt USING (subject_id) 
ORDER BY 
  attempt_id DESC, 
  RAND() 
LIMIT 
  3;

-- 105: Студент прошел тестирование (то есть все его ответы занесены в таблицу testing), далее необходимо вычислить результат(запрос) и занести его в таблицу attempt для соответствующей попытки.
--      Результат попытки вычислить как количество правильных ответов, деленное на 3 (количество вопросов в каждой попытке) и умноженное на 100. Результат округлить до целого.
--      Будем считать, что мы знаем id попытки, для которой вычисляется результат, в нашем случае это 8.

UPDATE 
  attempt 
SET 
  result = (
    SELECT 
      ROUND(
        SUM(is_correct)/ 3 * 100, 
        0
      ) 
    FROM 
      testing 
      JOIN answer USING (answer_id) 
    WHERE 
      attempt_id = 8
  ) 
WHERE 
  attempt_id = 8;

-- 106: Удалить из таблицы attempt все попытки, выполненные раньше 1 мая 2020 года. Также удалить и все соответствующие этим попыткам вопросы из таблицы testing. 

DELETE FROM 
  attempt 
WHERE 
  date_attempt < "2020-05-01";

-- 107: Вывести абитуриентов, которые хотят поступать на образовательную программу «Мехатроника и робототехника» в отсортированном по фамилиям виде.

SELECT 
  name_enrollee 
FROM 
  enrollee 
  JOIN program_enrollee USING (enrollee_id) 
  JOIN program USING (program_id) 
WHERE 
  name_program LIKE 'Мехатроника и робототехника' 
ORDER BY 
  1

-- 108: Вывести образовательные программы, на которые для поступления необходим предмет «Информатика». Программы отсортировать в обратном алфавитном порядке.

SELECT 
  name_program 
FROM 
  program 
  JOIN program_subject USING (program_id) 
  JOIN subject USING (subject_id) 
WHERE 
  name_subject = 'Информатика' 
ORDER BY 
  1 DESC

-- 109: Выведите количество абитуриентов, сдавших ЕГЭ по каждому предмету, максимальное, минимальное и среднее значение баллов по предмету ЕГЭ.
--      Вычисляемые столбцы назвать Количество, Максимум, Минимум, Среднее.
--      Информацию отсортировать по названию предмета в алфавитном порядке, среднее значение округлить до одного знака после запятой.

SELECT 
  name_subject, 
  COUNT(enrollee_id) AS Количество, 
  MAX(result) AS Максимум, 
  MIN(result) AS Минимум, 
  ROUND(
    AVG(result), 
    1
  ) AS Среднее 
FROM 
  subject 
  JOIN enrollee_subject USING (subject_id) 
GROUP BY 
  1 
ORDER BY 
  1

-- 110: Вывести образовательные программы, для которых минимальный балл ЕГЭ по каждому предмету больше или равен 40 баллам. Программы вывести в отсортированном по алфавиту виде.

SELECT 
  name_program 
FROM 
  program 
  JOIN program_subject USING (program_id) 
GROUP BY 
  1 
HAVING 
  MIN(min_result) >= 40 
ORDER BY 
  1

-- 111: Вывести образовательные программы, которые имеют самый большой план набора, вместе с этой величиной.

SELECT 
  name_program, 
  plan 
FROM 
  program 
WHERE 
  plan IN (
    SELECT 
      MAX(plan) 
    FROM 
      program
  )

-- 112: Посчитать, сколько дополнительных баллов получит каждый абитуриент. Столбец с дополнительными баллами назвать Бонус. Информацию вывести в отсортированном по фамилиям виде.

SELECT 
  name_enrollee, 
  ifnull(
    SUM(bonus), 
    0
  ) AS Бонус 
FROM 
  enrollee 
  LEFT JOIN (
    enrollee_achievement 
    INNER JOIN achievement USING (achievement_id)
  ) USING(enrollee_id) 
GROUP BY 
  name_enrollee 
ORDER BY 
  name_enrollee

-- 113: Выведите сколько человек подало заявление на каждую образовательную программу и конкурс на нее (число поданных заявлений деленное на количество мест по плану),
--      округленный до 2-х знаков после запятой. В запросе вывести название факультета, к которому относится образовательная программа, название образовательной программы,
--      план набора абитуриентов на образовательную программу (plan), количество поданных заявлений (Количество) и Конкурс. Информацию отсортировать в порядке убывания конкурса.

SELECT 
  name_department, 
  name_program, 
  plan, 
  COUNT(enrollee_id) AS Количество, 
  ROUND(
    COUNT(enrollee_id) / plan, 
    2
  ) AS Конкурс 
FROM 
  program 
  JOIN department USING (department_id) 
  JOIN program_enrollee USING (program_id) 
GROUP BY 
  name_department, 
  name_program, 
  plan 
ORDER BY 
  Конкурс DESC

-- 114: Вывести образовательные программы, на которые для поступления необходимы предмет «Информатика» и «Математика» в отсортированном по названию программ виде.

SELECT 
  name_program 
FROM 
  program 
  JOIN program_subject USING (program_id) 
  JOIN subject USING (subject_id) 
WHERE 
  name_subject IN (
    "Информатика", "Математика"
  ) 
GROUP BY 
  name_program 
HAVING 
  COUNT(name_program) = 2 
ORDER BY 
  name_program;

-- 115: Посчитать количество баллов каждого абитуриента на каждую образовательную программу, на которую он подал заявление, по результатам ЕГЭ.
--      В результат включить название образовательной программы, фамилию и имя абитуриента, а также столбец с суммой баллов, который назвать itog.
--      Информацию вывести в отсортированном сначала по образовательной программе, а потом по убыванию суммы баллов виде.

SELECT 
  name_program, 
  name_enrollee, 
  SUM(result) AS itog 
FROM 
  enrollee 
  JOIN program_enrollee USING (enrollee_id) 
  JOIN program USING (program_id) 
  JOIN program_subject USING (program_id) 
  JOIN enrollee_subject USING (subject_id, enrollee_id) 
GROUP BY 
  name_program, 
  name_enrollee 
ORDER BY 
  name_program, 
  itog DESC

-- 116: Вывести название образовательной программы и фамилию тех абитуриентов, которые подавали документы на эту образовательную программу, но не могут быть зачислены на нее.
--      Эти абитуриенты имеют результат по одному или нескольким предметам ЕГЭ, необходимым для поступления на эту образовательную программу, меньше минимального балла.
--      Информацию вывести в отсортированном сначала по программам, а потом по фамилиям абитуриентов виде.
--      Например, Баранов Павел по «Физике» набрал 41 балл, а для образовательной программы «Прикладная механика» минимальный балл по этому предмету определен в 45 баллов.
--      Следовательно, абитуриент на данную программу не может поступить.

SELECT 
  name_program, 
  name_enrollee 
FROM 
  enrollee 
  JOIN program_enrollee USING (enrollee_id) 
  JOIN program USING (program_id) 
  JOIN program_subject USING (program_id) 
  JOIN enrollee_subject USING (subject_id, enrollee_id) 
WHERE 
  result < min_result 
GROUP BY 
  1, 
  2 
ORDER BY 
  1, 
  2;

-- 117: Создать вспомогательную таблицу applicant, куда включить id образовательной программы, id абитуриента, сумму баллов абитуриентов (столбец itog) в отсортированном
--      сначала по id образовательной программы, а потом по убыванию суммы баллов виде.

CREATE TABLE applicant 
SELECT 
  program_id, 
  enrollee.enrollee_id, 
  SUM(result) AS itog 
FROM 
  enrollee 
  JOIN program_enrollee USING (enrollee_id) 
  JOIN program USING (program_id) 
  JOIN program_subject USING (program_id) 
  JOIN subject USING (subject_id) 
  JOIN enrollee_subject USING (enrollee_id, subject_id) 
WHERE 
  enrollee_subject.enrollee_id = enrollee.enrollee_id 
GROUP BY 
  program_id, 
  enrollee_id 
ORDER BY 
  program_id, 
  itog DESC;

-- 118: Из таблицы applicant, созданной на предыдущем шаге, удалить записи, если абитуриент на выбранную образовательную программу не набрал минимального балла хотя бы по одному предмету. 

DELETE FROM 
  applicant USING applicant 
  JOIN program_subject USING (program_id) 
  JOIN enrollee_subject USING (subject_id, enrollee_id) 
WHERE 
  result < min_result;

-- 119: Повысить итоговые баллы абитуриентов в таблице applicant на значения дополнительных баллов. 

UPDATE 
  applicant 
  JOIN (
    SELECT 
      enrollee_id, 
      SUM(bonus) AS bonus 
    FROM 
      achievement 
      INNER JOIN enrollee_achievement USING (achievement_id) 
    GROUP BY 
      enrollee_id
  ) AS bonus USING(enrollee_id) 
SET 
  itog = applicant.itog + bonus.bonus;

-- 120: Поскольку при добавлении дополнительных баллов, абитуриенты по каждой образовательной программе могут следовать не в порядке убывания суммарных баллов,
--      необходимо создать новую таблицу applicant_order на основе таблицы applicant. При создании таблицы данные нужно отсортировать сначала по id образовательной программы,
--      потом по убыванию итогового балла. А таблицу applicant, которая была создана как вспомогательная, необходимо удалить.

CREATE TABLE applicant_order AS 
SELECT 
  program_id, 
  enrollee_id, 
  itog 
FROM 
  applicant 
ORDER BY 
  1, 
  3 DESC;
DROP 
  TABLE applicant;

-- 121: Включить в таблицу applicant_order новый столбец str_id целого типа, расположить его перед первым.

ALTER TABLE 
  applicant_order 
ADD 
  str_id int FIRST

-- 122: Занести в столбец str_id таблицы applicant_order нумерацию абитуриентов, которая начинается с 1 для каждой образовательной программы.

SET 
  @row_num := 1;
SET 
  @num_pr := 0;
UPDATE 
  applicant_order 
SET 
  str_id = IF(
    program_id = @num_pr, 
    @row_num := @row_num + 1, 
    @row_num := 1 
    AND @num_pr := @num_pr + 1
  );

-- 123: Создать таблицу student, в которую включить абитуриентов, которые могут быть рекомендованы к зачислению в соответствии с планом набора.
--      Информацию отсортировать сначала в алфавитном порядке по названию программ, а потом по убыванию итогового балла.

CREATE TABLE student AS 
SELECT 
  program.name_program, 
  enrollee.name_enrollee, 
  applicant_order.itog 
FROM 
  applicant_order 
  JOIN program USING (program_id) 
  JOIN enrollee USING (enrollee_id) 
WHERE 
  applicant_order.str_id <= program.plan 
ORDER BY 
  1, 
  3 DESC;