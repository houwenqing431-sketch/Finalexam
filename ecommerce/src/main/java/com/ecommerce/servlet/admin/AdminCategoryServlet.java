package com.ecommerce.servlet.admin;

import com.ecommerce.bean.*;
import com.ecommerce.dao.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/category")
public class AdminCategoryServlet extends HttpServlet {

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
                case "delete":
                    delete(request, response);
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
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null || user.getRole() != 1) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String action = request.getParameter("action");
        if ("save".equals(action)) {
            try {
                save(request, response);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    private void list(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        CategoryDao categoryDao = new CategoryDao();
        List<Category> categories = categoryDao.findAll();
        request.setAttribute("categories", categories);
        request.getRequestDispatcher("/admin/category_list.jsp").forward(request, response);
    }

    private void delete(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        CategoryDao categoryDao = new CategoryDao();
        categoryDao.delete(id);
        response.sendRedirect(request.getContextPath() + "/admin/category?action=list");
    }

    private void save(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int id = 0;
        try {
            id = Integer.parseInt(request.getParameter("id"));
        } catch (NumberFormatException e) {
        }

        String name = request.getParameter("name");
        String description = request.getParameter("description");

        CategoryDao categoryDao = new CategoryDao();

        if (id > 0) {
            // 编辑：排除自身ID检查重名
            if (categoryDao.existNameExcluding(name, id)) {
                request.getSession().setAttribute("msg", "分类名称已存在");
                response.sendRedirect(request.getContextPath() + "/admin/category?action=list");
                return;
            }
            Category category = new Category();
            category.setId(id);
            category.setName(name);
            category.setDescription(description);
            categoryDao.update(category);
        } else {
            if (categoryDao.existName(name)) {
                request.getSession().setAttribute("msg", "分类名称已存在");
                response.sendRedirect(request.getContextPath() + "/admin/category?action=list");
                return;
            }
            categoryDao.add(name, description);
        }

        response.sendRedirect(request.getContextPath() + "/admin/category?action=list");
    }
}
