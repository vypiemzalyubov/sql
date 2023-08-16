-- 1. Вывести имена всех людей, которые есть в базе данных авиакомпаний.

SELECT name
FROM Passenger;

-- 2. Вывести названия всеx авиакомпаний.

SELECT name
FROM Company;

-- 3. Вывести все рейсы, совершенные из Москвы.

SELECT *
FROM Trip
WHERE town_from = 'Moscow';

-- 4. Вывести имена людей, которые заканчиваются на "man".

SELECT name
FROM Passenger
WHERE name LIKE '%man';

-- 5. Вывести количество рейсов, совершенных на TU-134.

SELECT COUNT(*) AS COUNT
FROM Trip
WHERE plane = 'TU-154';

-- 6. Какие компании совершали перелеты на Boeing.

SELECT DISTINCT name
FROM Company
	JOIN Trip ON Company.id = Trip.company
WHERE plane = 'Boeing';

-- 7. Вывести все названия самолётов, на которых можно улететь в Москву (Moscow).

SELECT DISTINCT plane
FROM Trip
WHERE town_to = 'Moscow';

-- 8. В какие города можно улететь из Парижа (Paris) и сколько времени это займёт?

SELECT town_to,
	TIMEDIFF(time_in, time_out) AS flight_time
FROM Trip
WHERE town_from = 'Paris';

-- 9. Какие компании организуют перелеты из Владивостока (Vladivostok)?

SELECT name
FROM Company
	JOIN Trip ON Company.id = Trip.company
WHERE town_from = 'Vladivostok';

-- 10. Вывести вылеты, совершенные с 10 ч. по 14 ч. 1 января 1900 г.

SELECT *
FROM Trip
WHERE time_out BETWEEN '1900-01-01T10:00:00.000Z' AND '1900-01-01T14:00:00.000Z';

-- 11. Выведите пассажиров с самым длинным ФИО. Пробелы, дефисы и точки считаются частью имени.

SELECT name
FROM Passenger
ORDER BY LENGTH(name) DESC
LIMIT 1;

-- 12. Вывести id и количество пассажиров для всех прошедших полётов.

SELECT trip AS trip,
	COUNT(passenger) AS count
FROM Pass_in_trip
GROUP BY trip;

-- 13. Вывести имена людей, у которых есть полный тёзка среди пассажиров.

SELECT name
FROM Passenger
GROUP BY name
HAVING COUNT(*) > 1;

-- 14. В какие города летал Bruce Willis.

SELECT town_to
FROM Trip
	JOIN Pass_in_trip ON Trip.id = Pass_in_trip.trip
	JOIN Passenger ON Pass_in_trip.passenger = passenger.id
WHERE name = 'Bruce Willis';

-- 15. Выведите дату и время прилёта пассажира Стив Мартин (Steve Martin) в Лондон (London).

SELECT time_in
FROM Trip
	JOIN Pass_in_trip ON Trip.id = Pass_in_trip.trip
	JOIN Passenger ON Pass_in_trip.passenger = Passenger.id
WHERE name = 'Steve Martin'
	AND town_to = 'London';

-- 16. Вывести отсортированный по количеству перелетов (по убыванию) и имени (по возрастанию) список пассажиров, совершивших хотя бы 1 полет.

SELECT name,
	COUNT(*) as count
FROM Pass_in_trip
	JOIN Passenger ON Pass_in_trip.passenger = Passenger.id
GROUP BY name
ORDER BY count DESC,
	name;

-- 17. Определить, сколько потратил в 2005 году каждый из членов семьи. В результирующей выборке не выводите тех членов семьи, которые ничего не потратили.

SELECT member_name,
	status,
	SUM(amount * unit_price) AS costs
FROM FamilyMembers
	JOIN Payments ON FamilyMembers.member_id = Payments.family_member
WHERE date BETWEEN '2005-01-01T00:00:00.000Z' AND '2005-12-31T00:00:00.000Z'
GROUP BY family_member;

-- 18. Узнать, кто старше всех в семьe.

SELECT member_name
FROM FamilyMembers
ORDER BY birthday
LIMIT 1;

-- 19. Определить, кто из членов семьи покупал картошку (potato).

