-- Task 1
-- a) Alice = 900.00, Bob = 600.00
-- b) To make sure both updates happen together, otherwise money could disappear.
-- c) One update would run and the other wouldn't, causing inconsistent balances.

-- Task 2
-- a) Alice temporarily had 500.00
-- b) After rollback she had 1000.00 again
-- c) Use rollback when you make a mistake in the transaction.

-- Task 3
-- a) Alice = 900.00, Bob = 500.00, Wally = 850.00
-- b) Bob was credited but rolled back to savepoint, so not in final state.
-- c) Savepoints allow undoing only part of a transaction.

-- Task 4
-- a) READ COMMITTED sees original data, then new data after commit.
-- b) SERIALIZABLE always sees the original snapshot.
-- c) READ COMMITTED allows changes during transaction, SERIALIZABLE blocks/isolates them.

-- Task 5
-- a) No, Terminal 1 does not see the new product.
-- b) Phantom read = new rows appear on re-read.
-- c) SERIALIZABLE prevents phantom reads.

-- Task 6
-- a) Yes, Terminal 1 saw 99.99. Problem: uncommitted data can disappear.
-- b) Dirty read = reading uncommitted data.
-- c) READ UNCOMMITTED is unsafe and should be avoided.

-- Independent Exercise 1
BEGIN;
UPDATE accounts SET balance = balance - 200 WHERE name='Bob' AND balance >= 200;
UPDATE accounts SET balance = balance + 200 WHERE name='Wally';
COMMIT;

-- Independent Exercise 2
BEGIN;
INSERT INTO products(shop,product,price) VALUES('Test','Item',5.00);
SAVEPOINT sp1;
UPDATE products SET price=6.00 WHERE product='Item';
SAVEPOINT sp2;
DELETE FROM products WHERE product='Item';
ROLLBACK TO sp1;
COMMIT;
-- Final state: Item exists with price updated to 6.00.

-- Independent Exercise 3 (concept only)
-- Two users try withdrawing at same time. At low isolation, both may think money exists.
-- At SERIALIZABLE one will wait/abort, preventing overdraft.

-- Independent Exercise 4
-- Without transactions: Sally sees MAX < MIN due to concurrent edits.
-- With transactions: using BEGIN/COMMIT fixes inconsistent reads.

-- Self-Assessment Answers
-- 1. Atomicity: all-or-nothing. Consistency: constraints ok. Isolation: others don't see partial changes.
--    Durability: survives crashes.
-- 2. COMMIT saves, ROLLBACK cancels.
-- 3. SAVEPOINT is for partial undo.
-- 4. READ UNCOMMITTED < READ COMMITTED < REPEATABLE READ < SERIALIZABLE
-- 5. Dirty read = reading uncommitted data; allowed in READ UNCOMMITTED.
-- 6. Non-repeatable read = same row changes between reads.
-- 7. Phantom read = new rows appear. Prevented by SERIALIZABLE.
-- 8. READ COMMITTED is faster, less locking.
-- 9. Transactions prevent inconsistent states.
-- 10. Uncommitted changes are lost.
