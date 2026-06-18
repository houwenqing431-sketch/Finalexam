package com.ecommerce.dao;

import com.ecommerce.bean.CartItem;
import com.ecommerce.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CartDao {

    /**
     * 查询用户所有购物车项（JOIN t_product 获取商品信息）
     */
    public List<CartItem> findByUser(int userId) {
        List<CartItem> list = new ArrayList<>();
        String sql = "SELECT c.*, p.name AS product_name, p.price AS product_price, " +
                     "p.image AS product_image, p.stock AS product_stock " +
                     "FROM t_cart c LEFT JOIN t_product p ON c.product_id = p.id " +
                     "WHERE c.user_id = ? ORDER BY c.id DESC";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, userId);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                CartItem item = new CartItem();
                item.setId(rs.getInt("id"));
                item.setUserId(rs.getInt("user_id"));
                item.setProductId(rs.getInt("product_id"));
                item.setQuantity(rs.getInt("quantity"));
                item.setCreateTime(rs.getTimestamp("create_time"));
                item.setProductName(rs.getString("product_name"));
                item.setProductPrice(rs.getDouble("product_price"));
                item.setProductImage(rs.getString("product_image"));
                item.setProductStock(rs.getInt("product_stock"));
                list.add(item);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt, rs);
        }
        return list;
    }

    /**
     * 根据ID查询购物车项
     */
    public CartItem findById(int id) {
        String sql = "SELECT c.*, p.name AS product_name, p.price AS product_price, " +
                     "p.image AS product_image, p.stock AS product_stock " +
                     "FROM t_cart c LEFT JOIN t_product p ON c.product_id = p.id " +
                     "WHERE c.id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, id);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                CartItem item = new CartItem();
                item.setId(rs.getInt("id"));
                item.setUserId(rs.getInt("user_id"));
                item.setProductId(rs.getInt("product_id"));
                item.setQuantity(rs.getInt("quantity"));
                item.setCreateTime(rs.getTimestamp("create_time"));
                item.setProductName(rs.getString("product_name"));
                item.setProductPrice(rs.getDouble("product_price"));
                item.setProductImage(rs.getString("product_image"));
                item.setProductStock(rs.getInt("product_stock"));
                return item;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt, rs);
        }
        return null;
    }

    /**
     * 查询某用户某商品的购物车项
     */
    public CartItem findByUserAndProduct(int userId, int productId) {
        String sql = "SELECT c.*, p.name AS product_name, p.price AS product_price, " +
                     "p.image AS product_image, p.stock AS product_stock " +
                     "FROM t_cart c LEFT JOIN t_product p ON c.product_id = p.id " +
                     "WHERE c.user_id = ? AND c.product_id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, userId);
            pstmt.setInt(2, productId);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                CartItem item = new CartItem();
                item.setId(rs.getInt("id"));
                item.setUserId(rs.getInt("user_id"));
                item.setProductId(rs.getInt("product_id"));
                item.setQuantity(rs.getInt("quantity"));
                item.setCreateTime(rs.getTimestamp("create_time"));
                item.setProductName(rs.getString("product_name"));
                item.setProductPrice(rs.getDouble("product_price"));
                item.setProductImage(rs.getString("product_image"));
                item.setProductStock(rs.getInt("product_stock"));
                return item;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt, rs);
        }
        return null;
    }

    /**
     * 添加到购物车
     */
    public int add(CartItem item) {
        String sql = "INSERT INTO t_cart (user_id, product_id, quantity, create_time) VALUES (?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            pstmt.setInt(1, item.getUserId());
            pstmt.setInt(2, item.getProductId());
            pstmt.setInt(3, item.getQuantity());
            pstmt.setTimestamp(4, new Timestamp(System.currentTimeMillis()));
            pstmt.executeUpdate();
            rs = pstmt.getGeneratedKeys();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt, rs);
        }
        return 0;
    }

    /**
     * 更新购物车项数量
     */
    public boolean updateQuantity(int id, int quantity) {
        String sql = "UPDATE t_cart SET quantity = ? WHERE id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, quantity);
            pstmt.setInt(2, id);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt);
        }
        return false;
    }

    /**
     * 删除购物车项
     */
    public boolean delete(int id) {
        String sql = "DELETE FROM t_cart WHERE id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, id);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt);
        }
        return false;
    }

    /**
     * 清空用户购物车
     */
    public boolean deleteByUser(int userId) {
        String sql = "DELETE FROM t_cart WHERE user_id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, userId);
            pstmt.executeUpdate();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt);
        }
        return false;
    }

    /**
     * 获取购物车总金额（SUM查询）
     */
    public double getTotal(int userId) {
        String sql = "SELECT SUM(c.quantity * p.price) FROM t_cart c " +
                     "LEFT JOIN t_product p ON c.product_id = p.id " +
                     "WHERE c.user_id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, userId);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                double total = rs.getDouble(1);
                return rs.wasNull() ? 0.0 : total;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt, rs);
        }
        return 0.0;
    }
}
