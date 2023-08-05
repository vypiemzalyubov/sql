-- 1. Сформулируйте SQL запрос для создания таблицы book, занесите его в окно кода и отправьте на проверку.
	
			CREATE TABLE book(
				book_id	INT PRIMARY KEY AUTO_INCREMENT,
				title	 VARCHAR(50),
				author	 VARCHAR(30),
				price	 DECIMAL(8, 2),
				amount	 INT
			);

-- 2. Занесите новую строку в таблицу book (текстовые значения (тип VARCHAR) заключать либо в двойные, либо в одинарные кавычки).

			INSERT INTO book (title, author, price, amount) 
			VALUES ('Мастер и Маргарита', 'Булгаков М.А.', 670.99, 3);
			
-- 3. Занесите три последние записи в таблицу book, первая запись уже добавлена на предыдущем шаге.

			INSERT book (title, author, price, amount)
			VALUES ('Белая гвардия', 'Булгаков М.А.', 540.50,  5);

			INSERT book (title, author, price, amount)
			VALUES ('Идиот', 'Достоевский Ф.М.', 460.00, 10);

			INSERT book (title, author, price, amount)
			VALUES ('Братья Карамазовы', 'Достоевский Ф.М.', 799.01, 2);
			
-- 4. Вывести информацию о всех книгах, хранящихся на складе.

			SELECT * FROM book;

-- 5. Выбрать авторов, название книг и их цену из таблицы book.

			SELECT author, title, price FROM book;
			
-- 6. Выбрать названия книг и авторов из таблицы book, для поля title задать имя(псевдоним) Название, для поля author – Автор.

			SELECT title AS Название, author AS Автор FROM book;
			
-- 7. Для упаковки каждой книги требуется один лист бумаги, цена которого 1 рубль 65 копеек.
--    Посчитать стоимость упаковки для каждой книги (сколько денег потребуется, чтобы упаковать все экземпляры книги).
--    В запросе вывести название книги, ее количество и стоимость упаковки, последний столбец назвать pack.
			
			SELECT title, amount,
			amount * 1.65 AS pack
			FROM book;

-- 8. В конце года цену всех книг на складе пересчитывают – снижают ее на 30%.
--    Написать SQL запрос, который из таблицы book выбирает названия, авторов, количества и вычисляет новые цены книг.
--    Столбец с новой ценой назвать new_price, цену округлить до 2-х знаков после запятой.
			
			SELECT title, author, amount,
			ROUND(price - price * (30/100),2) AS new_price
			FROM book;

-- 9. При анализе продаж книг выяснилось, что наибольшей популярностью пользуются книги Михаила Булгакова, на втором месте книги Сергея Есенина.
--    Исходя из этого решили поднять цену книг Булгакова на 10%, а цену книг Есенина - на 5%.
--    Написать запрос, куда включить автора, название книги и новую цену, последний столбец назвать new_price. Значение округлить до двух знаков после запятой.
			
			SELECT author, title,
			ROUND(IF(author = 'Булгаков М.А.', price * 1.1, IF(author = 'Есенин С.А.', price * 1.05, price)), 2) AS new_price
			FROM book;

-- 10. Вывести автора, название  и цены тех книг, количество которых меньше 10.

			SELECT author, title, price
			FROM book
			WHERE amount < 10
			
-- 11. Вывести название, автора,  цену  и количество всех книг, цена которых меньше 500 или больше 600, а стоимость всех экземпляров этих книг больше или равна 5000.

			SELECT title, author, price, amount
			FROM book
			WHERE (price < 500 OR price > 600) AND price * amount >= 5000
			
-- 12. Вывести название и авторов тех книг, цены которых принадлежат интервалу от 540.50 до 800 (включая границы), а количество или 2, или 3, или 5, или 7.
			
			SELECT title, author
			FROM book
			WHERE (price BETWEEN 540.05 AND 800) AND (amount IN(2, 3, 5, 7))
			
-- 13. Вывести  автора и название  книг, количество которых принадлежит интервалу от 2 до 14 (включая границы).
--     Информацию  отсортировать сначала по авторам (в обратном алфавитном порядке), а затем по названиям книг (по алфавиту).
			
			SELECT author, title
			FROM book
			WHERE amount BETWEEN 2 AND 14
			ORDER BY author DESC, title ASC
			
