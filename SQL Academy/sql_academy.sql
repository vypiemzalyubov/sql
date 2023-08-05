-- 1. Вывести имена всех людей, которые есть в базе данных авиакомпаний

SELECT name
FROM Passenger;

-- 2. Вывести названия всеx авиакомпаний

SELECT name
FROM Company;

-- 3. Вывести все рейсы, совершенные из Москвы

SELECT *
FROM Trip
WHERE town_from = 'Moscow';

-- 4. Вывести имена людей, которые заканчиваются на "man"

SELECT name
FROM Passenger
WHERE name LIKE '%man';

-- 5. Вывести количество рейсов, совершенных на TU-134

SELECT COUNT(*) AS COUNT
FROM Trip
WHERE plane = 'TU-154';

-- 6. Какие компании совершали перелеты на Boeing

SELECT DISTINCT name
FROM Company
	JOIN Trip ON Company.id = Trip.company
WHERE plane = 'Boeing';

-- 7. Вывести все названия самолётов, на которых можно улететь в Москву (Moscow)

SELECT DISTINCT plane
FROM Trip
WHERE town_to = 'Moscow';

-- 8. В какие города можно улететь из Парижа (Paris) и сколько времени это займёт?

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

-- 12. Вывести id и количество пассажиров для всех прошедших полётов

SELECT trip AS trip,
	COUNT(passenger) AS count
FROM Pass_in_trip
GROUP BY trip;

-- 13. Вывести имена людей, у которых есть полный тёзка среди пассажиров

SELECT name
FROM Passenger
GROUP BY name
HAVING COUNT(*) > 1;