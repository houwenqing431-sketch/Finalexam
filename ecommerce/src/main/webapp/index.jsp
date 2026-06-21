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
    <style>
        .hero-carousel .carousel-item img {
            height: 420px;
            object-fit: cover;
        }
        .hero-carousel .carousel-caption {
            bottom: 30%;
            text-shadow: 2px 2px 8px rgba(0,0,0,0.6);
        }
        .hero-carousel .carousel-caption h5 {
            font-size: 2rem;
            font-weight: 700;
        }
        .section-title {
            position: relative;
            padding-left: 16px;
            font-weight: 700;
        }
        .section-title::before {
            content: '';
            position: absolute;
            left: 0;
            top: 4px;
            bottom: 4px;
            width: 4px;
            background: linear-gradient(180deg, #667eea, #764ba2);
            border-radius: 2px;
        }
        .product-card {
            transition: transform 0.25s, box-shadow 0.25s;
            border: none;
            border-radius: 12px;
            overflow: hidden;
        }
        .product-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 16px 40px rgba(0,0,0,0.15) !important;
        }
        .product-card .img-wrapper {
            height: 200px;
            overflow: hidden;
        }
        .product-card .img-wrapper img {
            transition: transform 0.4s;
        }
        .product-card:hover .img-wrapper img {
            transform: scale(1.08);
        }
        .feature-bar {
            background: linear-gradient(135deg, #667eea, #764ba2);
            border-radius: 12px;
            padding: 28px 20px;
        }
        .feature-bar .feature-icon {
            font-size: 2rem;
        }
    </style>
</head>
<body>
<%@ include file="header.jsp" %>

<!-- 轮播图 -->
<div id="heroCarousel" class="carousel slide hero-carousel shadow-sm" data-bs-ride="carousel">
    <div class="carousel-indicators">
        <button type="button" data-bs-target="#heroCarousel" data-bs-slide-to="0" class="active"></button>
        <button type="button" data-bs-target="#heroCarousel" data-bs-slide-to="1"></button>
        <button type="button" data-bs-target="#heroCarousel" data-bs-slide-to="2"></button>
    </div>
    <div class="carousel-inner">
        <div class="carousel-item active">
            <img src="https://picsum.photos/id/1015/1200/400" class="d-block w-100" alt="欢迎">
            <div class="carousel-caption">
                <h5>欢迎来到电商平台</h5>
                <p class="lead">海量商品 · 优质低价 · 极速配送</p>
            </div>
        </div>
        <div class="carousel-item">
            <img src="https://picsum.photos/id/1043/1200/400" class="d-block w-100" alt="新品">
            <div class="carousel-caption">
                <h5>新品上市</h5>
                <p class="lead">最新潮流商品，等你来发现</p>
            </div>
        </div>
        <div class="carousel-item">
            <img src="https://picsum.photos/id/106/1200/400" class="d-block w-100" alt="特惠">
            <div class="carousel-caption">
                <h5>限时特惠</h5>
                <p class="lead">超值好物，不容错过</p>
            </div>
        </div>
    </div>
    <button class="carousel-control-prev" type="button" data-bs-target="#heroCarousel" data-bs-slide="prev">
        <span class="carousel-control-prev-icon"></span>
    </button>
    <button class="carousel-control-next" type="button" data-bs-target="#heroCarousel" data-bs-slide="next">
        <span class="carousel-control-next-icon"></span>
    </button>
</div>

<div class="container">
    <!-- 特色栏 -->
    <div class="feature-bar text-white text-center row g-0 my-4">
        <div class="col-md-4 py-2"><i class="bi bi-truck feature-icon d-block mb-1"></i><strong>全国包邮</strong><br><small class="opacity-75">满99元免运费</small></div>
        <div class="col-md-4 py-2"><i class="bi bi-shield-check feature-icon d-block mb-1"></i><strong>正品保障</strong><br><small class="opacity-75">品质无忧放心购</small></div>
        <div class="col-md-4 py-2"><i class="bi bi-headset feature-icon d-block mb-1"></i><strong>售后无忧</strong><br><small class="opacity-75">7天无理由退换</small></div>
    </div>

    <!-- 热门推荐 -->
    <c:if test="${not empty hotProducts}">
    <section class="mb-5">
        <h3 class="section-title mb-4">热门推荐</h3>
        <div class="row">
            <c:forEach items="${hotProducts}" var="p">
            <div class="col-lg-3 col-md-4 col-sm-6 mb-4">
                <div class="card product-card h-100 shadow-sm">
                    <div class="img-wrapper">
                        <c:choose>
                            <c:when test="${not empty p.image}">
                                <img src="${pageContext.request.contextPath}/${p.image}" class="w-100 h-100" alt="${fn:escapeXml(p.name)}" style="object-fit:cover;">
                            </c:when>
                            <c:otherwise>
                                <div class="w-100 h-100 bg-light d-flex align-items-center justify-content-center">
                                    <i class="bi bi-image text-muted" style="font-size:3rem;"></i>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="card-body d-flex flex-column">
                        <h6 class="card-title text-truncate">${fn:escapeXml(p.name)}</h6>
                        <p class="card-text text-danger fw-bold fs-5 mt-auto mb-2">
                            <fmt:formatNumber value="${p.price}" pattern="#,##0.00"/>
                            <small class="text-muted fs-6">元</small>
                        </p>
                        <a href="${pageContext.request.contextPath}/product?action=detail&id=${p.id}" class="btn btn-outline-primary btn-sm">
                            <i class="bi bi-eye me-1"></i>查看详情
                        </a>
                    </div>
                </div>
            </div>
            </c:forEach>
        </div>
    </section>
    </c:if>

    <!-- 按分类展示 -->
    <c:if test="${not empty categories}">
    <c:forEach items="${categories}" var="cat">
    <c:if test="${not empty catProductMap[cat.id]}">
    <section class="mb-5">
        <h3 class="section-title mb-4">
            ${fn:escapeXml(cat.name)}
            <a href="${pageContext.request.contextPath}/product?action=list&categoryId=${cat.id}" class="btn btn-sm btn-outline-secondary float-end rounded-pill">
                查看更多 <i class="bi bi-arrow-right"></i>
            </a>
        </h3>
        <div class="row">
            <c:forEach items="${catProductMap[cat.id]}" var="p" end="3">
            <div class="col-lg-3 col-md-4 col-sm-6 mb-4">
                <div class="card product-card h-100 shadow-sm">
                    <div class="img-wrapper">
                        <c:choose>
                            <c:when test="${not empty p.image}">
                                <img src="${pageContext.request.contextPath}/${p.image}" class="w-100 h-100" alt="${fn:escapeXml(p.name)}" style="object-fit:cover;">
                            </c:when>
                            <c:otherwise>
                                <div class="w-100 h-100 bg-light d-flex align-items-center justify-content-center">
                                    <i class="bi bi-image text-muted" style="font-size:3rem;"></i>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="card-body d-flex flex-column">
                        <h6 class="card-title text-truncate">${fn:escapeXml(p.name)}</h6>
                        <p class="card-text text-danger fw-bold fs-5 mt-auto mb-2">
                            <fmt:formatNumber value="${p.price}" pattern="#,##0.00"/>
                            <small class="text-muted fs-6">元</small>
                        </p>
                        <a href="${pageContext.request.contextPath}/product?action=detail&id=${p.id}" class="btn btn-outline-primary btn-sm">
                            <i class="bi bi-eye me-1"></i>查看详情
                        </a>
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
