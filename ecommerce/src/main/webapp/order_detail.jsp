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
    <title>订单详情 - 电商平台</title>
    <link href="https://cdn.bootcdn.net/ajax/libs/twitter-bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<%@ include file="header.jsp" %>

<div class="container mt-4">
    <c:choose>
        <c:when test="${not empty order}">
        <h2 class="mb-3">订单详情</h2>
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/index.jsp">首页</a></li>
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/order?action=list">我的订单</a></li>
                <li class="breadcrumb-item active">订单详情</li>
            </ol>
        </nav>

        <!-- 订单基本信息 -->
        <div class="card mb-4">
            <div class="card-header fw-bold">基本信息</div>
            <div class="card-body">
                <div class="row">
                    <div class="col-md-6">
                        <table class="table table-borderless mb-0">
                            <tr>
                                <td class="text-muted" style="width:100px;">订单编号：</td>
                                <td>${fn:escapeXml(order.orderNo)}</td>
                            </tr>
                            <tr>
                                <td class="text-muted">订单状态：</td>
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
                            </tr>
                            <tr>
                                <td class="text-muted">下单时间：</td>
                                <td><fmt:formatDate value="${order.createTime}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
                            </tr>
                            <c:if test="${not empty order.payTime}">
                            <tr>
                                <td class="text-muted">付款时间：</td>
                                <td><fmt:formatDate value="${order.payTime}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
                            </tr>
                            </c:if>
                        </table>
                    </div>
                    <div class="col-md-6">
                        <table class="table table-borderless mb-0">
                            <tr>
                                <td class="text-muted" style="width:100px;">收货人：</td>
                                <td>${fn:escapeXml(order.receiverName)}</td>
                            </tr>
                            <tr>
                                <td class="text-muted">联系电话：</td>
                                <td>${order.receiverPhone}</td>
                            </tr>
                            <tr>
                                <td class="text-muted">收货地址：</td>
                                <td>${fn:escapeXml(order.receiverAddress)}</td>
                            </tr>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <!-- 订单明细 -->
        <div class="card mb-4">
            <div class="card-header fw-bold">商品明细</div>
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-bordered align-middle">
                        <thead class="table-light">
                            <tr>
                                <th>商品名称</th>
                                <th style="width:120px;">单价</th>
                                <th style="width:100px;">数量</th>
                                <th style="width:120px;">小计</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${order.items}" var="item">
                            <tr>
                                <td>${fn:escapeXml(item.productName)}</td>
                                <td><fmt:formatNumber value="${item.productPrice}" pattern="#,##0.00"/> 元</td>
                                <td>${item.quantity}</td>
                                <td class="text-danger fw-bold"><fmt:formatNumber value="${item.subtotal}" pattern="#,##0.00"/> 元</td>
                            </tr>
                            </c:forEach>
                        </tbody>
                        <tfoot class="table-light">
                            <tr>
                                <td colspan="3" class="text-end fw-bold">总金额：</td>
                                <td class="text-danger fw-bold fs-5">
                                    <fmt:formatNumber value="${order.totalAmount}" pattern="#,##0.00"/> 元
                                </td>
                            </tr>
                        </tfoot>
                    </table>
                </div>
            </div>
        </div>

        <div class="mb-4">
            <a href="${pageContext.request.contextPath}/order?action=list" class="btn btn-secondary">返回订单列表</a>
            <c:if test="${order.status == 0}">
                <a href="${pageContext.request.contextPath}/order?action=pay&id=${order.id}" class="btn btn-success ms-2" onclick="return confirm('确认支付此订单吗？')">去支付</a>
            </c:if>
        </div>
        </c:when>
        <c:otherwise>
        <div class="alert alert-warning text-center py-5">
            <h4>订单不存在</h4>
            <p class="mb-3">该订单可能已被删除或您无权查看。</p>
            <a href="${pageContext.request.contextPath}/order?action=list" class="btn btn-primary">返回订单列表</a>
        </div>
        </c:otherwise>
    </c:choose>
</div>

<%@ include file="footer.jsp" %>
<script src="https://cdn.bootcdn.net/ajax/libs/twitter-bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
</body>
</html>
