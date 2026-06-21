package com.ecommerce.servlet;

import com.ecommerce.bean.Category;
import com.ecommerce.bean.Product;
import com.ecommerce.bean.User;
import com.ecommerce.dao.CategoryDao;
import com.ecommerce.dao.FavoriteDao;
import com.ecommerce.dao.ProductDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/product")
public class ProductServlet extends HttpServlet {

    private final ProductDao productDao = new ProductDao();
    private final CategoryDao categoryDao = new CategoryDao();
    private final FavoriteDao favoriteDao = new FavoriteDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");

        if ("detail".equals(action)) {
            handleDetail(req, resp);
        } else {
            handleList(req, resp);
        }
    }

    private void handleList(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        int categoryId = 0;
        String categoryIdStr = req.getParameter("categoryId");
        if (categoryIdStr != null && !categoryIdStr.trim().isEmpty()) {
            categoryId = Integer.parseInt(categoryIdStr);
        }

        String keyword = req.getParameter("keyword");
        if (keyword == null) {
            keyword = "";
        }

        int page = 1;
        String pageStr = req.getParameter("page");
        if (pageStr != null && !pageStr.trim().isEmpty()) {
            page = Integer.parseInt(pageStr);
        }

        int pageSize = 8;
        List<Product> productList = productDao.findByPage(page, pageSize, categoryId, keyword);
        int totalCount = productDao.count(categoryId, keyword);
        int totalPages = (int) Math.ceil(totalCount * 1.0 / pageSize);
        if (totalPages < 1) {
            totalPages = 1;
        }

        List<Category> categoryList = categoryDao.findAll();

        req.setAttribute("products", productList);
        req.setAttribute("categories", categoryList);
        req.setAttribute("page", page);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("totalCount", totalCount);
        req.setAttribute("categoryId", categoryId);
        req.setAttribute("keyword", keyword);

        req.getRequestDispatcher("/product_list.jsp").forward(req, resp);
    }

    private void handleDetail(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        int id = Integer.parseInt(req.getParameter("id"));
        Product product = productDao.findById(id);

        User user = (User) req.getSession().getAttribute("user");
        boolean isFav = false;
        if (user != null) {
            try {
                isFav = favoriteDao.isFavorite(user.getId(), id);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        req.setAttribute("product", product);
        req.setAttribute("isFavorite", isFav);
        req.getRequestDispatcher("/product_detail.jsp").forward(req, resp);
    }
}
