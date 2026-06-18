<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:if test="${sessionScope.user != null}">
    <c:redirect url="${pageContext.request.contextPath}/index.jsp"/>
</c:if>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>注册 - 电商平台</title>
    <link href="https://cdn.bootcdn.net/ajax/libs/twitter-bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<div class="container">
    <div class="row justify-content-center mt-5">
        <div class="col-md-6">
            <div class="card shadow">
                <div class="card-body p-5">
                    <h3 class="text-center mb-4">用户注册</h3>

                    <c:if test="${not empty msg}">
                        <div class="alert alert-${msgType eq 'success' ? 'success' : 'danger'} alert-dismissible fade show" role="alert">
                            ${msg}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>

                    <form action="${pageContext.request.contextPath}/register" method="post">
                        <div class="mb-3">
                            <label for="username" class="form-label">用户名 <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" id="username" name="username" placeholder="请输入用户名" required>
                        </div>
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="password" class="form-label">密码 <span class="text-danger">*</span></label>
                                <input type="password" class="form-control" id="password" name="password" placeholder="请输入密码" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="confirmPassword" class="form-label">确认密码 <span class="text-danger">*</span></label>
                                <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" placeholder="请再次输入密码" required>
                            </div>
                        </div>
                        <div class="mb-3">
                            <label for="realName" class="form-label">真实姓名</label>
                            <input type="text" class="form-control" id="realName" name="realName" placeholder="请输入真实姓名">
                        </div>
                        <div class="mb-3">
                            <label for="email" class="form-label">邮箱</label>
                            <input type="email" class="form-control" id="email" name="email" placeholder="请输入邮箱">
                        </div>
                        <div class="mb-3">
                            <label for="phone" class="form-label">电话</label>
                            <input type="text" class="form-control" id="phone" name="phone" placeholder="请输入电话号码">
                        </div>
                        <div class="mb-3">
                            <label for="address" class="form-label">地址</label>
                            <input type="text" class="form-control" id="address" name="address" placeholder="请输入收货地址">
                        </div>
                        <div class="d-grid mb-3">
                            <button type="submit" class="btn btn-primary btn-lg">注册</button>
                        </div>
                    </form>

                    <div class="text-center">
                        <span class="text-muted">已有账号？</span>
                        <a href="${pageContext.request.contextPath}/login">立即登录</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<script src="https://cdn.bootcdn.net/ajax/libs/twitter-bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
<script>
document.querySelector('form').addEventListener('submit', function(e) {
    var pwd = document.getElementById('password').value;
    var cfm = document.getElementById('confirmPassword').value;
    if (pwd !== cfm) {
        e.preventDefault();
        alert('两次输入的密码不一致！');
    }
});
</script>
</body>
</html>
