<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="header.jsp" %>
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h4><i class="bi bi-box-seam me-2"></i>商品管理</h4>
                <a href="${pageContext.request.contextPath}/admin/product?action=add" class="btn btn-primary">
                    <i class="bi bi-plus-lg"></i> 新增商品
                </a>
            </div>

            <!-- 搜索和筛选工具栏 -->
            <div class="card shadow-sm mb-4">
                <div class="card-body">
                    <form method="get" action="${pageContext.request.contextPath}/admin/product" class="row g-3">
                        <input type="hidden" name="action" value="list">
                        <div class="col-md-4">
                            <input type="text" name="keyword" class="form-control" placeholder="搜索商品名称或描述" value="${keyword}">
                        </div>
                        <div class="col-md-3">
                            <select name="categoryId" class="form-select">
                                <option value="0">全部分类</option>
                                <c:forEach var="cat" items="${categories}">
                                    <option value="${cat.id}" ${categoryId == cat.id ? 'selected' : ''}>${fn:escapeXml(cat.name)}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-2">
                            <button type="submit" class="btn btn-outline-primary w-100">
                                <i class="bi bi-search"></i> 搜索
                            </button>
                        </div>
                    </form>
                </div>
            </div>

            <!-- 商品表格 -->
            <div class="card shadow-sm">
                <div class="table-responsive">
                    <table class="table table-hover mb-0">
                        <thead class="table-light">
                            <tr>
                                <th style="width: 60px;">ID</th>
                                <th style="width: 80px;">图片</th>
                                <th>商品名称</th>
                                <th>分类</th>
                                <th>价格</th>
                                <th>库存</th>
                                <th>状态</th>
                                <th style="width: 180px;">操作</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="product" items="${products}">
                                <tr>
                                    <td>${product.id}</td>
                                    <td>
                                        <c:if test="${not empty product.image}">
                                            <img src="${pageContext.request.contextPath}/${product.image}" alt="${fn:escapeXml(product.name)}" class="rounded" style="width: 50px; height: 50px; object-fit: cover;">
                                        </c:if>
                                        <c:if test="${empty product.image}">
                                            <div class="bg-light rounded d-flex align-items-center justify-content-center" style="width: 50px; height: 50px;">
                                                <i class="bi bi-image text-muted"></i>
                                            </div>
                                        </c:if>
                                    </td>
                                    <td>${fn:escapeXml(product.name)}</td>
                                    <td>${product.categoryName}</td>
                                    <td>&yen;<fmt:formatNumber value="${product.price}" pattern="#,##0.00"/></td>
                                    <td>${product.stock}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${product.status == 1}">
                                                <span class="badge bg-success">上架</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-secondary">下架</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/admin/product?action=edit&id=${product.id}" class="btn btn-sm btn-outline-primary">
                                            <i class="bi bi-pencil"></i> 编辑
                                        </a>
                                        <a href="${pageContext.request.contextPath}/admin/product?action=delete&id=${product.id}" class="btn btn-sm btn-outline-danger" onclick="return confirm('确认删除？')">
                                            <i class="bi bi-trash"></i> 删除
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty products}">
                                <tr>
                                    <td colspan="8" class="text-center text-muted py-4">暂无商品数据</td>
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
                            <a class="page-link" href="${pageContext.request.contextPath}/admin/product?action=list&page=${currentPage - 1}&categoryId=${categoryId}&keyword=${keyword}">上一页</a>
                        </li>
                        <c:forEach var="i" begin="1" end="${totalPages}">
                            <li class="page-item ${i == currentPage ? 'active' : ''}">
                                <a class="page-link" href="${pageContext.request.contextPath}/admin/product?action=list&page=${i}&categoryId=${categoryId}&keyword=${keyword}">${i}</a>
                            </li>
                        </c:forEach>
                        <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                            <a class="page-link" href="${pageContext.request.contextPath}/admin/product?action=list&page=${currentPage + 1}&categoryId=${categoryId}&keyword=${keyword}">下一页</a>
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