SELECT DISTINCT status
FROM FamilyMembers AS f
	JOIN Payments AS p ON f.member_id = p.family_member
	JOIN Goods AS g ON p.good = g.good_id
WHERE good_name = 'potato';

-- 20. Сколько и кто из семьи потратил на развлечения (entertainment). Вывести статус в семье, имя, сумму.

SELECT status,
	member_name,
	SUM(amount * unit_price) AS costs
FROM FamilyMembers AS f
	JOIN Payments AS p ON f.member_id = p.family_member
	JOIN Goods AS g ON p.good = g.good_id
	JOIN GoodTypes AS gt ON g.type = gt.good_type_id
WHERE good_type_name = 'entertainment'
GROUP BY family_member;

-- 21. Определить товары, которые покупали более 1 раза.

SELECT good_name
FROM Goods AS g
	JOIN Payments AS p ON g.good_id = p.good
GROUP BY good
HAVING COUNT(*) > 1;

-- 22. Найти имена всех матерей (mother).

SELECT member_name
FROM FamilyMembers
WHERE status = 'mother';

-- 23. Найдите самый дорогой деликатес (delicacies) и выведите его цену.

SELECT good_name,
	unit_price
FROM Payments AS p
	JOIN Goods AS g ON g.good_id = p.good
	JOIN GoodTypes AS gt ON g.type = gt.good_type_id
WHERE good_type_name = 'delicacies'
ORDER BY unit_price DESC
LIMIT 1;

-- 24. Определить кто и сколько потратил в июне 2005.

SELECT member_name,
	SUM(amount * unit_price) AS costs
FROM FamilyMembers AS f
	JOIN Payments AS p ON f.member_id = p.family_member
WHERE MONTH(date) = 06
	AND YEAR(date) = 2005
GROUP BY member_name;

-- 25. Определить, какие товары не покупались в 2005 году.

SELECT good_name
FROM Goods
WHERE good_id NOT IN (
		SELECT good
		FROM Payments
		WHERE YEAR(date) = 2005
	)

-- 26. Определить группы товаров, которые не приобретались в 2005 году.

SELECT good_type_name
FROM GoodTypes
WHERE good_type_id NOT IN (
		SELECT good_type_id
		FROM GoodTypes AS gt
			JOIN Goods AS g ON gt.good_type_id = g.type
			JOIN Payments AS p ON g.good_id = p.good
		WHERE YEAR(date) = 2005
	);

-- 27. Узнать, сколько потрачено на каждую из групп товаров в 2005 году. Вывести название группы и сумму.

SELECT good_type_name,
	SUM(amount * unit_price) AS costs
FROM GoodTypes AS gt
	JOIN Goods AS g ON gt.good_type_id = g.type
	JOIN Payments AS p ON g.good_id = p.good
WHERE YEAR(date) = 2005
GROUP BY good_type_name;

-- 28. Сколько рейсов совершили авиакомпании из Ростова (Rostov) в Москву (Moscow)?

SELECT COUNT(*) as count
FROM Trip
WHERE town_from = 'Rostov'
	AND town_to = 'Moscow';

-- 29. Выведите имена пассажиров улетевших в Москву (Moscow) на самолете TU-134.

SELECT name
FROM Passenger AS p
	JOIN Pass_in_trip AS pit ON p.id = pit.passenger
	JOIN Trip AS t ON pit.trip = t.id
WHERE town_to = 'Moscow'
	AND plane = 'TU-134'
GROUP BY name;

-- 30. Выведите нагруженность (число пассажиров) каждого рейса (trip). Результат вывести в отсортированном виде по убыванию нагруженности.

SELECT trip,
	COUNT(*) AS count
FROM Pass_in_trip
GROUP BY trip
ORDER BY 2 DESC;

-- 31. Вывести всех членов семьи с фамилией Quincey.

SELECT *
FROM FamilyMembers
WHERE member_name LIKE '%Quincey';

-- 32. Вывести средний возраст людей (в годах), хранящихся в базе данных. Результат округлите до целого в меньшую сторону.

SELECT FLOOR(AVG(YEAR(CURRENT_DATE) - YEAR(birthday))) AS age
FROM FamilyMembers;

-- 33. Найдите среднюю стоимость икры. В базе данных хранятся данные о покупках красной (red caviar) и черной икры (black caviar).