-- 14. Вывести название и автора тех книг, название которых состоит из двух и более слов, а инициалы автора содержат букву «С».
--     Считать, что в названии слова отделяются друг от друга пробелами и не содержат знаков препинания, между фамилией автора и инициалами обязателен пробел, 
--     инициалы записываются без пробела в формате: буква, точка, буква, точка. Информацию отсортировать по названию книги в алфавитном порядке.
			
			SELECT title, author
			FROM book
			WHERE (title LIKE '_% _%') AND (author LIKE '%С.%')
			ORDER BY title ASC

-- 15. Отобрать различные (уникальные) элементы столбца amount таблицы book.

			SELECT DISTINCT amount
			FROM book
			
-- 16. Посчитать, количество различных книг и количество экземпляров книг каждого автора , хранящихся на складе.
--     Столбцы назвать Автор, Различных_книг и Количество_экземпляров соответственно.
			
			SELECT author AS Автор, COUNT(amount) AS Различных_книг, SUM(amount) AS Количество_экземпляров
			FROM book
			GROUP BY author
			
-- 17. Вывести фамилию и инициалы автора, минимальную, максимальную и среднюю цену книг каждого автора.
--     Вычисляемые столбцы назвать Минимальная_цена, Максимальная_цена и Средняя_цена соответственно.
			
			SELECT author, MIN(price) AS Минимальная_цена, MAX(price) AS Максимальная_цена, AVG(price) AS Средняя_цена
			FROM book
			GROUP BY author
			
-- 18. Для каждого автора вычислить суммарную стоимость книг S (имя столбца Стоимость), а также вычислить налог на добавленную стоимость для полученных сумм (имя столбца НДС ), 
--     который включен в стоимость и составляет k = 18%, а также стоимость книг (Стоимость_без_НДС) без него. Значения округлить до двух знаков после запятой.
			
			SELECT author, SUM(price * amount) AS Стоимость, 
				   ROUND(SUM((price * amount) * (18/100))/(1+(18/100)),2) AS НДС,
				   ROUND(SUM(price * amount)/(1+(18/100)),2) AS Стоимость_без_НДС
			FROM book
			GROUP BY author
			
-- 19. Вывести  цену самой дешевой книги, цену самой дорогой и среднюю цену уникальных книг на складе.
--     Названия столбцов Минимальная_цена, Максимальная_цена, Средняя_цена соответственно. Среднюю цену округлить до двух знаков после запятой.
			
			SELECT MIN(price) AS Минимальная_цена,
				   MAX(price) AS Максимальная_цена,
				   ROUND(AVG(price),2) AS Средняя_цена 
			FROM book
			
-- 20. Вычислить среднюю цену и суммарную стоимость тех книг, количество экземпляров которых принадлежит интервалу от 5 до 14, включительно.
--     Столбцы назвать Средняя_цена и Стоимость, значения округлить до 2-х знаков после запятой.
			
			SELECT ROUND(AVG(price),2) AS Средняя_цена, 
				   ROUND(SUM(price*amount),2) AS Стоимость
			FROM book
			WHERE amount BETWEEN 5 AND 14;
			
-- 21. Посчитать стоимость всех экземпляров каждого автора без учета книг «Идиот» и «Белая гвардия».
--     В результат включить только тех авторов, у которых суммарная стоимость книг (без учета книг «Идиот» и «Белая гвардия») более 5000 руб.
--     Вычисляемый столбец назвать Стоимость. Результат отсортировать по убыванию стоимости.
			
			SELECT author,
				SUM(price*amount) AS Стоимость
			FROM book
			WHERE title NOT IN("Идиот", "Белая гвардия")
			GROUP BY author
			HAVING SUM(price*amount) > 5000
			ORDER BY Стоимость DESC
			
-- 22. Вывести информацию (автора, название и цену) о  книгах, цены которых меньше или равны средней цене книг на складе.
--     Информацию вывести в отсортированном по убыванию цены виде. Среднее вычислить как среднее по цене книги.
			
			SELECT author, title, price
			FROM book
			WHERE price <= (
					SELECT AVG(price)
					FROM book)
			ORDER BY price DESC
			
-- 23. Вывести информацию (автора, название и цену) о тех книгах, цены которых превышают минимальную цену книги на складе не более чем на 150 рублей в отсортированном по возрастанию цены виде.
			
			SELECT author, title, price
			FROM book
			WHERE ABS(price - (SELECT MIN(price) FROM book)) <= 150
			ORDER BY price
			
