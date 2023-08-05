-- 54: Создать таблицу author следующей структуры: author_id INT PRIMARY KEY AUTO_INCREMENT, name_author VARCHAR(50).

CREATE TABLE author ( author_id INT PRIMARY KEY AUTO_INCREMENT, name_author VARCHAR(50))

-- 55: Заполнить таблицу author. В нее включить следующих авторов: Булгаков М.А., Достоевский Ф.М., Есенин С.А., Пастернак Б.Л.

INSERT author (name_author) VALUES ('Булгаков М.А.'), ('Достоевский Ф.М.'), ('Есенин С.А.'), ('Пастернак Б.Л.');

-- 56: Перепишите запрос на создание таблицы book, чтобы ее структура соответствовала структуре, показанной на логической схеме (таблица genre уже создана,
-- 	   порядок следования столбцов - как на логической схеме в таблице book, genre_id - внешний ключ). Для genre_id ограничение о недопустимости пустых значений не задавать.
-- 	   В качестве главной таблицы для описания поля genre_id использовать таблицу genre.

CREATE TABLE book ( book_id INT PRIMARY KEY AUTO_INCREMENT, title VARCHAR(50), author_id INT NOT NULL, genre_id INT, price DECIMAL(8, 2), amount INT, FOREIGN KEY (author_id) REFERENCES author (author_id), FOREIGN KEY (genre_id) REFERENCES genre (genre_id) );

-- 57: Создать таблицу book той же структуры, что и на предыдущем шаге. Будем считать, что при удалении автора из таблицы author, должны удаляться все записи о книгах из таблицы book,
--     написанные этим автором. А при удалении жанра из таблицы genre для соответствующей записи book установить значение Null в столбце genre_id.

CREATE TABLE book ( book_id INT PRIMARY KEY AUTO_INCREMENT, title VARCHAR(50), author_id INT NOT NULL, genre_id INT, price DECIMAL(8, 2), amount INT, FOREIGN KEY (author_id) REFERENCES author (author_id)
ON
DELETE CASCADE, FOREIGN KEY (genre_id) REFERENCES genre (genre_id)
ON DELETE

SET NULL );

-- 58: Добавьте три последние записи (с ключевыми значениями 6, 7, 8) в таблицу book, первые 5 записей уже добавлены.

INSERT book (title, author_id, genre_id, price, amount) VALUES ('Стихотворения и поэмы', 3, 2, 650.00, 15), ('Черный человек', 3, 2, 570.20, 6), ('Лирика', 4, 2, 518.99, 2)

-- 59: Вывести название, жанр и цену тех книг, количество которых больше 8, в отсортированном по убыванию цены виде.

SELECT  title
       ,name_genre
       ,price
FROM genre
INNER JOIN book
ON genre.genre_id = book.genre_id
WHERE amount > 8
ORDER BY price DESC

-- 60: Вывести все жанры, которые не представлены в книгах на складе.

SELECT  name_genre
FROM genre
LEFT JOIN book
ON genre.genre_id = book.genre_id
WHERE book.genre_id is Null

-- 61: Есть список городов, хранящийся в таблице city. Необходимо в каждом городе провести выставку книг каждого автора в течение 2020 года. Дату проведения выставки выбрать случайным образом.
--     Создать запрос, который выведет город, автора и дату проведения выставки. Последний столбец назвать Дата. Информацию вывести, отсортировав сначала в алфавитном порядке по названиям городов,
--     а потом по убыванию дат проведения выставок. Случайное число от 0 до 365 можно получить с помощью выражения: FLOOR(RAND() * 365).

SELECT  name_city
       ,name_author
       ,(DATE_ADD('2020-01-01',INTERVAL FLOOR(RAND() * 365) DAY)) AS Дата
FROM city
CROSS JOIN author
ORDER BY name_city, Дата DESC

-- 62: Вывести информацию о книгах (жанр, книга, автор), относящихся к жанру, включающему слово «роман» в отсортированном по названиям книг виде.

SELECT  name_genre
       ,title
       ,name_author
FROM genre
INNER JOIN book
ON genre.genre_id = book.genre_id
INNER JOIN author
ON author.author_id = book.author_id
WHERE name_genre IN ('роман')
ORDER BY title

-- 63: Посчитать количество экземпляров книг каждого автора из таблицы author. Вывести тех авторов, количество книг которых меньше 10, в отсортированном по возрастанию количества виде.
--     Последний столбец назвать Количество.

SELECT  name_author
       ,SUM(amount) AS Количество
