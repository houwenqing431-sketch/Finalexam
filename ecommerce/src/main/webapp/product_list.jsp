<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ page import="com.ecommerce.dao.CategoryDao" %>
<%
    CategoryDao categoryDao = new CategoryDao();
    request.setAttribute("categories", categoryDao.findAll());
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>商品列表 - 电商平台</title>
    <link href="https://cdn.bootcdn.net/ajax/libs/twitter-bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<%@ include file="header.jsp" %>

<div class="container mt-4">
    <div class="row">
        <!-- 左侧分类筛选栏 -->
        <div class="col-md-2">
            <div class="card">
                <div class="card-header fw-bold">商品分类</div>
                <div class="list-group list-group-flush">
                    <a href="${pageContext.request.contextPath}/product?action=list" class="list-group-item list-group-item-action <c:if test="${empty param.categoryId || param.categoryId == 0}">active</c:if>">
                        全部分类
                    </a>
                    <c:forEach items="${categories}" var="cat">
                        <a href="${pageContext.request.contextPath}/product?action=list&categoryId=${cat.id}" class="list-group-item list-group-item-action <c:if test="${param.categoryId == cat.id}">active</c:if>">
                            ${cat.name}
                        </a>
                    </c:forEach>
                </div>
            </div>
        </div>

        <!-- 右侧商品列表 -->
        <div class="col-md-10">
            <!-- 搜索表单 -->
            <div class="mb-4">
                <form class="d-flex" action="${pageContext.request.contextPath}/product" method="get">
                    <input type="hidden" name="action" value="list">
                    <c:if test="${not empty param.categoryId}">
                        <input type="hidden" name="categoryId" value="${param.categoryId}">
                    </c:if>
                    <input class="form-control me-2" type="search" name="keyword" placeholder="搜索商品名称或描述..." value="${fn:escapeXml(param.keyword)}">
                    <button class="btn btn-primary" type="submit">搜索</button>
                </form>
            </div>

            <!-- 商品网格 -->
            <c:choose>
                <c:when test="${not empty products}">
                <div class="row">
                    <c:forEach items="${products}" var="p">
                    <div class="col-md-3 col-sm-6 mb-4">
                        <div class="card h-100 shadow-sm">
                            <c:choose>
                                <c:when test="${not empty p.image}">
                                    <img src="${pageContext.request.contextPath}/${p.image}" class="card-img-top" alt="${fn:escapeXml(p.name)}" style="height:200px;object-fit:cover;">
                                </c:when>
                                <c:otherwise>
                                    <div class="card-img-top bg-light d-flex align-items-center justify-content-center" style="height:200px;">
                                        <span class="text-muted">暂无图片</span>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                            <div class="card-body d-flex flex-column">
                                <h6 class="card-title">${fn:escapeXml(p.name)}</h6>
                                <p class="card-text text-muted small">${fn:escapeXml(p.categoryName)}</p>
                                <p class="card-text text-danger fw-bold mt-auto">
                                    <fmt:formatNumber value="${p.price}" pattern="#,##0.00"/> 元
                                </p>
                                <div class="d-flex gap-2">
                                    <a href="${pageContext.request.contextPath}/product?action=detail&id=${p.id}" class="btn btn-outline-primary btn-sm">查看详情</a>
                                    <c:choose>
                                        <c:when test="${sessionScope.user != null && sessionScope.user.role != 1}">
                                            <form action="${pageContext.request.contextPath}/cart" method="post" style="display:inline;">
                                                <input type="hidden" name="action" value="add">
                                                <input type="hidden" name="productId" value="${p.id}">
                                                <input type="hidden" name="quantity" value="1">
                                                <button type="submit" class="btn btn-outline-success btn-sm">加入购物车</button>
                                            </form>
                                            <form action="${pageContext.request.contextPath}/favorite" method="post" style="display:inline;">
                                                <input type="hidden" name="action" value="add">
                                                <input type="hidden" name="productId" value="${p.id}">
                                                <button type="submit" class="btn btn-outline-danger btn-sm" title="收藏">♡</button>
                                            </form>
                                        </c:when>
                                        <c:otherwise>
                                            <a href="${pageContext.request.contextPath}/login" class="btn btn-outline-success btn-sm">加入购物车</a>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                    </div>
                    </c:forEach>
                </div>
                </c:when>
                <c:otherwise>
                    <div class="alert alert-info text-center">
                        <p class="mb-0">暂无商品数据</p>
                    </div>
                </c:otherwise>
            </c:choose>

            <!-- 分页导航 -->
            <c:if test="${totalPages > 1}">
            <nav aria-label="分页导航" class="mt-4">
                <ul class="pagination justify-content-center">
                    <c:set var="baseUrl" value="${pageContext.request.contextPath}/product?action=list"/>
                    <c:if test="${not empty param.categoryId}">
                        <c:set var="baseUrl" value="${baseUrl}&categoryId=${param.categoryId}"/>
                    </c:if>
                    <c:if test="${not empty param.keyword}">
                        <c:set var="baseUrl" value="${baseUrl}&keyword=${param.keyword}"/>
                    </c:if>

                    <li class="page-item <c:if test="${page <= 1}">disabled</c:if>">
                        <a class="page-link" href="${baseUrl}&page=${page - 1}">上一页</a>
                    </li>

                    <c:forEach begin="1" end="${totalPages}" var="i">
                        <li class="page-item <c:if test="${page == i}">active</c:if>">
                            <a class="page-link" href="${baseUrl}&page=${i}">${i}</a>
                        </li>
                    </c:forEach>

                    <li class="page-item <c:if test="${page >= totalPages}">disabled</c:if>">
                        <a class="page-link" href="${baseUrl}&page=${page + 1}">下一页</a>
                    </li>
                </ul>
            </nav>
            </c:if>
        </div>
    </div>
</div>

<%@ include file="footer.jsp" %>
<script src="https://cdn.bootcdn.net/ajax/libs/twitter-bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
</body>
</html>
