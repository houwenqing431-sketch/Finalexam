<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="header.jsp" %>
            <h4 class="mb-4"><i class="bi bi-grid me-2"></i>分类管理</h4>

            <!-- 新增分类表单 -->
            <div class="card shadow-sm mb-4">
                <div class="card-header">
                    <i class="bi bi-plus-circle me-1"></i>新增分类
                </div>
                <div class="card-body">
                    <form method="post" action="${pageContext.request.contextPath}/admin/category" class="row g-3 align-items-end">
                        <input type="hidden" name="action" value="save">
                        <div class="col-md-4">
                            <input type="text" name="name" class="form-control" placeholder="分类名称" required>
                        </div>
                        <div class="col-md-5">
                            <input type="text" name="description" class="form-control" placeholder="分类描述">
                        </div>
                        <div class="col-md-3">
                            <button type="submit" class="btn btn-primary w-100">
                                <i class="bi bi-check-lg"></i> 添加
                            </button>
                        </div>
                    </form>
                </div>
            </div>

            <!-- 分类列表表格 -->
            <div class="card shadow-sm">
                <div class="table-responsive">
                    <table class="table table-hover mb-0">
                        <thead class="table-light">
                            <tr>
                                <th style="width: 60px;">ID</th>
                                <th>分类名称</th>
                                <th>描述</th>
                                <th style="width: 170px;">操作</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="cat" items="${categories}">
                                <tr>
                                    <td>
                                        ${cat.id}
                                        <form id="catForm${cat.id}" method="post" action="${pageContext.request.contextPath}/admin/category">
                                            <input type="hidden" name="action" value="save">
                                            <input type="hidden" name="id" value="${cat.id}">
                                        </form>
                                    </td>
                                    <td>
                                        <input type="text" name="name" form="catForm${cat.id}" class="form-control form-control-sm" value="${fn:escapeXml(cat.name)}">
                                    </td>
                                    <td>
                                        <input type="text" name="description" form="catForm${cat.id}" class="form-control form-control-sm" value="${cat.description}">
                                    </td>
                                    <td>
                                        <button type="submit" form="catForm${cat.id}" class="btn btn-sm btn-outline-primary me-1">
                                            <i class="bi bi-check-lg"></i> 保存
                                        </button>
                                        <a href="${pageContext.request.contextPath}/admin/category?action=delete&id=${cat.id}" class="btn btn-sm btn-outline-danger" onclick="return confirm('确认删除？')">
                                            <i class="bi bi-trash"></i> 删除
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty categories}">
                                <tr>
                                    <td colspan="4" class="text-center text-muted py-4">暂无分类数据</td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>
<script src="https://cdn.bootcdn.net/ajax/libs/twitter-bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
</body>
</html>
