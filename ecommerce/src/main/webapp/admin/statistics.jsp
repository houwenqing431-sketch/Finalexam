<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="header.jsp" %>
            <h4 class="mb-4"><i class="bi bi-bar-chart me-2"></i>销量统计</h4>

            <div class="row g-4">
                <!-- 按月销售额统计 -->
                <div class="col-md-6">
                    <div class="card shadow-sm">
                        <div class="card-header">
                            <h5 class="mb-0"><i class="bi bi-calendar3 me-2"></i>按月销售额统计</h5>
                        </div>
                        <div class="table-responsive">
                            <table class="table table-hover mb-0">
                                <thead class="table-light">
                                    <tr>
                                        <th>月份</th>
                                        <th>销售额</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="row" items="${salesByMonth}">
                                        <tr>
                                            <td>${row[0]}</td>
                                            <td>&yen;<fmt:formatNumber value="${row[1]}" pattern="#,##0.00"/></td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty salesByMonth}">
                                        <tr>
                                            <td colspan="2" class="text-center text-muted py-4">暂无销售数据</td>
                                        </tr>
                                    </c:if>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <!-- 按分类销售额统计 -->
                <div class="col-md-6">
                    <div class="card shadow-sm">
                        <div class="card-header">
                            <h5 class="mb-0"><i class="bi bi-grid me-2"></i>按分类销售额统计</h5>
                        </div>
                        <div class="table-responsive">
                            <table class="table table-hover mb-0">
                                <thead class="table-light">
                                    <tr>
                                        <th>分类名称</th>
                                        <th>销售额</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="row" items="${salesByCategory}">
                                        <tr>
                                            <td>${row[0]}</td>
                                            <td>&yen;<fmt:formatNumber value="${row[1]}" pattern="#,##0.00"/></td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty salesByCategory}">
                                        <tr>
                                            <td colspan="2" class="text-center text-muted py-4">暂无分类销售数据</td>
                                        </tr>
                                    </c:if>
                                </tbody>
                            </table>
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