SELECT AVG(unit_price) AS cost
FROM Payments AS p
	JOIN Goods AS g ON p.good = g.good_id
WHERE good_name = 'red caviar'
	OR good_name = 'black caviar';

-- 34. Сколько всего 10-ых классов.

SELECT COUNT(*) AS count
FROM Class
WHERE name LIKE '10%';

-- 35. Сколько различных кабинетов школы использовались 2.09.2019 в образовательных целях?

SELECT COUNT(*) AS count
FROM Schedule
WHERE DAY(date) = 2
	AND MONTH(date) = 09
	AND YEAR(date) = 2019;

-- 36. Выведите информацию об обучающихся живущих на улице Пушкина (ul. Pushkina)?

SELECT *
FROM Student
WHERE address LIKE '%Pushkina%';

-- 37. Сколько лет самому молодому обучающемуся?

SELECT MIN(TIMESTAMPDIFF(YEAR, birthday, CURRENT_DATE)) AS year
FROM Student;

-- 38. Сколько Анн (Anna) учится в школе?

SELECT COUNT(*) AS count
FROM Student
WHERE first_name = 'Anna';

-- 39. Сколько обучающихся в 10 B классе?

SELECT COUNT(*) AS count
FROM Class AS c
	JOIN Student_in_class AS sic ON c.id = sic.class
WHERE name LIKE '10 B';

-- 40. Выведите название предметов, которые преподает Ромашкин П.П. (Romashkin P.P.)?

SELECT name AS subjects
FROM Subject AS sbj
	JOIN Schedule AS sch ON sbj.id = sch.subject
	JOIN Teacher AS tch ON sch.teacher = tch.id
WHERE last_name = 'Romashkin'
	AND first_name LIKE 'P%'
	AND middle_name LIKE 'P%';

-- 41. Во сколько начинается 4-ый учебный предмет по расписанию?

SELECT start_pair
FROM Timepair
WHERE id = 4;

-- 42. Сколько времени обучающийся будет находиться в школе, учась со 2-го по 4-ый уч. предмет?

SELECT TIMEDIFF(
		(
			SELECT end_pair
			FROM Timepair
			WHERE id = 4
		),
		(
			SELECT start_pair
			FROM Timepair
			WHERE id = 2
		)
	) AS time
FROM Timepair
LIMIT 1;

-- 43. Выведите фамилии преподавателей, которые ведут физическую культуру (Physical Culture). Отcортируйте преподавателей по фамилии.

SELECT last_name
FROM Teacher AS t
	JOIN Schedule AS sch ON t.id = sch.teacher
	JOIN Subject AS sbj ON sch.subject = sbj.id
WHERE name = 'Physical Culture'
ORDER BY 1;

-- 44. Найдите максимальный возраст (колич. лет) среди обучающихся 10 классов?

SELECT MAX(TIMESTAMPDIFF(YEAR, birthday, CURRENT_DATE)) AS max_year
FROM Student AS std
	JOIN Student_in_class AS sic ON std.id = sic.student
	JOIN Class AS c ON sic.class = c.id
WHERE name LIKE '10%';

-- 45. Какие кабинеты чаще всего использовались для проведения занятий? Выведите те, которые использовались максимальное количество раз.

SELECT classroom
FROM Schedule
GROUP BY classroom
HAVING COUNT(*) = (
		SELECT COUNT(*)
		FROM Schedule
		GROUP BY classroom
		ORDER BY 1 DESC
		LIMIT 1
	);

-- 46. В каких классах введет занятия преподаватель "Krauze"?

SELECT DISTINCT name
from Class AS c
	JOIN Schedule AS sch ON c.id = sch.class
	JOIN Teacher AS tch ON sch.teacher = tch.id
WHERE last_name = 'Krauze';

-- 47. Сколько занятий провел Krauze 30 августа 2019 г.?

SELECT COUNT(*) AS count
FROM Schedule AS sch
	JOIN Teacher AS tch ON sch.teacher = tch.id
WHERE YEAR(date) = 2019
	AND MONTH(date) = 08
	AND DAY(date) = 30
	AND last_name = 'Krauze';

-- 48. Выведите заполненность классов в порядке убывания.

SELECT name,
	COUNT(*) AS count
FROM Class AS c
	JOIN Student_in_class AS sic ON c.id = sic.class
