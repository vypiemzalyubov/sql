# Дата и время в SQL

Из всех типов данных в SQL временны́е данные являются наиболее сложными.
Сложность возникает по нескольким причинам, и вот некоторые из них:

- множество способов задания даты и времени
- наличие временных зон
- неочевидность вычислений некоторых значений на основании временных данных.
  Например, сложность вычисления возраста.

## Генерация временных данных

Временные данные можно получить одним из следующих способов:

- скопировать данные из существующего столбца с времéнным типом данных
- задать дату и время через строковое представление
- получить временны́е данные путём вызова встроенных функций, возвращающих временной тип данных

### Строковое представление временных данных

Для задания даты и времени используются следующие форматы:

| Тип         | Формат по умолчанию                                                                                                                                                          |
| :---------- | :--------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `DATE`      | `YYYY-MM-DD`                                                                                                                                                                 |
| `DATETIME`  | `YYYY-MM-DD hh:mm:ss`                                                                                                                                                        |
| `TIMESTAMP` | `YYYY-MM-DD hh:mm:ss`                                                                                                                                                        |
| `TIME`      | `hhh:mm:sss`                                                                                                                                                                 |
| `YEAR`      | `YYYY` - полный формат <br /> `YY` или `Y` - сокращённый формат, который возвращает год в пределах 2000-2069 для значений 0-69 и год в пределах 1970-1999 для значений 70-99 |

Причём, при указании даты допускается использовать любой знак пунктуации в качестве разделительного между частями разделов даты или времени.
Также возможно задавать дату вообще без разделительного знака, слитно.

Примеры валидного задания временных значений через строковое представление:

```sql
SELECT  CAST("2022-06-16 16:37:23" AS DATETIME) AS datetime_1,
        CAST("2014/02/22 16*37*22" AS DATETIME) AS datetime_2,
        CAST("20220616163723" AS DATETIME) AS datetime_3,
        CAST("2021-02-12" AS DATE) AS date_1,
        CAST("160:23:13" AS TIME) AS time_1,
        CAST("89" AS YEAR) AS year
```

| datetime_1               | datetime_2               | datetime_3               | date_1                   | time_1    | year |
| ------------------------ | ------------------------ | ------------------------ | ------------------------ | --------- | ---- |
| 2022-06-16T16:37:23.000Z | 2014-02-22T16:37:22.000Z | 2022-06-16T16:37:23.000Z | 2021-02-12T00:00:00.000Z | 160:23:13 | 1989 |

В запросе выше для принудительного преобразования строки в дату и время была использована функция `CAST`.
Она необходима, если сервер не ожидает временного значения и, соответственно, автоматически не преобразует строку
к нужному типу. С преобразованием типов мы более подробно познакомимся в статье <a href="https://sql-academy.org/guide/type-conversion-functions" target="_blank">«Функции преобразования типов, CAST»</a>.

### Функции генерации дат

Если необходимо получить временные данные из строки, которая не соответствует ни одному формату, который принимает
функция `CAST`, то можно использовать встроенную функцию `STR_TO_DATE`, которая принимает произвольную строку, содержащую дату, и формат, описывающий её.

```sql
SELECT STR_TO_DATE('November 13, 1998', '%M %d, %Y') AS date;
```

| date                     |
| ------------------------ |
| 1998-11-13T00:00:00.000Z |

Более подробное описание функции `STR_TO_DATE` и её аргументов можно посмотреть <a href="https://sql-academy.org/handbook/STR_TO_DATE" target="_blank">в справочнике</a>.

Для генерации же текущей даты или времени нет необходимости создавать строку для последующего её преобразования в дату,
потому что есть встроенные функции для получения данных значений: `CURDATE`, `CURTIME` и `NOW`.

```sql-executable
SELECT CURDATE(), CURTIME(), NOW();
```

## Функции извлечения временных данных

Иногда необходимо получить не всю дату, а только её конкретную часть, например,
месяц или год.

Для этого в SQL есть следующие функции:

| Функция                                                                        | Описание                                                   |
| :----------------------------------------------------------------------------- | :--------------------------------------------------------- |
| <a href="https://sql-academy.org/handbook/YEAR" target="_blank">`YEAR`</a>     | Возвращает год для указанной даты                          |
| <a href="https://sql-academy.org/handbook/MONTH" target="_blank">`MONTH`</a>   | Возвращает числовое значение месяца года (от 1 до 12) даты |
| <a href="https://sql-academy.org/handbook/DAY" target="_blank">`DAY`</a>       | Возвращает порядковый номер дня в месяце (от 1 до 31)      |
| <a href="https://sql-academy.org/handbook/HOUR" target="_blank">`HOUR`</a>     | Возвращает значение часа (от 0 до 23) для времени          |
| <a href="https://sql-academy.org/handbook/MINUTE" target="_blank">`MINUTE`</a> | Возвращает значение минут (от 0 до 59) для времени         |

## Отличие DATETIME от TIMESTAMP

В MySQL есть очень похожие друг на друга типы данных: `DATETIME` и `TIMESTAMP`. Они оба направлены на хранение даты и времени, но имеют ряд отличий, определяющих их целевое использование.

| Критерий     | `DATETIME`                                                                       | `TIMESTAMP`                                                                              |
| :----------- | :------------------------------------------------------------------------------- | :--------------------------------------------------------------------------------------- |
| Диапазон     | от `1000-01-01 00:00:00` <br /> до `9999-12-31 23:59:59`                         | от `1970-01-01 00:00:00` <br /> до `2038-01-19 03:14:07`                                 |
| Часовой пояс | Не учитывается <br /> Отображается в таком виде, в котором дата была установлена | Учитывается <br /> При выборках отображается с учётом текущего часового пояса сервера БД |

## Часовые пояса

Так как люди во всем мире хотят, чтобы полдень примерно соответствовал максимальному подъёму Солнца, то никогда не было задачи
использовать универсальное время и мир был разделён на 24 часовых пояса.

В качестве точки отсчёта времени используется UTC (Coordinated Universal Time). Все остальные часовые пояса можно описать
количеством часов сдвига от UTC. Для примера, часовой пояс Москвы может быть описан как UTC+3.

Часовой пояс является одной из настроек сервера баз данных и может задаваться:

- глобально
- для текущего пользователя
- для текущей пользовательской сессии

```sql
SET GLOBAL time_zone = '+03:00';    // глобально
SET time_zone = '+03:00';           // для текущего пользователя
SET @@session.time_zone = '+03:00'; // для текущей пользовательской сессии
```

Соответственно, при изменении временной зоны все значения с типом `TIMESTAMP` будут выводиться с учётом текущей активной временной зоны.

## Примеры задач на дату и время

Хочется отдельно остановиться на наиболее популярных задачах, связанных с временным типом данных,
на которых часто совершаются ошибки.

### Определение возраста

При постановке задачи найти возраст человека по дате его рождения часто возникает соблазн вычислить
разницу текущего года и года рождения человека:

```sql
SELECT YEAR(NOW()) - YEAR('2003-07-03 14:10:26');
```

Проблема такого подхода в том, что он не учитывает был ли день рождения у данного человека в этом году или ещё нет.
То есть, если на момент запроса уже наступило 3-е июля (07-03), то человек отпраздновал свой день рождения и ему уже 20 лет,
иначе ему по-прежнему 19 года.
Разница функций `YEAR` тут будет бесполезна — в обоих случаях она даст 20 лет.

Если определить возраст через разницу годов — неработающий вариант, то может возникнуть желание найти возраст через
разницу дней между двумя датами, затем поделить эту разницу на количество дней в году и округлить вниз:

```sql
SELECT FLOOR(DATEDIFF(NOW(), '2003-07-03 14:10:26') / 365);
```

И это решение будет гораздо точнее предыдущего. Но оно не будет абсолютно точным из-за наличия високосных годов, когда в году 366 дней.
Хотя погрешность в вычислении возраста для 1 человека из-за наличия високосного года достаточно низкая, в вычислениях на определение, скажем,
среднего возраста среди определённого списка людей, погрешность может накапливаться и исказить реальные значения.

И как же тогда корректно определять возраст? Для этого есть готовая встроенная функция — <a href="https://sql-academy.org/handbook/TIMESTAMPDIFF" target="_blank">`TIMESTAMPDIFF`</a>,
которая первым аргументом принимает единицу измерения, в которой нужно вернуть разницу между двумя временными значениями.

```sql
TIMESTAMPDIFF(YEAR, '2003-07-03 14:10:26', NOW());
```