-- 24. Вывести информацию (автора, книгу и количество) о тех книгах, количество экземпляров которых в таблице book не дублируется.

			SELECT author, title, amount
			FROM book
			WHERE amount IN (
					SELECT amount
					FROM book
					GROUP BY amount
					HAVING COUNT(amount) = 1
					)

-- 25. Вывести информацию о книгах(автор, название, цена), цена которых меньше самой большой из минимальных цен, вычисленных для каждого автора.
			
			SELECT author, title, price
			FROM book
			WHERE price < ANY (
					  SELECT MIN(price)
					  FROM book
					  GROUP BY author
					  )
							  
-- 26. Посчитать сколько и каких экземпляров книг нужно заказать поставщикам, чтобы на складе стало одинаковое количество экземпляров каждой книги, 
--     равное значению самого большего количества экземпляров одной книги на складе. Вывести название книги, ее автора, текущее количество экземпляров на складе
--     и количество заказываемых экземпляров книг. Последнему столбцу присвоить имя Заказ. В результат не включать книги, которые заказывать не нужно.
			
			SELECT title, author, amount,
						    (
						     SELECT MAX(amount)
						     FROM book
						    ) - amount AS Заказ
			FROM book
			WHERE amount NOT IN (SELECT MAX(amount) FROM book)
									
-- 27. Создать таблицу поставка (supply), которая имеет ту же структуру, что и таблиц book.
			
			CREATE  TABLE supply(
				supply_id INT PRIMARY KEY AUTO_INCREMENT,
				title VARCHAR(50), 
				author VARCHAR(30), 
				price DECIMAL(8,2), 
				amount INT
				);
				
-- 28. Занесите в таблицу supply четыре записи, чтобы получилась следующая таблица.
			
			INSERT supply (
				title,	author, price, amount
			) VALUES 
			('Лирика', 'Пастернак Б.Л.', 518.99,2),
			('Черный человек', 'Есенин С.А.',570.20,6),
			('Белая гвардия','Булгаков М.А.', 540.50,7), ('Идиот', 'Достоевский Ф.М.',360.80, 3)
			
-- 29. Добавить из таблицы supply в таблицу book, все книги, кроме книг, написанных Булгаковым М.А. и Достоевским Ф.М.

			INSERT book (title, author, price, amount)
			VALUES 
			('Лирика', 'Пастернак Б.Л.', 518.99,2),
			('Черный человек', 'Есенин С.А.',570.20,6)
			
-- 30. Занести из таблицы supply в таблицу book только те книги, авторов которых нет в book.
			
		INSERT book (title, author, price, amount) SELECT title, author, price, amount 
		FROM supply 
		WHERE author NOT IN ( 
                 		    SELECT author 
                 		    FROM book);
				 
-- 31. Уменьшить на 10% цену тех книг в таблице book, количество которых принадлежит интервалу от 5 до 10, включая границы.

			UPDATE book 
			SET price = 0.9 * price 
			WHERE amount BETWEEN 5 AND 10;
			
-- 32. В таблице book необходимо скорректировать значение для покупателя в столбце buy таким образом, чтобы оно не превышало количество экземпляров книг, указанных в столбце amount. 
--     А цену тех книг, которые покупатель не заказывал, снизить на 10%.
			
			UPDATE book 
			SET buy = IF (buy >= amount, amount, buy),
			price = IF (buy = 0, price * 0.9, price)
			
-- 33. Для тех книг в таблице book, которые есть в таблице supply, не только увеличить их количество в таблице book (увеличить их количество на значение столбца amount таблицы supply), 
--     но и пересчитать их цену (для каждой книги найти сумму цен из таблиц book и supply и разделить на 2).
			
			UPDATE book, supply 
			SET book.amount = book.amount + supply.amount,
			book.price = (book.price + supply.price)/2
			WHERE book.title = supply.title AND book.author = supply.author;
			
-- 34. Удалить из таблицы supply книги тех авторов, общее количество экземпляров книг которых в таблице book превышает 10.

			DELETE FROM supply 
			WHERE author IN (
					SELECT author
					FROM book
					GROUP BY author
					HAVING  SUM(amount) > 10
					);
						
-- 35. Создать таблицу заказ (ordering), куда включить авторов и названия тех книг, количество экземпляров которых в таблице book меньше среднего количества экземпляров книг в таблице book.
--     В таблицу включить столбец amount, в котором для всех книг указать одинаковое значение - среднее количество экземпляров книг в таблице book.
			
			CREATE TABLE ordering AS 
			SELECT author, title, 
					( 
					SELECT AVG(amount) 
					FROM book 
					) AS amount 
			FROM book 
			WHERE amount < (
					SELECT AVG(amount)
					FROM book
					);
			
