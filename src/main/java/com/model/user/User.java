/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model.user;

import java.util.Date;

/**
 *
 * @author DELL
 */
public class User {

    private int id;
    private String userName;
    private String passWord;
    private String first_name;
    private String last_name;
    private Date birthday;
    private String email;
    private String phone;
    private String gender;
    private boolean active;
    private boolean admin;
    private Date created_at;
    private Date update_at;
    private String avatar;

    public User(int id, String userName, String passWord, String first_name, String last_name, Date birthday, String email, String phone, String gender, boolean active, boolean admin, Date created_at, Date update_at, String avatar) {
        this.id = id;
        this.userName = userName;
        this.passWord = passWord;
        this.first_name = first_name;
        this.last_name = last_name;
        this.birthday = birthday;
        this.email = email;
        this.phone = phone;
        this.gender = gender;
        this.active = active;
        this.admin = admin;
        this.created_at = created_at;
        this.update_at = update_at;
        this.avatar = avatar;
    }

    public int getId() {
        return id;
    }

    public String getUserName() {
        return userName;
    }

    public String getPassWord() {
        return passWord;
    }

    public String getFirst_name() {
        return first_name;
    }

    public String getLast_name() {
        return last_name;
    }

    public Date getBirthday() {
        return birthday;
    }

    public String getEmail() {
        return email;
    }

    public String getPhone() {
        return phone;
    }

    public String getGender() {
        return gender;
    }

    public boolean isActive() {
        return active;
    }

    public boolean isAdmin() {
        return admin;
    }

    public Date getCreated_at() {
        return created_at;
    }

    public Date getUpdate_at() {
        return update_at;
    }

    public String getAvatar() {
        return avatar;
    }

    public void setId(int id) {
        this.id = id;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public void setPassWord(String passWord) {
        this.passWord = passWord;
    }

    public void setFirst_name(String first_name) {
        this.first_name = first_name;
    }

    public void setLast_name(String last_name) {
        this.last_name = last_name;
    }

    public void setBirthday(Date birthday) {
        this.birthday = birthday;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public void setActive(boolean active) {
        this.active = active;
    }

    public void setAdmin(boolean admin) {
        this.admin = admin;
    }

    public void setCreated_at(Date created_at) {
        this.created_at = created_at;
    }

    public void setUpdate_at(Date update_at) {
        this.update_at = update_at;
    }

    public void setAvatar(String avatar) {
        this.avatar = avatar;
    }

    @Override
    public String toString() {
        return "User{" + "id=" + id + ", userName=" + userName + ", passWord=" + passWord + ", first_name=" + first_name + ", last_name=" + last_name + ", birthday=" + birthday + ", email=" + email + ", phone=" + phone + ", gender=" + gender + ", active=" + active + ", admin=" + admin + ", created_at=" + created_at + ", update_at=" + update_at + ", avatar=" + avatar + '}';
    }

  

}
