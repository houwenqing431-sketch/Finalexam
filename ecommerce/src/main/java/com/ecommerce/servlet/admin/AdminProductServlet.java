package com.ecommerce.servlet.admin;

import com.ecommerce.bean.*;
import com.ecommerce.dao.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.util.List;
import java.util.Properties;
import java.util.UUID;

@WebServlet("/admin/product")
@MultipartConfig(
    maxFileSize = 10 * 1024 * 1024,  // 单个文件最大 10MB
    maxRequestSize = 50 * 1024 * 1024 // 总请求最大 50MB
)
public class AdminProductServlet extends HttpServlet {

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
                case "add":
                    add(request, response);
                    break;
                case "edit":
                    edit(request, response);
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
        int page = 1;
        try {
            page = Integer.parseInt(request.getParameter("page"));
        } catch (NumberFormatException e) {
        }

        int categoryId = 0;
        try {
            categoryId = Integer.parseInt(request.getParameter("categoryId"));
        } catch (NumberFormatException e) {
        }

        String keyword = request.getParameter("keyword");
        if (keyword == null) {
            keyword = "";
        }

        ProductDao productDao = new ProductDao();
        CategoryDao categoryDao = new CategoryDao();

        List<Product> products = productDao.findByPage(page, PAGE_SIZE, categoryId, keyword);
        int totalCount = productDao.count(categoryId, keyword);
        int totalPages = (int) Math.ceil((double) totalCount / PAGE_SIZE);

        List<Category> categories = categoryDao.findAll();

        request.setAttribute("products", products);
        request.setAttribute("categories", categories);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalCount", totalCount);
        request.setAttribute("categoryId", categoryId);
        request.setAttribute("keyword", keyword);

        request.getRequestDispatcher("/admin/product_list.jsp").forward(request, response);
    }

    private void add(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        CategoryDao categoryDao = new CategoryDao();
        List<Category> categories = categoryDao.findAll();
        request.setAttribute("categories", categories);
        request.getRequestDispatcher("/admin/product_edit.jsp").forward(request, response);
    }

    private void edit(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        ProductDao productDao = new ProductDao();
        CategoryDao categoryDao = new CategoryDao();

        Product product = productDao.findById(id);
        List<Category> categories = categoryDao.findAll();

        request.setAttribute("product", product);
        request.setAttribute("categories", categories);
        request.getRequestDispatcher("/admin/product_edit.jsp").forward(request, response);
    }

    private void delete(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        ProductDao productDao = new ProductDao();

        // 删除商品图片文件
        Product product = productDao.findById(id);
        if (product != null && product.getImage() != null) {
            String imagePath = product.getImage(); // e.g. "images/xxx.jpg"
            String fileName = imagePath.substring(imagePath.lastIndexOf("/") + 1);
            File imageFile = new File(getUploadDir(), fileName);
            if (imageFile.exists()) {
                imageFile.delete();
            }
        }

        productDao.delete(id);
        response.sendRedirect(request.getContextPath() + "/admin/product?action=list");
    }

    private void save(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        int id = 0;
        try {
            id = Integer.parseInt(request.getParameter("id"));
        } catch (NumberFormatException e) {
        }

        String name = request.getParameter("name");
        double price = Double.parseDouble(request.getParameter("price"));
        int stock = Integer.parseInt(request.getParameter("stock"));
        int categoryId = Integer.parseInt(request.getParameter("categoryId"));
        String description = request.getParameter("description");
        int status = Integer.parseInt(request.getParameter("status"));

        // 处理图片上传
        String image = request.getParameter("oldImage"); // 编辑时保留旧图
        Part filePart = request.getPart("imageFile");
        if (filePart != null && filePart.getSize() > 0) {
            // 生成唯一文件名，保留原始扩展名
            String fileName = filePart.getSubmittedFileName();
            String ext = fileName.substring(fileName.lastIndexOf("."));
            String newFileName = UUID.randomUUID().toString() + ext;

            // 保存到外部目录，避免重新部署时丢失
            String uploadPath = getUploadDir();
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }
            filePart.write(uploadPath + File.separator + newFileName);
            image = "images/" + newFileName;
        }

        ProductDao productDao = new ProductDao();
        Product product = new Product();
        product.setId(id);
        product.setName(name);
        product.setPrice(price);
        product.setStock(stock);
        product.setCategoryId(categoryId);
        product.setDescription(description);
        product.setImage(image);
        product.setStatus(status);

        if (id > 0) {
            productDao.update(product);
        } else {
            productDao.add(product);
        }

        response.sendRedirect(request.getContextPath() + "/admin/product?action=list");
    }

    private String getUploadDir() {
        String dir = "D:/ecommerce_uploads";
        try (InputStream is = getClass().getClassLoader().getResourceAsStream("db.properties")) {
            if (is != null) {
                Properties props = new Properties();
                props.load(is);
                String configured = props.getProperty("upload.dir");
                if (configured != null && !configured.trim().isEmpty()) {
                    dir = configured.trim();
                }
            }
        } catch (IOException ignored) {}
        return dir;
    }
}