-- 36. Вывести из таблицы trip информацию о командировках тех сотрудников, фамилия которых заканчивается на букву «а», в отсортированном по убыванию даты последнего дня командировки виде. 
--     В результат включить столбцы name, city, per_diem, date_first, date_last.
			
			SELECT name, city, per_diem, date_first, date_last
			FROM trip
			WHERE name LIKE '%а %.'
			ORDER BY date_last DESC
			
-- 37. Вывести в алфавитном порядке фамилии и инициалы тех сотрудников, которые были в командировке в Москве.

			SELECT DISTINCT  name
			FROM trip
			WHERE city LIKE 'Москва'
			ORDER BY name
			
-- 38. Для каждого города посчитать, сколько раз сотрудники в нем были. Информацию вывести в отсортированном в алфавитном порядке по названию городов. Вычисляемый столбец назвать Количество.
			
			SELECT city, COUNT(city) AS Количество
			FROM trip
			GROUP BY city
			ORDER BY city 

-- 39. Вывести два города, в которых чаще всего были в командировках сотрудники. Вычисляемый столбец назвать Количество.
			
			SELECT city, COUNT(city) AS Количество
			FROM trip
			GROUP BY city
			ORDER BY COUNT(city) DESC
			LIMIT 2
			
-- 40. Вывести информацию о командировках во все города кроме Москвы и Санкт-Петербурга (фамилии и инициалы сотрудников, город ,длительность командировки в днях, при этом первый и последний день 
--     относится к периоду командировки). Последний столбец назвать Длительность. Информацию вывести в упорядоченном по убыванию длительности поездки, а потом по убыванию названий городов 
--     (в обратном алфавитном порядке). Увеличьте разницу на 1, чтобы включить первый день командировки.
			
			SELECT name, city, DATEDIFF(date_last, date_first) + 1 AS Длительность
			FROM trip
			WHERE city NOT IN ('Москва', 'Санкт-Петербург')
			ORDER BY Длительность DESC, city DESC 
			
-- 41. Вывести информацию о командировках сотрудника(ов), которые были самыми короткими по времени. В результат включить столбцы name, city, date_first, date_last
			
			SELECT name, city, date_first, date_last
			FROM trip
			WHERE (
				SELECT 
				MIN(DATEDIFF(date_last, date_first))
				FROM trip
				) = DATEDIFF(date_last, date_first)
					
-- 42. Вывести информацию о командировках, начало и конец которых относятся к одному месяцу (год может быть любой). В результат включить столбцы name, city, date_first, date_last.
--     Строки отсортировать сначала в алфавитном порядке по названию города, а затем по фамилии сотрудника.
			
			SELECT name, city, date_first, date_last
			FROM trip
			WHERE MONTH(date_first) = MONTH(date_last)
			ORDER BY city, name
			
-- 43. 	Вывести название месяца и количество командировок для каждого месяца. Считаем, что командировка относится к некоторому месяцу, если она началась в этом месяце.
--      Информацию вывести сначала в отсортированном по убыванию количества, а потом в алфавитном порядке по названию месяца виде. Название столбцов – Месяц и Количество.
			
			SELECT MONTHNAME(date_first) AS Месяц, COUNT(date_first) AS Количество
			FROM trip
			GROUP BY Месяц
			ORDER BY Количество DESC, Месяц
			
-- 44. Вывести сумму суточных (произведение количества дней командировки и размера суточных) для командировок, первый день которых пришелся на февраль или март 2020 года. 
--     Значение суточных для каждой командировки занесено в столбец per_diem. Вывести фамилию и инициалы сотрудника, город, первый день командировки и сумму суточных. Последний столбец назвать Сумма.
--     Информацию отсортировать сначала в алфавитном порядке по фамилиям сотрудников, а затем по убыванию суммы суточных.
			
			SELECT name, city, date_first, per_diem * (DATEDIFF(date_last, date_first)+1) AS Сумма
			FROM trip
			WHERE (MONTH(date_first) = 2 AND YEAR(date_first) = 2020) OR (MONTH(date_first) = 3 AND YEAR(date_first) = 2020)
			ORDER BY name, Сумма DESC

