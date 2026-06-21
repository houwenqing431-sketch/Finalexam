# 🛒 电子商务平台

基于 **JSP + Servlet + JavaBean + JDBC + MySQL** 的电子商务平台，采用 MVC 分层架构，包含前后台两大子系统。

## 🛠 技术栈

| 技术 | 版本 |
|------|------|
| Java | OpenJDK 17 |
| Jakarta Servlet API | 6.1 |
| Jakarta JSP API | 4.0 |
| JSTL | 3.0 |
| MySQL Connector | 8.0.33 |
| Bootstrap | 5.3.0 |
| Chart.js | 4.4.0 |
| Tomcat | 11 |
| Maven | 3.x |

## ✨ 功能模块

### 🏪 前台商城
- 商品浏览、分类筛选、关键词搜索
- 商品详情页（面包屑导航 + 购物车 + 收藏）
- 购物车管理（增删改 + 全选结算）
- 订单系统（下单 → 支付 → 订单列表）
- 商品收藏（❤ 切换状态）
- 个人中心（修改资料 + 修改密码）
- 用户注册 / 登录 / 登出

### 🔧 后台管理
- **商品管理** — 增删改查 + 图片上传（UUID 命名持久化存储）
- **分类管理** — 行内编辑 + 新增 + 删除（含重名校验）
- **订单管理** — 列表筛选 + 详情查看 + 状态流转（合法路径校验）
- **用户管理** — 列表 + 启用/禁用（管理员自保护）
- **📊 销量统计** — 按月柱状图 + 按分类环形图（Chart.js 可视化）

## 📁 项目结构

```
ecommerce/
├── pom.xml                          # Maven 配置
├── sql/
│   └── init.sql                     # 数据库初始化脚本
└── src/main/
    ├── java/com/ecommerce/
    │   ├── bean/                    # POJO 实体类
    │   │   ├── User.java
    │   │   ├── Product.java
    │   │   ├── Category.java
    │   │   ├── Order.java
    │   │   ├── OrderItem.java
    │   │   ├── Cart.java
    │   │   └── Favorite.java
    │   ├── dao/                     # 数据访问层 (JDBC)
    │   │   ├── UserDao.java
    │   │   ├── ProductDao.java
    │   │   ├── CategoryDao.java
    │   │   ├── OrderDao.java
    │   │   ├── CartDao.java
    │   │   └── FavoriteDao.java
    │   ├── servlet/                 # 控制层 (Servlet)
    │   │   ├── LoginServlet.java
    │   │   ├── RegisterServlet.java
    │   │   ├── LogoutServlet.java
    │   │   ├── UserServlet.java
    │   │   ├── ProductServlet.java
    │   │   ├── CartServlet.java
    │   │   ├── FavoriteServlet.java
    │   │   ├── OrderServlet.java
    │   │   ├── ImageServlet.java
    │   │   └── admin/
    │   │       ├── AdminProductServlet.java
    │   │       ├── AdminCategoryServlet.java
    │   │       ├── AdminOrderServlet.java
    │   │       ├── AdminUserServlet.java
    │   │       └── AdminStatisticsServlet.java
    │   └── util/                    # 工具类
    │       ├── DBUtil.java          # 数据库连接管理
    │       └── EncodingFilter.java  # 编码过滤器
    └── webapp/                      # 前端资源
        ├── index.jsp                # 首页（轮播图 + 热门推荐 + 分类展示）
        ├── login.jsp                # 登录页
        ├── register.jsp             # 注册页
        ├── header.jsp               # 前台公共导航
        ├── footer.jsp               # 前台公共页脚
        ├── product_list.jsp         # 商品列表
        ├── product_detail.jsp       # 商品详情
        ├── cart.jsp                 # 购物车
        ├── favorites.jsp            # 我的收藏
        ├── order_list.jsp           # 我的订单
        ├── order_detail.jsp         # 订单详情
        ├── user_center.jsp          # 个人中心
        ├── images/                  # 商品图片
        ├── WEB-INF/web.xml          # 部署配置
        └── admin/                   # 后台页面
            ├── header.jsp           # 后台公共侧边栏
            ├── index.jsp            # 管理首页
            ├── product_list.jsp     # 商品管理
            ├── product_edit.jsp     # 商品新增/编辑
            ├── category_list.jsp    # 分类管理
            ├── order_list.jsp       # 订单管理
            ├── order_detail.jsp     # 订单详情
            ├── user_list.jsp        # 用户管理
            └── statistics.jsp       # 销量统计（图表）
```

## 🚀 快速开始

### 1. 环境要求

- JDK 17+
- MySQL 8.0+
- Tomcat 11
- Maven 3.x

### 2. 初始化数据库

```bash
mysql -u root -p < ecommerce/sql/init.sql
```

### 3. 修改数据库配置

编辑 `src/main/resources/db.properties`：

```properties
jdbc.driver=com.mysql.cj.jdbc.Driver
jdbc.url=jdbc:mysql://localhost:3306/db_ecommerce?useSSL=false&serverTimezone=Asia/Shanghai&characterEncoding=utf-8
jdbc.username=root
jdbc.password=你的密码
```

### 4. 构建部署

```bash
mvn clean package -DskipTests
# 将 target/ecommerce.war 部署到 Tomcat 的 webapps 目录
```

### 5. 访问

```
前台首页：  http://localhost:8080/ecommerce/
后台管理：  http://localhost:8080/ecommerce/admin/
```

## 🔑 默认账号

| 角色 | 用户名 | 密码 |
|------|--------|------|
| 管理员 | `admin` | `admin123` |
| 普通用户 | `zhangsan` | `123456` |
| 普通用户 | `lisi` | `123456` |

## 📊 数据库设计

| 表名 | 说明 |
|------|------|
| t_user | 用户表 |
| t_category | 商品分类表 |
| t_product | 商品表 |
| t_cart | 购物车表 |
| t_order | 订单表 |
| t_order_item | 订单明细表 |
| t_favorite | 收藏表 |
