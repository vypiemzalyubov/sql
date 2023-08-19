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

