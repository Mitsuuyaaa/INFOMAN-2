
-- Activity 1

CREATE OR REPLACE FUNCTION log_product_changes()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    -- Handle INSERT operations
    IF TG_OP = 'INSERT' THEN
        INSERT INTO products_audit (
            product_id,
            change_type,
            new_name,
            new_price
        ) VALUES (
            NEW.product_id,
            'INSERT',
            NEW.name,
            NEW.price
        );
        RETURN NEW;

    -- Handle DELETE operations
    ELSIF TG_OP = 'DELETE' THEN
        INSERT INTO products_audit (
            product_id,
            change_type,
            old_name,
            old_price
        ) VALUES (
            OLD.product_id,
            'DELETE',
            OLD.name,
            OLD.price
        );
        RETURN OLD;

    -- Handle UPDATE operations
    ELSIF TG_OP = 'UPDATE' THEN
        -- Only log if name or price has changed
        IF NEW.name IS DISTINCT FROM OLD.name OR NEW.price IS DISTINCT FROM OLD.price THEN
            INSERT INTO products_audit (
                product_id,
                change_type,
                old_name,
                new_name,
                old_price,
                new_price
            ) VALUES (
                OLD.product_id,
                'UPDATE',
                OLD.name,
                NEW.name,
                OLD.price,
                NEW.price
            );
        END IF;
        RETURN NEW;

    END IF;

    RETURN NULL; -- Should never reach here
END;
$$;

-- Activity 2

CREATE TRIGGER product_audit_trigger
AFTER INSERT OR UPDATE OR DELETE
ON products
FOR EACH ROW
EXECUTE FUNCTION log_product_changes();


-- Activity 3

-- 1. Test the INSERT trigger
INSERT INTO products (name, description, price, stock_quantity)
VALUES ('Miniature Thingamabob', 'A very small thingamabob.', 4.99, 500);

-- 2. Test the UPDATE trigger (with a meaningful change)
UPDATE products
SET price = 225.00, name = 'Mega Gadget v2'
WHERE name = 'Mega Gadget';

-- 3. Test an UPDATE with no meaningful change (should not create a log entry)
UPDATE products
SET description = 'An even simpler gizmo for all your daily tasks.'
WHERE name = 'Basic Gizmo';

-- 4. Test the DELETE trigger
DELETE FROM products
WHERE name = 'Super Widget';


-- Activity 4

SELECT * FROM products_audit ORDER BY audit_id;
