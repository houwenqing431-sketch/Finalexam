<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:if test="${sessionScope.user == null}">
    <c:redirect url="${pageContext.request.contextPath}/login"/>
</c:if>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>个人中心 - 电商平台</title>
    <link href="https://cdn.bootcdn.net/ajax/libs/twitter-bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<%@ include file="header.jsp" %>

<div class="container mt-4">
    <h2 class="mb-4">个人中心</h2>

    <c:if test="${not empty msg}">
        <div class="alert alert-${msgType eq 'success' ? 'success' : 'danger'} alert-dismissible fade show" role="alert">
            ${msg}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <!-- Bootstrap Tabs -->
    <ul class="nav nav-tabs" id="userTab" role="tablist">
        <li class="nav-item" role="presentation">
            <button class="nav-link active" id="info-tab" data-bs-toggle="tab" data-bs-target="#info" type="button" role="tab">个人信息</button>
        </li>
        <li class="nav-item" role="presentation">
            <button class="nav-link" id="password-tab" data-bs-toggle="tab" data-bs-target="#password" type="button" role="tab">修改密码</button>
        </li>
    </ul>

    <div class="tab-content p-4 border border-top-0 rounded-bottom">
        <!-- 个人信息 Tab -->
        <div class="tab-pane fade show active" id="info" role="tabpanel">
            <form action="${pageContext.request.contextPath}/user?action=updateInfo" method="post">
                <div class="mb-3">
                    <label for="username" class="form-label">用户名</label>
                    <input type="text" class="form-control" id="username" value="${fn:escapeXml(sessionScope.user.username)}" readonly disabled>
                </div>
                <div class="mb-3">
                    <label for="realName" class="form-label">真实姓名</label>
                    <input type="text" class="form-control" id="realName" name="realName" value="${fn:escapeXml(sessionScope.user.realName)}">
                </div>
                <div class="mb-3">
                    <label for="email" class="form-label">邮箱</label>
                    <input type="email" class="form-control" id="email" name="email" value="${sessionScope.user.email}">
                </div>
                <div class="mb-3">
                    <label for="phone" class="form-label">电话</label>
                    <input type="text" class="form-control" id="phone" name="phone" value="${sessionScope.user.phone}">
                </div>
                <div class="mb-3">
                    <label for="address" class="form-label">地址</label>
                    <input type="text" class="form-control" id="address" name="address" value="${sessionScope.user.address}">
                </div>
                <button type="submit" class="btn btn-primary">保存修改</button>
            </form>
        </div>

        <!-- 修改密码 Tab -->
        <div class="tab-pane fade" id="password" role="tabpanel">
            <form action="${pageContext.request.contextPath}/user?action=changePwd" method="post" onsubmit="return checkPassword()">
                <div class="mb-3">
                    <label for="oldPassword" class="form-label">旧密码</label>
                    <input type="password" class="form-control" id="oldPassword" name="oldPassword" placeholder="请输入旧密码" required>
                </div>
                <div class="mb-3">
                    <label for="newPassword" class="form-label">新密码</label>
                    <input type="password" class="form-control" id="newPassword" name="newPassword" placeholder="请输入新密码" required>
                </div>
                <div class="mb-3">
                    <label for="confirmPassword" class="form-label">确认新密码</label>
                    <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" placeholder="请再次输入新密码" required>
                </div>
                <button type="submit" class="btn btn-warning">修改密码</button>
            </form>
        </div>
    </div>
</div>

<%@ include file="footer.jsp" %>
<script src="https://cdn.bootcdn.net/ajax/libs/twitter-bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
<script>
function checkPassword() {
    var newPwd = document.getElementById('newPassword').value;
    var cfmPwd = document.getElementById('confirmPassword').value;
    if (newPwd !== cfmPwd) {
        alert('两次输入的新密码不一致！');
        return false;
    }
    return true;
}
</script>
</body>
</html>
