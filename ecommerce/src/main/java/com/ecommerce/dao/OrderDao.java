package com.ecommerce.dao;

import com.ecommerce.bean.Order;
import com.ecommerce.bean.OrderItem;
import com.ecommerce.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

public class OrderDao {

    public void createOrder(Order order) throws SQLException {
        Connection conn = null;
        try {
            conn = DBUtil.getConnection();
            conn.setAutoCommit(false);

            String orderNo = UUID.randomUUID().toString().replace("-", "").substring(0, 32);
            String orderSql = "INSERT INTO t_order(order_no, user_id, total_amount, status, receiver_name, receiver_phone, receiver_address, create_time) VALUES(?,?,?,?,?,?,?,NOW())";
            PreparedStatement ps = conn.prepareStatement(orderSql, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, orderNo);
            ps.setInt(2, order.getUserId());
            ps.setDouble(3, order.getTotalAmount());
            ps.setInt(4, order.getStatus());
            ps.setString(5, order.getReceiverName());
            ps.setString(6, order.getReceiverPhone());
            ps.setString(7, order.getReceiverAddress());
            ps.executeUpdate();

            ResultSet rs = ps.getGeneratedKeys();
            int orderId = 0;
            if (rs.next()) {
                orderId = rs.getInt(1);
            }
            DBUtil.close(null, ps, rs);

            if (order.getItems() != null) {
                String itemSql = "INSERT INTO t_order_item(order_id, product_id, product_name, product_price, quantity, subtotal) VALUES(?,?,?,?,?,?)";
                ps = conn.prepareStatement(itemSql);
                for (OrderItem item : order.getItems()) {
                    ps.setInt(1, orderId);
                    ps.setInt(2, item.getProductId());
                    ps.setString(3, item.getProductName());
                    ps.setDouble(4, item.getProductPrice());
                    ps.setInt(5, item.getQuantity());
                    ps.setDouble(6, item.getSubtotal());
                    ps.addBatch();
                }
                ps.executeBatch();
                DBUtil.close(null, ps);
            }

            conn.commit();
            order.setId(orderId);
            order.setOrderNo(orderNo);
        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            throw e;
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                } catch (SQLException e) {
                    e.printStackTrace();
                }
                DBUtil.close(conn, null);
            }
        }
    }

    public List<Order> findByUser(int userId, int page, int pageSize) throws SQLException {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT o.*, u.username FROM t_order o LEFT JOIN t_user u ON o.user_id = u.id WHERE o.user_id = ? ORDER BY o.create_time DESC LIMIT ?,?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            ps.setInt(2, (page - 1) * pageSize);
            ps.setInt(3, pageSize);
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(rowToOrder(rs));
            }
        } finally {
            DBUtil.close(conn, ps, rs);
        }
        return list;
    }

    public int countByUser(int userId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM t_order WHERE user_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } finally {
            DBUtil.close(conn, ps, rs);
        }
        return 0;
    }

    public List<Order> findAll(int page, int pageSize, String status, String keyword) throws SQLException {
        List<Order> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT o.*, u.username FROM t_order o LEFT JOIN t_user u ON o.user_id = u.id WHERE 1=1");
        List<Object> params = new ArrayList<>();

        if (status != null && !status.isEmpty()) {
            sql.append(" AND o.status = ?");
            params.add(Integer.parseInt(status));
        }
        if (keyword != null && !keyword.isEmpty()) {
            sql.append(" AND (o.order_no LIKE ? OR u.username LIKE ?)");
            params.add("%" + keyword + "%");
            params.add("%" + keyword + "%");
        }

        sql.append(" ORDER BY o.create_time DESC LIMIT ?,?");
        params.add((page - 1) * pageSize);
        params.add(pageSize);

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql.toString());
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(rowToOrder(rs));
            }
        } finally {
            DBUtil.close(conn, ps, rs);
        }
        return list;
    }

    public int countAll(String status, String keyword) throws SQLException {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM t_order o LEFT JOIN t_user u ON o.user_id = u.id WHERE 1=1");
        List<Object> params = new ArrayList<>();

        if (status != null && !status.isEmpty()) {
            sql.append(" AND o.status = ?");
            params.add(Integer.parseInt(status));
        }
        if (keyword != null && !keyword.isEmpty()) {
            sql.append(" AND (o.order_no LIKE ? OR u.username LIKE ?)");
            params.add("%" + keyword + "%");
            params.add("%" + keyword + "%");
        }

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql.toString());
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } finally {
            DBUtil.close(conn, ps, rs);
        }
        return 0;
    }

    public Order findById(int id) throws SQLException {
        String sql = "SELECT o.*, u.username FROM t_order o LEFT JOIN t_user u ON o.user_id = u.id WHERE o.id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            rs = ps.executeQuery();
            if (rs.next()) {
                return rowToOrder(rs);
            }
        } finally {
            DBUtil.close(conn, ps, rs);
        }
        return null;
    }

    public List<OrderItem> findItemsByOrder(int orderId) throws SQLException {
        List<OrderItem> list = new ArrayList<>();
        String sql = "SELECT * FROM t_order_item WHERE order_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, orderId);
            rs = ps.executeQuery();
            while (rs.next()) {
                OrderItem item = new OrderItem();
                item.setId(rs.getInt("id"));
                item.setOrderId(rs.getInt("order_id"));
                item.setProductId(rs.getInt("product_id"));
                item.setProductName(rs.getString("product_name"));
                item.setProductPrice(rs.getDouble("product_price"));
                item.setQuantity(rs.getInt("quantity"));
                item.setSubtotal(rs.getDouble("subtotal"));
                list.add(item);
            }
        } finally {
            DBUtil.close(conn, ps, rs);
        }
        return list;
    }

    public void updateStatus(int id, int status) throws SQLException {
        String sql = "UPDATE t_order SET status = ? WHERE id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, status);
            ps.setInt(2, id);
            ps.executeUpdate();
        } finally {
            DBUtil.close(conn, ps);
        }
    }

    public void updateStatusWithPayTime(int id, int status) throws SQLException {
        String sql = "UPDATE t_order SET status = ?, pay_time = NOW() WHERE id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, status);
            ps.setInt(2, id);
            ps.executeUpdate();
        } finally {
            DBUtil.close(conn, ps);
        }
    }

    public List<Object[]> getSalesByMonth() throws SQLException {
        List<Object[]> list = new ArrayList<>();
        String sql = "SELECT DATE_FORMAT(create_time,'%Y-%m') AS month, SUM(total_amount) AS total FROM t_order WHERE status IN(1,2,3) GROUP BY month ORDER BY month";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                Object[] row = new Object[2];
                row[0] = rs.getString("month");
                row[1] = rs.getDouble("total");
                list.add(row);
            }
        } finally {
            DBUtil.close(conn, ps, rs);
        }
        return list;
    }

    public List<Object[]> getSalesByCategory() throws SQLException {
        List<Object[]> list = new ArrayList<>();
        String sql = "SELECT c.name, IFNULL(SUM(oi.subtotal),0) FROM t_category c LEFT JOIN t_product p ON c.id=p.category_id LEFT JOIN t_order_item oi ON p.id=oi.product_id LEFT JOIN t_order o ON oi.order_id=o.id AND o.status IN(1,2,3) GROUP BY c.id, c.name";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                Object[] row = new Object[2];
                row[0] = rs.getString(1);
                row[1] = rs.getDouble(2);
                list.add(row);
            }
        } finally {
            DBUtil.close(conn, ps, rs);
        }
        return list;
    }

    private Order rowToOrder(ResultSet rs) throws SQLException {
        Order order = new Order();
        order.setId(rs.getInt("id"));
        order.setOrderNo(rs.getString("order_no"));
        order.setUserId(rs.getInt("user_id"));
        order.setTotalAmount(rs.getDouble("total_amount"));
        order.setStatus(rs.getInt("status"));
        order.setReceiverName(rs.getString("receiver_name"));
        order.setReceiverPhone(rs.getString("receiver_phone"));
        order.setReceiverAddress(rs.getString("receiver_address"));
        order.setCreateTime(rs.getTimestamp("create_time"));
        order.setPayTime(rs.getTimestamp("pay_time"));
        try {
            order.setUsername(rs.getString("username"));
        } catch (SQLException ignored) {
        }
        return order;
    }
}
