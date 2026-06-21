<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>商品列表 - 电商平台</title>
    <link href="https://cdn.bootcdn.net/ajax/libs/twitter-bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .product-card {
            transition: transform 0.2s, box-shadow 0.2s;
            border: none;
        }
        .product-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 12px 30px rgba(0,0,0,0.15) !important;
        }
        .product-card img {
            transition: transform 0.3s;
        }
        .product-card:hover img {
            transform: scale(1.05);
        }
        .sidebar {
            border: none;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 2px 8px rgba(0,0,0,0.06);
        }
        .sidebar .card-header {
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
            font-weight: 600;
        }
        .list-group-item {
            border-left: 3px solid transparent;
            transition: all 0.15s;
        }
        .list-group-item.active {
            border-left-color: #764ba2;
        }
        .list-group-item:hover:not(.active) {
            border-left-color: #ddd;
            background-color: #f8f9fa;
        }
    </style>
</head>
<body>
<%@ include file="header.jsp" %>

<div class="container mt-4">
    <div class="row">
        <!-- 左侧分类栏 -->
        <div class="col-md-2">
            <div class="card sidebar mb-4">
                <div class="card-header"><i class="bi bi-grid me-2"></i>商品分类</div>
                <div class="list-group list-group-flush">
                    <a href="${pageContext.request.contextPath}/product?action=list"
                       class="list-group-item list-group-item-action <c:if test="${empty param.categoryId || param.categoryId == 0}">active</c:if>">
                        <i class="bi bi-list-ul me-2"></i>全部分类
                    </a>
                    <c:forEach items="${categories}" var="cat">
                        <a href="${pageContext.request.contextPath}/product?action=list&categoryId=${cat.id}"
                           class="list-group-item list-group-item-action <c:if test="${param.categoryId == cat.id}">active</c:if>">
                            <i class="bi bi-tag me-2"></i>${fn:escapeXml(cat.name)}
                        </a>
                    </c:forEach>
                </div>
            </div>
        </div>

        <!-- 右侧商品区 -->
        <div class="col-md-10">
            <!-- 搜索栏 -->
            <div class="card shadow-sm mb-4 border-0 rounded-3">
                <div class="card-body py-3">
                    <form class="row g-2 align-items-center" action="${pageContext.request.contextPath}/product" method="get">
                        <input type="hidden" name="action" value="list">
                        <c:if test="${not empty param.categoryId}">
                            <input type="hidden" name="categoryId" value="${param.categoryId}">
                        </c:if>
                        <div class="col">
                            <div class="input-group">
                                <span class="input-group-text bg-white"><i class="bi bi-search"></i></span>
                                <input class="form-control" type="search" name="keyword" placeholder="搜索商品名称或描述..." value="${fn:escapeXml(param.keyword)}">
                            </div>
                        </div>
                        <div class="col-auto">
                            <button class="btn btn-primary px-4" type="submit">
                                <i class="bi bi-search me-1"></i>搜索
                            </button>
                        </div>
                    </form>
                </div>
            </div>

            <!-- 商品网格 -->
            <c:choose>
                <c:when test="${not empty products}">
                <div class="row">
                    <c:forEach items="${products}" var="p">
                    <div class="col-lg-3 col-md-4 col-sm-6 mb-4">
                        <div class="card product-card h-100 shadow-sm">
                            <div class="position-relative overflow-hidden" style="height:200px;">
                                <c:choose>
                                    <c:when test="${not empty p.image}">
                                        <img src="${pageContext.request.contextPath}/${p.image}" class="w-100 h-100" alt="${fn:escapeXml(p.name)}" style="object-fit:cover;">
                                    </c:when>
                                    <c:otherwise>
                                        <div class="w-100 h-100 bg-light d-flex align-items-center justify-content-center">
                                            <span class="text-muted"><i class="bi bi-image fs-1"></i></span>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div class="card-body d-flex flex-column">
                                <h6 class="card-title text-truncate">${fn:escapeXml(p.name)}</h6>
                                <p class="card-text text-muted small mb-2">
                                    <i class="bi bi-folder2 me-1"></i>${fn:escapeXml(p.categoryName)}
                                </p>
                                <p class="card-text text-danger fw-bold fs-5 mt-auto mb-2">
                                    <fmt:formatNumber value="${p.price}" pattern="#,##0.00"/>
                                    <small class="text-muted fs-6">元</small>
                                </p>
                                <div class="d-flex gap-2">
                                    <a href="${pageContext.request.contextPath}/product?action=detail&id=${p.id}" class="btn btn-outline-primary btn-sm flex-grow-1">
                                        <i class="bi bi-eye me-1"></i>详情
                                    </a>
                                    <c:choose>
                                        <c:when test="${sessionScope.user != null && sessionScope.user.role != 1}">
                                            <form action="${pageContext.request.contextPath}/cart" method="post" class="d-inline">
                                                <input type="hidden" name="action" value="add">
                                                <input type="hidden" name="productId" value="${p.id}">
                                                <input type="hidden" name="quantity" value="1">
                                                <button type="submit" class="btn btn-outline-success btn-sm" title="加入购物车"><i class="bi bi-cart-plus"></i></button>
                                            </form>
                                            <form action="${pageContext.request.contextPath}/favorite" method="post" class="d-inline">
                                                <input type="hidden" name="action" value="add">
                                                <input type="hidden" name="productId" value="${p.id}">
                                                <button type="submit" class="btn btn-outline-danger btn-sm" title="收藏"><i class="bi bi-heart"></i></button>
                                            </form>
                                        </c:when>
                                        <c:when test="${sessionScope.user == null}">
                                            <a href="${pageContext.request.contextPath}/login" class="btn btn-outline-success btn-sm"><i class="bi bi-cart-plus me-1"></i>购买</a>
                                        </c:when>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                    </div>
                    </c:forEach>
                </div>
                </c:when>
                <c:otherwise>
                    <div class="text-center py-5">
                        <i class="bi bi-inbox fs-1 text-muted"></i>
                        <p class="text-muted mt-2">暂无商品</p>
                    </div>
                </c:otherwise>
            </c:choose>

            <!-- 分页 -->
            <c:if test="${totalPages > 1}">
            <nav class="mt-4">
                <ul class="pagination justify-content-center">
                    <c:set var="baseUrl" value="${pageContext.request.contextPath}/product?action=list"/>
                    <c:if test="${not empty param.categoryId}">
                        <c:set var="baseUrl" value="${baseUrl}&categoryId=${param.categoryId}"/>
                    </c:if>
                    <c:if test="${not empty param.keyword}">
                        <c:set var="baseUrl" value="${baseUrl}&keyword=${fn:escapeXml(param.keyword)}"/>
                    </c:if>

                    <li class="page-item <c:if test="${page <= 1}">disabled</c:if>">
                        <a class="page-link" href="${baseUrl}&page=${page - 1}"><i class="bi bi-chevron-left"></i></a>
                    </li>
                    <c:forEach begin="1" end="${totalPages}" var="i">
                        <li class="page-item <c:if test="${page == i}">active</c:if>">
                            <a class="page-link" href="${baseUrl}&page=${i}">${i}</a>
                        </li>
                    </c:forEach>
                    <li class="page-item <c:if test="${page >= totalPages}">disabled</c:if>">
                        <a class="page-link" href="${baseUrl}&page=${page + 1}"><i class="bi bi-chevron-right"></i></a>
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
