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