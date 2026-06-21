<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ page import="com.ecommerce.dao.ProductDao" %>
<%@ page import="com.ecommerce.dao.CategoryDao" %>
<%@ page import="com.ecommerce.bean.Category" %>
<%@ page import="com.ecommerce.bean.Product" %>
<%@ page import="java.util.*" %>
<%
    ProductDao productDao = new ProductDao();
    CategoryDao categoryDao = new CategoryDao();
    List<Category> categories = categoryDao.findAll();
    request.setAttribute("categories", categories);
    request.setAttribute("hotProducts", productDao.findByPage(1, 8, 0, ""));
    // 按分类获取商品
    Map<Integer, List<Product>> catProductMap = new LinkedHashMap<>();
    for (Category cat : categories) {
        List<Product> catProducts = productDao.findByCategory(cat.getId());
        if (catProducts != null && !catProducts.isEmpty()) {
            catProductMap.put(cat.getId(), catProducts);
        }
    }
    request.setAttribute("catProductMap", catProductMap);
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>电商平台 - 首页</title>
    <link href="https://cdn.bootcdn.net/ajax/libs/twitter-bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<%@ include file="header.jsp" %>

<!-- 轮播图 Banner -->
<div id="heroCarousel" class="carousel slide mb-4" data-bs-ride="carousel">
    <div class="carousel-indicators">
        <button type="button" data-bs-target="#heroCarousel" data-bs-slide-to="0" class="active"></button>
        <button type="button" data-bs-target="#heroCarousel" data-bs-slide-to="1"></button>
        <button type="button" data-bs-target="#heroCarousel" data-bs-slide-to="2"></button>
    </div>
    <div class="carousel-inner">
        <div class="carousel-item active">
            <img src="https://picsum.photos/id/1015/1200/400" class="d-block w-100" alt="Banner 1" style="height:400px;object-fit:cover;">
            <div class="carousel-caption d-none d-md-block">
                <h5>欢迎来到电商平台</h5>
                <p>海量商品，优质低价</p>
            </div>
        </div>
        <div class="carousel-item">
            <img src="https://picsum.photos/id/1043/1200/400" class="d-block w-100" alt="Banner 2" style="height:400px;object-fit:cover;">
            <div class="carousel-caption d-none d-md-block">
                <h5>新品上市</h5>
                <p>最新潮流商品等你发现</p>
            </div>
        </div>
        <div class="carousel-item">
            <img src="https://picsum.photos/id/106/1200/400" class="d-block w-100" alt="Banner 3" style="height:400px;object-fit:cover;">
            <div class="carousel-caption d-none d-md-block">
                <h5>限时特惠</h5>
                <p>超值好物不容错过</p>
            </div>
        </div>
    </div>
    <button class="carousel-control-prev" type="button" data-bs-target="#heroCarousel" data-bs-slide="prev">
        <span class="carousel-control-prev-icon"></span>
        <span class="visually-hidden">上一页</span>
    </button>
    <button class="carousel-control-next" type="button" data-bs-target="#heroCarousel" data-bs-slide="next">
        <span class="carousel-control-next-icon"></span>
        <span class="visually-hidden">下一页</span>
    </button>
</div>

<div class="container">
    <!-- 热门推荐 -->
    <c:if test="${not empty hotProducts}">
    <section class="mb-5">
        <h3 class="mb-4 border-bottom pb-2">🔥 热门推荐</h3>
        <div class="row">
            <c:forEach items="${hotProducts}" var="p">
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
                        <p class="card-text text-danger fw-bold mt-auto">
                            <fmt:formatNumber value="${p.price}" pattern="#,##0.00"/> 元
                        </p>
                        <a href="${pageContext.request.contextPath}/product?action=detail&id=${p.id}" class="btn btn-outline-primary btn-sm">查看详情</a>
                    </div>
                </div>
            </div>
            </c:forEach>
        </div>
    </section>
    </c:if>

    <!-- 按分类展示商品 -->
    <c:if test="${not empty categories}">
    <c:forEach items="${categories}" var="cat">
    <c:if test="${not empty catProductMap[cat.id]}">
    <section class="mb-5">
        <h3 class="mb-4 border-bottom pb-2">
            ${fn:escapeXml(cat.name)}
            <a href="${pageContext.request.contextPath}/product?action=list&categoryId=${cat.id}" class="btn btn-sm btn-outline-secondary float-end">查看更多</a>
        </h3>
        <div class="row">
            <c:forEach items="${catProductMap[cat.id]}" var="p" end="3">
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
                        <p class="card-text text-danger fw-bold mt-auto">
                            <fmt:formatNumber value="${p.price}" pattern="#,##0.00"/> 元
                        </p>
                        <a href="${pageContext.request.contextPath}/product?action=detail&id=${p.id}" class="btn btn-outline-primary btn-sm">查看详情</a>
                    </div>
                </div>
            </div>
            </c:forEach>
        </div>
    </section>
    </c:if>
    </c:forEach>
    </c:if>
</div>

<%@ include file="footer.jsp" %>
<script src="https://cdn.bootcdn.net/ajax/libs/twitter-bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
</body>
</html>