FROM author
LEFT JOIN book
ON author.author_id = book.author_id
GROUP BY  name_author
HAVING SUM(amount) < 10 OR SUM(amount) IS NULL
ORDER BY Количество ASC

-- 64: Вывести в алфавитном порядке всех авторов, которые пишут только в одном жанре. Поскольку у нас в таблицах так занесены данные, что у каждого автора книги только в одном жанре,
--     для этого запроса внесем изменения в таблицу book. Пусть у нас книга Есенина «Черный человек» относится к жанру «Роман», а книга Булгакова «Белая гвардия» к «Приключениям».

SELECT  name_author
FROM author
LEFT JOIN book
ON author.author_id = book.author_id
GROUP BY  name_author
HAVING COUNT(DISTINCT(genre_id)) = 1

-- 65: Вывести информацию о книгах (название книги, фамилию и инициалы автора, название жанра, цену и количество экземпляров книги), написанных в самых популярных жанрах,
--     в отсортированном в алфавитном порядке по названию книг виде. Самым популярным считать жанр, общее количество экземпляров книг которого на складе максимально.

SELECT  title
       ,name_author
       ,name_genre
       ,price
       ,amount
FROM author
INNER JOIN book
ON author.author_id = book.author_id
INNER JOIN genre
ON book.genre_id = genre.genre_id
WHERE genre.genre_id IN ( SELECT query_in_1.genre_id FROM  ( SELECT genre_id, SUM(amount) AS sum_amount FROM book GROUP BY genre_id  )query_in_1 INNER JOIN  ( SELECT genre_id, SUM(amount) AS sum_amount FROM book GROUP BY genre_id ORDER BY sum_amount DESC LIMIT 1  ) query_in_2 ON query_in_1.sum_amount = query_in_2.sum_amount ) ORDER BY title

-- 66: Если в таблицах supply и book есть одинаковые книги, которые имеют равную цену, вывести их название и автора, а также посчитать общее количество экземпляров книг в таблицах supply и book,
--     столбцы назвать Название, Автор и Количество.

SELECT  book.title                  AS Название
       ,name_author                 AS Автор
       ,book.amount + supply.amount AS Количество
FROM author
INNER JOIN book USING
(author_id
)
INNER JOIN supply
ON book.title = supply.title AND author.name_author = supply.author
WHERE supply.price = book.price

-- 67: Для книг, которые уже есть на складе (в таблице book), но по другой цене, чем в поставке (supply), необходимо в таблице book увеличить количество на значение,
--     указанное в поставке, и пересчитать цену. А в таблице supply обнулить количество этих книг.

UPDATE book
INNER JOIN author
ON author.author_id = book.author_id
INNER JOIN supply
ON book.title = supply.title AND supply.author = author.name_author

SET book.price = (book.price * book.amount + supply.price * supply.amount)/(book.amount + supply.amount), book.amount = book.amount + supply.amount, supply.amount = 0
WHERE book.price != supply.price;

-- 68: Включить новых авторов в таблицу author с помощью запроса на добавление, а затем вывести все данные из таблицы author.
--     Новыми считаются авторы, которые есть в таблице supply, но нет в таблице author.

INSERT author (name_author)
SELECT  supply.author
FROM author
RIGHT JOIN supply
ON author.name_author = supply.author
WHERE name_author IS Null;

-- 69: Добавить новые книги из таблицы supply в таблицу book на основе сформированного выше запроса. Затем вывести для просмотра таблицу book.

INSERT book (title, author_id, price, amount)
SELECT  title
       ,author_id
       ,price
       ,amount
FROM author
INNER JOIN supply
ON author.name_author = supply.author
WHERE amount <> 0;

SELECT  *
FROM book;

-- 70: Занести для книги «Стихотворения и поэмы» Лермонтова жанр «Поэзия», а для книги «Остров сокровищ» Стивенсона - «Приключения» (Использовать два запроса). 

UPDATE book
SET genre_id = (
SELECT  genre_id
FROM genre
WHERE name_genre = 'Поэзия')
WHERE title LIKE 'Стихотворения и поэмы'
AND author_id IN ( SELECT author_id FROM author WHERE name_author LIKE 'Лермонтов%');

UPDATE book

SET genre_id = (
SELECT  genre_id
FROM genre
WHERE name_genre = 'Приключения')
WHERE title LIKE 'Остров сокровищ'
AND author_id IN ( SELECT author_id FROM author WHERE name_author LIKE 'Стивенсон%');

SELECT  *
FROM book;

-- 71: Удалить всех авторов и все их книги, общее количество книг которых меньше 20. 

