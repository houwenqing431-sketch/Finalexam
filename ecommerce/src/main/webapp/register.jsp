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
    <link href="https://cdn.bootcdn.net/ajax/libs/bootstrap-icons/1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body {
            min-height: 100vh;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }
        .register-card {
            border: none;
            border-radius: 16px;
            overflow: hidden;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
            margin: 40px 0;
        }
        .register-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            text-align: center;
            padding: 30px 20px;
        }
        .register-header .icon-circle {
            width: 70px;
            height: 70px;
            background: rgba(255,255,255,0.2);
            border-radius: 50%;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-size: 32px;
            margin-bottom: 12px;
        }
        .register-body {
            padding: 40px;
            background: #fff;
        }
        .form-floating > .form-control:focus ~ label,
        .form-floating > .form-control:not(:placeholder-shown) ~ label {
            color: #667eea;
        }
        .form-floating > .form-control:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
        }
        .btn-register {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            color: white;
            font-size: 16px;
            font-weight: 600;
            padding: 12px;
            border-radius: 8px;
            transition: transform 0.2s, box-shadow 0.2s;
        }
        .btn-register:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(102, 126, 234, 0.4);
            color: white;
        }
        .login-link {
            color: #667eea;
            font-weight: 600;
            text-decoration: none;
        }
        .login-link:hover {
            color: #764ba2;
            text-decoration: underline;
        }
    </style>
</head>
<body>
<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-7 col-lg-5">
            <div class="register-card">
                <div class="register-header">
                    <div class="icon-circle">
                        <i class="bi bi-person-plus"></i>
                    </div>
                    <h4 class="mb-1">创建账号</h4>
                    <p class="mb-0 opacity-75">加入我们，开始购物之旅</p>
                </div>

                <div class="register-body">
                    <c:if test="${not empty msg}">
                        <div class="alert alert-${msgType eq 'success' ? 'success' : 'danger'} alert-dismissible fade show" role="alert">
                            <i class="bi bi-${msgType eq 'success' ? 'check-circle' : 'exclamation-triangle'} me-2"></i>${msg}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>

                    <form action="${pageContext.request.contextPath}/register" method="post" id="registerForm">
                        <div class="form-floating mb-3">
                            <input type="text" class="form-control" id="username" name="username" placeholder="用户名" required>
                            <label for="username"><i class="bi bi-person me-1"></i>用户名 <span class="text-danger">*</span></label>
                        </div>
                        <div class="row g-2 mb-3">
                            <div class="col-6">
                                <div class="form-floating">
                                    <input type="password" class="form-control" id="password" name="password" placeholder="密码" required>
                                    <label for="password"><i class="bi bi-lock me-1"></i>密码 <span class="text-danger">*</span></label>
                                </div>
                            </div>
                            <div class="col-6">
                                <div class="form-floating">
                                    <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" placeholder="确认密码" required>
                                    <label for="confirmPassword"><i class="bi bi-lock-fill me-1"></i>确认密码 <span class="text-danger">*</span></label>
                                </div>
                            </div>
                        </div>
                        <div class="form-floating mb-3">
                            <input type="text" class="form-control" id="realName" name="realName" placeholder="真实姓名">
                            <label for="realName"><i class="bi bi-person-badge me-1"></i>真实姓名</label>
                        </div>
                        <div class="form-floating mb-3">
                            <input type="email" class="form-control" id="email" name="email" placeholder="邮箱">
                            <label for="email"><i class="bi bi-envelope me-1"></i>邮箱</label>
                        </div>
                        <div class="form-floating mb-3">
                            <input type="text" class="form-control" id="phone" name="phone" placeholder="电话">
                            <label for="phone"><i class="bi bi-phone me-1"></i>电话</label>
                        </div>
                        <div class="form-floating mb-4">
                            <input type="text" class="form-control" id="address" name="address" placeholder="地址">
                            <label for="address"><i class="bi bi-geo-alt me-1"></i>收货地址</label>
                        </div>
                        <div class="d-grid mb-4">
                            <button type="submit" class="btn btn-register">
                                <i class="bi bi-check-circle me-2"></i>注 册
                            </button>
                        </div>
                    </form>

                    <div class="text-center">
                        <span class="text-muted">已有账号？</span>
                        <a href="${pageContext.request.contextPath}/login" class="login-link">立即登录 <i class="bi bi-arrow-right"></i></a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<script src="https://cdn.bootcdn.net/ajax/libs/twitter-bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
<script>
document.getElementById('registerForm').addEventListener('submit', function(e) {
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
