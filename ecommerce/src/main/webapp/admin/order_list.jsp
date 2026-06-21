<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="header.jsp" %>
            <h4 class="mb-4"><i class="bi bi-cart3 me-2"></i>订单管理</h4>

            <!-- 筛选栏 -->
            <div class="card shadow-sm mb-4">
                <div class="card-body">
                    <form method="get" action="${pageContext.request.contextPath}/admin/order" class="row g-3">
                        <input type="hidden" name="action" value="list">
                        <div class="col-md-3">
                            <select name="status" class="form-select">
                                <option value="">全部状态</option>
                                <option value="0" ${status == '0' ? 'selected' : ''}>待付款</option>
                                <option value="1" ${status == '1' ? 'selected' : ''}>已付款</option>
                                <option value="2" ${status == '2' ? 'selected' : ''}>已发货</option>
                                <option value="3" ${status == '3' ? 'selected' : ''}>已完成</option>
                                <option value="4" ${status == '4' ? 'selected' : ''}>已取消</option>
                            </select>
                        </div>
                        <div class="col-md-4">
                            <input type="text" name="keyword" class="form-control" placeholder="搜索订单编号或用户名" value="${keyword}">
                        </div>
                        <div class="col-md-2">
                            <button type="submit" class="btn btn-outline-primary w-100">
                                <i class="bi bi-search"></i> 搜索
                            </button>
                        </div>
                    </form>
                </div>
            </div>

            <!-- 订单表格 -->
            <div class="card shadow-sm">
                <div class="table-responsive">
                    <table class="table table-hover mb-0">
                        <thead class="table-light">
                            <tr>
                                <th>订单编号</th>
                                <th>用户名</th>
                                <th>总金额</th>
                                <th>状态</th>
                                <th>下单时间</th>
                                <th style="width: 220px;">操作</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="order" items="${orders}">
                                <tr>
                                    <td><code>${order.orderNo}</code></td>
                                    <td>${order.username}</td>
                                    <td>&yen;<fmt:formatNumber value="${order.totalAmount}" pattern="#,##0.00"/></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${order.status == 0}">
                                                <span class="badge bg-secondary">待付款</span>
                                            </c:when>
                                            <c:when test="${order.status == 1}">
                                                <span class="badge bg-info">已付款</span>
                                            </c:when>
                                            <c:when test="${order.status == 2}">
                                                <span class="badge bg-primary">已发货</span>
                                            </c:when>
                                            <c:when test="${order.status == 3}">
                                                <span class="badge bg-success">已完成</span>
                                            </c:when>
                                            <c:when test="${order.status == 4}">
                                                <span class="badge bg-danger">已取消</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-dark">未知</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td><fmt:formatDate value="${order.createTime}" pattern="yyyy-MM-dd HH:mm"/></td>
                                    <td>
                                        <div class="d-flex gap-1">
                                            <a href="${pageContext.request.contextPath}/admin/order?action=detail&id=${order.id}" class="btn btn-sm btn-outline-info">
                                                <i class="bi bi-eye"></i> 详情
                                            </a>
                                            <select class="form-select form-select-sm" style="width: auto;" onchange="if(this.value && confirm('确定要修改订单状态吗？')) location.href='${pageContext.request.contextPath}/admin/order?action=status&id=${order.id}&status='+this.value; else this.value=''">
                                                <option value="">修改状态</option>
                                                <option value="0">待付款</option>
                                                <option value="1">已付款</option>
                                                <option value="2">已发货</option>
                                                <option value="3">已完成</option>
                                                <option value="4">已取消</option>
                                            </select>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty orders}">
                                <tr>
                                    <td colspan="6" class="text-center text-muted py-4">暂无订单数据</td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- 分页导航 -->
            <c:if test="${totalPages > 1}">
                <nav class="mt-4">
                    <ul class="pagination justify-content-center">
                        <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                            <a class="page-link" href="${pageContext.request.contextPath}/admin/order?action=list&page=${currentPage - 1}&status=${status}&keyword=${keyword}">上一页</a>
                        </li>
                        <c:forEach var="i" begin="1" end="${totalPages}">
                            <li class="page-item ${i == currentPage ? 'active' : ''}">
                                <a class="page-link" href="${pageContext.request.contextPath}/admin/order?action=list&page=${i}&status=${status}&keyword=${keyword}">${i}</a>
                            </li>
                        </c:forEach>
                        <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                            <a class="page-link" href="${pageContext.request.contextPath}/admin/order?action=list&page=${currentPage + 1}&status=${status}&keyword=${keyword}">下一页</a>
                        </li>
                    </ul>
                </nav>
            </c:if>
        </div>
    </div>
</div>
<script src="https://cdn.bootcdn.net/ajax/libs/twitter-bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
</body>
</html>