DELETE
FROM author
WHERE author_id IN ( SELECT author_id FROM book GROUP BY author_id HAVING SUM(amount) < 20);

SELECT  *
FROM author;

SELECT  *
FROM book;

-- 72: Удалить все жанры, к которым относится меньше 4-х книг. В таблице book для этих жанров установить значение Null. 

DELETE
FROM genre
WHERE genre_id IN ( SELECT DISTINCT genre_id FROM book GROUP BY genre_id HAVING COUNT(amount) < 4);

SELECT  *
FROM genre;

SELECT  *
FROM book;

-- 73: Удалить всех авторов, которые пишут в жанре "Поэзия". Из таблицы book удалить все книги этих авторов. В запросе для отбора авторов использовать полное название жанра, а не его id. 

DELETE
FROM author USING author
INNER JOIN book
ON author.author_id = book.author_id
INNER JOIN genre
ON genre.genre_id = book.genre_id
WHERE name_genre = 'Поэзия';

-- 74: Вывести все заказы Баранова Павла (id заказа, какие книги, по какой цене и в каком количестве он заказал) в отсортированном по номеру заказа и названиям книг виде.

SELECT  buy.buy_id
       ,book.title
       ,book.price
       ,buy_book.amount
FROM client
INNER JOIN buy
ON client.client_id = buy.client_id
INNER JOIN buy_book
ON buy_book.buy_id = buy.buy_id
INNER JOIN book
ON buy_book.book_id = book.book_id
WHERE name_client = 'Баранов Павел'
ORDER BY buy_id, title

-- 75: Посчитать, сколько раз была заказана каждая книга, для книги вывести ее автора (нужно посчитать, в каком количестве заказов фигурирует каждая книга).
-- Вывести фамилию и инициалы автора, название книги, последний столбец назвать Количество. Результат отсортировать сначала по фамилиям авторов, а потом по названиям книг.

SELECT  name_author
       ,title
       ,COUNT(buy_book.amount) AS Количество
FROM author
INNER JOIN book
ON author.author_id = book.author_id
LEFT JOIN buy_book
ON book.book_id = buy_book.book_id
GROUP BY  title
         ,name_author
ORDER BY name_author
         ,title

-- 76: Вывести города, в которых живут клиенты, оформлявшие заказы в интернет-магазине. Указать количество заказов в каждый город, этот столбец назвать Количество.
-- Информацию вывести по убыванию количества заказов, а затем в алфавитном порядке по названию городов.

SELECT  name_city
       ,COUNT(name_city) AS Количество
FROM city
INNER JOIN client
ON city.city_id = client.city_id
INNER JOIN buy
ON client.client_id = buy.client_id
GROUP BY  name_city
ORDER BY Количество DESC
         ,name_city

-- 77: Вывести номера всех оплаченных заказов и даты, когда они были оплачены.

SELECT  buy_id
       ,date_step_end
FROM step
INNER JOIN buy_step
ON step.step_id = buy_step.step_id
WHERE buy_step.step_id = 1
AND date_step_end IS NOT NULL

-- 78: Вывести информацию о каждом заказе: его номер, кто его сформировал (фамилия пользователя) и его стоимость (сумма произведений количества заказанных книг и их цены),
-- в отсортированном по номеру заказа виде. Последний столбец назвать Стоимость.

SELECT  buy.buy_id
       ,name_client
       ,SUM(buy_book.amount*book.price) AS Стоимость
FROM book
INNER JOIN buy_book
ON book.book_id = buy_book.book_id
INNER JOIN buy
ON buy_book.buy_id = buy.buy_id
INNER JOIN client
ON buy.client_id = client.client_id
GROUP BY  buy.buy_id
ORDER BY buy.buy_id

-- 79: Вывести номера заказов (buy_id) и названия этапов, на которых они в данный момент находятся. Если заказ доставлен – информацию о нем не выводить.
-- Информацию отсортировать по возрастанию buy_id.

SELECT  buy_id
       ,name_step
FROM step
INNER JOIN buy_step
ON step.step_id = buy_step.step_id
WHERE date_step_beg IS NOT NULL
AND date_step_end IS NULL
ORDER BY buy_id

-- 80: В таблице city для каждого города указано количество дней, за которые заказ может быть доставлен в этот город (рассматривается только этап Транспортировка).
-- Для тех заказов, которые прошли этап транспортировки, вывести количество дней за которое заказ реально доставлен в город.
-- А также, если заказ доставлен с опозданием, указать количество дней задержки, в противном случае вывести 0.
-- В результат включить номер заказа (buy_id), а также вычисляемые столбцы Количество_дней и Опоздание. Информацию вывести в отсортированном по номеру заказа виде.

