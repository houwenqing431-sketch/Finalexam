package com.ecommerce.servlet.admin;

import com.ecommerce.bean.*;
import com.ecommerce.dao.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/statistics")
public class AdminStatisticsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null || user.getRole() != 1) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        try {
            OrderDao orderDao = new OrderDao();
            List<Object[]> salesByMonth = orderDao.getSalesByMonth();
            List<Object[]> salesByCategory = orderDao.getSalesByCategory();

            request.setAttribute("salesByMonth", salesByMonth);
            request.setAttribute("salesByCategory", salesByCategory);

            request.getRequestDispatcher("/admin/statistics.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
