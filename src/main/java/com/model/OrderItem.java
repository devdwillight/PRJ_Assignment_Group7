/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.model;

import jakarta.persistence.Basic;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.NamedQueries;
import jakarta.persistence.NamedQuery;
import jakarta.persistence.Table;
import jakarta.persistence.Temporal;
import jakarta.persistence.TemporalType;
import jakarta.xml.bind.annotation.XmlRootElement;
import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;

/**
 *
 * @author DELL
 */
@Entity
@Table(name = "Order_Item")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "OrderItem.findAll", query = "SELECT o FROM OrderItem o"),
    @NamedQuery(name = "OrderItem.findByIdOrderItem", query = "SELECT o FROM OrderItem o WHERE o.idOrderItem = :idOrderItem"),
    @NamedQuery(name = "OrderItem.findByPrice", query = "SELECT o FROM OrderItem o WHERE o.price = :price"),
    @NamedQuery(name = "OrderItem.findByDiscount", query = "SELECT o FROM OrderItem o WHERE o.discount = :discount"),
    @NamedQuery(name = "OrderItem.findByCreatedAt", query = "SELECT o FROM OrderItem o WHERE o.createdAt = :createdAt")})
public class OrderItem implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    @Column(name = "id_order_item")
    private Integer idOrderItem;
    // @Max(value=?)  @Min(value=?)//if you know range of your decimal fields consider using these annotations to enforce field validation
    @Column(name = "price")
    private BigDecimal price;
    @Column(name = "discount")
    private BigDecimal discount;
    @Column(name = "created_at")
    @Temporal(TemporalType.TIMESTAMP)
    private Date createdAt;
    @JoinColumn(name = "id_course", referencedColumnName = "id_course")
    @ManyToOne(optional = false)
    private Course idCourse;
    @JoinColumn(name = "id_order", referencedColumnName = "id_order")
    @ManyToOne(optional = false)
    private Orders idOrder;

    public OrderItem() {
    }

    public OrderItem(Integer idOrderItem) {
        this.idOrderItem = idOrderItem;
    }

    public Integer getIdOrderItem() {
        return idOrderItem;
    }

    public void setIdOrderItem(Integer idOrderItem) {
        this.idOrderItem = idOrderItem;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public BigDecimal getDiscount() {
        return discount;
    }

    public void setDiscount(BigDecimal discount) {
        this.discount = discount;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public Course getIdCourse() {
        return idCourse;
    }

    public void setIdCourse(Course idCourse) {
        this.idCourse = idCourse;
    }

    public Orders getIdOrder() {
        return idOrder;
    }

    public void setIdOrder(Orders idOrder) {
        this.idOrder = idOrder;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (idOrderItem != null ? idOrderItem.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof OrderItem)) {
            return false;
        }
        OrderItem other = (OrderItem) object;
        if ((this.idOrderItem == null && other.idOrderItem != null) || (this.idOrderItem != null && !this.idOrderItem.equals(other.idOrderItem))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "com.model.OrderItem[ idOrderItem=" + idOrderItem + " ]";
    }
    
}
