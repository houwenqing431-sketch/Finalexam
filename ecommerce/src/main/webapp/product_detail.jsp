<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>`r`n<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${fn:escapeXml(product.name)} - 电商平台</title>
    <link href="https://cdn.bootcdn.net/ajax/libs/twitter-bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<%@ include file="header.jsp" %>

<div class="container mt-4">
    <c:choose>
        <c:when test="${not empty product}">
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb">
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/index.jsp">首页</a></li>
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/product?action=list">商品列表</a></li>
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/product?action=list&categoryId=${product.categoryId}">${fn:escapeXml(product.categoryName)}</a></li>
                    <li class="breadcrumb-item active">${fn:escapeXml(product.name)}</li>
                </ol>
            </nav>

            <div class="row">
                <!-- 商品大图 -->
                <div class="col-md-6">
                    <c:choose>
                        <c:when test="${not empty product.image}">
                            <img src="${pageContext.request.contextPath}/${product.image}" class="img-fluid rounded" alt="${fn:escapeXml(product.name)}" style="max-height:450px;width:100%;object-fit:cover;">
                        </c:when>
                        <c:otherwise>
                            <div class="bg-light d-flex align-items-center justify-content-center rounded" style="height:400px;">
                                <span class="text-muted fs-4">暂无图片</span>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- 商品信息 -->
                <div class="col-md-6">
                    <h2>${fn:escapeXml(product.name)}</h2>
                    <p class="text-muted">分类：${fn:escapeXml(product.categoryName)}</p>
                    <h3 class="text-danger mb-3">
                        <fmt:formatNumber value="${product.price}" pattern="#,##0.00"/> 元
                    </h3>

                    <div class="mb-3">
                        <span class="fw-bold">库存：</span>
                        <c:choose>
                            <c:when test="${product.stock > 0}">
                                <span class="badge bg-success">有货（${product.stock}）</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge bg-danger">缺货</span>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <div class="mb-4">
                        <h5>商品描述</h5>
                        <p class="text-muted">${fn:escapeXml(product.description)}</p>
                    </div>

                    <c:if test="${sessionScope.user != null && sessionScope.user.role != 1}">
                    <c:if test="${product.stock > 0}">
                    <div class="d-flex align-items-center gap-3 mb-3">
                        <label for="quantity" class="form-label mb-0">数量：</label>
                        <input type="number" id="quantity" class="form-control" style="width:80px;" value="1" min="1" max="${product.stock}">
                        <button type="button" id="addToCartBtn" class="btn btn-primary" onclick="addToCart()">加入购物车</button>
                        <c:choose>
                            <c:when test="${isFavorite}">
                                <button type="button" id="favBtn" class="btn btn-danger" onclick="addToFavorite()">❤ 取消收藏</button>
                            </c:when>
                            <c:otherwise>
                                <button type="button" id="favBtn" class="btn btn-outline-danger" onclick="addToFavorite()">♡ 收藏</button>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    </c:if>
                    </c:if>

                    <c:if test="${sessionScope.user == null}">
                        <div class="alert alert-secondary">
                            请先<a href="${pageContext.request.contextPath}/login">登录</a>后购买商品。
                        </div>
                    </c:if>
                </div>
            </div>
        </c:when>
        <c:otherwise>
            <div class="alert alert-warning text-center">
                <p class="mb-0">商品不存在或已下架</p>
                <a href="${pageContext.request.contextPath}/product?action=list" class="btn btn-primary mt-2">返回商品列表</a>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<%@ include file="footer.jsp" %>
<script src="https://cdn.bootcdn.net/ajax/libs/twitter-bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
<c:if test="${sessionScope.user != null && sessionScope.user.role != 1}">
<script>
function addToCart() {
    var qty = document.getElementById('quantity').value;
    var xhr = new XMLHttpRequest();
    xhr.open('POST', '${pageContext.request.contextPath}/cart?action=add', true);
    xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
    xhr.onload = function() {
        if (xhr.status === 200) {
            alert('已成功加入购物车！');
        } else {
            alert('加入购物车失败，请重试。');
        }
    };
    xhr.send('productId=${product.id}&quantity=' + qty);
}

function addToFavorite() {
    var favBtn = document.getElementById('favBtn');
    var isFavorite = '${isFavorite}' === 'true';
    var xhr = new XMLHttpRequest();
    xhr.open('POST', '${pageContext.request.contextPath}/favorite', true);
    xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
    xhr.onload = function() {
        if (xhr.status === 200) {
            location.reload();
        } else {
            alert('操作失败，请重试。');
        }
    };
    if (isFavorite) {
        xhr.send('action=deleteByProduct&productId=${product.id}');
    } else {
        xhr.send('action=add&productId=${product.id}');
    }
}
</script>
</c:if>
</body>
</html>
