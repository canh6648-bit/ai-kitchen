SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS favorite_recipes;
DROP TABLE IF EXISTS user_history;
DROP TABLE IF EXISTS recipe_ingredients;
DROP TABLE IF EXISTS recipes;
DROP TABLE IF EXISTS ingredients;
DROP TABLE IF EXISTS users;
SET FOREIGN_KEY_CHECKS = 1;

CREATE DATABASE IF NOT EXISTS smart_recipe_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE smart_recipe_db;


CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    fullname VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE ingredients (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL,
    category VARCHAR(50),
    INDEX(name)
);

CREATE TABLE recipes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    instructions TEXT NOT NULL,
    image_url VARCHAR(500)
);

CREATE TABLE recipe_ingredients (
    recipe_id INT,
    ingredient_id INT,
    quantity_desc VARCHAR(100),
    is_main TINYINT(1) DEFAULT 1,
    PRIMARY KEY(recipe_id, ingredient_id),
    FOREIGN KEY(recipe_id) REFERENCES recipes(id) ON DELETE CASCADE,
    FOREIGN KEY(ingredient_id) REFERENCES ingredients(id) ON DELETE CASCADE
);

CREATE TABLE user_history (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    recipe_name VARCHAR(255),
    ingredients_used TEXT,
    source VARCHAR(50),
    instructions TEXT,
    image_url VARCHAR(500),
    match_score INT,
    missing_ingredients TEXT,
    alternatives TEXT,
    note TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY(user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE favorite_recipes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    recipe_name VARCHAR(255),
    ingredients_used TEXT,
    source VARCHAR(50),
    instructions TEXT,
    image_url VARCHAR(500),
    match_score INT,
    missing_ingredients TEXT,
    alternatives TEXT,
    note TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY(user_id) REFERENCES users(id) ON DELETE CASCADE
);

INSERT INTO ingredients(name, category) VALUES
('Bánh mì','Tinh bột'),
('Bí đỏ','Rau củ'),
('Cá chép','Hải sản'),
('Cà chua','Rau củ'),
('Cá rô phi','Hải sản'),
('Cà rốt','Rau củ'),
('Cà tím','Rau củ'),
('Cải thảo','Rau củ'),
('Chanh','Gia vị'),
('Chuối','Trái cây'),
('Đậu phụ','Đạm thực vật'),
('Đậu que','Rau củ'),
('Dưa chuột','Rau củ'),
('Dưa hấu','Trái cây'),
('Hành lá','Gia vị'),
('Hành tây','Rau củ'),
('Khoai tây','Rau củ'),
('Mướp đắng','Rau củ'),
('Ngao','Hải sản'),
('Ớt chuông','Rau củ'),
('Ớt nhỏ','Gia vị'),
('Quả dứa','Trái cây'),
('Rau muống','Rau củ'),
('Su hào','Rau củ'),
('Sườn non','Thịt'),
('Súp lơ','Rau củ'),
('Thịt gà','Thịt'),
('Thịt lợn','Thịt'),
('Tỏi','Gia vị'),
('Tôm','Hải sản'),
('Trứng gà','Thịt & Trứng'),
('Xoài','Trái cây'),
('Gừng','Gia vị'),
('Nước mắm','Gia vị'),
('Đường','Gia vị'),
('Tiêu','Gia vị'),
('Muối','Gia vị'),
('Dầu ăn','Gia vị'),
('Bún tươi','Tinh bột'),
('Cơm trắng','Tinh bột'),
('Nấm kim châm','Rau củ'),
('Cải ngọt','Rau củ'),
('Ức gà','Thịt'),
('Thịt bò','Thịt'),
('Đậu phụ non','Đạm thực vật');

INSERT INTO recipes(id, name, instructions, image_url) VALUES
(1,'Trứng sốt cà chua','1. Sơ chế Trứng gà, Cà chua, để ráo nước.
2. Chuẩn bị Hành lá, Tỏi, nêm muối, tiêu, nước mắm vừa ăn.
3. Làm nóng chảo/nồi, cho nguyên liệu chính vào nấu đến khi chín.
4. Nêm lại cho vừa khẩu vị, rắc hành nếu có và dùng nóng.','https://placehold.co/600x400?text=Tr%E1%BB%A9ng%2Bs%E1%BB%91t%2Bc%C3%A0%2Bchua'),
(2,'Trứng chiên hành lá','1. Sơ chế Trứng gà, Hành lá, để ráo nước.
2. Chuẩn bị Nước mắm, Tiêu, nêm muối, tiêu, nước mắm vừa ăn.
3. Làm nóng chảo/nồi, cho nguyên liệu chính vào nấu đến khi chín.
4. Nêm lại cho vừa khẩu vị, rắc hành nếu có và dùng nóng.','https://placehold.co/600x400?text=Tr%E1%BB%A9ng%2Bchi%C3%AAn%2Bh%C3%A0nh%2Bl%C3%A1'),
(3,'Trứng chiên cà rốt','1. Sơ chế Trứng gà, Cà rốt, để ráo nước.
2. Chuẩn bị Hành lá, nêm muối, tiêu, nước mắm vừa ăn.
3. Làm nóng chảo/nồi, cho nguyên liệu chính vào nấu đến khi chín.
4. Nêm lại cho vừa khẩu vị, rắc hành nếu có và dùng nóng.','https://placehold.co/600x400?text=Tr%E1%BB%A9ng%2Bchi%C3%AAn%2Bc%C3%A0%2Br%E1%BB%91t'),
(4,'Trứng cuộn đậu que','1. Sơ chế Trứng gà, Đậu que, để ráo nước.
2. Chuẩn bị Hành lá, nêm muối, tiêu, nước mắm vừa ăn.
3. Làm nóng chảo/nồi, cho nguyên liệu chính vào nấu đến khi chín.
4. Nêm lại cho vừa khẩu vị, rắc hành nếu có và dùng nóng.','https://placehold.co/600x400?text=Tr%E1%BB%A9ng%2Bcu%E1%BB%99n%2B%C4%91%E1%BA%ADu%2Bque'),
(5,'Mướp đắng xào trứng','1. Sơ chế Mướp đắng, Trứng gà, để ráo nước.
2. Chuẩn bị Tỏi, nêm muối, tiêu, nước mắm vừa ăn.
3. Làm nóng chảo/nồi, cho nguyên liệu chính vào nấu đến khi chín.
4. Nêm lại cho vừa khẩu vị, rắc hành nếu có và dùng nóng.','https://placehold.co/600x400?text=M%C6%B0%E1%BB%9Bp%2B%C4%91%E1%BA%AFng%2Bx%C3%A0o%2Btr%E1%BB%A9ng'),
(6,'Canh trứng cà chua','1. Sơ chế Trứng gà, Cà chua, để ráo nước.
2. Chuẩn bị Hành lá, nêm muối, tiêu, nước mắm vừa ăn.
3. Làm nóng chảo/nồi, cho nguyên liệu chính vào nấu đến khi chín.
4. Nêm lại cho vừa khẩu vị, rắc hành nếu có và dùng nóng.','https://placehold.co/600x400?text=Canh%2Btr%E1%BB%A9ng%2Bc%C3%A0%2Bchua'),
(7,'Trứng hấp đậu phụ','1. Sơ chế Trứng gà, Đậu phụ, để ráo nước.
2. Chuẩn bị Hành lá, nêm muối, tiêu, nước mắm vừa ăn.
3. Làm nóng chảo/nồi, cho nguyên liệu chính vào nấu đến khi chín.
4. Nêm lại cho vừa khẩu vị, rắc hành nếu có và dùng nóng.','https://placehold.co/600x400?text=Tr%E1%BB%A9ng%2Bh%E1%BA%A5p%2B%C4%91%E1%BA%ADu%2Bph%E1%BB%A5'),
(8,'Bánh mì trứng','1. Sơ chế Bánh mì, Trứng gà, để ráo nước.
2. Chuẩn bị Dưa chuột, nêm muối, tiêu, nước mắm vừa ăn.
3. Làm nóng chảo/nồi, cho nguyên liệu chính vào nấu đến khi chín.
4. Nêm lại cho vừa khẩu vị, rắc hành nếu có và dùng nóng.','https://placehold.co/600x400?text=B%C3%A1nh%2Bm%C3%AC%2Btr%E1%BB%A9ng'),
(9,'Bánh mì thịt trứng','1. Sơ chế Bánh mì, Thịt lợn, Trứng gà, để ráo nước.
2. Chuẩn bị Dưa chuột, Hành lá, nêm muối, tiêu, nước mắm vừa ăn.
3. Làm nóng chảo/nồi, cho nguyên liệu chính vào nấu đến khi chín.
4. Nêm lại cho vừa khẩu vị, rắc hành nếu có và dùng nóng.','https://placehold.co/600x400?text=B%C3%A1nh%2Bm%C3%AC%2Bth%E1%BB%8Bt%2Btr%E1%BB%A9ng'),
(10,'Cơm chiên trứng cà rốt','1. Sơ chế Cơm trắng, Trứng gà, Cà rốt, để ráo nước.
2. Chuẩn bị Hành lá, nêm muối, tiêu, nước mắm vừa ăn.
3. Làm nóng chảo/nồi, cho nguyên liệu chính vào nấu đến khi chín.
4. Nêm lại cho vừa khẩu vị, rắc hành nếu có và dùng nóng.','https://placehold.co/600x400?text=C%C6%A1m%2Bchi%C3%AAn%2Btr%E1%BB%A9ng%2Bc%C3%A0%2Br%E1%BB%91t'),
(11,'Thịt gà xào sả gừng','1. Sơ chế Thịt gà, Gừng, để ráo nước.
2. Chuẩn bị Tỏi, Ớt nhỏ, nêm muối, tiêu, nước mắm vừa ăn.
3. Làm nóng chảo/nồi, cho nguyên liệu chính vào nấu đến khi chín.
4. Nêm lại cho vừa khẩu vị, rắc hành nếu có và dùng nóng.','https://placehold.co/600x400?text=Th%E1%BB%8Bt%2Bg%C3%A0%2Bx%C3%A0o%2Bs%E1%BA%A3%2Bg%E1%BB%ABng'),
(12,'Gà xào ớt chuông','1. Sơ chế Thịt gà, Ớt chuông, để ráo nước.
2. Chuẩn bị Hành tây, Tỏi, nêm muối, tiêu, nước mắm vừa ăn.
3. Làm nóng chảo/nồi, cho nguyên liệu chính vào nấu đến khi chín.
4. Nêm lại cho vừa khẩu vị, rắc hành nếu có và dùng nóng.','https://placehold.co/600x400?text=G%C3%A0%2Bx%C3%A0o%2B%E1%BB%9Bt%2Bchu%C3%B4ng'),
(13,'Gà xào hành tây','1. Sơ chế Thịt gà, Hành tây, để ráo nước.
2. Chuẩn bị Tỏi, nêm muối, tiêu, nước mắm vừa ăn.
3. Làm nóng chảo/nồi, cho nguyên liệu chính vào nấu đến khi chín.
4. Nêm lại cho vừa khẩu vị, rắc hành nếu có và dùng nóng.','https://placehold.co/600x400?text=G%C3%A0%2Bx%C3%A0o%2Bh%C3%A0nh%2Bt%C3%A2y'),
(14,'Gà kho gừng','1. Sơ chế Thịt gà, Gừng, để ráo nước.
2. Chuẩn bị Nước mắm, Tiêu, nêm muối, tiêu, nước mắm vừa ăn.
3. Làm nóng chảo/nồi, cho nguyên liệu chính vào nấu đến khi chín.
4. Nêm lại cho vừa khẩu vị, rắc hành nếu có và dùng nóng.','https://placehold.co/600x400?text=G%C3%A0%2Bkho%2Bg%E1%BB%ABng'),
(15,'Gà xào súp lơ','1. Sơ chế Thịt gà, Súp lơ, để ráo nước.
2. Chuẩn bị Tỏi, nêm muối, tiêu, nước mắm vừa ăn.
3. Làm nóng chảo/nồi, cho nguyên liệu chính vào nấu đến khi chín.
4. Nêm lại cho vừa khẩu vị, rắc hành nếu có và dùng nóng.','https://placehold.co/600x400?text=G%C3%A0%2Bx%C3%A0o%2Bs%C3%BAp%2Bl%C6%A1'),
(16,'Gà nấu bí đỏ','1. Sơ chế Thịt gà, Bí đỏ, để ráo nước.
2. Chuẩn bị Hành lá, nêm muối, tiêu, nước mắm vừa ăn.
3. Làm nóng chảo/nồi, cho nguyên liệu chính vào nấu đến khi chín.
4. Nêm lại cho vừa khẩu vị, rắc hành nếu có và dùng nóng.','https://placehold.co/600x400?text=G%C3%A0%2Bn%E1%BA%A5u%2Bb%C3%AD%2B%C4%91%E1%BB%8F'),
(17,'Gà xào đậu que','1. Sơ chế Thịt gà, Đậu que, để ráo nước.
2. Chuẩn bị Tỏi, nêm muối, tiêu, nước mắm vừa ăn.
3. Làm nóng chảo/nồi, cho nguyên liệu chính vào nấu đến khi chín.
4. Nêm lại cho vừa khẩu vị, rắc hành nếu có và dùng nóng.','https://placehold.co/600x400?text=G%C3%A0%2Bx%C3%A0o%2B%C4%91%E1%BA%ADu%2Bque'),
(18,'Gà xào cà rốt','1. Sơ chế Thịt gà, Cà rốt, để ráo nước.
2. Chuẩn bị Hành tây, nêm muối, tiêu, nước mắm vừa ăn.
3. Làm nóng chảo/nồi, cho nguyên liệu chính vào nấu đến khi chín.
4. Nêm lại cho vừa khẩu vị, rắc hành nếu có và dùng nóng.','https://placehold.co/600x400?text=G%C3%A0%2Bx%C3%A0o%2Bc%C3%A0%2Br%E1%BB%91t'),
(19,'Canh gà cải thảo','1. Sơ chế Thịt gà, Cải thảo, để ráo nước.
2. Chuẩn bị Gừng, nêm muối, tiêu, nước mắm vừa ăn.
3. Làm nóng chảo/nồi, cho nguyên liệu chính vào nấu đến khi chín.
4. Nêm lại cho vừa khẩu vị, rắc hành nếu có và dùng nóng.','https://placehold.co/600x400?text=Canh%2Bg%C3%A0%2Bc%E1%BA%A3i%2Bth%E1%BA%A3o'),
(20,'Salad gà dưa chuột','1. Sơ chế Thịt gà, Dưa chuột, để ráo nước.
2. Chuẩn bị Chanh, nêm muối, tiêu, nước mắm vừa ăn.
3. Làm nóng chảo/nồi, cho nguyên liệu chính vào nấu đến khi chín.
4. Nêm lại cho vừa khẩu vị, rắc hành nếu có và dùng nóng.','https://placehold.co/600x400?text=Salad%2Bg%C3%A0%2Bd%C6%B0a%2Bchu%E1%BB%99t'),
(21,'Thịt lợn xào hành tây','1. Sơ chế Thịt lợn, Hành tây, để ráo nước.
2. Chuẩn bị Tỏi, nêm muối, tiêu, nước mắm vừa ăn.
3. Làm nóng chảo/nồi, cho nguyên liệu chính vào nấu đến khi chín.
4. Nêm lại cho vừa khẩu vị, rắc hành nếu có và dùng nóng.','https://placehold.co/600x400?text=Th%E1%BB%8Bt%2Bl%E1%BB%A3n%2Bx%C3%A0o%2Bh%C3%A0nh%2Bt%C3%A2y'),
(22,'Thịt lợn kho trứng','1. Sơ chế Thịt lợn, Trứng gà, để ráo nước.
2. Chuẩn bị Nước mắm, Tiêu, nêm muối, tiêu, nước mắm vừa ăn.
3. Làm nóng chảo/nồi, cho nguyên liệu chính vào nấu đến khi chín.
4. Nêm lại cho vừa khẩu vị, rắc hành nếu có và dùng nóng.','https://placehold.co/600x400?text=Th%E1%BB%8Bt%2Bl%E1%BB%A3n%2Bkho%2Btr%E1%BB%A9ng'),
(23,'Thịt lợn xào đậu que','1. Sơ chế Thịt lợn, Đậu que, để ráo nước.
2. Chuẩn bị Tỏi, nêm muối, tiêu, nước mắm vừa ăn.
3. Làm nóng chảo/nồi, cho nguyên liệu chính vào nấu đến khi chín.
4. Nêm lại cho vừa khẩu vị, rắc hành nếu có và dùng nóng.','https://placehold.co/600x400?text=Th%E1%BB%8Bt%2Bl%E1%BB%A3n%2Bx%C3%A0o%2B%C4%91%E1%BA%ADu%2Bque'),
(24,'Thịt lợn xào cà tím','1. Sơ chế Thịt lợn, Cà tím, để ráo nước.
2. Chuẩn bị Tỏi, nêm muối, tiêu, nước mắm vừa ăn.
3. Làm nóng chảo/nồi, cho nguyên liệu chính vào nấu đến khi chín.
4. Nêm lại cho vừa khẩu vị, rắc hành nếu có và dùng nóng.','https://placehold.co/600x400?text=Th%E1%BB%8Bt%2Bl%E1%BB%A3n%2Bx%C3%A0o%2Bc%C3%A0%2Bt%C3%ADm'),
(25,'Thịt lợn xào su hào','1. Sơ chế Thịt lợn, Su hào, để ráo nước.
2. Chuẩn bị Hành lá, nêm muối, tiêu, nước mắm vừa ăn.
3. Làm nóng chảo/nồi, cho nguyên liệu chính vào nấu đến khi chín.
4. Nêm lại cho vừa khẩu vị, rắc hành nếu có và dùng nóng.','https://placehold.co/600x400?text=Th%E1%BB%8Bt%2Bl%E1%BB%A3n%2Bx%C3%A0o%2Bsu%2Bh%C3%A0o'),
(26,'Thịt lợn xào cải thảo','1. Sơ chế Thịt lợn, Cải thảo, để ráo nước.
2. Chuẩn bị Tỏi, nêm muối, tiêu, nước mắm vừa ăn.
3. Làm nóng chảo/nồi, cho nguyên liệu chính vào nấu đến khi chín.
4. Nêm lại cho vừa khẩu vị, rắc hành nếu có và dùng nóng.','https://placehold.co/600x400?text=Th%E1%BB%8Bt%2Bl%E1%BB%A3n%2Bx%C3%A0o%2Bc%E1%BA%A3i%2Bth%E1%BA%A3o'),
(27,'Thịt lợn rim chanh','1. Sơ chế Thịt lợn, Chanh, để ráo nước.
2. Chuẩn bị Tỏi, nêm muối, tiêu, nước mắm vừa ăn.
3. Làm nóng chảo/nồi, cho nguyên liệu chính vào nấu đến khi chín.
4. Nêm lại cho vừa khẩu vị, rắc hành nếu có và dùng nóng.','https://placehold.co/600x400?text=Th%E1%BB%8Bt%2Bl%E1%BB%A3n%2Brim%2Bchanh'),
(28,'Thịt lợn xào khoai tây','1. Sơ chế Thịt lợn, Khoai tây, để ráo nước.
2. Chuẩn bị Hành tây, nêm muối, tiêu, nước mắm vừa ăn.
3. Làm nóng chảo/nồi, cho nguyên liệu chính vào nấu đến khi chín.
4. Nêm lại cho vừa khẩu vị, rắc hành nếu có và dùng nóng.','https://placehold.co/600x400?text=Th%E1%BB%8Bt%2Bl%E1%BB%A3n%2Bx%C3%A0o%2Bkhoai%2Bt%C3%A2y'),
(29,'Canh bí đỏ thịt bằm','1. Sơ chế Bí đỏ, Thịt lợn, để ráo nước.
2. Chuẩn bị Hành lá, nêm muối, tiêu, nước mắm vừa ăn.
3. Làm nóng chảo/nồi, cho nguyên liệu chính vào nấu đến khi chín.
4. Nêm lại cho vừa khẩu vị, rắc hành nếu có và dùng nóng.','https://placehold.co/600x400?text=Canh%2Bb%C3%AD%2B%C4%91%E1%BB%8F%2Bth%E1%BB%8Bt%2Bb%E1%BA%B1m'),
(30,'Cà tím bung thịt','1. Sơ chế Cà tím, Thịt lợn, để ráo nước.
2. Chuẩn bị Đậu phụ, Hành lá, nêm muối, tiêu, nước mắm vừa ăn.
3. Làm nóng chảo/nồi, cho nguyên liệu chính vào nấu đến khi chín.
4. Nêm lại cho vừa khẩu vị, rắc hành nếu có và dùng nóng.','https://placehold.co/600x400?text=C%C3%A0%2Bt%C3%ADm%2Bbung%2Bth%E1%BB%8Bt'),
(31,'Sườn non kho tiêu','1. Sơ chế Sườn non, Tiêu, để ráo nước.
2. Chuẩn bị Tỏi, nêm muối, tiêu, nước mắm vừa ăn.
3. Làm nóng chảo/nồi, cho nguyên liệu chính vào nấu đến khi chín.
4. Nêm lại cho vừa khẩu vị, rắc hành nếu có và dùng nóng.','https://placehold.co/600x400?text=S%C6%B0%E1%BB%9Dn%2Bnon%2Bkho%2Bti%C3%AAu'),
(32,'Sườn xào chua ngọt','1. Sơ chế Sườn non, Chanh, để ráo nước.
2. Chuẩn bị Tỏi, Ớt nhỏ, nêm muối, tiêu, nước mắm vừa ăn.
3. Làm nóng chảo/nồi, cho nguyên liệu chính vào nấu đến khi chín.
4. Nêm lại cho vừa khẩu vị, rắc hành nếu có và dùng nóng.','https://placehold.co/600x400?text=S%C6%B0%E1%BB%9Dn%2Bx%C3%A0o%2Bchua%2Bng%E1%BB%8Dt'),
(33,'Canh sườn bí đỏ','1. Sơ chế Sườn non, Bí đỏ, để ráo nước.
2. Chuẩn bị Hành lá, nêm muối, tiêu, nước mắm vừa ăn.
3. Làm nóng chảo/nồi, cho nguyên liệu chính vào nấu đến khi chín.
4. Nêm lại cho vừa khẩu vị, rắc hành nếu có và dùng nóng.','https://placehold.co/600x400?text=Canh%2Bs%C6%B0%E1%BB%9Dn%2Bb%C3%AD%2B%C4%91%E1%BB%8F'),
(34,'Sườn hầm khoai tây','1. Sơ chế Sườn non, Khoai tây, để ráo nước.
2. Chuẩn bị Cà rốt, nêm muối, tiêu, nước mắm vừa ăn.
3. Làm nóng chảo/nồi, cho nguyên liệu chính vào nấu đến khi chín.
4. Nêm lại cho vừa khẩu vị, rắc hành nếu có và dùng nóng.','https://placehold.co/600x400?text=S%C6%B0%E1%BB%9Dn%2Bh%E1%BA%A7m%2Bkhoai%2Bt%C3%A2y'),
(35,'Sườn non rim tỏi','1. Sơ chế Sườn non, Tỏi, để ráo nước.
2. Chuẩn bị Nước mắm, nêm muối, tiêu, nước mắm vừa ăn.
3. Làm nóng chảo/nồi, cho nguyên liệu chính vào nấu đến khi chín.
4. Nêm lại cho vừa khẩu vị, rắc hành nếu có và dùng nóng.','https://placehold.co/600x400?text=S%C6%B0%E1%BB%9Dn%2Bnon%2Brim%2Bt%E1%BB%8Fi'),
(36,'Sườn nấu su hào','1. Sơ chế Sườn non, Su hào, để ráo nước.
2. Chuẩn bị Hành lá, nêm muối, tiêu, nước mắm vừa ăn.
3. Làm nóng chảo/nồi, cho nguyên liệu chính vào nấu đến khi chín.
4. Nêm lại cho vừa khẩu vị, rắc hành nếu có và dùng nóng.','https://placehold.co/600x400?text=S%C6%B0%E1%BB%9Dn%2Bn%E1%BA%A5u%2Bsu%2Bh%C3%A0o'),
(37,'Sườn nấu cải thảo','1. Sơ chế Sườn non, Cải thảo, để ráo nước.
2. Chuẩn bị Gừng, nêm muối, tiêu, nước mắm vừa ăn.
3. Làm nóng chảo/nồi, cho nguyên liệu chính vào nấu đến khi chín.
4. Nêm lại cho vừa khẩu vị, rắc hành nếu có và dùng nóng.','https://placehold.co/600x400?text=S%C6%B0%E1%BB%9Dn%2Bn%E1%BA%A5u%2Bc%E1%BA%A3i%2Bth%E1%BA%A3o'),
(38,'Sườn sốt cà chua','1. Sơ chế Sườn non, Cà chua, để ráo nước.
2. Chuẩn bị Hành lá, nêm muối, tiêu, nước mắm vừa ăn.
3. Làm nóng chảo/nồi, cho nguyên liệu chính vào nấu đến khi chín.
4. Nêm lại cho vừa khẩu vị, rắc hành nếu có và dùng nóng.','https://placehold.co/600x400?text=S%C6%B0%E1%BB%9Dn%2Bs%E1%BB%91t%2Bc%C3%A0%2Bchua'),
(39,'Sườn kho dứa','1. Sơ chế Sườn non, Quả dứa, để ráo nước.
2. Chuẩn bị Tỏi, nêm muối, tiêu, nước mắm vừa ăn.
3. Làm nóng chảo/nồi, cho nguyên liệu chính vào nấu đến khi chín.
4. Nêm lại cho vừa khẩu vị, rắc hành nếu có và dùng nóng.','https://placehold.co/600x400?text=S%C6%B0%E1%BB%9Dn%2Bkho%2Bd%E1%BB%A9a'),
(40,'Bún sườn chua','1. Sơ chế Bún tươi, Sườn non, Cà chua, để ráo nước.
2. Chuẩn bị Chanh, Hành lá, nêm muối, tiêu, nước mắm vừa ăn.
3. Làm nóng chảo/nồi, cho nguyên liệu chính vào nấu đến khi chín.
4. Nêm lại cho vừa khẩu vị, rắc hành nếu có và dùng nóng.','https://placehold.co/600x400?text=B%C3%BAn%2Bs%C6%B0%E1%BB%9Dn%2Bchua'),
(41,'Tôm rim tỏi','1. Sơ chế Tôm, Tỏi, để ráo nước.
2. Chuẩn bị Nước mắm, Tiêu, nêm muối, tiêu, nước mắm vừa ăn.
3. Làm nóng chảo/nồi, cho nguyên liệu chính vào nấu đến khi chín.
4. Nêm lại cho vừa khẩu vị, rắc hành nếu có và dùng nóng.','https://placehold.co/600x400?text=T%C3%B4m%2Brim%2Bt%E1%BB%8Fi'),
(42,'Tôm xào súp lơ','1. Sơ chế Tôm, Súp lơ, để ráo nước.
2. Chuẩn bị Tỏi, nêm muối, tiêu, nước mắm vừa ăn.
3. Làm nóng chảo/nồi, cho nguyên liệu chính vào nấu đến khi chín.
4. Nêm lại cho vừa khẩu vị, rắc hành nếu có và dùng nóng.','https://placehold.co/600x400?text=T%C3%B4m%2Bx%C3%A0o%2Bs%C3%BAp%2Bl%C6%A1'),
(43,'Tôm xào đậu que','1. Sơ chế Tôm, Đậu que, để ráo nước.
2. Chuẩn bị Tỏi, nêm muối, tiêu, nước mắm vừa ăn.
3. Làm nóng chảo/nồi, cho nguyên liệu chính vào nấu đến khi chín.
4. Nêm lại cho vừa khẩu vị, rắc hành nếu có và dùng nóng.','https://placehold.co/600x400?text=T%C3%B4m%2Bx%C3%A0o%2B%C4%91%E1%BA%ADu%2Bque'),
(44,'Tôm xào ớt chuông','1. Sơ chế Tôm, Ớt chuông, để ráo nước.
2. Chuẩn bị Hành tây, nêm muối, tiêu, nước mắm vừa ăn.
3. Làm nóng chảo/nồi, cho nguyên liệu chính vào nấu đến khi chín.
4. Nêm lại cho vừa khẩu vị, rắc hành nếu có và dùng nóng.','https://placehold.co/600x400?text=T%C3%B4m%2Bx%C3%A0o%2B%E1%BB%9Bt%2Bchu%C3%B4ng'),
(45,'Tôm rang trứng','1. Sơ chế Tôm, Trứng gà, để ráo nước.
2. Chuẩn bị Hành lá, nêm muối, tiêu, nước mắm vừa ăn.
3. Làm nóng chảo/nồi, cho nguyên liệu chính vào nấu đến khi chín.
4. Nêm lại cho vừa khẩu vị, rắc hành nếu có và dùng nóng.','https://placehold.co/600x400?text=T%C3%B4m%2Brang%2Btr%E1%BB%A9ng'),
(46,'Canh tôm bí đỏ','1. Sơ chế Tôm, Bí đỏ, để ráo nước.
2. Chuẩn bị Hành lá, nêm muối, tiêu, nước mắm vừa ăn.
3. Làm nóng chảo/nồi, cho nguyên liệu chính vào nấu đến khi chín.
4. Nêm lại cho vừa khẩu vị, rắc hành nếu có và dùng nóng.','https://placehold.co/600x400?text=Canh%2Bt%C3%B4m%2Bb%C3%AD%2B%C4%91%E1%BB%8F'),
(47,'Tôm xào dứa','1. Sơ chế Tôm, Quả dứa, để ráo nước.
2. Chuẩn bị Ớt chuông, nêm muối, tiêu, nước mắm vừa ăn.
3. Làm nóng chảo/nồi, cho nguyên liệu chính vào nấu đến khi chín.
4. Nêm lại cho vừa khẩu vị, rắc hành nếu có và dùng nóng.','https://placehold.co/600x400?text=T%C3%B4m%2Bx%C3%A0o%2Bd%E1%BB%A9a'),
(48,'Tôm xào cà rốt','1. Sơ chế Tôm, Cà rốt, để ráo nước.
2. Chuẩn bị Hành tây, nêm muối, tiêu, nước mắm vừa ăn.
3. Làm nóng chảo/nồi, cho nguyên liệu chính vào nấu đến khi chín.
4. Nêm lại cho vừa khẩu vị, rắc hành nếu có và dùng nóng.','https://placehold.co/600x400?text=T%C3%B4m%2Bx%C3%A0o%2Bc%C3%A0%2Br%E1%BB%91t'),
(49,'Tôm hấp gừng','1. Sơ chế Tôm, Gừng, để ráo nước.
2. Chuẩn bị Chanh, nêm muối, tiêu, nước mắm vừa ăn.
3. Làm nóng chảo/nồi, cho nguyên liệu chính vào nấu đến khi chín.
4. Nêm lại cho vừa khẩu vị, rắc hành nếu có và dùng nóng.','https://placehold.co/600x400?text=T%C3%B4m%2Bh%E1%BA%A5p%2Bg%E1%BB%ABng'),
(50,'Bún tôm cà chua','1. Sơ chế Bún tươi, Tôm, Cà chua, để ráo nước.
2. Chuẩn bị Hành lá, nêm muối, tiêu, nước mắm vừa ăn.
3. Làm nóng chảo/nồi, cho nguyên liệu chính vào nấu đến khi chín.
4. Nêm lại cho vừa khẩu vị, rắc hành nếu có và dùng nóng.','https://placehold.co/600x400?text=B%C3%BAn%2Bt%C3%B4m%2Bc%C3%A0%2Bchua'),
(51,'Cá rô phi chiên giòn','1. Sơ chế Cá rô phi, để ráo nước.
2. Chuẩn bị Chanh, Tỏi, nêm muối, tiêu, nước mắm vừa ăn.
3. Làm nóng chảo/nồi, cho nguyên liệu chính vào nấu đến khi chín.
4. Nêm lại cho vừa khẩu vị, rắc hành nếu có và dùng nóng.','https://placehold.co/600x400?text=C%C3%A1%2Br%C3%B4%2Bphi%2Bchi%C3%AAn%2Bgi%C3%B2n'),
(52,'Cá rô phi sốt cà chua','1. Sơ chế Cá rô phi, Cà chua, để ráo nước.
2. Chuẩn bị Hành lá, nêm muối, tiêu, nước mắm vừa ăn.
3. Làm nóng chảo/nồi, cho nguyên liệu chính vào nấu đến khi chín.
4. Nêm lại cho vừa khẩu vị, rắc hành nếu có và dùng nóng.','https://placehold.co/600x400?text=C%C3%A1%2Br%C3%B4%2Bphi%2Bs%E1%BB%91t%2Bc%C3%A0%2Bchua'),
(53,'Cá rô phi kho gừng','1. Sơ chế Cá rô phi, Gừng, để ráo nước.
2. Chuẩn bị Nước mắm, nêm muối, tiêu, nước mắm vừa ăn.
3. Làm nóng chảo/nồi, cho nguyên liệu chính vào nấu đến khi chín.
4. Nêm lại cho vừa khẩu vị, rắc hành nếu có và dùng nóng.','https://placehold.co/600x400?text=C%C3%A1%2Br%C3%B4%2Bphi%2Bkho%2Bg%E1%BB%ABng'),
(54,'Canh cá rô phi nấu chua','1. Sơ chế Cá rô phi, Cà chua, để ráo nước.
2. Chuẩn bị Chanh, Hành lá, nêm muối, tiêu, nước mắm vừa ăn.
3. Làm nóng chảo/nồi, cho nguyên liệu chính vào nấu đến khi chín.
4. Nêm lại cho vừa khẩu vị, rắc hành nếu có và dùng nóng.','https://placehold.co/600x400?text=Canh%2Bc%C3%A1%2Br%C3%B4%2Bphi%2Bn%E1%BA%A5u%2Bchua'),
(55,'Cá rô phi hấp hành','1. Sơ chế Cá rô phi, Hành lá, để ráo nước.
2. Chuẩn bị Gừng, nêm muối, tiêu, nước mắm vừa ăn.
3. Làm nóng chảo/nồi, cho nguyên liệu chính vào nấu đến khi chín.
4. Nêm lại cho vừa khẩu vị, rắc hành nếu có và dùng nóng.','https://placehold.co/600x400?text=C%C3%A1%2Br%C3%B4%2Bphi%2Bh%E1%BA%A5p%2Bh%C3%A0nh'),
(56,'Cá chép om dưa chua kiểu nhà','1. Sơ chế Cá chép, Cà chua, để ráo nước.
2. Chuẩn bị Hành lá, Gừng, nêm muối, tiêu, nước mắm vừa ăn.
3. Làm nóng chảo/nồi, cho nguyên liệu chính vào nấu đến khi chín.
4. Nêm lại cho vừa khẩu vị, rắc hành nếu có và dùng nóng.','https://placehold.co/600x400?text=C%C3%A1%2Bch%C3%A9p%2Bom%2Bd%C6%B0a%2Bchua%2Bki%E1%BB%83u%2Bnh%C3%A0'),
(57,'Cá chép hấp gừng','1. Sơ chế Cá chép, Gừng, để ráo nước.
2. Chuẩn bị Hành lá, nêm muối, tiêu, nước mắm vừa ăn.
3. Làm nóng chảo/nồi, cho nguyên liệu chính vào nấu đến khi chín.
4. Nêm lại cho vừa khẩu vị, rắc hành nếu có và dùng nóng.','https://placehold.co/600x400?text=C%C3%A1%2Bch%C3%A9p%2Bh%E1%BA%A5p%2Bg%E1%BB%ABng'),
(58,'Cá chép sốt cà chua','1. Sơ chế Cá chép, Cà chua, để ráo nước.
2. Chuẩn bị Tỏi, nêm muối, tiêu, nước mắm vừa ăn.
3. Làm nóng chảo/nồi, cho nguyên liệu chính vào nấu đến khi chín.
4. Nêm lại cho vừa khẩu vị, rắc hành nếu có và dùng nóng.','https://placehold.co/600x400?text=C%C3%A1%2Bch%C3%A9p%2Bs%E1%BB%91t%2Bc%C3%A0%2Bchua'),
(59,'Canh cá chép rau muống','1. Sơ chế Cá chép, Rau muống, để ráo nước.
2. Chuẩn bị Gừng, nêm muối, tiêu, nước mắm vừa ăn.
3. Làm nóng chảo/nồi, cho nguyên liệu chính vào nấu đến khi chín.
4. Nêm lại cho vừa khẩu vị, rắc hành nếu có và dùng nóng.','https://placehold.co/600x400?text=Canh%2Bc%C3%A1%2Bch%C3%A9p%2Brau%2Bmu%E1%BB%91ng'),
(60,'Cá chép kho tiêu','1. Sơ chế Cá chép, Tiêu, để ráo nước.
2. Chuẩn bị Tỏi, nêm muối, tiêu, nước mắm vừa ăn.
3. Làm nóng chảo/nồi, cho nguyên liệu chính vào nấu đến khi chín.
4. Nêm lại cho vừa khẩu vị, rắc hành nếu có và dùng nóng.','https://placehold.co/600x400?text=C%C3%A1%2Bch%C3%A9p%2Bkho%2Bti%C3%AAu'),
(61,'Canh ngao cà chua','1. Sơ chế Ngao, Cà chua, để ráo nước.
2. Chuẩn bị Hành lá, nêm muối, tiêu, nước mắm vừa ăn.
3. Làm nóng chảo/nồi, cho nguyên liệu chính vào nấu đến khi chín.
4. Nêm lại cho vừa khẩu vị, rắc hành nếu có và dùng nóng.','https://placehold.co/600x400?text=Canh%2Bngao%2Bc%C3%A0%2Bchua'),
(62,'Ngao hấp gừng','1. Sơ chế Ngao, Gừng, để ráo nước.
2. Chuẩn bị Chanh, nêm muối, tiêu, nước mắm vừa ăn.
3. Làm nóng chảo/nồi, cho nguyên liệu chính vào nấu đến khi chín.
4. Nêm lại cho vừa khẩu vị, rắc hành nếu có và dùng nóng.','https://placehold.co/600x400?text=Ngao%2Bh%E1%BA%A5p%2Bg%E1%BB%ABng'),
(63,'Ngao xào ớt chuông','1. Sơ chế Ngao, Ớt chuông, để ráo nước.
2. Chuẩn bị Hành tây, nêm muối, tiêu, nước mắm vừa ăn.
3. Làm nóng chảo/nồi, cho nguyên liệu chính vào nấu đến khi chín.
4. Nêm lại cho vừa khẩu vị, rắc hành nếu có và dùng nóng.','https://placehold.co/600x400?text=Ngao%2Bx%C3%A0o%2B%E1%BB%9Bt%2Bchu%C3%B4ng'),
(64,'Bún ngao chua','1. Sơ chế Bún tươi, Ngao, Cà chua, để ráo nước.
2. Chuẩn bị Chanh, Hành lá, nêm muối, tiêu, nước mắm vừa ăn.
3. Làm nóng chảo/nồi, cho nguyên liệu chính vào nấu đến khi chín.
4. Nêm lại cho vừa khẩu vị, rắc hành nếu có và dùng nóng.','https://placehold.co/600x400?text=B%C3%BAn%2Bngao%2Bchua'),
(65,'Canh ngao dứa','1. Sơ chế Ngao, Quả dứa, để ráo nước.
2. Chuẩn bị Cà chua, nêm muối, tiêu, nước mắm vừa ăn.
3. Làm nóng chảo/nồi, cho nguyên liệu chính vào nấu đến khi chín.
4. Nêm lại cho vừa khẩu vị, rắc hành nếu có và dùng nóng.','https://placehold.co/600x400?text=Canh%2Bngao%2Bd%E1%BB%A9a'),
(66,'Đậu phụ sốt cà chua','1. Sơ chế Đậu phụ, Cà chua, để ráo nước.
2. Chuẩn bị Hành lá, nêm muối, tiêu, nước mắm vừa ăn.
3. Làm nóng chảo/nồi, cho nguyên liệu chính vào nấu đến khi chín.
4. Nêm lại cho vừa khẩu vị, rắc hành nếu có và dùng nóng.','https://placehold.co/600x400?text=%C4%90%E1%BA%ADu%2Bph%E1%BB%A5%2Bs%E1%BB%91t%2Bc%C3%A0%2Bchua'),
(67,'Đậu phụ chiên sả tỏi','1. Sơ chế Đậu phụ, Tỏi, để ráo nước.
2. Chuẩn bị Ớt nhỏ, nêm muối, tiêu, nước mắm vừa ăn.
3. Làm nóng chảo/nồi, cho nguyên liệu chính vào nấu đến khi chín.
4. Nêm lại cho vừa khẩu vị, rắc hành nếu có và dùng nóng.','https://placehold.co/600x400?text=%C4%90%E1%BA%ADu%2Bph%E1%BB%A5%2Bchi%C3%AAn%2Bs%E1%BA%A3%2Bt%E1%BB%8Fi'),
(68,'Đậu phụ xào cải thảo','1. Sơ chế Đậu phụ, Cải thảo, để ráo nước.
2. Chuẩn bị Tỏi, nêm muối, tiêu, nước mắm vừa ăn.
3. Làm nóng chảo/nồi, cho nguyên liệu chính vào nấu đến khi chín.
4. Nêm lại cho vừa khẩu vị, rắc hành nếu có và dùng nóng.','https://placehold.co/600x400?text=%C4%90%E1%BA%ADu%2Bph%E1%BB%A5%2Bx%C3%A0o%2Bc%E1%BA%A3i%2Bth%E1%BA%A3o'),
(69,'Đậu phụ xào nấm kim châm','1. Sơ chế Đậu phụ, Nấm kim châm, để ráo nước.
2. Chuẩn bị Hành lá, nêm muối, tiêu, nước mắm vừa ăn.
3. Làm nóng chảo/nồi, cho nguyên liệu chính vào nấu đến khi chín.
4. Nêm lại cho vừa khẩu vị, rắc hành nếu có và dùng nóng.','https://placehold.co/600x400?text=%C4%90%E1%BA%ADu%2Bph%E1%BB%A5%2Bx%C3%A0o%2Bn%E1%BA%A5m%2Bkim%2Bch%C3%A2m'),
(70,'Canh đậu phụ cà chua','1. Sơ chế Đậu phụ, Cà chua, để ráo nước.
2. Chuẩn bị Hành lá, nêm muối, tiêu, nước mắm vừa ăn.
3. Làm nóng chảo/nồi, cho nguyên liệu chính vào nấu đến khi chín.
4. Nêm lại cho vừa khẩu vị, rắc hành nếu có và dùng nóng.','https://placehold.co/600x400?text=Canh%2B%C4%91%E1%BA%ADu%2Bph%E1%BB%A5%2Bc%C3%A0%2Bchua'),
(71,'Đậu phụ xào đậu que','1. Sơ chế Đậu phụ, Đậu que, để ráo nước.
2. Chuẩn bị Tỏi, nêm muối, tiêu, nước mắm vừa ăn.
3. Làm nóng chảo/nồi, cho nguyên liệu chính vào nấu đến khi chín.
4. Nêm lại cho vừa khẩu vị, rắc hành nếu có và dùng nóng.','https://placehold.co/600x400?text=%C4%90%E1%BA%ADu%2Bph%E1%BB%A5%2Bx%C3%A0o%2B%C4%91%E1%BA%ADu%2Bque'),
(72,'Đậu phụ kho gừng','1. Sơ chế Đậu phụ, Gừng, để ráo nước.
2. Chuẩn bị Nước mắm, nêm muối, tiêu, nước mắm vừa ăn.
3. Làm nóng chảo/nồi, cho nguyên liệu chính vào nấu đến khi chín.
4. Nêm lại cho vừa khẩu vị, rắc hành nếu có và dùng nóng.','https://placehold.co/600x400?text=%C4%90%E1%BA%ADu%2Bph%E1%BB%A5%2Bkho%2Bg%E1%BB%ABng'),
(73,'Đậu phụ xào cà tím','1. Sơ chế Đậu phụ, Cà tím, để ráo nước.
2. Chuẩn bị Tỏi, nêm muối, tiêu, nước mắm vừa ăn.
3. Làm nóng chảo/nồi, cho nguyên liệu chính vào nấu đến khi chín.
4. Nêm lại cho vừa khẩu vị, rắc hành nếu có và dùng nóng.','https://placehold.co/600x400?text=%C4%90%E1%BA%ADu%2Bph%E1%BB%A5%2Bx%C3%A0o%2Bc%C3%A0%2Bt%C3%ADm'),
(74,'Đậu phụ sốt hành tây','1. Sơ chế Đậu phụ, Hành tây, để ráo nước.
2. Chuẩn bị Tỏi, nêm muối, tiêu, nước mắm vừa ăn.
3. Làm nóng chảo/nồi, cho nguyên liệu chính vào nấu đến khi chín.
4. Nêm lại cho vừa khẩu vị, rắc hành nếu có và dùng nóng.','https://placehold.co/600x400?text=%C4%90%E1%BA%ADu%2Bph%E1%BB%A5%2Bs%E1%BB%91t%2Bh%C3%A0nh%2Bt%C3%A2y'),
(75,'Bún đậu phụ cà chua','1. Sơ chế Bún tươi, Đậu phụ, Cà chua, để ráo nước.
2. Chuẩn bị Hành lá, nêm muối, tiêu, nước mắm vừa ăn.
3. Làm nóng chảo/nồi, cho nguyên liệu chính vào nấu đến khi chín.
4. Nêm lại cho vừa khẩu vị, rắc hành nếu có và dùng nóng.','https://placehold.co/600x400?text=B%C3%BAn%2B%C4%91%E1%BA%ADu%2Bph%E1%BB%A5%2Bc%C3%A0%2Bchua'),
(76,'Rau muống xào tỏi','1. Sơ chế Rau muống, Tỏi, để ráo nước.
2. Chuẩn bị gia vị cơ bản, nêm muối, tiêu, nước mắm vừa ăn.
3. Làm nóng chảo/nồi, cho nguyên liệu chính vào nấu đến khi chín.
4. Nêm lại cho vừa khẩu vị, rắc hành nếu có và dùng nóng.','https://placehold.co/600x400?text=Rau%2Bmu%E1%BB%91ng%2Bx%C3%A0o%2Bt%E1%BB%8Fi'),
(77,'Canh rau muống chanh','1. Sơ chế Rau muống, Chanh, để ráo nước.
2. Chuẩn bị gia vị cơ bản, nêm muối, tiêu, nước mắm vừa ăn.
3. Làm nóng chảo/nồi, cho nguyên liệu chính vào nấu đến khi chín.
4. Nêm lại cho vừa khẩu vị, rắc hành nếu có và dùng nóng.','https://placehold.co/600x400?text=Canh%2Brau%2Bmu%E1%BB%91ng%2Bchanh'),
(78,'Rau muống xào thịt bò','1. Sơ chế Rau muống, Thịt bò, để ráo nước.
2. Chuẩn bị Tỏi, nêm muối, tiêu, nước mắm vừa ăn.
3. Làm nóng chảo/nồi, cho nguyên liệu chính vào nấu đến khi chín.
4. Nêm lại cho vừa khẩu vị, rắc hành nếu có và dùng nóng.','https://placehold.co/600x400?text=Rau%2Bmu%E1%BB%91ng%2Bx%C3%A0o%2Bth%E1%BB%8Bt%2Bb%C3%B2'),
(79,'Rau muống xào tôm','1. Sơ chế Rau muống, Tôm, để ráo nước.
2. Chuẩn bị Tỏi, nêm muối, tiêu, nước mắm vừa ăn.
3. Làm nóng chảo/nồi, cho nguyên liệu chính vào nấu đến khi chín.
4. Nêm lại cho vừa khẩu vị, rắc hành nếu có và dùng nóng.','https://placehold.co/600x400?text=Rau%2Bmu%E1%BB%91ng%2Bx%C3%A0o%2Bt%C3%B4m'),
(80,'Nộm rau muống dưa chuột','1. Sơ chế Rau muống, Dưa chuột, để ráo nước.
2. Chuẩn bị Chanh, nêm muối, tiêu, nước mắm vừa ăn.
3. Làm nóng chảo/nồi, cho nguyên liệu chính vào nấu đến khi chín.
4. Nêm lại cho vừa khẩu vị, rắc hành nếu có và dùng nóng.','https://placehold.co/600x400?text=N%E1%BB%99m%2Brau%2Bmu%E1%BB%91ng%2Bd%C6%B0a%2Bchu%E1%BB%99t'),
(81,'Cải thảo xào tỏi','1. Sơ chế Cải thảo, Tỏi, để ráo nước.
2. Chuẩn bị gia vị cơ bản, nêm muối, tiêu, nước mắm vừa ăn.
3. Làm nóng chảo/nồi, cho nguyên liệu chính vào nấu đến khi chín.
4. Nêm lại cho vừa khẩu vị, rắc hành nếu có và dùng nóng.','https://placehold.co/600x400?text=C%E1%BA%A3i%2Bth%E1%BA%A3o%2Bx%C3%A0o%2Bt%E1%BB%8Fi'),
(82,'Cải thảo cuộn thịt','1. Sơ chế Cải thảo, Thịt lợn, để ráo nước.
2. Chuẩn bị Hành lá, nêm muối, tiêu, nước mắm vừa ăn.
3. Làm nóng chảo/nồi, cho nguyên liệu chính vào nấu đến khi chín.
4. Nêm lại cho vừa khẩu vị, rắc hành nếu có và dùng nóng.','https://placehold.co/600x400?text=C%E1%BA%A3i%2Bth%E1%BA%A3o%2Bcu%E1%BB%99n%2Bth%E1%BB%8Bt'),
(83,'Canh cải thảo đậu phụ','1. Sơ chế Cải thảo, Đậu phụ, để ráo nước.
2. Chuẩn bị Hành lá, nêm muối, tiêu, nước mắm vừa ăn.
3. Làm nóng chảo/nồi, cho nguyên liệu chính vào nấu đến khi chín.
4. Nêm lại cho vừa khẩu vị, rắc hành nếu có và dùng nóng.','https://placehold.co/600x400?text=Canh%2Bc%E1%BA%A3i%2Bth%E1%BA%A3o%2B%C4%91%E1%BA%ADu%2Bph%E1%BB%A5'),
(84,'Cải thảo xào tôm','1. Sơ chế Cải thảo, Tôm, để ráo nước.
2. Chuẩn bị Tỏi, nêm muối, tiêu, nước mắm vừa ăn.
3. Làm nóng chảo/nồi, cho nguyên liệu chính vào nấu đến khi chín.
4. Nêm lại cho vừa khẩu vị, rắc hành nếu có và dùng nóng.','https://placehold.co/600x400?text=C%E1%BA%A3i%2Bth%E1%BA%A3o%2Bx%C3%A0o%2Bt%C3%B4m'),
(85,'Cải thảo xào trứng','1. Sơ chế Cải thảo, Trứng gà, để ráo nước.
2. Chuẩn bị Hành lá, nêm muối, tiêu, nước mắm vừa ăn.
3. Làm nóng chảo/nồi, cho nguyên liệu chính vào nấu đến khi chín.
4. Nêm lại cho vừa khẩu vị, rắc hành nếu có và dùng nóng.','https://placehold.co/600x400?text=C%E1%BA%A3i%2Bth%E1%BA%A3o%2Bx%C3%A0o%2Btr%E1%BB%A9ng'),
(86,'Súp lơ xào tỏi','1. Sơ chế Súp lơ, Tỏi, để ráo nước.
2. Chuẩn bị gia vị cơ bản, nêm muối, tiêu, nước mắm vừa ăn.
3. Làm nóng chảo/nồi, cho nguyên liệu chính vào nấu đến khi chín.
4. Nêm lại cho vừa khẩu vị, rắc hành nếu có và dùng nóng.','https://placehold.co/600x400?text=S%C3%BAp%2Bl%C6%A1%2Bx%C3%A0o%2Bt%E1%BB%8Fi'),
(87,'Súp lơ xào thịt bò','1. Sơ chế Súp lơ, Thịt bò, để ráo nước.
2. Chuẩn bị Tỏi, nêm muối, tiêu, nước mắm vừa ăn.
3. Làm nóng chảo/nồi, cho nguyên liệu chính vào nấu đến khi chín.
4. Nêm lại cho vừa khẩu vị, rắc hành nếu có và dùng nóng.','https://placehold.co/600x400?text=S%C3%BAp%2Bl%C6%A1%2Bx%C3%A0o%2Bth%E1%BB%8Bt%2Bb%C3%B2'),
(88,'Súp lơ xào tôm','1. Sơ chế Súp lơ, Tôm, để ráo nước.
2. Chuẩn bị Tỏi, nêm muối, tiêu, nước mắm vừa ăn.
3. Làm nóng chảo/nồi, cho nguyên liệu chính vào nấu đến khi chín.
4. Nêm lại cho vừa khẩu vị, rắc hành nếu có và dùng nóng.','https://placehold.co/600x400?text=S%C3%BAp%2Bl%C6%A1%2Bx%C3%A0o%2Bt%C3%B4m'),
(89,'Canh súp lơ cà rốt','1. Sơ chế Súp lơ, Cà rốt, để ráo nước.
2. Chuẩn bị Hành lá, nêm muối, tiêu, nước mắm vừa ăn.
3. Làm nóng chảo/nồi, cho nguyên liệu chính vào nấu đến khi chín.
4. Nêm lại cho vừa khẩu vị, rắc hành nếu có và dùng nóng.','https://placehold.co/600x400?text=Canh%2Bs%C3%BAp%2Bl%C6%A1%2Bc%C3%A0%2Br%E1%BB%91t'),
(90,'Súp lơ xào trứng','1. Sơ chế Súp lơ, Trứng gà, để ráo nước.
2. Chuẩn bị Hành lá, nêm muối, tiêu, nước mắm vừa ăn.
3. Làm nóng chảo/nồi, cho nguyên liệu chính vào nấu đến khi chín.
4. Nêm lại cho vừa khẩu vị, rắc hành nếu có và dùng nóng.','https://placehold.co/600x400?text=S%C3%BAp%2Bl%C6%A1%2Bx%C3%A0o%2Btr%E1%BB%A9ng'),
(91,'Khoai tây xào cà rốt','1. Sơ chế Khoai tây, Cà rốt, để ráo nước.
2. Chuẩn bị Hành lá, nêm muối, tiêu, nước mắm vừa ăn.
3. Làm nóng chảo/nồi, cho nguyên liệu chính vào nấu đến khi chín.
4. Nêm lại cho vừa khẩu vị, rắc hành nếu có và dùng nóng.','https://placehold.co/600x400?text=Khoai%2Bt%C3%A2y%2Bx%C3%A0o%2Bc%C3%A0%2Br%E1%BB%91t'),
(92,'Khoai tây hầm thịt gà','1. Sơ chế Khoai tây, Thịt gà, để ráo nước.
2. Chuẩn bị Cà rốt, nêm muối, tiêu, nước mắm vừa ăn.
3. Làm nóng chảo/nồi, cho nguyên liệu chính vào nấu đến khi chín.
4. Nêm lại cho vừa khẩu vị, rắc hành nếu có và dùng nóng.','https://placehold.co/600x400?text=Khoai%2Bt%C3%A2y%2Bh%E1%BA%A7m%2Bth%E1%BB%8Bt%2Bg%C3%A0'),
(93,'Khoai tây xào thịt bò','1. Sơ chế Khoai tây, Thịt bò, để ráo nước.
2. Chuẩn bị Tỏi, nêm muối, tiêu, nước mắm vừa ăn.
3. Làm nóng chảo/nồi, cho nguyên liệu chính vào nấu đến khi chín.
4. Nêm lại cho vừa khẩu vị, rắc hành nếu có và dùng nóng.','https://placehold.co/600x400?text=Khoai%2Bt%C3%A2y%2Bx%C3%A0o%2Bth%E1%BB%8Bt%2Bb%C3%B2'),
(94,'Canh khoai tây cà rốt','1. Sơ chế Khoai tây, Cà rốt, để ráo nước.
2. Chuẩn bị Hành lá, nêm muối, tiêu, nước mắm vừa ăn.
3. Làm nóng chảo/nồi, cho nguyên liệu chính vào nấu đến khi chín.
4. Nêm lại cho vừa khẩu vị, rắc hành nếu có và dùng nóng.','https://placehold.co/600x400?text=Canh%2Bkhoai%2Bt%C3%A2y%2Bc%C3%A0%2Br%E1%BB%91t'),
(95,'Khoai tây chiên tỏi','1. Sơ chế Khoai tây, Tỏi, để ráo nước.
2. Chuẩn bị gia vị cơ bản, nêm muối, tiêu, nước mắm vừa ăn.
3. Làm nóng chảo/nồi, cho nguyên liệu chính vào nấu đến khi chín.
4. Nêm lại cho vừa khẩu vị, rắc hành nếu có và dùng nóng.','https://placehold.co/600x400?text=Khoai%2Bt%C3%A2y%2Bchi%C3%AAn%2Bt%E1%BB%8Fi'),
(96,'Su hào xào cà rốt','1. Sơ chế Su hào, Cà rốt, để ráo nước.
2. Chuẩn bị Hành lá, nêm muối, tiêu, nước mắm vừa ăn.
3. Làm nóng chảo/nồi, cho nguyên liệu chính vào nấu đến khi chín.
4. Nêm lại cho vừa khẩu vị, rắc hành nếu có và dùng nóng.','https://placehold.co/600x400?text=Su%2Bh%C3%A0o%2Bx%C3%A0o%2Bc%C3%A0%2Br%E1%BB%91t'),
(97,'Su hào xào thịt lợn','1. Sơ chế Su hào, Thịt lợn, để ráo nước.
2. Chuẩn bị Tỏi, nêm muối, tiêu, nước mắm vừa ăn.
3. Làm nóng chảo/nồi, cho nguyên liệu chính vào nấu đến khi chín.
4. Nêm lại cho vừa khẩu vị, rắc hành nếu có và dùng nóng.','https://placehold.co/600x400?text=Su%2Bh%C3%A0o%2Bx%C3%A0o%2Bth%E1%BB%8Bt%2Bl%E1%BB%A3n'),
(98,'Canh su hào sườn non','1. Sơ chế Su hào, Sườn non, để ráo nước.
2. Chuẩn bị Hành lá, nêm muối, tiêu, nước mắm vừa ăn.
3. Làm nóng chảo/nồi, cho nguyên liệu chính vào nấu đến khi chín.
4. Nêm lại cho vừa khẩu vị, rắc hành nếu có và dùng nóng.','https://placehold.co/600x400?text=Canh%2Bsu%2Bh%C3%A0o%2Bs%C6%B0%E1%BB%9Dn%2Bnon'),
(99,'Nộm su hào cà rốt','1. Sơ chế Su hào, Cà rốt, để ráo nước.
2. Chuẩn bị Chanh, nêm muối, tiêu, nước mắm vừa ăn.
3. Làm nóng chảo/nồi, cho nguyên liệu chính vào nấu đến khi chín.
4. Nêm lại cho vừa khẩu vị, rắc hành nếu có và dùng nóng.','https://placehold.co/600x400?text=N%E1%BB%99m%2Bsu%2Bh%C3%A0o%2Bc%C3%A0%2Br%E1%BB%91t'),
(100,'Su hào xào trứng','1. Sơ chế Su hào, Trứng gà, để ráo nước.
2. Chuẩn bị Hành lá, nêm muối, tiêu, nước mắm vừa ăn.
3. Làm nóng chảo/nồi, cho nguyên liệu chính vào nấu đến khi chín.
4. Nêm lại cho vừa khẩu vị, rắc hành nếu có và dùng nóng.','https://placehold.co/600x400?text=Su%2Bh%C3%A0o%2Bx%C3%A0o%2Btr%E1%BB%A9ng');

INSERT INTO recipe_ingredients(recipe_id, ingredient_id, quantity_desc, is_main) VALUES
(1,(SELECT id FROM ingredients WHERE name='Trứng gà'),'2 quả',1),
(1,(SELECT id FROM ingredients WHERE name='Cà chua'),'2 quả',1),
(1,(SELECT id FROM ingredients WHERE name='Hành lá'),'2 nhánh',0),
(1,(SELECT id FROM ingredients WHERE name='Tỏi'),'3 tép',0),
(2,(SELECT id FROM ingredients WHERE name='Trứng gà'),'2 quả',1),
(2,(SELECT id FROM ingredients WHERE name='Hành lá'),'2 nhánh',1),
(2,(SELECT id FROM ingredients WHERE name='Nước mắm'),'1 muỗng',0),
(2,(SELECT id FROM ingredients WHERE name='Tiêu'),'1/2 muỗng',0),
(3,(SELECT id FROM ingredients WHERE name='Trứng gà'),'2 quả',1),
(3,(SELECT id FROM ingredients WHERE name='Cà rốt'),'1 củ',1),
(3,(SELECT id FROM ingredients WHERE name='Hành lá'),'2 nhánh',0),
(4,(SELECT id FROM ingredients WHERE name='Trứng gà'),'2 quả',1),
(4,(SELECT id FROM ingredients WHERE name='Đậu que'),'200g',1),
(4,(SELECT id FROM ingredients WHERE name='Hành lá'),'2 nhánh',0),
(5,(SELECT id FROM ingredients WHERE name='Mướp đắng'),'2 quả',1),
(5,(SELECT id FROM ingredients WHERE name='Trứng gà'),'2 quả',1),
(5,(SELECT id FROM ingredients WHERE name='Tỏi'),'3 tép',0),
(6,(SELECT id FROM ingredients WHERE name='Trứng gà'),'2 quả',1),
(6,(SELECT id FROM ingredients WHERE name='Cà chua'),'2 quả',1),
(6,(SELECT id FROM ingredients WHERE name='Hành lá'),'2 nhánh',0),
(7,(SELECT id FROM ingredients WHERE name='Trứng gà'),'2 quả',1),
(7,(SELECT id FROM ingredients WHERE name='Đậu phụ'),'2 bìa',1),
(7,(SELECT id FROM ingredients WHERE name='Hành lá'),'2 nhánh',0),
(8,(SELECT id FROM ingredients WHERE name='Bánh mì'),'1 ổ',1),
(8,(SELECT id FROM ingredients WHERE name='Trứng gà'),'2 quả',1),
(8,(SELECT id FROM ingredients WHERE name='Dưa chuột'),'1 quả',0),
(9,(SELECT id FROM ingredients WHERE name='Bánh mì'),'1 ổ',1),
(9,(SELECT id FROM ingredients WHERE name='Thịt lợn'),'250g',1),
(9,(SELECT id FROM ingredients WHERE name='Trứng gà'),'2 quả',1),
(9,(SELECT id FROM ingredients WHERE name='Dưa chuột'),'1 quả',0),
(9,(SELECT id FROM ingredients WHERE name='Hành lá'),'2 nhánh',0),
(10,(SELECT id FROM ingredients WHERE name='Cơm trắng'),'2 bát',1),
(10,(SELECT id FROM ingredients WHERE name='Trứng gà'),'2 quả',1),
(10,(SELECT id FROM ingredients WHERE name='Cà rốt'),'1 củ',1),
(10,(SELECT id FROM ingredients WHERE name='Hành lá'),'2 nhánh',0),
(11,(SELECT id FROM ingredients WHERE name='Thịt gà'),'300g',1),
(11,(SELECT id FROM ingredients WHERE name='Gừng'),'1 củ',1),
(11,(SELECT id FROM ingredients WHERE name='Tỏi'),'3 tép',0),
(11,(SELECT id FROM ingredients WHERE name='Ớt nhỏ'),'1 quả',0),
(12,(SELECT id FROM ingredients WHERE name='Thịt gà'),'300g',1),
(12,(SELECT id FROM ingredients WHERE name='Ớt chuông'),'1 quả',1),
(12,(SELECT id FROM ingredients WHERE name='Hành tây'),'1 củ',0),
(12,(SELECT id FROM ingredients WHERE name='Tỏi'),'3 tép',0),
(13,(SELECT id FROM ingredients WHERE name='Thịt gà'),'300g',1),
(13,(SELECT id FROM ingredients WHERE name='Hành tây'),'1 củ',1),
(13,(SELECT id FROM ingredients WHERE name='Tỏi'),'3 tép',0),
(14,(SELECT id FROM ingredients WHERE name='Thịt gà'),'300g',1),
(14,(SELECT id FROM ingredients WHERE name='Gừng'),'1 củ',1),
(14,(SELECT id FROM ingredients WHERE name='Nước mắm'),'1 muỗng',0),
(14,(SELECT id FROM ingredients WHERE name='Tiêu'),'1/2 muỗng',0),
(15,(SELECT id FROM ingredients WHERE name='Thịt gà'),'300g',1),
(15,(SELECT id FROM ingredients WHERE name='Súp lơ'),'1 cây',1),
(15,(SELECT id FROM ingredients WHERE name='Tỏi'),'3 tép',0),
(16,(SELECT id FROM ingredients WHERE name='Thịt gà'),'300g',1),
(16,(SELECT id FROM ingredients WHERE name='Bí đỏ'),'300g',1),
(16,(SELECT id FROM ingredients WHERE name='Hành lá'),'2 nhánh',0),
(17,(SELECT id FROM ingredients WHERE name='Thịt gà'),'300g',1),
(17,(SELECT id FROM ingredients WHERE name='Đậu que'),'200g',1),
(17,(SELECT id FROM ingredients WHERE name='Tỏi'),'3 tép',0),
(18,(SELECT id FROM ingredients WHERE name='Thịt gà'),'300g',1),
(18,(SELECT id FROM ingredients WHERE name='Cà rốt'),'1 củ',1),
(18,(SELECT id FROM ingredients WHERE name='Hành tây'),'1 củ',0),
(19,(SELECT id FROM ingredients WHERE name='Thịt gà'),'300g',1),
(19,(SELECT id FROM ingredients WHERE name='Cải thảo'),'300g',1),
(19,(SELECT id FROM ingredients WHERE name='Gừng'),'1 củ',0),
(20,(SELECT id FROM ingredients WHERE name='Thịt gà'),'300g',1),
(20,(SELECT id FROM ingredients WHERE name='Dưa chuột'),'1 quả',1),
(20,(SELECT id FROM ingredients WHERE name='Chanh'),'1 quả',0),
(21,(SELECT id FROM ingredients WHERE name='Thịt lợn'),'250g',1),
(21,(SELECT id FROM ingredients WHERE name='Hành tây'),'1 củ',1),
(21,(SELECT id FROM ingredients WHERE name='Tỏi'),'3 tép',0),
(22,(SELECT id FROM ingredients WHERE name='Thịt lợn'),'250g',1),
(22,(SELECT id FROM ingredients WHERE name='Trứng gà'),'2 quả',1),
(22,(SELECT id FROM ingredients WHERE name='Nước mắm'),'1 muỗng',0),
(22,(SELECT id FROM ingredients WHERE name='Tiêu'),'1/2 muỗng',0),
(23,(SELECT id FROM ingredients WHERE name='Thịt lợn'),'250g',1),
(23,(SELECT id FROM ingredients WHERE name='Đậu que'),'200g',1),
(23,(SELECT id FROM ingredients WHERE name='Tỏi'),'3 tép',0),
(24,(SELECT id FROM ingredients WHERE name='Thịt lợn'),'250g',1),
(24,(SELECT id FROM ingredients WHERE name='Cà tím'),'2 quả',1),
(24,(SELECT id FROM ingredients WHERE name='Tỏi'),'3 tép',0),
(25,(SELECT id FROM ingredients WHERE name='Thịt lợn'),'250g',1),
(25,(SELECT id FROM ingredients WHERE name='Su hào'),'1 củ',1),
(25,(SELECT id FROM ingredients WHERE name='Hành lá'),'2 nhánh',0),
(26,(SELECT id FROM ingredients WHERE name='Thịt lợn'),'250g',1),
(26,(SELECT id FROM ingredients WHERE name='Cải thảo'),'300g',1),
(26,(SELECT id FROM ingredients WHERE name='Tỏi'),'3 tép',0),
(27,(SELECT id FROM ingredients WHERE name='Thịt lợn'),'250g',1),
(27,(SELECT id FROM ingredients WHERE name='Chanh'),'1 quả',1),
(27,(SELECT id FROM ingredients WHERE name='Tỏi'),'3 tép',0),
(28,(SELECT id FROM ingredients WHERE name='Thịt lợn'),'250g',1),
(28,(SELECT id FROM ingredients WHERE name='Khoai tây'),'2 củ',1),
(28,(SELECT id FROM ingredients WHERE name='Hành tây'),'1 củ',0),
(29,(SELECT id FROM ingredients WHERE name='Bí đỏ'),'300g',1),
(29,(SELECT id FROM ingredients WHERE name='Thịt lợn'),'250g',1),
(29,(SELECT id FROM ingredients WHERE name='Hành lá'),'2 nhánh',0),
(30,(SELECT id FROM ingredients WHERE name='Cà tím'),'2 quả',1),
(30,(SELECT id FROM ingredients WHERE name='Thịt lợn'),'250g',1),
(30,(SELECT id FROM ingredients WHERE name='Đậu phụ'),'2 bìa',0),
(30,(SELECT id FROM ingredients WHERE name='Hành lá'),'2 nhánh',0),
(31,(SELECT id FROM ingredients WHERE name='Sườn non'),'500g',1),
(31,(SELECT id FROM ingredients WHERE name='Tiêu'),'1/2 muỗng',1),
(31,(SELECT id FROM ingredients WHERE name='Tỏi'),'3 tép',0),
(32,(SELECT id FROM ingredients WHERE name='Sườn non'),'500g',1),
(32,(SELECT id FROM ingredients WHERE name='Chanh'),'1 quả',1),
(32,(SELECT id FROM ingredients WHERE name='Tỏi'),'3 tép',0),
(32,(SELECT id FROM ingredients WHERE name='Ớt nhỏ'),'1 quả',0),
(33,(SELECT id FROM ingredients WHERE name='Sườn non'),'500g',1),
(33,(SELECT id FROM ingredients WHERE name='Bí đỏ'),'300g',1),
(33,(SELECT id FROM ingredients WHERE name='Hành lá'),'2 nhánh',0),
(34,(SELECT id FROM ingredients WHERE name='Sườn non'),'500g',1),
(34,(SELECT id FROM ingredients WHERE name='Khoai tây'),'2 củ',1),
(34,(SELECT id FROM ingredients WHERE name='Cà rốt'),'1 củ',0),
(35,(SELECT id FROM ingredients WHERE name='Sườn non'),'500g',1),
(35,(SELECT id FROM ingredients WHERE name='Tỏi'),'3 tép',1),
(35,(SELECT id FROM ingredients WHERE name='Nước mắm'),'1 muỗng',0),
(36,(SELECT id FROM ingredients WHERE name='Sườn non'),'500g',1),
(36,(SELECT id FROM ingredients WHERE name='Su hào'),'1 củ',1),
(36,(SELECT id FROM ingredients WHERE name='Hành lá'),'2 nhánh',0),
(37,(SELECT id FROM ingredients WHERE name='Sườn non'),'500g',1),
(37,(SELECT id FROM ingredients WHERE name='Cải thảo'),'300g',1),
(37,(SELECT id FROM ingredients WHERE name='Gừng'),'1 củ',0),
(38,(SELECT id FROM ingredients WHERE name='Sườn non'),'500g',1),
(38,(SELECT id FROM ingredients WHERE name='Cà chua'),'2 quả',1),
(38,(SELECT id FROM ingredients WHERE name='Hành lá'),'2 nhánh',0),
(39,(SELECT id FROM ingredients WHERE name='Sườn non'),'500g',1),
(39,(SELECT id FROM ingredients WHERE name='Quả dứa'),'1/2 quả',1),
(39,(SELECT id FROM ingredients WHERE name='Tỏi'),'3 tép',0),
(40,(SELECT id FROM ingredients WHERE name='Bún tươi'),'500g',1),
(40,(SELECT id FROM ingredients WHERE name='Sườn non'),'500g',1),
(40,(SELECT id FROM ingredients WHERE name='Cà chua'),'2 quả',1),
(40,(SELECT id FROM ingredients WHERE name='Chanh'),'1 quả',0),
(40,(SELECT id FROM ingredients WHERE name='Hành lá'),'2 nhánh',0),
(41,(SELECT id FROM ingredients WHERE name='Tôm'),'300g',1),
(41,(SELECT id FROM ingredients WHERE name='Tỏi'),'3 tép',1),
(41,(SELECT id FROM ingredients WHERE name='Nước mắm'),'1 muỗng',0),
(41,(SELECT id FROM ingredients WHERE name='Tiêu'),'1/2 muỗng',0),
(42,(SELECT id FROM ingredients WHERE name='Tôm'),'300g',1),
(42,(SELECT id FROM ingredients WHERE name='Súp lơ'),'1 cây',1),
(42,(SELECT id FROM ingredients WHERE name='Tỏi'),'3 tép',0),
(43,(SELECT id FROM ingredients WHERE name='Tôm'),'300g',1),
(43,(SELECT id FROM ingredients WHERE name='Đậu que'),'200g',1),
(43,(SELECT id FROM ingredients WHERE name='Tỏi'),'3 tép',0),
(44,(SELECT id FROM ingredients WHERE name='Tôm'),'300g',1),
(44,(SELECT id FROM ingredients WHERE name='Ớt chuông'),'1 quả',1),
(44,(SELECT id FROM ingredients WHERE name='Hành tây'),'1 củ',0),
(45,(SELECT id FROM ingredients WHERE name='Tôm'),'300g',1),
(45,(SELECT id FROM ingredients WHERE name='Trứng gà'),'2 quả',1),
(45,(SELECT id FROM ingredients WHERE name='Hành lá'),'2 nhánh',0),
(46,(SELECT id FROM ingredients WHERE name='Tôm'),'300g',1),
(46,(SELECT id FROM ingredients WHERE name='Bí đỏ'),'300g',1),
(46,(SELECT id FROM ingredients WHERE name='Hành lá'),'2 nhánh',0),
(47,(SELECT id FROM ingredients WHERE name='Tôm'),'300g',1),
(47,(SELECT id FROM ingredients WHERE name='Quả dứa'),'1/2 quả',1),
(47,(SELECT id FROM ingredients WHERE name='Ớt chuông'),'1 quả',0),
(48,(SELECT id FROM ingredients WHERE name='Tôm'),'300g',1),
(48,(SELECT id FROM ingredients WHERE name='Cà rốt'),'1 củ',1),
(48,(SELECT id FROM ingredients WHERE name='Hành tây'),'1 củ',0),
(49,(SELECT id FROM ingredients WHERE name='Tôm'),'300g',1),
(49,(SELECT id FROM ingredients WHERE name='Gừng'),'1 củ',1),
(49,(SELECT id FROM ingredients WHERE name='Chanh'),'1 quả',0),
(50,(SELECT id FROM ingredients WHERE name='Bún tươi'),'500g',1),
(50,(SELECT id FROM ingredients WHERE name='Tôm'),'300g',1),
(50,(SELECT id FROM ingredients WHERE name='Cà chua'),'2 quả',1),
(50,(SELECT id FROM ingredients WHERE name='Hành lá'),'2 nhánh',0),
(51,(SELECT id FROM ingredients WHERE name='Cá rô phi'),'1 con',1),
(51,(SELECT id FROM ingredients WHERE name='Chanh'),'1 quả',0),
(51,(SELECT id FROM ingredients WHERE name='Tỏi'),'3 tép',0),
(52,(SELECT id FROM ingredients WHERE name='Cá rô phi'),'1 con',1),
(52,(SELECT id FROM ingredients WHERE name='Cà chua'),'2 quả',1),
(52,(SELECT id FROM ingredients WHERE name='Hành lá'),'2 nhánh',0),
(53,(SELECT id FROM ingredients WHERE name='Cá rô phi'),'1 con',1),
(53,(SELECT id FROM ingredients WHERE name='Gừng'),'1 củ',1),
(53,(SELECT id FROM ingredients WHERE name='Nước mắm'),'1 muỗng',0),
(54,(SELECT id FROM ingredients WHERE name='Cá rô phi'),'1 con',1),
(54,(SELECT id FROM ingredients WHERE name='Cà chua'),'2 quả',1),
(54,(SELECT id FROM ingredients WHERE name='Chanh'),'1 quả',0),
(54,(SELECT id FROM ingredients WHERE name='Hành lá'),'2 nhánh',0),
(55,(SELECT id FROM ingredients WHERE name='Cá rô phi'),'1 con',1),
(55,(SELECT id FROM ingredients WHERE name='Hành lá'),'2 nhánh',1),
(55,(SELECT id FROM ingredients WHERE name='Gừng'),'1 củ',0),
(56,(SELECT id FROM ingredients WHERE name='Cá chép'),'1 con',1),
(56,(SELECT id FROM ingredients WHERE name='Cà chua'),'2 quả',1),
(56,(SELECT id FROM ingredients WHERE name='Hành lá'),'2 nhánh',0),
(56,(SELECT id FROM ingredients WHERE name='Gừng'),'1 củ',0),
(57,(SELECT id FROM ingredients WHERE name='Cá chép'),'1 con',1),
(57,(SELECT id FROM ingredients WHERE name='Gừng'),'1 củ',1),
(57,(SELECT id FROM ingredients WHERE name='Hành lá'),'2 nhánh',0),
(58,(SELECT id FROM ingredients WHERE name='Cá chép'),'1 con',1),
(58,(SELECT id FROM ingredients WHERE name='Cà chua'),'2 quả',1),
(58,(SELECT id FROM ingredients WHERE name='Tỏi'),'3 tép',0),
(59,(SELECT id FROM ingredients WHERE name='Cá chép'),'1 con',1),
(59,(SELECT id FROM ingredients WHERE name='Rau muống'),'1 bó',1),
(59,(SELECT id FROM ingredients WHERE name='Gừng'),'1 củ',0),
(60,(SELECT id FROM ingredients WHERE name='Cá chép'),'1 con',1),
(60,(SELECT id FROM ingredients WHERE name='Tiêu'),'1/2 muỗng',1),
(60,(SELECT id FROM ingredients WHERE name='Tỏi'),'3 tép',0),
(61,(SELECT id FROM ingredients WHERE name='Ngao'),'500g',1),
(61,(SELECT id FROM ingredients WHERE name='Cà chua'),'2 quả',1),
(61,(SELECT id FROM ingredients WHERE name='Hành lá'),'2 nhánh',0),
(62,(SELECT id FROM ingredients WHERE name='Ngao'),'500g',1),
(62,(SELECT id FROM ingredients WHERE name='Gừng'),'1 củ',1),
(62,(SELECT id FROM ingredients WHERE name='Chanh'),'1 quả',0),
(63,(SELECT id FROM ingredients WHERE name='Ngao'),'500g',1),
(63,(SELECT id FROM ingredients WHERE name='Ớt chuông'),'1 quả',1),
(63,(SELECT id FROM ingredients WHERE name='Hành tây'),'1 củ',0),
(64,(SELECT id FROM ingredients WHERE name='Bún tươi'),'500g',1),
(64,(SELECT id FROM ingredients WHERE name='Ngao'),'500g',1),
(64,(SELECT id FROM ingredients WHERE name='Cà chua'),'2 quả',1),
(64,(SELECT id FROM ingredients WHERE name='Chanh'),'1 quả',0),
(64,(SELECT id FROM ingredients WHERE name='Hành lá'),'2 nhánh',0),
(65,(SELECT id FROM ingredients WHERE name='Ngao'),'500g',1),
(65,(SELECT id FROM ingredients WHERE name='Quả dứa'),'1/2 quả',1),
(65,(SELECT id FROM ingredients WHERE name='Cà chua'),'2 quả',0),
(66,(SELECT id FROM ingredients WHERE name='Đậu phụ'),'2 bìa',1),
(66,(SELECT id FROM ingredients WHERE name='Cà chua'),'2 quả',1),
(66,(SELECT id FROM ingredients WHERE name='Hành lá'),'2 nhánh',0),
(67,(SELECT id FROM ingredients WHERE name='Đậu phụ'),'2 bìa',1),
(67,(SELECT id FROM ingredients WHERE name='Tỏi'),'3 tép',1),
(67,(SELECT id FROM ingredients WHERE name='Ớt nhỏ'),'1 quả',0),
(68,(SELECT id FROM ingredients WHERE name='Đậu phụ'),'2 bìa',1),
(68,(SELECT id FROM ingredients WHERE name='Cải thảo'),'300g',1),
(68,(SELECT id FROM ingredients WHERE name='Tỏi'),'3 tép',0),
(69,(SELECT id FROM ingredients WHERE name='Đậu phụ'),'2 bìa',1),
(69,(SELECT id FROM ingredients WHERE name='Nấm kim châm'),'1 túi',1),
(69,(SELECT id FROM ingredients WHERE name='Hành lá'),'2 nhánh',0),
(70,(SELECT id FROM ingredients WHERE name='Đậu phụ'),'2 bìa',1),
(70,(SELECT id FROM ingredients WHERE name='Cà chua'),'2 quả',1),
(70,(SELECT id FROM ingredients WHERE name='Hành lá'),'2 nhánh',0),
(71,(SELECT id FROM ingredients WHERE name='Đậu phụ'),'2 bìa',1),
(71,(SELECT id FROM ingredients WHERE name='Đậu que'),'200g',1),
(71,(SELECT id FROM ingredients WHERE name='Tỏi'),'3 tép',0),
(72,(SELECT id FROM ingredients WHERE name='Đậu phụ'),'2 bìa',1),
(72,(SELECT id FROM ingredients WHERE name='Gừng'),'1 củ',1),
(72,(SELECT id FROM ingredients WHERE name='Nước mắm'),'1 muỗng',0),
(73,(SELECT id FROM ingredients WHERE name='Đậu phụ'),'2 bìa',1),
(73,(SELECT id FROM ingredients WHERE name='Cà tím'),'2 quả',1),
(73,(SELECT id FROM ingredients WHERE name='Tỏi'),'3 tép',0),
(74,(SELECT id FROM ingredients WHERE name='Đậu phụ'),'2 bìa',1),
(74,(SELECT id FROM ingredients WHERE name='Hành tây'),'1 củ',1),
(74,(SELECT id FROM ingredients WHERE name='Tỏi'),'3 tép',0),
(75,(SELECT id FROM ingredients WHERE name='Bún tươi'),'500g',1),
(75,(SELECT id FROM ingredients WHERE name='Đậu phụ'),'2 bìa',1),
(75,(SELECT id FROM ingredients WHERE name='Cà chua'),'2 quả',1),
(75,(SELECT id FROM ingredients WHERE name='Hành lá'),'2 nhánh',0),
(76,(SELECT id FROM ingredients WHERE name='Rau muống'),'1 bó',1),
(76,(SELECT id FROM ingredients WHERE name='Tỏi'),'3 tép',1),
(77,(SELECT id FROM ingredients WHERE name='Rau muống'),'1 bó',1),
(77,(SELECT id FROM ingredients WHERE name='Chanh'),'1 quả',1),
(78,(SELECT id FROM ingredients WHERE name='Rau muống'),'1 bó',1),
(78,(SELECT id FROM ingredients WHERE name='Thịt bò'),'250g',1),
(78,(SELECT id FROM ingredients WHERE name='Tỏi'),'3 tép',0),
(79,(SELECT id FROM ingredients WHERE name='Rau muống'),'1 bó',1),
(79,(SELECT id FROM ingredients WHERE name='Tôm'),'300g',1),
(79,(SELECT id FROM ingredients WHERE name='Tỏi'),'3 tép',0),
(80,(SELECT id FROM ingredients WHERE name='Rau muống'),'1 bó',1),
(80,(SELECT id FROM ingredients WHERE name='Dưa chuột'),'1 quả',1),
(80,(SELECT id FROM ingredients WHERE name='Chanh'),'1 quả',0),
(81,(SELECT id FROM ingredients WHERE name='Cải thảo'),'300g',1),
(81,(SELECT id FROM ingredients WHERE name='Tỏi'),'3 tép',1),
(82,(SELECT id FROM ingredients WHERE name='Cải thảo'),'300g',1),
(82,(SELECT id FROM ingredients WHERE name='Thịt lợn'),'250g',1),
(82,(SELECT id FROM ingredients WHERE name='Hành lá'),'2 nhánh',0),
(83,(SELECT id FROM ingredients WHERE name='Cải thảo'),'300g',1),
(83,(SELECT id FROM ingredients WHERE name='Đậu phụ'),'2 bìa',1),
(83,(SELECT id FROM ingredients WHERE name='Hành lá'),'2 nhánh',0),
(84,(SELECT id FROM ingredients WHERE name='Cải thảo'),'300g',1),
(84,(SELECT id FROM ingredients WHERE name='Tôm'),'300g',1),
(84,(SELECT id FROM ingredients WHERE name='Tỏi'),'3 tép',0),
(85,(SELECT id FROM ingredients WHERE name='Cải thảo'),'300g',1),
(85,(SELECT id FROM ingredients WHERE name='Trứng gà'),'2 quả',1),
(85,(SELECT id FROM ingredients WHERE name='Hành lá'),'2 nhánh',0),
(86,(SELECT id FROM ingredients WHERE name='Súp lơ'),'1 cây',1),
(86,(SELECT id FROM ingredients WHERE name='Tỏi'),'3 tép',1),
(87,(SELECT id FROM ingredients WHERE name='Súp lơ'),'1 cây',1),
(87,(SELECT id FROM ingredients WHERE name='Thịt bò'),'250g',1),
(87,(SELECT id FROM ingredients WHERE name='Tỏi'),'3 tép',0),
(88,(SELECT id FROM ingredients WHERE name='Súp lơ'),'1 cây',1),
(88,(SELECT id FROM ingredients WHERE name='Tôm'),'300g',1),
(88,(SELECT id FROM ingredients WHERE name='Tỏi'),'3 tép',0),
(89,(SELECT id FROM ingredients WHERE name='Súp lơ'),'1 cây',1),
(89,(SELECT id FROM ingredients WHERE name='Cà rốt'),'1 củ',1),
(89,(SELECT id FROM ingredients WHERE name='Hành lá'),'2 nhánh',0),
(90,(SELECT id FROM ingredients WHERE name='Súp lơ'),'1 cây',1),
(90,(SELECT id FROM ingredients WHERE name='Trứng gà'),'2 quả',1),
(90,(SELECT id FROM ingredients WHERE name='Hành lá'),'2 nhánh',0),
(91,(SELECT id FROM ingredients WHERE name='Khoai tây'),'2 củ',1),
(91,(SELECT id FROM ingredients WHERE name='Cà rốt'),'1 củ',1),
(91,(SELECT id FROM ingredients WHERE name='Hành lá'),'2 nhánh',0),
(92,(SELECT id FROM ingredients WHERE name='Khoai tây'),'2 củ',1),
(92,(SELECT id FROM ingredients WHERE name='Thịt gà'),'300g',1),
(92,(SELECT id FROM ingredients WHERE name='Cà rốt'),'1 củ',0),
(93,(SELECT id FROM ingredients WHERE name='Khoai tây'),'2 củ',1),
(93,(SELECT id FROM ingredients WHERE name='Thịt bò'),'250g',1),
(93,(SELECT id FROM ingredients WHERE name='Tỏi'),'3 tép',0),
(94,(SELECT id FROM ingredients WHERE name='Khoai tây'),'2 củ',1),
(94,(SELECT id FROM ingredients WHERE name='Cà rốt'),'1 củ',1),
(94,(SELECT id FROM ingredients WHERE name='Hành lá'),'2 nhánh',0),
(95,(SELECT id FROM ingredients WHERE name='Khoai tây'),'2 củ',1),
(95,(SELECT id FROM ingredients WHERE name='Tỏi'),'3 tép',1),
(96,(SELECT id FROM ingredients WHERE name='Su hào'),'1 củ',1),
(96,(SELECT id FROM ingredients WHERE name='Cà rốt'),'1 củ',1),
(96,(SELECT id FROM ingredients WHERE name='Hành lá'),'2 nhánh',0),
(97,(SELECT id FROM ingredients WHERE name='Su hào'),'1 củ',1),
(97,(SELECT id FROM ingredients WHERE name='Thịt lợn'),'250g',1),
(97,(SELECT id FROM ingredients WHERE name='Tỏi'),'3 tép',0),
(98,(SELECT id FROM ingredients WHERE name='Su hào'),'1 củ',1),
(98,(SELECT id FROM ingredients WHERE name='Sườn non'),'500g',1),
(98,(SELECT id FROM ingredients WHERE name='Hành lá'),'2 nhánh',0),
(99,(SELECT id FROM ingredients WHERE name='Su hào'),'1 củ',1),
(99,(SELECT id FROM ingredients WHERE name='Cà rốt'),'1 củ',1),
(99,(SELECT id FROM ingredients WHERE name='Chanh'),'1 quả',0),
(100,(SELECT id FROM ingredients WHERE name='Su hào'),'1 củ',1),
(100,(SELECT id FROM ingredients WHERE name='Trứng gà'),'2 quả',1),
(100,(SELECT id FROM ingredients WHERE name='Hành lá'),'2 nhánh',0);
