package com.ecommerce.bean;

import java.util.Date;

/**
 * 购物车实体类
 */
public class CartItem {
    private int id;
    private int userId;
    private int productId;
    private int quantity;
    private Date createTime;

    // 关联查询字段
    private String productName;
    private double productPrice;
    private String productImage;
    private int productStock;

    public CartItem() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    public int getProductId() { return productId; }
    public void setProductId(int productId) { this.productId = productId; }
    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
    public Date getCreateTime() { return createTime; }
    public void setCreateTime(Date createTime) { this.createTime = createTime; }
    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }
    public double getProductPrice() { return productPrice; }
    public void setProductPrice(double productPrice) { this.productPrice = productPrice; }
    public String getProductImage() { return productImage; }
    public void setProductImage(String productImage) { this.productImage = productImage; }
    public int getProductStock() { return productStock; }
    public void setProductStock(int productStock) { this.productStock = productStock; }

    /**
     * 计算小计
     */
    public double getSubtotal() {
        return productPrice * quantity;
    }
}