-- 45. Вывести фамилию с инициалами и общую сумму суточных, полученных за все командировки для тех сотрудников, которые были в командировках больше чем 3 раза, 
--     в отсортированном по убыванию сумм суточных виде. Последний столбец назвать Сумма.
			
			SELECT name, SUM(per_diem * (DATEDIFF(date_last, date_first)+1)) AS Сумма
			FROM trip
			GROUP BY name
			HAVING COUNT(name) > 3
			ORDER BY Сумма DESC
			
-- 46. Создать таблицу fine следующей структуры.
			
			CREATE  TABLE fine(
					fine_id	 INT PRIMARY KEY AUTO_INCREMENT,
					name VARCHAR(30),
					number_plate VARCHAR(6),
					violation VARCHAR(50),
					sum_fine DECIMAL(8,2), 
					date_violation DATE,
					date_payment DATE
					);

-- 47. В таблицу fine первые 5 строк уже занесены. Добавить в таблицу записи с ключевыми значениями 6, 7, 8.
			
			INSERT fine(
				name, number_plate, violation, sum_fine, date_violation, date_payment)
			VALUES ('Баранов П.Е.', 'Р523ВТ', 'Превышение скорости(от 40 до 60)', NULL, '2020-02-14', NULL),
				   ('Абрамова К.А.', 'О111АВ', 'Проезд на запрещающий сигнал', NULL, '2020-02-23', NULL),
				   ('Яковлев Г.Р.', 'Т330ТТ', 'Проезд на запрещающий сигнал', NULL, '2020-03-03', NULL)
				   
-- 48. Занести в таблицу fine суммы штрафов, которые должен оплатить водитель, в соответствии с данными из таблицы traffic_violation. При этом суммы заносить только в пустые поля столбца sum_fine.
--     Таблица traffic_violation создана и заполнена. Сравнение значения столбца с пустым значением осуществляется с помощью оператора IS NULL.
			
			UPDATE fine AS f, traffic_violation AS tv
			SET f.sum_fine = tv.sum_fine
			WHERE (f.sum_fine IS NULL) AND f.violation = tv.violation

-- 49. Вывести фамилию, номер машины и нарушение только для тех водителей, которые на одной машине нарушили одно и то же правило два и более раз. 
--     При этом учитывать все нарушения, независимо от того оплачены они или нет. 
--     Информацию отсортировать в алфавитном порядке, сначала по фамилии водителя, потом по номеру машины и, наконец, по нарушению.
			
			SELECT name, number_plate, violation
			FROM fine
			GROUP BY name, number_plate, violation
			HAVING COUNT(violation) >= 2
			ORDER by name, number_plate, violation
			
-- 50. В таблице fine увеличить в два раза сумму неоплаченных штрафов для отобранных на предыдущем шаге записей.
			
			UPDATE 
				fine, 
				(SELECT name, number_plate, violation
					FROM fine
					GROUP BY name, number_plate, violation
					HAVING COUNT(violation) >= 2
					ORDER by name, number_plate, violation) query_in
			SET 
				sum_fine = sum_fine * 2
			WHERE 
				date_payment is null AND
				fine.name = query_in.name AND
				fine.number_plate = query_in.number_plate AND
				fine.violation = query_in.violation
				
-- 51. Водители оплачивают свои штрафы. В таблице payment занесены даты их оплаты.
--     Необходимо: в таблицу fine занести дату оплаты соответствующего штрафа из таблицы payment уменьшить начисленный штраф в таблице fine в два раза 
--     (только для тех штрафов, информация о которых занесена в таблицу payment), если оплата произведена не позднее 20 дней со дня нарушения.
			
			UPDATE fine f, payment p
			SET f.date_payment = p.date_payment, f.sum_fine = IF (DATEDIFF(p.date_payment, p.date_violation) < 21, f.sum_fine / 2, f.sum_fine)
			WHERE f.name = p.name AND f.number_plate = p.number_plate AND f.violation = p.violation AND f.date_violation = p.date_violation
			
-- 52. Создать новую таблицу back_payment, куда внести информацию о неоплаченных штрафах (Фамилию и инициалы водителя, номер машины, нарушение, сумму штрафа  и  дату нарушения) из таблицы fine.
			
			CREATE TABLE back_payment AS 
			SELECT name, number_plate, violation, sum_fine, date_violation
			FROM fine
			WHERE date_payment IS NULL
			
-- 53. Удалить из таблицы fine информацию о нарушениях, совершенных раньше 1 февраля 2020 года.
			
			DELETE FROM fine
			WHERE date_violation < '2020-02-01';