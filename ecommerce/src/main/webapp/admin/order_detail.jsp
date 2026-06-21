<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="header.jsp" %>
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h4><i class="bi bi-receipt me-2"></i>订单详情</h4>
                <a href="${pageContext.request.contextPath}/admin/order?action=list" class="btn btn-secondary">
                    <i class="bi bi-arrow-left"></i> 返回订单列表
                </a>
            </div>

            <c:if test="${not empty order}">
                <!-- 订单基本信息 -->
                <div class="card shadow-sm mb-4">
                    <div class="card-header">
                        <h5 class="mb-0">订单信息</h5>
                    </div>
                    <div class="card-body">
                        <div class="row g-3 mb-3">
                            <div class="col-md-6">
                                <label class="form-label text-muted">订单编号</label>
                                <div><code>${order.orderNo}</code></div>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label text-muted">用户名</label>
                                <div>${order.username}</div>
                            </div>
                        </div>
                        <div class="row g-3 mb-3">
                            <div class="col-md-6">
                                <label class="form-label text-muted">总金额</label>
                                <div class="fw-bold text-danger fs-5">&yen;<fmt:formatNumber value="${order.totalAmount}" pattern="#,##0.00"/></div>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label text-muted">订单状态</label>
                                <div>
                                    <form method="get" action="${pageContext.request.contextPath}/admin/order" class="d-flex gap-2 align-items-center">
                                        <input type="hidden" name="action" value="status">
                                        <input type="hidden" name="id" value="${order.id}">
                                        <select name="status" class="form-select form-select-sm" style="width: auto;" onchange="if(confirm('确定要修改订单状态吗？')) this.form.submit()">
                                            <option value="0" ${order.status == 0 ? 'selected' : ''}>待付款</option>
                                            <option value="1" ${order.status == 1 ? 'selected' : ''}>已付款</option>
                                            <option value="2" ${order.status == 2 ? 'selected' : ''}>已发货</option>
                                            <option value="3" ${order.status == 3 ? 'selected' : ''}>已完成</option>
                                            <option value="4" ${order.status == 4 ? 'selected' : ''}>已取消</option>
                                        </select>
                                    </form>
                                </div>
                            </div>
                        </div>
                        <div class="row g-3 mb-3">
                            <div class="col-md-6">
                                <label class="form-label text-muted">创建时间</label>
                                <div><fmt:formatDate value="${order.createTime}" pattern="yyyy-MM-dd HH:mm:ss"/></div>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label text-muted">付款时间</label>
                                <div>
                                    <c:choose>
                                        <c:when test="${not empty order.payTime}">
                                            <fmt:formatDate value="${order.payTime}" pattern="yyyy-MM-dd HH:mm:ss"/>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text-muted">未付款</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- 收货信息 -->
                <div class="card shadow-sm mb-4">
                    <div class="card-header">
                        <h5 class="mb-0">收货信息</h5>
                    </div>
                    <div class="card-body">
                        <div class="row g-3">
                            <div class="col-md-4">
                                <label class="form-label text-muted">收货人</label>
                                <div>${order.receiverName}</div>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label text-muted">联系电话</label>
                                <div>${order.receiverPhone}</div>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label text-muted">收货地址</label>
                                <div>${order.receiverAddress}</div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- 订单明细 -->
                <div class="card shadow-sm mb-4">
                    <div class="card-header">
                        <h5 class="mb-0">订单明细</h5>
                    </div>
                    <div class="table-responsive">
                        <table class="table table-hover mb-0">
                            <thead class="table-light">
                                <tr>
                                    <th>商品名称</th>
                                    <th>单价</th>
                                    <th>数量</th>
                                    <th>小计</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="item" items="${items}">
                                    <tr>
                                        <td>${item.productName}</td>
                                        <td>&yen;<fmt:formatNumber value="${item.productPrice}" pattern="#,##0.00"/></td>
                                        <td>${item.quantity}</td>
                                        <td>&yen;<fmt:formatNumber value="${item.subtotal}" pattern="#,##0.00"/></td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty items}">
                                    <tr>
                                        <td colspan="4" class="text-center text-muted py-4">暂无明细数据</td>
                                    </tr>
                                </c:if>
                            </tbody>
                            <tfoot class="table-light">
                                <tr>
                                    <td colspan="3" class="text-end fw-bold">合计：</td>
                                    <td class="fw-bold text-danger">&yen;<fmt:formatNumber value="${order.totalAmount}" pattern="#,##0.00"/></td>
                                </tr>
                            </tfoot>
                        </table>
                    </div>
                </div>
            </c:if>

            <div class="text-center mt-4">
                <a href="${pageContext.request.contextPath}/admin/order?action=list" class="btn btn-secondary">
                    <i class="bi bi-arrow-left"></i> 返回订单列表
                </a>
            </div>
        </div>
    </div>
</div>
<script src="https://cdn.bootcdn.net/ajax/libs/twitter-bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
</body>
</html>
