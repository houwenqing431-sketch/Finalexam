package com.ecommerce.servlet;

import com.ecommerce.bean.User;
import com.ecommerce.dao.UserDao;
import com.ecommerce.util.PasswordUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.Date;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    private final UserDao userDao = new UserDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/register.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        String username = req.getParameter("username");
        String password = req.getParameter("password");
        String confirmPassword = req.getParameter("confirmPassword");
        String realName = req.getParameter("realName");
        String email = req.getParameter("email");
        String phone = req.getParameter("phone");
        String address = req.getParameter("address");

        // 输入验证
        if (username != null && username.length() > 50) {
            req.setAttribute("msgType", "danger");
            req.setAttribute("msg", "用户名不能超过50个字符");
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
            return;
        }
        if (password != null && password.length() < 6) {
            req.setAttribute("msgType", "danger");
            req.setAttribute("msg", "密码长度不能少于6位");
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
            return;
        }
        if (email != null && email.length() > 100) {
            req.setAttribute("msgType", "danger");
            req.setAttribute("msg", "邮箱地址过长");
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
            return;
        }
        if (phone != null && phone.length() > 20) {
            req.setAttribute("msgType", "danger");
            req.setAttribute("msg", "手机号码过长");
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
            return;
        }

        if (username == null || username.trim().isEmpty()) {
            req.setAttribute("msgType", "danger");
            req.setAttribute("msg", "用户名不能为空");
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
            return;
        }
        if (password == null || password.trim().isEmpty()) {
            req.setAttribute("msgType", "danger");
            req.setAttribute("msg", "密码不能为空");
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
            return;
        }
        if (!password.equals(confirmPassword)) {
            req.setAttribute("msgType", "danger");
            req.setAttribute("msg", "两次密码不一致");
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
            return;
        }

        User existUser = userDao.findByUsername(username);
        if (existUser != null) {
            req.setAttribute("msgType", "danger");
            req.setAttribute("msg", "用户名已存在");
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
            return;
        }

        User user = new User();
        user.setUsername(username);
        user.setPassword(PasswordUtil.hash(password));
        user.setRealName(realName);
        user.setEmail(email);
        user.setPhone(phone);
        user.setAddress(address);
        user.setRole(0);
        user.setStatus(1);
        user.setCreateTime(new Date());

        userDao.add(user);

        req.setAttribute("msgType", "success");
        req.setAttribute("msg", "注册成功，请登录");
        req.getRequestDispatcher("/register.jsp").forward(req, resp);
    }
}
