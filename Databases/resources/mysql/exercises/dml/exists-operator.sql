
-- 1
/*Geef per city de drivers met de hoogste status. Sorteer alfabetisch op plaats.*/
SELECT *
FROM drivers d1
WHERE not exists(select * FROM drivers d2
            WHERE d1.city = d2.city AND d2.STATUS > d1.STATUS)
order by city;

-- 2
/*Geef de gegevens van de drivers die voor elk project geleverd hebben.*/
SELECT *
FROM drivers
WHERE NOT EXISTS (SELECT * FROM projects
                  WHERE pno NOT IN (SELECT pno FROM deliveries
                                    WHERE dno = drivers.dno));

-- 3
/*Geef een lijst van de boeken (books.*) die in hun categorie het goedkoopst zijn.
Sorteer op categorie en daarbinnen op titel.*/
SELECT *
FROM books b1
WHERE NOT EXISTS (SELECT * FROM books b2
                  WHERE b2.category = b1.category AND b2.price < b1.price)
 ORDER BY category, title;

-- 4
/*Geef de gegevens van de uitgevers (publishers.*) die geen enkel boek hebben
uitgegeven (dat opgenomen is in de databank). Sorteer alfabetisch op uitgeversnaam.*/
SELECT *
FROM publishers
WHERE NOT EXISTS(select * from books where publishers.pno = books.pno)
ORDER BY publisher;