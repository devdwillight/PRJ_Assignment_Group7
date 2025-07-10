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
import java.util.Date;

/**
 *
 * @author DELL
 */
@Entity
@Table(name = "User_Course")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "UserCourse.findAll", query = "SELECT u FROM UserCourse u"),
    @NamedQuery(name = "UserCourse.findByIdEnroll", query = "SELECT u FROM UserCourse u WHERE u.idEnroll = :idEnroll"),
    @NamedQuery(name = "UserCourse.findByEnrollDate", query = "SELECT u FROM UserCourse u WHERE u.enrollDate = :enrollDate")})
public class UserCourse implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    @Column(name = "id_enroll")
    private Integer idEnroll;
    @Column(name = "enroll_date")
    @Temporal(TemporalType.TIMESTAMP)
    private Date enrollDate;
    @JoinColumn(name = "id_course", referencedColumnName = "id_course")
    @ManyToOne(optional = false)
    private Course idCourse;
    @JoinColumn(name = "id_user", referencedColumnName = "id_user")
    @ManyToOne(optional = false)
    private User idUser;

    public UserCourse() {
    }

    public UserCourse(Integer idEnroll) {
        this.idEnroll = idEnroll;
    }

    public Integer getIdEnroll() {
        return idEnroll;
    }

    public void setIdEnroll(Integer idEnroll) {
        this.idEnroll = idEnroll;
    }

    public Date getEnrollDate() {
        return enrollDate;
    }

    public void setEnrollDate(Date enrollDate) {
        this.enrollDate = enrollDate;
    }

    public Course getIdCourse() {
        return idCourse;
    }

    public void setIdCourse(Course idCourse) {
        this.idCourse = idCourse;
    }

    public User getIdUser() {
        return idUser;
    }

    public void setIdUser(User idUser) {
        this.idUser = idUser;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (idEnroll != null ? idEnroll.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof UserCourse)) {
            return false;
        }
        UserCourse other = (UserCourse) object;
        if ((this.idEnroll == null && other.idEnroll != null) || (this.idEnroll != null && !this.idEnroll.equals(other.idEnroll))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "com.model.UserCourse[ idEnroll=" + idEnroll + " ]";
    }
    
}
