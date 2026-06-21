<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="header.jsp" %>
            <h4 class="mb-4"><i class="bi bi-bar-chart me-2"></i>销量统计</h4>

            <div class="row g-4">
                <!-- 按月销售额统计 -->
                <div class="col-lg-8">
                    <div class="card shadow-sm">
                        <div class="card-header">
                            <h5 class="mb-0"><i class="bi bi-calendar3 me-2"></i>按月销售额趋势</h5>
                        </div>
                        <div class="card-body">
                            <c:choose>
                                <c:when test="${not empty salesByMonth}">
                                    <div style="height:300px;"><canvas id="monthlyChart"></canvas></div>
                                </c:when>
                                <c:otherwise>
                                    <p class="text-center text-muted py-4 mb-0">暂无销售数据</p>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>

                <!-- 按分类销售额统计 -->
                <div class="col-lg-4">
                    <div class="card shadow-sm">
                        <div class="card-header">
                            <h5 class="mb-0"><i class="bi bi-pie-chart me-2"></i>按分类销售额占比</h5>
                        </div>
                        <div class="card-body">
                            <c:choose>
                                <c:when test="${not empty salesByCategory}">
                                    <div style="height:300px;"><canvas id="categoryChart"></canvas></div>
                                </c:when>
                                <c:otherwise>
                                    <p class="text-center text-muted py-4 mb-0">暂无分类销售数据</p>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 下方保留数据表格 -->
            <div class="row g-4 mt-2">
                <div class="col-lg-6">
                    <div class="card shadow-sm">
                        <div class="card-header">
                            <h6 class="mb-0">按月销售明细</h6>
                        </div>
                        <div class="table-responsive">
                            <table class="table table-hover mb-0 table-sm">
                                <thead class="table-light">
                                    <tr><th>月份</th><th>销售额</th></tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="row" items="${salesByMonth}">
                                        <tr>
                                            <td>${row[0]}</td>
                                            <td>&yen;<fmt:formatNumber value="${row[1]}" pattern="#,##0.00"/></td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty salesByMonth}">
                                        <tr><td colspan="2" class="text-center text-muted">暂无数据</td></tr>
                                    </c:if>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
                <div class="col-lg-6">
                    <div class="card shadow-sm">
                        <div class="card-header">
                            <h6 class="mb-0">按分类销售明细</h6>
                        </div>
                        <div class="table-responsive">
                            <table class="table table-hover mb-0 table-sm">
                                <thead class="table-light">
                                    <tr><th>分类</th><th>销售额</th></tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="row" items="${salesByCategory}">
                                        <tr>
                                            <td>${row[0]}</td>
                                            <td>&yen;<fmt:formatNumber value="${row[1]}" pattern="#,##0.00"/></td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty salesByCategory}">
                                        <tr><td colspan="2" class="text-center text-muted">暂无数据</td></tr>
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
<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/4.4.0/chart.umd.min.js"></script>

<c:if test="${not empty salesByMonth || not empty salesByCategory}">
<script>
document.addEventListener('DOMContentLoaded', function() {
    if (typeof Chart === 'undefined') {
        console.error('Chart.js 未能加载，请检查网络连接');
        return;
    }

    // 按月销售柱状图
    <c:if test="${not empty salesByMonth}">
    (function() {
        var canvas = document.getElementById('monthlyChart');
        if (!canvas) return;
        var ctx = canvas.getContext('2d');
        new Chart(ctx, {
            type: 'bar',
            data: {
                labels: [<c:forEach var="row" items="${salesByMonth}" varStatus="s">'${row[0]}'${s.last ? '' : ','}</c:forEach>],
                datasets: [{
                    label: '销售额 (元)',
                    data: [<c:forEach var="row" items="${salesByMonth}" varStatus="s">${row[1]}${s.last ? '' : ','}</c:forEach>],
                    backgroundColor: 'rgba(54, 162, 235, 0.7)',
                    borderColor: 'rgba(54, 162, 235, 1)',
                    borderWidth: 1,
                    borderRadius: 4,
                    maxBarThickness: 60
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: { legend: { display: false } },
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: { callback: function(v) { return '¥' + v.toLocaleString(); } }
                    }
                }
            }
        });
    })();
    </c:if>

    // 按分类环形图
    <c:if test="${not empty salesByCategory}">
    (function() {
        var canvas = document.getElementById('categoryChart');
        if (!canvas) return;
        var ctx = canvas.getContext('2d');
        var colors = ['#FF6384','#36A2EB','#FFCE56','#4BC0C0','#9966FF','#FF9F40','#C9CBCF','#5366FF'];
        new Chart(ctx, {
            type: 'doughnut',
            data: {
                labels: [<c:forEach var="row" items="${salesByCategory}" varStatus="s">'${row[0]}'${s.last ? '' : ','}</c:forEach>],
                datasets: [{
                    data: [<c:forEach var="row" items="${salesByCategory}" varStatus="s">${row[1]}${s.last ? '' : ','}</c:forEach>],
                    backgroundColor: colors,
                    borderWidth: 2,
                    borderColor: '#fff'
                }]
            },
            options: {
                responsive: true,
                plugins: { legend: { position: 'bottom' } }
            }
        });
    })();
    </c:if>
});
</script>
</c:if>
</body>
</html>