GROUP BY class
ORDER BY 2 DESC;

-- 49. Какой процент обучающихся учится в 10 A классе?

SELECT COUNT(*) * 100 / (
		SELECT COUNT(*)
		FROM Student_in_class
	) AS percent
FROM Student_in_class sic
	JOIN Class c ON sic.class = c.id
WHERE name = '10 A';

-- 50. Какой процент обучающихся родился в 2000 году? Результат округлить до целого в меньшую сторону.

SELECT FLOOR(
		COUNT(*) * 100 / (
			SELECT COUNT(*)
			FROM Student
		)
	) AS percent
FROM Student
WHERE YEAR(birthday) = 2000;

-- 51. Добавьте товар с именем "Cheese" и типом "food" в список товаров (Goods). В качестве первичного ключа (good_id) укажите количество записей в таблице + 1.

INSERT INTO Goods
SET good_id = (
		SELECT COUNT(*) + 1
		FROM Goods AS g
	),
	good_name = 'Cheese',
	type = (
		SELECT good_type_id
		FROM GoodTypes
		WHERE good_type_name = 'food'
	);

-- 52. Добавьте в список типов товаров (GoodTypes) новый тип "auto". В качестве первичного ключа (good_type_id) укажите количество записей в таблице + 1.

INSERT INTO GoodTypes
SET good_type_id = (
		SELECT COUNT(*) + 1
		FROM GoodTypes AS gt
	),
	good_type_name = 'auto';

-- 53. Измените имя "Andie Quincey" на новое "Andie Anthony".

UPDATE FamilyMembers
SET member_name = 'Andie Anthony'
WHERE member_name = 'Andie Quincey';

-- 54. Удалить всех членов семьи с фамилией "Quincey".

DELETE FROM FamilyMembers
WHERE member_name LIKE '%Quincey';

-- 55. Удалить компании, совершившие наименьшее количество рейсов.

DELETE FROM Company AS c
WHERE c.id IN (
		SELECT company
		FROM Trip
		GROUP BY company
		HAVING COUNT(*) = (
				SELECT MIN(count)
				FROM (
						SELECT COUNT(*) AS count
						FROM Trip
						GROUP BY company
					) AS min_count
			)
	);

-- 56. Удалить все перелеты, совершенные из Москвы (Moscow).

DELETE FROM Trip
WHERE town_from = 'Moscow';

-- 57. Перенести расписание всех занятий на 30 мин. вперед.

UPDATE Timepair
SET start_pair = start_pair + INTERVAL 30 MINUTE,
	end_pair = end_pair + INTERVAL 30 MINUTE;

-- 58. Добавить отзыв с рейтингом 5 на жилье, находящиеся по адресу "11218, Friel Place, New York", от имени "George Clooney". 
--     В качестве первичного ключа (id) укажите количество записей в таблице + 1. Резервация комнаты, на которую вам нужно оставить отзыв, уже была сделана, нужно лишь ее найти.

INSERT INTO Reviews
SET id = (
		SELECT COUNT(*) + 1
		FROM Reviews AS a
	),
	rating = 5,
	reservation_id = (
		SELECT res.id
		FROM Reservations AS res
			JOIN Rooms AS rms ON res.room_id = rms.id
			JOIN Users AS usr ON res.user_id = usr.id
		WHERE rms.address = '11218, Friel Place, New York'
			AND usr.name = 'George Clooney'
	)

-- 59. Вывести пользователей,указавших Белорусский номер телефона ? Телефонный код Белоруссии +375.

SELECT *
FROM Users
WHERE phone_number LIKE '+375%';

-- 60. Выведите идентификаторы преподавателей, которые хотя бы один раз за всё время преподавали в каждом из одиннадцатых классов.

SELECT teacher
FROM Schedule AS sch
	JOIN class AS cls ON sch.class = cls.id
WHERE name LIKE '11%'
GROUP BY teacher
HAVING COUNT(DISTINCT name) > 1;

-- 61. Выведите список комнат, которые были зарезервированы в течение 12 недели 2020 года.

SELECT DISTINCT Rooms.*
FROM Rooms
	JOIN Reservations ON Rooms.id = Reservations.room_id
WHERE WEEK(start_date, 1) = 12
	AND YEAR(start_date) = 2020;