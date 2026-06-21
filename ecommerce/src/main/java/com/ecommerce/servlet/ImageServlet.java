package com.ecommerce.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;

/**
 * 图片服务Servlet - 从外部目录读取图片，避免重新部署导致文件丢失
 */
@WebServlet(urlPatterns = "/images/*", loadOnStartup = 1)
public class ImageServlet extends HttpServlet {

    // 图片存储的外部目录（绝对路径）
    private static final String UPLOAD_DIR = "D:/finalexam/Finalexam/ecommerce/src/main/webapp/images";

    @Override
    public void init() throws ServletException {
        // 启动时自动创建上传目录
        File uploadDir = new File(UPLOAD_DIR);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // 从URL中提取文件名: /images/xxx.jpg → xxx.jpg
        String pathInfo = req.getPathInfo();
        if (pathInfo == null || pathInfo.equals("/")) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        String fileName = pathInfo.substring(1); // 去掉开头的 /
        File file = new File(UPLOAD_DIR, fileName);

        if (!file.exists() || !file.isFile()) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        // 根据扩展名设置 Content-Type
        String contentType = getServletContext().getMimeType(file.getName());
        if (contentType == null) {
            contentType = "application/octet-stream";
        }
        resp.setContentType(contentType);
        resp.setContentLengthLong(file.length());

        // 设置缓存
        resp.setHeader("Cache-Control", "public, max-age=86400");

        // 输出文件内容
        try (FileInputStream fis = new FileInputStream(file);
             OutputStream os = resp.getOutputStream()) {
            byte[] buffer = new byte[8192];
            int bytesRead;
            while ((bytesRead = fis.read(buffer)) != -1) {
                os.write(buffer, 0, bytesRead);
            }
        }
    }
}
