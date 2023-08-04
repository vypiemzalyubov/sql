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