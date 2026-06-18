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
    <title>购物车 - 电商平台</title>
    <link href="https://cdn.bootcdn.net/ajax/libs/twitter-bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<%@ include file="header.jsp" %>

<div class="container mt-4">
    <h2 class="mb-4">我的购物车</h2>

    <c:choose>
        <c:when test="${not empty cartItems}">
        <div class="table-responsive">
            <table class="table table-bordered align-middle">
                <thead class="table-dark">
                    <tr>
                        <th style="width:100px;">商品图片</th>
                        <th>商品名称</th>
                        <th style="width:120px;">单价</th>
                        <th style="width:120px;">数量</th>
                        <th style="width:120px;">小计</th>
                        <th style="width:100px;">操作</th>
                    </tr>
                </thead>
                <tbody>
                    <c:set var="grandTotal" value="0"/>
                    <c:forEach items="${cartItems}" var="item">
                    <tr>
                        <td>
                            <c:choose>
                                <c:when test="${not empty item.productImage}">
                                    <img src="${pageContext.request.contextPath}/${item.productImage}" alt="${fn:escapeXml(item.productName)}" style="width:80px;height:80px;object-fit:cover;">
                                </c:when>
                                <c:otherwise>
                                    <div class="bg-light d-flex align-items-center justify-content-center" style="width:80px;height:80px;">
                                        <span class="text-muted small">无图</span>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <a href="${pageContext.request.contextPath}/product?action=detail&id=${item.productId}">${fn:escapeXml(item.productName)}</a>
                        </td>
                        <td class="text-danger fw-bold">
                            <fmt:formatNumber value="${item.productPrice}" pattern="#,##0.00"/>
                        </td>
                        <td>
                            <form action="${pageContext.request.contextPath}/cart" method="post" class="d-flex align-items-center">
                                <input type="hidden" name="action" value="update">
                                <input type="hidden" name="id" value="${item.id}">
                                <input type="number" name="quantity" value="${item.quantity}" min="1" max="${item.productStock}" class="form-control form-control-sm" style="width:70px;" onchange="this.form.submit()">
                            </form>
                        </td>
                        <td class="text-danger fw-bold">
                            <fmt:formatNumber value="${item.subtotal}" pattern="#,##0.00"/>
                        </td>
                        <td>
                            <a href="${pageContext.request.contextPath}/cart?action=delete&id=${item.id}" class="btn btn-danger btn-sm" onclick="return confirm('确定要移除此商品吗？')">删除</a>
                        </td>
                    </tr>
                    <c:set var="grandTotal" value="${grandTotal + item.subtotal}"/>
                    </c:forEach>
                </tbody>
                <tfoot class="table-light">
                    <tr>
                        <td colspan="4" class="text-end fw-bold">总计：</td>
                        <td class="text-danger fw-bold fs-5">
                            <fmt:formatNumber value="${grandTotal}" pattern="#,##0.00"/> 元
                        </td>
                        <td></td>
                    </tr>
                </tfoot>
            </table>
        </div>

        <!-- 结算表单 -->
        <div class="card mt-4">
            <div class="card-header fw-bold">结算信息</div>
            <div class="card-body">
                <form action="${pageContext.request.contextPath}/order?action=create" method="post">
                    <div class="row">
                        <div class="col-md-4 mb-3">
                            <label for="receiverName" class="form-label">收货人 <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" id="receiverName" name="receiverName" value="${sessionScope.user.realName}" required>
                        </div>
                        <div class="col-md-4 mb-3">
                            <label for="receiverPhone" class="form-label">联系电话 <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" id="receiverPhone" name="receiverPhone" value="${sessionScope.user.phone}" required>
                        </div>
                        <div class="col-md-4 mb-3">
                            <label for="receiverAddress" class="form-label">收货地址 <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" id="receiverAddress" name="receiverAddress" value="${sessionScope.user.address}" required>
                        </div>
                    </div>
                    <div class="text-end">
                        <button type="submit" class="btn btn-primary btn-lg">去结算</button>
                    </div>
                </form>
            </div>
        </div>
        </c:when>
        <c:otherwise>
        <div class="alert alert-info text-center py-5">
            <h4>购物车还是空的</h4>
            <p class="mb-3">快去挑选喜欢的商品吧！</p>
            <a href="${pageContext.request.contextPath}/product?action=list" class="btn btn-primary">去逛逛</a>
        </div>
        </c:otherwise>
    </c:choose>
</div>

<%@ include file="footer.jsp" %>
<script src="https://cdn.bootcdn.net/ajax/libs/twitter-bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
</body>
</html>
