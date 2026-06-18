<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>页面未找到 - 电商平台</title>
    <link href="https://cdn.bootcdn.net/ajax/libs/twitter-bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<div class="container">
    <div class="row justify-content-center mt-5">
        <div class="col-md-6 text-center">
            <div class="card shadow">
                <div class="card-body py-5">
                    <h1 class="display-1 text-muted">404</h1>
                    <h3 class="mb-3">页面未找到</h3>
                    <p class="text-muted mb-4">抱歉，您访问的页面不存在或已被移除。</p>
                    <a href="${pageContext.request.contextPath}/index.jsp" class="btn btn-primary btn-lg">返回首页</a>
                </div>
            </div>
        </div>
    </div>
</div>
<script src="https://cdn.bootcdn.net/ajax/libs/twitter-bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
</body>
</html>
