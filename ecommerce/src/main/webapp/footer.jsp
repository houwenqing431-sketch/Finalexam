<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<footer class="bg-dark text-light pt-5 pb-3 mt-5">
    <div class="container">
        <div class="row g-4">
            <div class="col-lg-4">
                <h5 class="mb-3"><i class="bi bi-shop me-2"></i>电商平台</h5>
                <p class="text-secondary">海量商品，优质低价<br>为您提供最好的购物体验</p>
            </div>
            <div class="col-lg-4">
                <h6 class="mb-3">快速链接</h6>
                <ul class="list-unstyled">
                    <li class="mb-2"><a href="${pageContext.request.contextPath}/index.jsp" class="text-secondary text-decoration-none"><i class="bi bi-chevron-right me-1"></i>首页</a></li>
                    <li class="mb-2"><a href="${pageContext.request.contextPath}/product?action=list" class="text-secondary text-decoration-none"><i class="bi bi-chevron-right me-1"></i>商品列表</a></li>
                    <li><a href="${pageContext.request.contextPath}/cart" class="text-secondary text-decoration-none"><i class="bi bi-chevron-right me-1"></i>购物车</a></li>
                </ul>
            </div>
            <div class="col-lg-4">
                <h6 class="mb-3">联系我们</h6>
                <ul class="list-unstyled text-secondary">
                    <li class="mb-2"><i class="bi bi-envelope me-2"></i>support@ecommerce.com</li>
                    <li class="mb-2"><i class="bi bi-telephone me-2"></i>400-888-8888</li>
                    <li><i class="bi bi-clock me-2"></i>周一至周日 9:00-21:00</li>
                </ul>
            </div>
        </div>
        <hr class="border-secondary mt-4">
        <div class="text-center text-secondary">
            <small>&copy; 2026 电子商务平台 版权所有</small>
        </div>
    </div>
</footer>
