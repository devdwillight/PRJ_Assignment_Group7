/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.model;

import jakarta.persistence.Basic;
import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.NamedQueries;
import jakarta.persistence.NamedQuery;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;
import jakarta.persistence.Temporal;
import jakarta.persistence.TemporalType;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import jakarta.xml.bind.annotation.XmlRootElement;
import jakarta.xml.bind.annotation.XmlTransient;
import java.io.Serializable;
import java.util.Date;
import java.util.List;

/**
 *
 * @author DELL
 */
@Entity
@Table(name = "Calendar")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "Calendar_1.findAll", query = "SELECT c FROM Calendar_1 c"),
    @NamedQuery(name = "Calendar_1.findByIdCalendar", query = "SELECT c FROM Calendar_1 c WHERE c.idCalendar = :idCalendar"),
    @NamedQuery(name = "Calendar_1.findByName", query = "SELECT c FROM Calendar_1 c WHERE c.name = :name"),
    @NamedQuery(name = "Calendar_1.findByColor", query = "SELECT c FROM Calendar_1 c WHERE c.color = :color"),
    @NamedQuery(name = "Calendar_1.findByCreatedAt", query = "SELECT c FROM Calendar_1 c WHERE c.createdAt = :createdAt"),
    @NamedQuery(name = "Calendar_1.findByUpdatedAt", query = "SELECT c FROM Calendar_1 c WHERE c.updatedAt = :updatedAt")})
public class Calendar_1 implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    @Column(name = "id_calendar")
    private Integer idCalendar;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 255)
    @Column(name = "name")
    private String name;
    @Size(max = 50)
    @Column(name = "color")
    private String color;
    @Column(name = "created_at")
    @Temporal(TemporalType.TIMESTAMP)
    private Date createdAt;
    @Column(name = "updated_at")
    @Temporal(TemporalType.TIMESTAMP)
    private Date updatedAt;
    @JoinColumn(name = "id_user", referencedColumnName = "id_user")
    @ManyToOne(optional = false)
    private Users idUser;
    @OneToMany(cascade = CascadeType.ALL, mappedBy = "idCalendar")
    private List<UserEvents> userEventsList;

    public Calendar_1() {
    }

    public Calendar_1(Integer idCalendar) {
        this.idCalendar = idCalendar;
    }

    public Calendar_1(Integer idCalendar, String name) {
        this.idCalendar = idCalendar;
        this.name = name;
    }

    public Integer getIdCalendar() {
        return idCalendar;
    }

    public void setIdCalendar(Integer idCalendar) {
        this.idCalendar = idCalendar;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getColor() {
        return color;
    }

    public void setColor(String color) {
        this.color = color;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public Date getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Date updatedAt) {
        this.updatedAt = updatedAt;
    }

    public Users getIdUser() {
        return idUser;
    }

    public void setIdUser(Users idUser) {
        this.idUser = idUser;
    }

    @XmlTransient
    public List<UserEvents> getUserEventsList() {
        return userEventsList;
    }

    public void setUserEventsList(List<UserEvents> userEventsList) {
        this.userEventsList = userEventsList;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (idCalendar != null ? idCalendar.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof Calendar_1)) {
            return false;
        }
        Calendar_1 other = (Calendar_1) object;
        if ((this.idCalendar == null && other.idCalendar != null) || (this.idCalendar != null && !this.idCalendar.equals(other.idCalendar))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "com.model.Calendar_1[ idCalendar=" + idCalendar + " ]";
    }
    
}
