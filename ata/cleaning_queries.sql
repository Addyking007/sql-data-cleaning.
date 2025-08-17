-- 1. Remove duplicates (based on Name + Email)
DELETE FROM customers
WHERE rowid NOT IN (
    SELECT MIN(rowid)
    FROM customers
    GROUP BY Name, Email
);

-- 2. Handle missing country values
UPDATE customers
SET Country = 'Unknown'
WHERE Country IS NULL;

-- 3. Standardize phone numbers (remove dashes)
UPDATE customers
SET Phone = REPLACE(Phone, '-', '');

-- 4. Fix incorrect emails
UPDATE customers
SET Email = CONCAT(Name, '@example.com')
WHERE Email IS NULL OR Email NOT LIKE '%@%';

-- 5. Fill missing purchase amounts with average
UPDATE customers
SET PurchaseAmount = (
    SELECT AVG(PurchaseAmount) FROM customers
)
WHERE PurchaseAmount IS NULL;
