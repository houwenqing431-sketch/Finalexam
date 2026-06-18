<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="header.jsp" %>
            <h4 class="mb-4"><i class="bi bi-people me-2"></i>用户管理</h4>

            <!-- 用户表格 -->
            <div class="card shadow-sm">
                <div class="table-responsive">
                    <table class="table table-hover mb-0">
                        <thead class="table-light">
                            <tr>
                                <th style="width: 60px;">ID</th>
                                <th>用户名</th>
                                <th>真实姓名</th>
                                <th>邮箱</th>
                                <th>电话</th>
                                <th>角色</th>
                                <th>状态</th>
                                <th>注册时间</th>
                                <th style="width: 120px;">操作</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="u" items="${users}">
                                <tr>
                                    <td>${u.id}</td>
                                    <td>${fn:escapeXml(u.username)}</td>
                                    <td>${fn:escapeXml(u.realName)}</td>
                                    <td>${u.email}</td>
                                    <td>${u.phone}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${u.role == 1}">
                                                <span class="badge bg-danger">管理员</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-secondary">普通用户</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${u.status == 1}">
                                                <span class="badge bg-success">正常</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-danger">禁用</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td><fmt:formatDate value="${u.createTime}" pattern="yyyy-MM-dd HH:mm"/></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${u.status == 1}">
                                                <a href="${pageContext.request.contextPath}/admin/user?action=status&id=${u.id}&status=0" class="btn btn-sm btn-outline-danger" onclick="return confirm('确认禁用该用户？')">
                                                    <i class="bi bi-lock"></i> 禁用
                                                </a>
                                            </c:when>
                                            <c:otherwise>
                                                <a href="${pageContext.request.contextPath}/admin/user?action=status&id=${u.id}&status=1" class="btn btn-sm btn-outline-success" onclick="return confirm('确认启用该用户？')">
                                                    <i class="bi bi-unlock"></i> 启用
                                                </a>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty users}">
                                <tr>
                                    <td colspan="9" class="text-center text-muted py-4">暂无用户数据</td>
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
                            <a class="page-link" href="${pageContext.request.contextPath}/admin/user?action=list&page=${currentPage - 1}">上一页</a>
                        </li>
                        <c:forEach var="i" begin="1" end="${totalPages}">
                            <li class="page-item ${i == currentPage ? 'active' : ''}">
                                <a class="page-link" href="${pageContext.request.contextPath}/admin/user?action=list&page=${i}">${i}</a>
                            </li>
                        </c:forEach>
                        <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                            <a class="page-link" href="${pageContext.request.contextPath}/admin/user?action=list&page=${currentPage + 1}">下一页</a>
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
