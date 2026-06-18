<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="header.jsp" %>
            <c:choose>
                <c:when test="${empty product}">
                    <h4 class="mb-4"><i class="bi bi-plus-circle me-2"></i>新增商品</h4>
                </c:when>
                <c:otherwise>
                    <h4 class="mb-4"><i class="bi bi-pencil-square me-2"></i>编辑商品</h4>
                </c:otherwise>
            </c:choose>

            <div class="card shadow-sm">
                <div class="card-body">
                    <form method="post" action="${pageContext.request.contextPath}/admin/product" enctype="multipart/form-data">
                        <input type="hidden" name="action" value="save">
                        <c:if test="${not empty product}">
                            <input type="hidden" name="id" value="${product.id}">
                            <input type="hidden" name="oldImage" value="${product.image}">
                        </c:if>

                        <div class="row g-3 mb-3">
                            <div class="col-md-6">
                                <label for="name" class="form-label">商品名称 <span class="text-danger">*</span></label>
                                <input type="text" class="form-control" id="name" name="name" value="${fn:escapeXml(product.name)}" required>
                            </div>
                            <div class="col-md-6">
                                <label for="categoryId" class="form-label">所属分类 <span class="text-danger">*</span></label>
                                <select class="form-select" id="categoryId" name="categoryId" required>
                                    <option value="">请选择分类</option>
                                    <c:forEach var="cat" items="${categories}">
                                        <option value="${cat.id}" ${product.categoryId == cat.id ? 'selected' : ''}>${fn:escapeXml(cat.name)}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>

                        <div class="row g-3 mb-3">
                            <div class="col-md-4">
                                <label for="price" class="form-label">价格 <span class="text-danger">*</span></label>
                                <div class="input-group">
                                    <span class="input-group-text">&yen;</span>
                                    <input type="number" step="0.01" min="0" class="form-control" id="price" name="price" value="${product.price}" required>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <label for="stock" class="form-label">库存 <span class="text-danger">*</span></label>
                                <input type="number" min="0" class="form-control" id="stock" name="stock" value="${product.stock}" required>
                            </div>
                            <div class="col-md-4">
                                <label for="imageFile" class="form-label">商品图片</label>
                                <input type="file" class="form-control" id="imageFile" name="imageFile" accept="image/*">
                                <c:if test="${not empty product.image}">
                                    <div class="mt-2">
                                        <img src="${pageContext.request.contextPath}/${product.image}" style="width:80px;height:80px;object-fit:cover;" class="rounded border">
                                        <small class="text-muted ms-2">当前图片，上传新图将覆盖</small>
                                    </div>
                                </c:if>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label for="description" class="form-label">商品描述</label>
                            <textarea class="form-control" id="description" name="description" rows="4">${product.description}</textarea>
                        </div>

                        <div class="mb-3">
                            <label class="form-label d-block">商品状态</label>
                            <div class="form-check form-check-inline">
                                <input class="form-check-input" type="radio" name="status" id="statusOn" value="1" ${product.status != 0 ? 'checked' : ''}>
                                <label class="form-check-label" for="statusOn">上架</label>
                            </div>
                            <div class="form-check form-check-inline">
                                <input class="form-check-input" type="radio" name="status" id="statusOff" value="0" ${product.status == 0 ? 'checked' : ''}>
                                <label class="form-check-label" for="statusOff">下架</label>
                            </div>
                        </div>

                        <div class="border-top pt-3">
                            <button type="submit" class="btn btn-primary">
                                <i class="bi bi-check-lg"></i> 保存
                            </button>
                            <a href="${pageContext.request.contextPath}/admin/product?action=list" class="btn btn-secondary">
                                <i class="bi bi-arrow-left"></i> 返回
                            </a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
<script src="https://cdn.bootcdn.net/ajax/libs/twitter-bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
</body>
</html>
