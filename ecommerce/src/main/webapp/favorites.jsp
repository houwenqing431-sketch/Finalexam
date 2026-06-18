<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>`r`n<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:if test="${sessionScope.user == null}">
    <c:redirect url="${pageContext.request.contextPath}/login"/>
</c:if>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>我的收藏 - 电商平台</title>
    <link href="https://cdn.bootcdn.net/ajax/libs/twitter-bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<%@ include file="header.jsp" %>

<div class="container mt-4">
    <h2 class="mb-4">我的收藏</h2>

    <c:choose>
        <c:when test="${not empty favorites}">
        <div class="row">
            <c:forEach items="${favorites}" var="fav">
            <div class="col-md-3 col-sm-6 mb-4">
                <div class="card h-100 shadow-sm">
                    <c:choose>
                        <c:when test="${not empty fav.productImage}">
                            <img src="${pageContext.request.contextPath}/${fav.productImage}" class="card-img-top" alt="${fav.productName}" style="height:200px;object-fit:cover;">
                        </c:when>
                        <c:otherwise>
                            <div class="card-img-top bg-light d-flex align-items-center justify-content-center" style="height:200px;">
                                <span class="text-muted">暂无图片</span>
                            </div>
                        </c:otherwise>
                    </c:choose>
                    <button class="btn btn-sm btn-outline-danger position-absolute top-0 end-0 m-2" onclick="cancelFavorite(${fav.id})" title="取消收藏">&times;</button>
                    <div class="card-body d-flex flex-column">
                        <h6 class="card-title">${fav.productName}</h6>
                        <p class="card-text text-danger fw-bold mt-auto">
                            <fmt:formatNumber value="${fav.productPrice}" pattern="#,##0.00"/> 元
                        </p>
                        <div class="d-flex gap-2">
                            <a href="${pageContext.request.contextPath}/product?action=detail&id=${fav.productId}" class="btn btn-outline-primary btn-sm flex-grow-1">查看详情</a>
                            <a href="${pageContext.request.contextPath}/favorite?action=delete&id=${fav.id}" class="btn btn-outline-danger btn-sm" onclick="return confirm('确定要取消收藏吗？')">取消</a>
                        </div>
                    </div>
                </div>
            </div>
            </c:forEach>
        </div>
        </c:when>
        <c:otherwise>
        <div class="alert alert-info text-center py-5">
            <h4>还没有收藏任何商品</h4>
            <p class="mb-3">快去发现喜欢的商品吧！</p>
            <a href="${pageContext.request.contextPath}/product?action=list" class="btn btn-primary">去逛逛</a>
        </div>
        </c:otherwise>
    </c:choose>
</div>

<%@ include file="footer.jsp" %>
<script src="https://cdn.bootcdn.net/ajax/libs/twitter-bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
</body>
</html>
