package com.ecommerce.dao;

import com.ecommerce.bean.Favorite;
import com.ecommerce.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class FavoriteDao {

    public List<Favorite> findByUser(int userId) throws SQLException {
        List<Favorite> list = new ArrayList<>();
        String sql = "SELECT f.*, p.name AS product_name, p.price AS product_price, p.image AS product_image FROM t_favorite f JOIN t_product p ON f.product_id = p.id WHERE f.user_id = ? AND p.status = 1 ORDER BY f.create_time DESC";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(rowToFavorite(rs));
            }
        } finally {
            DBUtil.close(conn, ps, rs);
        }
        return list;
    }

    public void add(int userId, int productId) throws SQLException {
        String sql = "INSERT INTO t_favorite(user_id, product_id, create_time) VALUES(?,?,NOW())";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            ps.setInt(2, productId);
            ps.executeUpdate();
        } finally {
            DBUtil.close(conn, ps);
        }
    }

    public void delete(int id) throws SQLException {
        String sql = "DELETE FROM t_favorite WHERE id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            ps.executeUpdate();
        } finally {
            DBUtil.close(conn, ps);
        }
    }

    public void deleteByUserAndProduct(int userId, int productId) throws SQLException {
        String sql = "DELETE FROM t_favorite WHERE user_id = ? AND product_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            ps.setInt(2, productId);
            ps.executeUpdate();
        } finally {
            DBUtil.close(conn, ps);
        }
    }

    public boolean isFavorite(int userId, int productId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM t_favorite WHERE user_id = ? AND product_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            ps.setInt(2, productId);
            rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } finally {
            DBUtil.close(conn, ps, rs);
        }
        return false;
    }

    public int countByUser(int userId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM t_favorite WHERE user_id = ?";
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

    private Favorite rowToFavorite(ResultSet rs) throws SQLException {
        Favorite favorite = new Favorite();
        favorite.setId(rs.getInt("id"));
        favorite.setUserId(rs.getInt("user_id"));
        favorite.setProductId(rs.getInt("product_id"));
        favorite.setCreateTime(rs.getTimestamp("create_time"));
        try {
            favorite.setProductName(rs.getString("product_name"));
        } catch (SQLException ignored) {
        }
        try {
            favorite.setProductPrice(rs.getDouble("product_price"));
        } catch (SQLException ignored) {
        }
        try {
            favorite.setProductImage(rs.getString("product_image"));
        } catch (SQLException ignored) {
        }
        return favorite;
    }
}
