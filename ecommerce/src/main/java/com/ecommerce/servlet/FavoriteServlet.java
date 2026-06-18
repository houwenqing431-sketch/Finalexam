package com.ecommerce.servlet;

import com.ecommerce.bean.Favorite;
import com.ecommerce.bean.User;
import com.ecommerce.dao.FavoriteDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/favorite")
public class FavoriteServlet extends HttpServlet {

    private final FavoriteDao favoriteDao = new FavoriteDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("user");
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }
        try {
            handleList(req, resp, user);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        User user = (User) req.getSession().getAttribute("user");
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        String action = req.getParameter("action");
        try {
            if ("add".equals(action)) {
                handleAdd(req, resp, user);
            } else if ("delete".equals(action)) {
                handleDelete(req, resp);
            } else if ("deleteByProduct".equals(action)) {
                handleDeleteByProduct(req, resp, user);
            } else {
                resp.sendRedirect(req.getContextPath() + "/favorite?action=list");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new ServletException(e);
        }
    }

    private void handleList(HttpServletRequest req, HttpServletResponse resp, User user)
            throws SQLException, ServletException, IOException {
        List<Favorite> favoriteList = favoriteDao.findByUser(user.getId());
        req.setAttribute("favorites", favoriteList);
        req.getRequestDispatcher("/favorites.jsp").forward(req, resp);
    }

    private void handleAdd(HttpServletRequest req, HttpServletResponse resp, User user)
            throws SQLException, IOException {
        int productId = Integer.parseInt(req.getParameter("productId"));
        // 防止重复收藏
        if (!favoriteDao.isFavorite(user.getId(), productId)) {
            favoriteDao.add(user.getId(), productId);
        }
        // 根据来源页面返回
        String referer = req.getHeader("Referer");
        if (referer != null && referer.contains("/product?")) {
            resp.sendRedirect(req.getContextPath() + "/product?action=detail&id=" + productId);
        } else {
            resp.sendRedirect(req.getContextPath() + "/favorite?action=list");
        }
    }

    private void handleDeleteByProduct(HttpServletRequest req, HttpServletResponse resp, User user)
            throws SQLException, IOException {
        int productId = Integer.parseInt(req.getParameter("productId"));
        favoriteDao.deleteByUserAndProduct(user.getId(), productId);
        String referer = req.getHeader("Referer");
        if (referer != null && referer.contains("/product?")) {
            resp.sendRedirect(req.getContextPath() + "/product?action=detail&id=" + productId);
        } else {
            resp.sendRedirect(req.getContextPath() + "/favorite?action=list");
        }
    }

    private void handleDelete(HttpServletRequest req, HttpServletResponse resp)
            throws SQLException, IOException {
        int id = Integer.parseInt(req.getParameter("id"));
        favoriteDao.delete(id);
        resp.sendRedirect(req.getContextPath() + "/favorite?action=list");
    }
}
