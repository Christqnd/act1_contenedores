-- Crear tabla solo si no existe, con restricción UNIQUE en name
CREATE TABLE IF NOT EXISTS products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) UNIQUE, -- esta línea permite usar ON CONFLICT (name)
    price NUMERIC
);

-- Insertar solo si no existe un producto con el mismo name
INSERT INTO products (name, price) VALUES
('Laptop', 1200.50),
('Keyboard', 55.99),
('Mouse', 30.00),
('Monitor', 220.00),
('Webcam HD', 75.49),
('Gaming Chair', 199.99),
('USB-C Hub', 45.00),
('External SSD 1TB', 129.95),
('Wireless Headphones', 89.99),
('Smartphone Stand', 15.99),
('Desk Lamp', 39.90),
('Mechanical Keyboard', 109.00),
('Portable Projector', 320.00),
('Graphics Tablet', 249.99),
('Bluetooth Speaker', 65.00),
('Ergonomic Mouse', 49.50),
('HDMI Cable 2m', 12.49),
('Wireless Charger', 34.95),
('NAS 4-Bay Storage', 499.99),
('Smartwatch', 159.99)
ON CONFLICT (name) DO NOTHING;
