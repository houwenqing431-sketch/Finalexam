package com.ecommerce.servlet;

import com.ecommerce.bean.CartItem;
import com.ecommerce.bean.User;
import com.ecommerce.dao.CartDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/cart")
public class CartServlet extends HttpServlet {

    private final CartDao cartDao = new CartDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("user");
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        String action = req.getParameter("action");
        if (action == null) {
            action = "list";
        }

        if ("list".equals(action)) {
            List<CartItem> cartItems = cartDao.findByUser(user.getId());
            double total = cartDao.getTotal(user.getId());

            req.setAttribute("cartItems", cartItems);
            req.setAttribute("total", total);
            req.getRequestDispatcher("/cart.jsp").forward(req, resp);
        } else if ("delete".equals(action)) {
            int id = Integer.parseInt(req.getParameter("id"));
            cartDao.delete(id);
            resp.sendRedirect(req.getContextPath() + "/cart");
        } else {
            resp.sendRedirect(req.getContextPath() + "/cart");
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

        if ("add".equals(action)) {
            int productId = Integer.parseInt(req.getParameter("productId"));
            int quantity = Integer.parseInt(req.getParameter("quantity"));

            CartItem existItem = cartDao.findByUserAndProduct(user.getId(), productId);
            if (existItem != null) {
                cartDao.updateQuantity(existItem.getId(), existItem.getQuantity() + quantity);
            } else {
                CartItem item = new CartItem();
                item.setUserId(user.getId());
                item.setProductId(productId);
                item.setQuantity(quantity);
                cartDao.add(item);
            }

            resp.setContentType("text/plain;charset=UTF-8");
            resp.getWriter().write("success");
        } else if ("update".equals(action)) {
            int id = Integer.parseInt(req.getParameter("id"));
            int quantity = Integer.parseInt(req.getParameter("quantity"));
            cartDao.updateQuantity(id, quantity);
            resp.sendRedirect(req.getContextPath() + "/cart");
        } else if ("delete".equals(action)) {
            int id = Integer.parseInt(req.getParameter("id"));
            cartDao.delete(id);
            resp.sendRedirect(req.getContextPath() + "/cart");
        }
    }
}
