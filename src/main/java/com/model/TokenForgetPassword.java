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
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import jakarta.xml.bind.annotation.XmlRootElement;
import java.io.Serializable;
import java.util.Date;

/**
 *
 * @author ADMIN
 */
@Entity
@Table(name = "tokenForgetPassword")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "TokenForgetPassword.findAll", query = "SELECT t FROM TokenForgetPassword t"),
    @NamedQuery(name = "TokenForgetPassword.findById", query = "SELECT t FROM TokenForgetPassword t WHERE t.id = :id"),
    @NamedQuery(name = "TokenForgetPassword.findByToken", query = "SELECT t FROM TokenForgetPassword t WHERE t.token = :token"),
    @NamedQuery(name = "TokenForgetPassword.findByExpiryTime", query = "SELECT t FROM TokenForgetPassword t WHERE t.expiryTime = :expiryTime"),
    @NamedQuery(name = "TokenForgetPassword.findByIsUsed", query = "SELECT t FROM TokenForgetPassword t WHERE t.isUsed = :isUsed")})
public class TokenForgetPassword implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    @Column(name = "id")
    private Integer id;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 255)
    @Column(name = "token")
    private String token;
    @Basic(optional = false)
    @NotNull
    @Column(name = "expiryTime")
    @Temporal(TemporalType.TIMESTAMP)
    private Date expiryTime;
    @Basic(optional = false)
    @NotNull
    @Column(name = "isUsed")
    private boolean isUsed;
    @JoinColumn(name = "userId", referencedColumnName = "id_user")
    @ManyToOne(optional = false)
    private User userId;

    public TokenForgetPassword() {
    }

    public TokenForgetPassword(Integer id) {
        this.id = id;
    }

    public TokenForgetPassword(Integer id, String token, Date expiryTime, boolean isUsed) {
        this.id = id;
        this.token = token;
        this.expiryTime = expiryTime;
        this.isUsed = isUsed;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getToken() {
        return token;
    }

    public void setToken(String token) {
        this.token = token;
    }

    public Date getExpiryTime() {
        return expiryTime;
    }

    public void setExpiryTime(Date expiryTime) {
        this.expiryTime = expiryTime;
    }

    public boolean getIsUsed() {
        return isUsed;
    }

    public void setIsUsed(boolean isUsed) {
        this.isUsed = isUsed;
    }

    public User getUserId() {
        return userId;
    }

    public void setUserId(User userId) {
        this.userId = userId;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (id != null ? id.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof TokenForgetPassword)) {
            return false;
        }
        TokenForgetPassword other = (TokenForgetPassword) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "com.model.TokenForgetPassword[ id=" + id + " ]";
    }
    
}
