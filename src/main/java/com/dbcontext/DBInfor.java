/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.dbcontext;

/**
 *
 * @author DELL
 */
public interface DBInfor {
     String driverName = "com.microsoft.sqlserver.jdbc.SQLServerDriver";
    String dbURL = "jdbc:sqlserver://localhost:1433;databaseName=Calendar;trustServerCertificate=true";
    String userDB = "sa";
    String passDB = "123456";
}
