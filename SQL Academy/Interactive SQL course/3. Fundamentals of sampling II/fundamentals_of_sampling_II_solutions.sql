-- 25. Объедините таблицы Class и Student_in_class с помощью внутреннего соединения по полям Class.id и Student_in_class.class. 
--     Выведите название класса (поле Class.name) и идентификатор ученика (поле Student_in_class.student).

SELECT 
  Class.name, 
  Student_in_class.student 
FROM 
  Class 
  JOIN Student_in_class ON Class.id = Student_in_class.class;

-- 26. Дополните запрос из предыдущего задания, добавив ещё одно внутреннее соединение с таблицей Student. 
--     Объедините по полям Student_in_class.student и Student.id и вместо идентификатора ученика выведите его имя (поле first_name).

SELECT 
  Class.name, 
  Student.first_name 
FROM 
  Class 
  JOIN Student_in_class ON Class.id = Student_in_class.class 
  JOIN Student ON Student_in_class.student = Student.id;

-- 27. Выведите названия продуктов, которые покупал член семьи со статусом "son". 
--     Для получения выборки вам нужно объединить таблицу Payments с таблицей FamilyMembers по полям family_member и member_id, а также с таблицей Goods по полям good и good_id.

SELECT 
  good_name 
FROM 
  Goods 
  JOIN Payments ON Goods.good_id = Payments.good 
  JOIN FamilyMembers ON Payments.family_member = FamilyMembers.member_id 
WHERE 
  status = 'son';

-- 28. Выведите идентификатор (поле room_id) и среднюю оценку комнаты (поле rating, для вывода используйте псевдоним avg_score), составленную на основании отзывов из таблицы Reviews.
--     Данная таблица связана с Reservations (таблица, где вы можете взять идентификатор комнаты) по полям reservation_id и Reservations.id.

SELECT 
  room_id, 
  avg(rating) AS avg_score 
FROM 
  Reviews 
  JOIN Reservations ON Reviews.reservation_id = Reservations.id 
GROUP BY 
  room_id;

-- 29. Выведите имена first_name и фамилии last_name всех учителей из таблицы Teacher, а также количество занятий, в которых они назначены преподавателями.
--     Для вывода количества занятий используйте псевдоним amount_classes.

SELECT 
  first_name, 
  last_name, 
  count(*) AS amount_classes 
FROM 
  Teacher 
  JOIN Schedule ON Teacher.id = Schedule.teacher 
GROUP BY 
  teacher;

-- 30. Отсортируйте список компаний (таблица Company) по их названию в алфавитном порядке и выведите первые две записи.

SELECT 
  * 
FROM 
  Company 
ORDER BY 
  name 
LIMIT 
  2;

-- 31. Выведите начало (поле start_pair) и окончание (поле end_pair) второго и третьего занятия из таблицы Timepair.

SELECT 
  start_pair, 
  end_pair 
FROM 
  Timepair 
LIMIT 
  1, 
  2;

-- 32. Выведите всю информацию о пользователе из таблицы Users, кто является владельцем самого дорого жилья (таблица Rooms).

SELECT 
  * 
FROM 
  Users 
WHERE 
  id = (
    SELECT 
      owner_id 
    FROM 
      Rooms 
    ORDER BY 
      price DESC 
    LIMIT 
      1
  );

-- 33. Выведите названия товаров из таблицы Goods (поле good_name), которые ещё ни разу не покупались ни одним из членов семьи (таблица Payments).

SELECT 
  good_name 
FROM 
  Goods 
WHERE 
  good_id <> ALL (
    SELECT 
      good 
    FROM 
      Payments 
    WHERE 
      amount > 0
  );

-- 34. Выведите список комнат (все поля, таблица Rooms), которые по своим удобствам (has_tv, has_internet, has_kitchen, has_air_con) совпадают с комнатой с идентификатором "11".

SELECT 
  * 
FROM 
  Rooms 
WHERE 
  (
    has_tv, has_internet, has_kitchen, 
    has_air_con
  ) IN (
    SELECT 
      has_tv, 
      has_internet, 
      has_kitchen, 
      has_air_con 
    FROM 
      Rooms 
    WHERE 
      id = 11
  );

-- 35. С помощью коррелированного подзапроса выведите имена всех членов семьи (member_name) и цену их самого дорогого купленного товара.
--     Для вывода цены самого дорогого купленного товара используйте псевдоним good_price. Если такого товара нет, выведите NULL.

SELECT 
  member_name, 
  (
    SELECT 
      MAX(unit_price) 
    FROM 
      Payments 
    WHERE 
      Payments.family_member = FamilyMembers.member_id
  ) AS good_price 
FROM 
  FamilyMembers;

-- 36. Выведите полные имена (поля first_name, middle_name и last_name) всех студентов и преподавателей.

SELECT 
  first_name, 
  middle_name, 
  last_name 
FROM 
  Student 
UNION 
SELECT 
  first_name, 
  middle_name, 
  last_name 
FROM 
  Teacher;

-- 37. Из таблицы Reviews выведите идентификаторы отзывов (поле id) и их категорию: для рейтинга 4-5 проставьте категорию «positive», для 3 проставьте «neutral», а для 1-2 - «negative».
--     Для вывода категории рейтинга используйте псевдоним rating.

SELECT 
  id, 
  CASE rating 
  WHEN 5 THEN 'positive' 
  WHEN 4 THEN 'positive' 
  WHEN 3 THEN 'neutral' 
  ELSE 'negative' END as rating 
FROM 
  Reviews;

-- 38. Из таблицы Rooms выведите идентификаторы сдаваемых жилых помещений (поле id) и наличие телевизора в помещении: если телевизор присутствует выведите «YES», иначе «NO».
--     Для вывода наличия телевизора используйте псевдоним has_tv.

SELECT 
  id, 
  IF (has_tv = true, 'YES', 'NO') AS has_tv 
FROM 
  Rooms;

-- 39. Из таблицы Teacher выведите имена (поле first_name), отчества (поле middle_name) и фамилии (поле last_name) учителей. 
--     Если отчество у учителя отсутствует, выведите в поле middle_name значение «Empty».

SELECT 
  first_name, 
  IFNULL(middle_name, 'Empty') AS middle_name, 
  last_name 
FROM 
  Teacher;
