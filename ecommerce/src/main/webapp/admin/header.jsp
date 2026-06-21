<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:if test="${sessionScope.user == null || sessionScope.user.role != 1}">
    <c:redirect url="${pageContext.request.contextPath}/login.jsp"/>
</c:if>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>后台管理系统</title>
    <link href="https://cdn.bootcdn.net/ajax/libs/twitter-bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.bootcdn.net/ajax/libs/bootstrap-icons/1.11.1/font/bootstrap-icons.css" rel="stylesheet">
</head>
<body>
<div class="d-flex" style="min-height: 100vh;">
    <!-- 左侧边栏 -->
    <nav class="bg-dark text-white d-flex flex-column flex-shrink-0" style="width: 250px;">
        <div class="p-3 border-bottom border-secondary">
            <h5 class="mb-0 text-center">后台管理系统</h5>
        </div>
        <ul class="nav nav-pills flex-column mb-auto p-3">
            <li class="nav-item">
                <a href="${pageContext.request.contextPath}/admin/index.jsp" class="nav-link text-white">
                    <i class="bi bi-speedometer2 me-2"></i>管理首页
                </a>
            </li>
            <li class="nav-item">
                <a href="${pageContext.request.contextPath}/admin/product?action=list" class="nav-link text-white">
                    <i class="bi bi-box-seam me-2"></i>商品管理
                </a>
            </li>
            <li class="nav-item">
                <a href="${pageContext.request.contextPath}/admin/category?action=list" class="nav-link text-white">
                    <i class="bi bi-grid me-2"></i>分类管理
                </a>
            </li>
            <li class="nav-item">
                <a href="${pageContext.request.contextPath}/admin/order?action=list" class="nav-link text-white">
                    <i class="bi bi-cart3 me-2"></i>订单管理
                </a>
            </li>
            <li class="nav-item">
                <a href="${pageContext.request.contextPath}/admin/user?action=list" class="nav-link text-white">
                    <i class="bi bi-people me-2"></i>用户管理
                </a>
            </li>
            <li class="nav-item">
                <a href="${pageContext.request.contextPath}/admin/statistics" class="nav-link text-white">
                    <i class="bi bi-bar-chart me-2"></i>销量统计
                </a>
            </li>
        </ul>
    </nav>

    <!-- 右侧内容区 -->
    <div class="flex-grow-1 d-flex flex-column">
        <!-- 顶部导航栏 -->
        <nav class="navbar navbar-expand-lg navbar-light bg-light border-bottom px-4">
            <div class="container-fluid">
                <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#adminTopNav">
                    <span class="navbar-toggler-icon"></span>
                </button>
                <div class="collapse navbar-collapse" id="adminTopNav">
                    <ul class="navbar-nav ms-auto">
                        <li class="nav-item">
                            <span class="nav-link text-dark">
                                <i class="bi bi-person-circle me-1"></i>${sessionScope.user.username}
                            </span>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/index.jsp">返回前台</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link text-danger" href="${pageContext.request.contextPath}/logout">安全退出</a>
                        </li>
                    </ul>
                </div>
            </div>
        </nav>

        <!-- 主内容区域 -->
        <div class="p-4 flex-grow-1 bg-light bg-opacity-25">
        <c:if test="${not empty sessionScope.msg}">
            <div class="alert alert-warning alert-dismissible fade show" role="alert">
                <i class="bi bi-exclamation-triangle me-2"></i>${sessionScope.msg}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <c:remove var="msg" scope="session"/>
        </c:if>
