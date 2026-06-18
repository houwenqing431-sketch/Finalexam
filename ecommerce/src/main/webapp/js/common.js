/**
 * 电子商务平台 - 通用JavaScript
 */

// 加入购物车
function addToCart(productId, quantity) {
    quantity = parseInt(quantity) || 1;
    if (quantity < 1) quantity = 1;
    if (quantity > 999) quantity = 999;
    var xhr = new XMLHttpRequest();
    xhr.open('POST', contextPath + '/cart?action=add', true);
    xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
    xhr.onreadystatechange = function() {
        if (xhr.readyState === 4) {
            if (xhr.status === 200) {
                alert('已加入购物车！');
            } else {
                alert('操作失败，请重试');
            }
        }
    };
    xhr.send('productId=' + productId + '&quantity=' + quantity);
}

// 从详情页加入购物车（带数量）
function addToCartFromDetail(productId) {
    var quantity = parseInt(document.getElementById('buyQuantity').value) || 1;
    if (quantity < 1) quantity = 1;
    if (quantity > 999) quantity = 999;
    addToCart(productId, quantity);
}

// 切换收藏
function toggleFavorite(productId, isFav) {
    var url;
    if (isFav) {
        url = contextPath + '/favorite?action=deleteByProduct&productId=' + productId;
    } else {
        url = contextPath + '/favorite?action=add&productId=' + productId;
    }
    window.location.href = url;
}

// 购物车数量变更
function updateCartQuantity(id) {
    var qty = parseInt(document.getElementById('qty_' + id).value) || 1;
    if (qty < 1) qty = 1;
    if (qty > 999) qty = 999;
    window.location.href = contextPath + '/cart?action=update&id=' + id + '&quantity=' + qty;
}

// Bootstrap tooltip初始化
document.addEventListener('DOMContentLoaded', function() {
    var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
    tooltipTriggerList.map(function (tooltipTriggerEl) {
        return new bootstrap.Tooltip(tooltipTriggerEl);
    });
});
