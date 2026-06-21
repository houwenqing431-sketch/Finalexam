-- ==========================================
-- 电子商务平台数据库初始化脚本
-- 数据库名称：db_ecommerce
-- ==========================================

CREATE DATABASE IF NOT EXISTS db_ecommerce 
    DEFAULT CHARACTER SET utf8mb4 
    DEFAULT COLLATE utf8mb4_unicode_ci;

USE db_ecommerce;

-- ==========================================
-- 1. 用户表 (t_user)
-- ==========================================
CREATE TABLE IF NOT EXISTS t_user (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE COMMENT '用户名',
    password VARCHAR(100) NOT NULL COMMENT '密码',
    real_name VARCHAR(50) COMMENT '真实姓名',
    email VARCHAR(100) COMMENT '电子邮箱',
    phone VARCHAR(20) COMMENT '联系电话',
    address VARCHAR(255) COMMENT '地址',
    role TINYINT DEFAULT 0 COMMENT '角色：0-普通用户，1-管理员',
    status TINYINT DEFAULT 1 COMMENT '状态：0-禁用，1-正常',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '注册时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户表';

-- ==========================================
-- 2. 商品分类表 (t_category)
-- ==========================================
CREATE TABLE IF NOT EXISTS t_category (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE COMMENT '分类名称',
    description VARCHAR(255) COMMENT '分类描述',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='商品分类表';

-- ==========================================
-- 3. 商品表 (t_product)
-- ==========================================
CREATE TABLE IF NOT EXISTS t_product (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL COMMENT '商品名称',
    description TEXT COMMENT '商品描述',
    price DECIMAL(10,2) NOT NULL COMMENT '商品价格',
    stock INT DEFAULT 0 COMMENT '库存数量',
    image VARCHAR(255) COMMENT '商品图片路径',
    category_id INT NOT NULL COMMENT '所属分类ID',
    status TINYINT DEFAULT 1 COMMENT '状态：0-下架，1-上架',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    FOREIGN KEY (category_id) REFERENCES t_category(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='商品表';

-- ==========================================
-- 4. 购物车表 (t_cart)
-- ==========================================
CREATE TABLE IF NOT EXISTS t_cart (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL COMMENT '用户ID',
    product_id INT NOT NULL COMMENT '商品ID',
    quantity INT DEFAULT 1 COMMENT '数量',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '添加时间',
    FOREIGN KEY (user_id) REFERENCES t_user(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES t_product(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='购物车表';

-- ==========================================
-- 5. 订单表 (t_order)
-- ==========================================
CREATE TABLE IF NOT EXISTS t_order (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_no VARCHAR(32) NOT NULL UNIQUE COMMENT '订单编号',
    user_id INT NOT NULL COMMENT '用户ID',
    total_amount DECIMAL(10,2) NOT NULL COMMENT '订单总金额',
    status TINYINT DEFAULT 0 COMMENT '订单状态：0-待付款，1-已付款，2-已发货，3-已完成，4-已取消',
    receiver_name VARCHAR(50) COMMENT '收货人姓名',
    receiver_phone VARCHAR(20) COMMENT '收货人电话',
    receiver_address VARCHAR(255) COMMENT '收货地址',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '下单时间',
    pay_time DATETIME COMMENT '付款时间',
    FOREIGN KEY (user_id) REFERENCES t_user(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='订单表';

-- ==========================================
-- 6. 订单明细表 (t_order_item)
-- ==========================================
CREATE TABLE IF NOT EXISTS t_order_item (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL COMMENT '订单ID',
    product_id INT NOT NULL COMMENT '商品ID',
    product_name VARCHAR(100) COMMENT '商品名称',
    product_price DECIMAL(10,2) COMMENT '商品单价',
    quantity INT DEFAULT 1 COMMENT '购买数量',
    subtotal DECIMAL(10,2) COMMENT '小计金额',
    FOREIGN KEY (order_id) REFERENCES t_order(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES t_product(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='订单明细表';

-- ==========================================
-- 7. 收藏表 (t_favorite)
-- ==========================================
CREATE TABLE IF NOT EXISTS t_favorite (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL COMMENT '用户ID',
    product_id INT NOT NULL COMMENT '商品ID',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '收藏时间',
    FOREIGN KEY (user_id) REFERENCES t_user(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES t_product(id) ON DELETE CASCADE,
    UNIQUE KEY uk_user_product (user_id, product_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='收藏表';

-- ==========================================
-- 插入初始数据
-- ==========================================

-- 管理员账号（密码：admin123）
INSERT INTO t_user (username, password, real_name, role, status)
VALUES ('admin', 'admin123', '系统管理员', 1, 1);

-- 测试用户
INSERT INTO t_user (username, password, real_name, email, phone, address, role, status)
VALUES ('zhangsan', '123456', '张三', 'zhangsan@example.com', '13800001111', '北京市朝阳区', 0, 1),
       ('lisi', '123456', '李四', 'lisi@example.com', '13800002222', '上海市浦东新区', 0, 1);

-- 商品分类
INSERT INTO t_category (name, description) VALUES
('手机数码', '手机、平板、数码配件等电子产品'),
('电脑办公', '笔记本电脑、台式机、办公设备'),
('家用电器', '电视机、冰箱、洗衣机等家电产品'),
('服装鞋帽', '男装、女装、鞋靴、箱包'),
('食品生鲜', '水果、蔬菜、肉禽蛋奶、休闲零食'),
('图书文娱', '图书、电子书、音乐、影视');

-- 示例商品
INSERT INTO t_product (name, description, price, stock, image, category_id, status) VALUES
('华为Mate 60 Pro', '麒麟9000S芯片 | 卫星通话 | 超可靠玄武架构', 6999.00, 100, 'images/product_1.jpg', 1, 1),
('iPhone 15 Pro Max', 'A17 Pro芯片 | 钛金属设计 | 4800万像素', 9999.00, 80, 'images/product_2.jpg', 1, 1),
('小米14 Ultra', '骁龙8Gen3 | 徕卡光学 | 小米澎湃OS', 5999.00, 150, 'images/product_3.jpg', 1, 1),
('联想ThinkPad X1', 'i7处理器 | 16GB内存 | 512GB固态', 8999.00, 50, 'images/product_4.jpg', 2, 1),
('MacBook Pro 14', 'M3芯片 | 18GB内存 | Liquid Retina XDR', 12999.00, 30, 'images/product_5.jpg', 2, 1),
('海尔冰箱BCD-500', '500升大容量 | 风冷无霜 | 一级能效', 3999.00, 60, 'images/product_6.jpg', 3, 1),
('美的空调KFR-35GW', '1.5匹 | 新一级能效 | 智能WiFi', 2999.00, 80, 'images/product_7.jpg', 3, 1),
('Nike Air Max 270', '气垫运动鞋 | 舒适缓震 | 多色可选', 899.00, 200, 'images/product_8.jpg', 4, 1),
('三只松鼠坚果礼盒', '每日坚果 | 混合装 | 750g', 99.00, 500, 'images/product_9.jpg', 5, 1),
('Java编程思想（第4版）', 'Java经典著作 | 入门到精通', 79.00, 300, 'images/product_10.jpg', 6, 1);
