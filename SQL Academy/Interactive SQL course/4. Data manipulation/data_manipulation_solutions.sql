-- 40. Добавьте новый товар в таблицу Goods с именем «Table» и типом «equipment». В качестве первичного ключа (good_id) укажите количество записей в таблице + 1.

INSERT INTO Goods 
SET 
  good_id = (
    SELECT 
      COUNT(*) + 1 
    FROM 
      Goods AS g
  ), 
  good_name = 'Table', 
  type = (
    SELECT 
      good_type_id 
    FROM 
      GoodTypes 
    WHERE 
      good_type_name = 'equipment'
  );

-- 41. Измените имя у "Wednesday Addams" на новое "Tuesday Addams".

UPDATE 
  FamilyMembers 
SET 
  member_name = 'Tuesday Addams' 
WHERE 
  member_name = 'Wednesday Addams';

-- 42. Обновите стоимость всех комнат в таблице (Rooms), добавив к текущей 10 единиц.

UPDATE 
  Rooms 
SET 
  price = price + 10;

-- 43. Удалите все записи из таблицы Payments, используя оператор DELETE.

DELETE FROM 
  Payments;

-- 44. Удалить запись из таблицы Goods, у которой поле good_name равно "milk".

DELETE FROM 
  Goods 
WHERE 
  good_name = 'milk';

-- 45. Измените запрос так, чтобы удалить товары (Goods), имеющие тип деликатесов (delicacies).

DELETE Goods 
FROM 
  Goods 
  JOIN GoodTypes ON Goods.type = GoodTypes.good_type_id 
WHERE 
  GoodTypes.good_type_name = "delicacies";