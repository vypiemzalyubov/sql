-- 1. С помощью оператора SELECT выведите текст "Hello world".

SELECT "Hello world";

-- 2. Выведите все столбцы из таблицы Payments.

SELECT * 
FROM Payments;

-- 3. Выведите поля member_id, member_name и status из таблицы FamilyMembers.

SELECT 
  member_id, 
  member_name, 
  status 
FROM FamilyMembers;

-- 4. Выведите поле name из таблицы Passenger. При выводе данного поля используйте псевдоним "passengerName".

select name passengerName 
from Passenger;
