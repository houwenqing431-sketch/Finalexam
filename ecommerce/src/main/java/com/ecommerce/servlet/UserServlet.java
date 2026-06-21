package com.ecommerce.servlet;

import com.ecommerce.bean.User;
import com.ecommerce.dao.UserDao;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/user")
public class UserServlet extends HttpServlet {

    private final UserDao userDao = new UserDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("user");
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        String action = req.getParameter("action");
        if ("info".equals(action)) {
            req.getRequestDispatcher("/user_center.jsp").forward(req, resp);
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

        if ("updateInfo".equals(action)) {
            handleUpdateInfo(req, resp, user);
        } else if ("changePwd".equals(action)) {
            handleChangePwd(req, resp, user);
        }
    }

    private void handleUpdateInfo(HttpServletRequest req, HttpServletResponse resp, User user)
            throws ServletException, IOException {
        String realName = req.getParameter("realName");
        String email = req.getParameter("email");
        String phone = req.getParameter("phone");
        String address = req.getParameter("address");

        user.setRealName(realName);
        user.setEmail(email);
        user.setPhone(phone);
        user.setAddress(address);

        userDao.update(user);

        req.getSession().setAttribute("user", user);
        req.setAttribute("msgType", "success");
        req.setAttribute("msg", "修改成功");
        req.getRequestDispatcher("/user_center.jsp").forward(req, resp);
    }

    private void handleChangePwd(HttpServletRequest req, HttpServletResponse resp, User user)
            throws ServletException, IOException {
        String oldPassword = req.getParameter("oldPassword");
        String newPassword = req.getParameter("newPassword");
        String confirmPassword = req.getParameter("confirmPassword");

        if (!oldPassword.equals(user.getPassword())) {
            req.setAttribute("msgType", "danger");
            req.setAttribute("msg", "旧密码错误");
            req.getRequestDispatcher("/user_center.jsp").forward(req, resp);
            return;
        }
        if (!newPassword.equals(confirmPassword)) {
            req.setAttribute("msgType", "danger");
            req.setAttribute("msg", "两次新密码不一致");
            req.getRequestDispatcher("/user_center.jsp").forward(req, resp);
            return;
        }

        userDao.changePassword(user.getId(), newPassword);
        user.setPassword(newPassword);
        req.getSession().setAttribute("user", user);

        req.setAttribute("msgType", "success");
        req.setAttribute("msg", "修改成功");
        req.getRequestDispatcher("/user_center.jsp").forward(req, resp);
    }
}
