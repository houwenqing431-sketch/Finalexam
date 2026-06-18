package com.ecommerce.servlet;

import com.ecommerce.bean.CartItem;
import com.ecommerce.bean.Order;
import com.ecommerce.bean.OrderItem;
import com.ecommerce.bean.User;
import com.ecommerce.dao.CartDao;
import com.ecommerce.dao.OrderDao;
import com.ecommerce.dao.ProductDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/order")
public class OrderServlet extends HttpServlet {

    private final OrderDao orderDao = new OrderDao();
    private final CartDao cartDao = new CartDao();
    private final ProductDao productDao = new ProductDao();

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

        try {
            if ("detail".equals(action)) {
                handleDetail(req, resp, user);
            } else if ("pay".equals(action)) {
                handlePay(req, resp, user);
            } else {
                handleList(req, resp, user);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new ServletException(e);
        }
    }

    private void handleList(HttpServletRequest req, HttpServletResponse resp, User user)
            throws SQLException, ServletException, IOException {
        int page = 1;
        String pageStr = req.getParameter("page");
        if (pageStr != null && !pageStr.trim().isEmpty()) {
            page = Integer.parseInt(pageStr);
        }

        int pageSize = 8;
        List<Order> orderList = orderDao.findByUser(user.getId(), page, pageSize);
        int totalCount = orderDao.countByUser(user.getId());
        int totalPages = (int) Math.ceil(totalCount * 1.0 / pageSize);
        if (totalPages < 1) {
            totalPages = 1;
        }

        req.setAttribute("orders", orderList);
        req.setAttribute("page", page);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("totalCount", totalCount);

        req.getRequestDispatcher("/order_list.jsp").forward(req, resp);
    }

    private void handleDetail(HttpServletRequest req, HttpServletResponse resp, User user)
            throws SQLException, ServletException, IOException {
        int id = Integer.parseInt(req.getParameter("id"));
        Order order = orderDao.findById(id);
        List<OrderItem> items = orderDao.findItemsByOrder(id);

        order.setItems(items);
        req.setAttribute("order", order);
        req.getRequestDispatcher("/order_detail.jsp").forward(req, resp);
    }

    private void handlePay(HttpServletRequest req, HttpServletResponse resp, User user)
            throws SQLException, IOException {
        int id = Integer.parseInt(req.getParameter("id"));
        Order order = orderDao.findById(id);

        if (order == null || order.getUserId() != user.getId()) {
            resp.sendRedirect(req.getContextPath() + "/order?action=list");
            return;
        }
        if (order.getStatus() != 0) {
            resp.sendRedirect(req.getContextPath() + "/order?action=detail&id=" + id);
            return;
        }

        orderDao.updateStatusWithPayTime(id, 1);
        resp.sendRedirect(req.getContextPath() + "/order?action=detail&id=" + id);
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
        if ("create".equals(action)) {
            try {
                handleCreate(req, resp, user);
            } catch (SQLException e) {
                e.printStackTrace();
                throw new ServletException(e);
            }
        }
    }

    private void handleCreate(HttpServletRequest req, HttpServletResponse resp, User user)
            throws SQLException, IOException {
        String receiverName = req.getParameter("receiverName");
        String receiverPhone = req.getParameter("receiverPhone");
        String receiverAddress = req.getParameter("receiverAddress");

        List<CartItem> cartList = cartDao.findByUser(user.getId());

        double total = 0;
        List<OrderItem> orderItems = new ArrayList<>();
        for (CartItem cartItem : cartList) {
            OrderItem orderItem = new OrderItem();
            orderItem.setProductId(cartItem.getProductId());
            orderItem.setProductName(cartItem.getProductName());
            orderItem.setProductPrice(cartItem.getProductPrice());
            orderItem.setQuantity(cartItem.getQuantity());
            orderItem.setSubtotal(cartItem.getProductPrice() * cartItem.getQuantity());
            orderItems.add(orderItem);
            total += orderItem.getSubtotal();
        }

        Order order = new Order();
        order.setUserId(user.getId());
        order.setTotalAmount(total);
        order.setStatus(0);
        order.setReceiverName(receiverName);
        order.setReceiverPhone(receiverPhone);
        order.setReceiverAddress(receiverAddress);
        order.setItems(orderItems);

        for (CartItem cartItem : cartList) {
            int newStock = cartItem.getProductStock() - cartItem.getQuantity();
            productDao.updateStock(cartItem.getProductId(), newStock);
        }

        orderDao.createOrder(order);
        cartDao.deleteByUser(user.getId());

        resp.sendRedirect(req.getContextPath() + "/order?action=list");
    }
}
