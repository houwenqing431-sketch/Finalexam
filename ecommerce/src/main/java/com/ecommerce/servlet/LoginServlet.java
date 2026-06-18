package com.ecommerce.servlet;

import com.ecommerce.bean.User;
import com.ecommerce.dao.UserDao;
import com.ecommerce.util.PasswordUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private final UserDao userDao = new UserDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        String username = req.getParameter("username");
        String password = req.getParameter("password");

        User user = userDao.findByUsername(username);
        if (user == null) {
            req.setAttribute("msg", "用户名不存在");
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
            return;
        }
        if (!PasswordUtil.verify(password, user.getPassword())) {
            req.setAttribute("msg", "密码错误");
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
            return;
        }
        if (user.getStatus() != 1) {
            req.setAttribute("msg", "账号已被禁用");
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
            return;
        }

        HttpSession session = req.getSession();
        session.setAttribute("user", user);

        if (user.getRole() == 1) {
            resp.sendRedirect(req.getContextPath() + "/admin/index.jsp");
        } else {
            resp.sendRedirect(req.getContextPath() + "/index.jsp");
        }
    }
}