SELECT  buy.buy_id
       ,DATEDIFF(date_step_end,date_step_beg)                                                                             AS Количество_дней
       ,IF(DATEDIFF(date_step_end,date_step_beg) > days_delivery,DATEDIFF(date_step_end,date_step_beg) - days_delivery,0) AS Опоздание
FROM city
INNER JOIN client
ON city.city_id = client.city_id
INNER JOIN buy
ON client.client_id = buy.client_id
INNER JOIN buy_step
ON buy.buy_id = buy_step.buy_id
INNER JOIN step
ON buy_step.step_id = step.step_id
WHERE date_step_end IS NOT NULL
AND buy_step.step_id = 3
ORDER BY buy.buy_id

-- 81: Выбрать всех клиентов, которые заказывали книги Достоевского, информацию вывести в отсортированном по алфавиту виде. В решении используйте фамилию автора, а не его id.

SELECT  DISTINCT client.name_client
FROM author
INNER JOIN book
ON author.author_id = book.author_id
INNER JOIN buy_book
ON book.book_id = buy_book.book_id
INNER JOIN buy
ON buy_book.buy_id = buy.buy_id
INNER JOIN client
ON buy.client_id = client.client_id
WHERE author.name_author = 'Достоевский Ф.М.'
ORDER BY client.name_client

-- 82: Вывести жанр (или жанры), в котором было заказано больше всего экземпляров книг, указать это количество. Последний столбец назвать Количество.

SELECT  name_genre
       ,SUM(buy_book.amount) AS Количество
FROM genre
JOIN book USING
(genre_id
)
JOIN buy_book USING
(book_id
)
GROUP BY  name_genre
HAVING SUM(buy_book.amount) = (
SELECT  MAX(sum_amount) AS max_sum_amount
FROM
(
	SELECT  genre_id
	       ,SUM(buy_book.amount) AS sum_amount
	FROM book
	JOIN buy_book USING
	(book_id
	)
	GROUP BY  genre_id
) query_max)

-- 83: Сравнить ежемесячную выручку от продажи книг за текущий и предыдущий годы. Для этого вывести год, месяц, сумму выручки в отсортированном сначала по возрастанию месяцев,
-- затем по возрастанию лет виде. Название столбцов: Год, Месяц, Сумма.

SELECT  YEAR(date_step_end)             AS 'Год'
       ,MONTHNAME(date_step_end)        AS 'Месяц'
       ,SUM(book.price*buy_book.amount) AS 'Сумма'
FROM buy_step
JOIN buy_book USING
(buy_id
)
JOIN book USING
(book_id
)
WHERE step_id = 1
AND date_step_end IS NOT NULL
GROUP BY  YEAR(date_step_end)
         ,MONTHNAME(date_step_end)
UNION ALL
SELECT  YEAR(date_payment)
       ,MONTHNAME(date_payment)
       ,SUM(price*amount)
FROM buy_archive
GROUP BY  YEAR(date_payment)
         ,MONTHNAME(date_payment)
ORDER BY 2
         ,1;

-- 84: Для каждой отдельной книги необходимо вывести информацию о количестве проданных экземпляров и их стоимости за текущий и предыдущий год.
-- Вычисляемые столбцы назвать Количество и Сумма. Информацию отсортировать по убыванию стоимости.

SELECT  title
       ,SUM(Количество) AS Количество
       ,SUM(Сумма)      AS Сумма
FROM
(
	SELECT  title
	       ,SUM(buy_archive.amount)                   AS Количество
	       ,SUM(buy_archive.price*buy_archive.amount) AS Сумма
	FROM buy_archive
	JOIN book USING
	(book_id
	)
	GROUP BY  title
	UNION ALL
	SELECT  title
	       ,SUM(buy_book.amount)       AS Количество
	       ,SUM(price*buy_book.amount) AS Сумма
	FROM book
	JOIN buy_book USING
	(book_id
	)
	JOIN buy_step USING
	(buy_id
	)
	JOIN step USING
	(step_id
	)
	WHERE step.name_step = 'Оплата'
	AND buy_step.date_step_end IS NOT NULL
	GROUP BY  title
) AS query_in
GROUP BY  title
ORDER BY Сумма DESC

-- 85: Включить нового человека в таблицу с клиентами. Его имя Попов Илья, его email popov@test, проживает он в Москве.

