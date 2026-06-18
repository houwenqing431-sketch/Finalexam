<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.ecommerce.dao.ProductDao" %>
<%@ page import="com.ecommerce.dao.UserDao" %>
<%@ page import="com.ecommerce.dao.OrderDao" %>
<%@ include file="header.jsp" %>
<%
    ProductDao productDao = new ProductDao();
    UserDao userDao = new UserDao();
    OrderDao orderDao = new OrderDao();
    int productCount = productDao.count(0, "");
    int userCount = userDao.count();
    int orderCount = orderDao.countAll("", "");
%>
            <h4 class="mb-4"><i class="bi bi-speedometer2 me-2"></i>管理后台首页</h4>
            <p class="text-muted mb-4">欢迎回来，<strong>${sessionScope.user.username}</strong>！以下是系统概览：</p>

            <div class="row g-4 mb-4">
                <div class="col-md-4">
                    <div class="card text-white bg-primary shadow-sm">
                        <div class="card-body">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <h6 class="card-title mb-1">商品总数</h6>
                                    <h2 class="mb-0"><%= productCount %></h2>
                                </div>
                                <i class="bi bi-box-seam" style="font-size: 2.5rem; opacity: 0.5;"></i>
                            </div>
                        </div>
                        <div class="card-footer bg-transparent border-top border-light border-opacity-25">
                            <a href="${pageContext.request.contextPath}/admin/product?action=list" class="text-white text-decoration-none small">查看详情 <i class="bi bi-arrow-right"></i></a>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card text-white bg-success shadow-sm">
                        <div class="card-body">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <h6 class="card-title mb-1">用户总数</h6>
                                    <h2 class="mb-0"><%= userCount %></h2>
                                </div>
                                <i class="bi bi-people" style="font-size: 2.5rem; opacity: 0.5;"></i>
                            </div>
                        </div>
                        <div class="card-footer bg-transparent border-top border-light border-opacity-25">
                            <a href="${pageContext.request.contextPath}/admin/user?action=list" class="text-white text-decoration-none small">查看详情 <i class="bi bi-arrow-right"></i></a>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card text-white bg-warning shadow-sm">
                        <div class="card-body">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <h6 class="card-title mb-1">订单总数</h6>
                                    <h2 class="mb-0"><%= orderCount %></h2>
                                </div>
                                <i class="bi bi-cart3" style="font-size: 2.5rem; opacity: 0.5;"></i>
                            </div>
                        </div>
                        <div class="card-footer bg-transparent border-top border-light border-opacity-25">
                            <a href="${pageContext.request.contextPath}/admin/order?action=list" class="text-white text-decoration-none small">查看详情 <i class="bi bi-arrow-right"></i></a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<script src="https://cdn.bootcdn.net/ajax/libs/twitter-bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
</body>
</html>
