<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:if test="${sessionScope.user == null}">
    <c:redirect url="${pageContext.request.contextPath}/login"/>
</c:if>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>我的订单 - 电商平台</title>
    <link href="https://cdn.bootcdn.net/ajax/libs/twitter-bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<%@ include file="header.jsp" %>

<div class="container mt-4">
    <h2 class="mb-4">我的订单</h2>

    <c:choose>
        <c:when test="${not empty orders}">
        <div class="table-responsive">
            <table class="table table-bordered table-hover align-middle">
                <thead class="table-dark">
                    <tr>
                        <th>订单编号</th>
                        <th>下单时间</th>
                        <th>总金额</th>
                        <th>状态</th>
                        <th>操作</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${orders}" var="order">
                    <tr>
                        <td>${order.orderNo}</td>
                        <td><fmt:formatDate value="${order.createTime}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
                        <td class="text-danger fw-bold">
                            <fmt:formatNumber value="${order.totalAmount}" pattern="#,##0.00"/> 元
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${order.status == 0}"><span class="badge bg-warning text-dark">待付款</span></c:when>
                                <c:when test="${order.status == 1}"><span class="badge bg-info">已付款</span></c:when>
                                <c:when test="${order.status == 2}"><span class="badge bg-primary">已发货</span></c:when>
                                <c:when test="${order.status == 3}"><span class="badge bg-success">已完成</span></c:when>
                                <c:when test="${order.status == 4}"><span class="badge bg-secondary">已取消</span></c:when>
                                <c:otherwise><span class="badge bg-secondary">未知</span></c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <a href="${pageContext.request.contextPath}/order?action=detail&id=${order.id}" class="btn btn-outline-primary btn-sm">查看详情</a>
                            <c:if test="${order.status == 0}">
                                <a href="${pageContext.request.contextPath}/order?action=pay&id=${order.id}" class="btn btn-success btn-sm" onclick="return confirm('确认支付此订单吗？')">去支付</a>
                            </c:if>
                        </td>
                    </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>

        <!-- 分页导航 -->
        <c:if test="${totalPages > 1}">
        <nav aria-label="分页导航" class="mt-4">
            <ul class="pagination justify-content-center">
                <li class="page-item <c:if test="${page <= 1}">disabled</c:if>">
                    <a class="page-link" href="${pageContext.request.contextPath}/order?action=list&page=${page - 1}">上一页</a>
                </li>
                <c:forEach begin="1" end="${totalPages}" var="i">
                    <li class="page-item <c:if test="${page == i}">active</c:if>">
                        <a class="page-link" href="${pageContext.request.contextPath}/order?action=list&page=${i}">${i}</a>
                    </li>
                </c:forEach>
                <li class="page-item <c:if test="${page >= totalPages}">disabled</c:if>">
                    <a class="page-link" href="${pageContext.request.contextPath}/order?action=list&page=${page + 1}">下一页</a>
                </li>
            </ul>
        </nav>
        </c:if>
        </c:when>
        <c:otherwise>
        <div class="alert alert-info text-center py-5">
            <h4>暂无订单</h4>
            <p class="mb-3">赶紧去下单吧！</p>
            <a href="${pageContext.request.contextPath}/product?action=list" class="btn btn-primary">去逛逛</a>
        </div>
        </c:otherwise>
    </c:choose>
</div>

<%@ include file="footer.jsp" %>
<script src="https://cdn.bootcdn.net/ajax/libs/twitter-bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
</body>
</html>
