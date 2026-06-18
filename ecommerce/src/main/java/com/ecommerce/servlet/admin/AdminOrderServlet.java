package com.ecommerce.servlet.admin;

import com.ecommerce.bean.*;
import com.ecommerce.dao.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/admin/order")
public class AdminOrderServlet extends HttpServlet {

    private static final int PAGE_SIZE = 10;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null || user.getRole() != 1) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        try {
            switch (action) {
                case "list":
                    list(request, response);
                    break;
                case "detail":
                    detail(request, response);
                    break;
                case "status":
                    updateStatus(request, response);
                    break;
                default:
                    list(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    private void list(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        int page = 1;
        try {
            page = Integer.parseInt(request.getParameter("page"));
        } catch (NumberFormatException e) {
        }

        String status = request.getParameter("status");
        if (status == null) {
            status = "";
        }

        String keyword = request.getParameter("keyword");
        if (keyword == null) {
            keyword = "";
        }

        OrderDao orderDao = new OrderDao();
        List<Order> orders = orderDao.findAll(page, PAGE_SIZE, status, keyword);
        int totalCount = orderDao.countAll(status, keyword);
        int totalPages = (int) Math.ceil((double) totalCount / PAGE_SIZE);

        request.setAttribute("orders", orders);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalCount", totalCount);
        request.setAttribute("status", status);
        request.setAttribute("keyword", keyword);

        request.getRequestDispatcher("/admin/order_list.jsp").forward(request, response);
    }

    private void detail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        int id = Integer.parseInt(request.getParameter("id"));
        OrderDao orderDao = new OrderDao();

        Order order = orderDao.findById(id);
        List<OrderItem> items = orderDao.findItemsByOrder(id);

        request.setAttribute("order", order);
        request.setAttribute("items", items);

        request.getRequestDispatcher("/admin/order_detail.jsp").forward(request, response);
    }

    private void updateStatus(HttpServletRequest request, HttpServletResponse response)
            throws IOException, SQLException {
        int id = Integer.parseInt(request.getParameter("id"));
        int status = Integer.parseInt(request.getParameter("status"));
        OrderDao orderDao = new OrderDao();
        orderDao.updateStatus(id, status);
        response.sendRedirect(request.getContextPath() + "/admin/order?action=list");
    }
}
