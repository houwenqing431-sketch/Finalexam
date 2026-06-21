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
        int newStatus = Integer.parseInt(request.getParameter("status"));

        OrderDao orderDao = new OrderDao();
        Order order = orderDao.findById(id);

        if (order == null) {
            request.getSession().setAttribute("msg", "订单不存在");
            response.sendRedirect(request.getContextPath() + "/admin/order?action=list");
            return;
        }

        int oldStatus = order.getStatus();

        // 合法状态流转规则
        boolean valid = false;
        switch (oldStatus) {
            case 0: // 待付款 → 已付款 / 已取消
                valid = (newStatus == 1 || newStatus == 4);
                break;
            case 1: // 已付款 → 已发货 / 已取消
                valid = (newStatus == 2 || newStatus == 4);
                break;
            case 2: // 已发货 → 已完成
                valid = (newStatus == 3);
                break;
            case 3: // 已完成 → 不可变更
            case 4: // 已取消 → 不可变更
                valid = false;
                break;
        }

        if (!valid) {
            request.getSession().setAttribute("msg", "非法的状态变更操作");
            response.sendRedirect(request.getContextPath() + "/admin/order?action=list");
            return;
        }

        orderDao.updateStatus(id, newStatus);
        response.sendRedirect(request.getContextPath() + "/admin/order?action=list");
    }
}