INSERT INTO client (name_client, city_id, email)
SELECT  'Попов Илья'
       ,city_id
       ,'popov@test'
FROM city
WHERE name_city = 'Москва';

SELECT  *
FROM client;

-- 86: Создать новый заказ для Попова Ильи. Его комментарий для заказа: «Связаться со мной по вопросу доставки».

INSERT INTO buy (buy_description, client_id)
SELECT  'Связаться со мной по вопросу доставки'
       ,client_id
FROM client
WHERE name_client = 'Попов Илья';

SELECT  *
FROM buy;

-- 87: В таблицу buy_book добавить заказ с номером 5. Этот заказ должен содержать книгу Пастернака «Лирика» в количестве двух экземпляров и книгу Булгакова «Белая гвардия» в одном экземпляре.

INSERT buy_book (buy_id, book_id, amount)
SELECT  5
       ,book_id
       ,2
FROM author
INNER JOIN book USING
(author_id
)
WHERE name_author = 'Пастернак Б.Л.'
AND title = 'Лирика';
INSERT buy_book (buy_id, book_id, amount)
SELECT  5
       ,book_id
       ,1
FROM author
INNER JOIN book USING
(author_id
)
WHERE name_author = 'Булгаков М.А.'
AND title = 'Белая гвардия';

SELECT  *
FROM buy_book;

-- 88: Количество тех книг на складе, которые были включены в заказ с номером 5, уменьшить на то количество, которое в заказе с номером 5 указано. 

UPDATE book, buy_book
SET book.amount = book.amount - buy_book.amount
WHERE buy_book.buy_id = 5
AND book.book_id = buy_book.book_id;

SELECT  *
FROM book;

-- 89: Создать счет (таблицу buy_pay) на оплату заказа с номером 5, в который включить название книг, их автора, цену, количество заказанных книг и стоимость.
-- Последний столбец назвать Стоимость. Информацию в таблицу занести в отсортированном по названиям книг виде.

CREATE TABLE buy_pay AS
SELECT  title
       ,name_author
       ,price
       ,buy_book.amount
       ,book.price * buy_book.amount AS Стоимость
FROM buy_book
JOIN book
ON book.book_id = buy_book.book_id
JOIN author
ON author.author_id = book.author_id
WHERE buy_book.buy_id = 5
ORDER BY book.title;

SELECT  *
FROM buy_pay;

-- 90: Создать общий счет (таблицу buy_pay) на оплату заказа с номером 5. Куда включить номер заказа, количество книг в заказе (название столбца Количество)
-- и его общую стоимость (название столбца Итого). Для решения используйте ОДИН запрос.

CREATE TABLE buy_pay
SELECT  buy_id
       ,SUM(buy_book.amount)              AS Количество
       ,SUM(book.price * buy_book.amount) AS Итого
FROM buy_book
INNER JOIN book
ON buy_book.book_id = book.book_id
GROUP BY  buy_id
HAVING buy_book.buy_id = 5;

SELECT  *
FROM buy_pay;

-- 91: В таблицу buy_step для заказа с номером 5 включить все этапы из таблицы step, которые должен пройти этот заказ. В столбцы date_step_beg и date_step_end всех записей занести Null.

INSERT INTO buy_step (buy_id, step_id, date_step_beg, date_step_end)
SELECT  buy_id
       ,step_id
       ,NULL
       ,NULL
FROM step
CROSS JOIN buy
WHERE buy_id = 5;

SELECT  *
FROM buy_step;

-- 92: В таблицу buy_step занести дату 12.04.2020 выставления счета на оплату заказа с номером 5. 

UPDATE buy_step
SET date_step_beg = '2020-04-12'
WHERE buy_id = 5
AND step_id = 1;

SELECT  *
FROM buy_step;

-- 93: Завершить этап «Оплата» для заказа с номером 5, вставив в столбец date_step_end дату 13.04.2020, и начать следующий этап («Упаковка»), задав в столбце date_step_beg для этого этапа ту же дату.
-- Реализовать два запроса для завершения этапа и начала следующего. Они должны быть записаны в общем виде, чтобы его можно было применять для любых этапов, изменив только текущий этап.
-- Для примера пусть это будет этап «Оплата». 

UPDATE buy_step
SET date_step_end = '2020.04.13'
WHERE buy_id = 5
AND step_id IN ( SELECT step_id FROM step WHERE name_step = 'Оплата'); UPDATE buy_step

SET date_step_beg = '2020.04.13'
WHERE buy_id = 5
AND step_id IN ( SELECT step_id FROM step WHERE step_id = 2 );