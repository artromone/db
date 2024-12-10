-- Table: public.goods
DROP TABLE IF EXISTS public.goods;
CREATE TABLE IF NOT EXISTS public.goods (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    priority INT
);

-- Table: public.sales
DROP TABLE IF EXISTS public.sales;
CREATE TABLE IF NOT EXISTS public.sales (
    id SERIAL PRIMARY KEY,
    good_id INT NOT NULL,
    good_count INT NOT NULL,
    create_date DATE DEFAULT CURRENT_DATE,
    CONSTRAINT fk_sales_goods FOREIGN KEY (good_id) REFERENCES public.goods (id)
);

-- Table: public.warehouse1
DROP TABLE IF EXISTS public.warehouse1;
CREATE TABLE IF NOT EXISTS public.warehouse1 (
    id SERIAL PRIMARY KEY,
    good_id INT NOT NULL,
    good_count INT NOT NULL,
    CONSTRAINT fk_warehouse1_goods FOREIGN KEY (good_id) REFERENCES public.goods (id)
);

-- Table: public.warehouse2
DROP TABLE IF EXISTS public.warehouse2;
CREATE TABLE IF NOT EXISTS public.warehouse2 (
    id SERIAL PRIMARY KEY,
    good_id INT NOT NULL,
    good_count INT NOT NULL,
    CONSTRAINT fk_warehouse2_goods FOREIGN KEY (good_id) REFERENCES public.goods (id)
);

-- Function: delete_unused_goods
CREATE OR REPLACE FUNCTION delete_unused_goods()
RETURNS TRIGGER AS $$
BEGIN
    DELETE FROM goods
    WHERE id NOT IN (
        SELECT DISTINCT good_id FROM sales
        WHERE create_date >= CURRENT_DATE - INTERVAL '6 months'
    );
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- Trigger: delete_unused_goods_trigger
CREATE OR REPLACE TRIGGER delete_unused_goods_trigger
AFTER INSERT OR UPDATE ON sales
FOR EACH STATEMENT
EXECUTE FUNCTION delete_unused_goods();

-- Function: check_links
CREATE OR REPLACE FUNCTION check_links()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (SELECT 1 FROM sales WHERE sales.good_id = OLD.id) THEN
        RAISE EXCEPTION 'Еще есть заявки на товар';
    END IF;

    IF EXISTS (SELECT 1 FROM warehouse1 WHERE warehouse1.good_id = OLD.id) THEN
        RAISE EXCEPTION 'Товар лежит на 1 складе';
    END IF;

    IF EXISTS (SELECT 1 FROM warehouse2 WHERE warehouse2.good_id = OLD.id) THEN
        RAISE EXCEPTION 'Товар лежит на 2 складе';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger: check_links
CREATE OR REPLACE TRIGGER check_links
BEFORE DELETE ON goods
FOR EACH STATEMENT
EXECUTE FUNCTION check_links();

-- Function: use_cache_dummy
CREATE OR REPLACE FUNCTION use_cache_dummy()
RETURNS TRIGGER AS $$
DECLARE
    wh1_has_good BOOLEAN;
BEGIN
    SELECT EXISTS (
        SELECT 1 FROM warehouse1 WHERE warehouse1.good_id = NEW.good_id
    ) INTO wh1_has_good;

    IF wh1_has_good AND OLD.good_count > NEW.good_count THEN
        RAISE EXCEPTION 'На первом складе есть этот товар';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger: use_cache_dummy
CREATE OR REPLACE TRIGGER use_cache_dummy
BEFORE UPDATE ON warehouse2
FOR EACH ROW
EXECUTE FUNCTION use_cache_dummy();

-- Function: prevent_low_inventory_insert
CREATE OR REPLACE FUNCTION prevent_low_inventory_insert()
RETURNS TRIGGER AS $$
DECLARE
    stock1 INT;
    stock2 INT;
BEGIN
    SELECT COALESCE(wh1.good_count, 0) INTO stock1
    FROM warehouse1 wh1 WHERE wh1.good_id = NEW.good_id;

    SELECT COALESCE(wh2.good_count, 0) INTO stock2
    FROM warehouse2 wh2 WHERE wh2.good_id = NEW.good_id;

    IF NEW.good_count > stock1 + stock2 THEN
        RAISE EXCEPTION 'Недостаточно товара на складе для выполнения заказа';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger: prevent_low_inventory_insert
CREATE OR REPLACE TRIGGER prevent_low_inventory_insert
BEFORE INSERT ON sales
FOR EACH ROW
EXECUTE FUNCTION prevent_low_inventory_insert();

-- Initial data for goods (100 goods)
INSERT INTO public.goods (name, priority)
SELECT 'Good ' || gs, gs % 10 + 1
FROM generate_series(1, 100) gs;

-- Initial data for sales (100 sales entries)
INSERT INTO public.sales (good_id, good_count, create_date)
SELECT (gs % 100) + 1, (gs % 50) + 1, CURRENT_DATE - (gs * interval '1 day')
FROM generate_series(1, 100) gs;

-- Initial data for warehouse1 (50 goods in warehouse1)
INSERT INTO public.warehouse1 (good_id, good_count)
SELECT (gs % 100) + 1, (gs % 20) + 10
FROM generate_series(1, 50) gs;

-- Initial data for warehouse2 (50 goods in warehouse2)
INSERT INTO public.warehouse2 (good_id, good_count)
SELECT (gs % 100) + 1, (gs % 15) + 5
FROM generate_series(51, 100) gs;
