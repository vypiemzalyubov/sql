-- 1. С помощью оператора SELECT выведите текст "Hello world".

SELECT 
  "Hello world";

-- 2. Выведите все столбцы из таблицы Payments.

SELECT 
  * 
FROM 
  Payments;

-- 3. Выведите поля member_id, member_name и status из таблицы FamilyMembers.

SELECT 
  member_id, 
  member_name, 
  status 
FROM 
  FamilyMembers;

-- 4. Выведите поле name из таблицы Passenger. При выводе данного поля используйте псевдоним "passengerName".

SELECT 
  name passengerName 
FROM 
  Passenger;

-- 5. Выведите текст "Hello world" в нижнем регистре с помощью соответствующей функции. Для вывода текста используйте псевдоним lower_string.

SELECT 
  LOWER("Hello world") AS lower_string;

-- 6. Выведите полное имя члена семьи и его год рождения. Для вывода года рождения используйте псевдоним year_of_birth.

SELECT 
  member_name, 
  YEAR(birthday) AS year_of_birth 
FROM 
  FamilyMembers;

-- 7. Выведите полное имя члена семьи и длину его фамилии. Для вывода длины фамилии используйте псевдоним lastname_length.

SELECT 
  member_name, 
  LENGTH(member_name) - INSTR(member_name, ' ') AS lastname_length 
FROM 
  FamilyMembers;

-- 8. Выведите только уникальные имена first_name студентов из таблицы Student.

SELECT 
  DISTINCT first_name 
FROM 
  Student;

-- 9. Выведите только уникальные пары значений идентификатор учителя teacher и идентификатор предмета subject из таблицы Schedule.

SELECT 
  DISTINCT teacher, 
  subject 
FROM 
  Schedule;

-- 10. Выведите идентификаторы товаров (поле good) из таблицы Payments, стоимость которых больше 2000 единиц. Стоимость товара хранится в поле unit_price.

SELECT 
  good 
FROM 
  Payments 
WHERE 
  unit_price > 2000;

-- 11. Выведите имена (поле member_name) членов семьи из таблицы FamilyMembers, чей статус (поле status) равен "father".

SELECT 
  member_name 
FROM 
  FamilyMembers 
WHERE 
  status = 'father';

-- 12. Выведите имя (поле member_name) и дату рождения (поле birthday) членов семьи из таблицы FamilyMembers, чей статус (поле status) равен "father" или "mother".

SELECT 
  member_name, 
  birthday 
FROM 
  FamilyMembers 
WHERE 
  status = 'father' 
  OR status = 'mother';

-- 13. Необходимо получить все комнаты, в которых есть как кухня (поле has_kitchen), так и интернет (поле has_internet). 
--     Напишите запрос, удовлетворяющий вышеописанному условию, который выводит все поля из таблицы Rooms. Наличие обозначается 1 или true, а отсутствие 0 или false.

SELECT 
  * 
FROM 
  Rooms 
WHERE 
  has_kitchen = 1 
  AND has_internet = 1;

-- 14. Выведите имена first_name и фамилии last_name студентов из таблицы Student, у кого отсутствует отчество middle_name.

SELECT 
  first_name, 
  last_name 
FROM
  Student 
WHERE 
  middle_name IS NULL;

-- 15. Выведите резервации комнат (поля room_id, start_date, end_date) из таблицы Reservations, у которых итоговая стоимость аренды (поле total) находится в промежутке от 500 до 1200 включительно.

SELECT 
  room_id, 
  start_date, 
  end_date 
FROM 
  Reservations 
WHERE 
  total BETWEEN 500 
  AND 1200;

-- 16. Выведите информацию о студентах из таблицы Student, у которых год рождения соответствует одном из перечисленных: 2000, 2002 и 2004.

SELECT 
  * 
FROM
  Student 
WHERE 
  year(birthday) IN (2000, 2002, 2004);

-- 17. Найдите всех членов семьи с фамилией "Quincey" и выведите поле member_name.

SELECT 
  member_name 
FROM 
  FamilyMembers 
WHERE 
  member_name like '%Quincey';

-- 18. Для каждого отдельного платежа выведите идентификатор товара и сумму, потраченную на него, в отсортированном по убыванию этой суммы виде. Список платежей находится в таблице Payments.
--     Для вывода суммы используйте псевдоним sum.

SELECT 
  good, 
  amount * unit_price AS sum 
FROM
  Payments 
ORDER BY 
  sum DESC;

-- 19. Выведите список членов семьи с фамилией Quincey, в отсортированном по возрастанию столбцам status и member_name виде.

SELECT 
  * 
FROM
  FamilyMembers 
WHERE 
  member_name LIKE '%Quincey' 
ORDER BY 
  status, 
  member_name;

-- 20. Подсчитайте количество учеников в каждом классе, а также отсортируйте их по убыванию количества учеников. Принадлежность ученика к конкретному классу вы можете получить
--     из таблицы Student_in_class. В качестве результата необходимо вывести идентификатор класса (поле class) и количество учеников в этом классе.
--     Для вывода количества учеников используйте псевдоним count.

SELECT 
  class, 
  COUNT(*) AS count 
FROM 
  Student_in_class 
GROUP BY 
  class 
ORDER BY 
  count DESC;

-- 21. Для каждого из существующих статусов (поле status) найдите самого старого человека (используйте поле birthday). Выведите статус и дату рождения.
--     Для вывода даты рождения используйте псевдоним birthday.

SELECT 
  status, 
  MIN(birthday) AS birthday 
FROM 
  FamilyMembers 
GROUP BY 
  status;

-- 22. Получите среднее время полётов, совершённых на каждой из моделей самолёта. Выведите поле plane и среднее время полёта в секундах. Для вывода времени используйте псевдоним time.
--     Используйте функцию TIMESTAMPDIFF(second, time_out, time_in), чтобы получить разницу во времени в секундах между двумя датами.

SELECT 
  plane, 
  AVG(
    TIMESTAMPDIFF(second, time_out, time_in)
  ) AS time 
FROM 
  Trip 
GROUP BY 
  plane;

-- 23. Выведите идентификатор комнаты (поле room_id), среднюю стоимость за один день аренды (поле price, для вывода используйте псевдоним avg_price), 
--     а также количество резерваций этой комнаты (используйте псевдоним count). Полученный результат отсортируйте в порядке убывания сначала по количеству резерваций, а потом по средней стоимости.

SELECT 
  room_id, 
  AVG(price) AS avg_price, 
  COUNT(*) AS count 
Friel 
  Reservations 
GROUP BY 
  room_id 
ORDER BY 
  count DESC, 
  avg_price DESC;

-- 24. Выведите типы комнат (поле home_type) и разницу между самым дорогим и самым дешевым представителем данного типа. 
--     В итоговую выборку включите только те типы жилья, количество которых в таблице Rooms больше или равно 2. Для вывода разницы стоимости используйте псевдоним difference.

SELECT 
  home_type, 
  (
    MAX(price) - MIN(price)
  ) AS difference 
FROM 
  Rooms 
GROUP BY 
  home_type 
HAVING 
  count(*) > 2;