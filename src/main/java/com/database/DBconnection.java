/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.database;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author DELL
 */
public class DBconnection implements DBinformation {

    public DBconnection() {
    }

    public static Connection getConnection() {
        Connection con = null;
        try {
            Class.forName(driverName);
            con = DriverManager.getConnection(dbURL, userDB, passDB);
            return con;
        } catch (ClassNotFoundException | SQLException ex) {
            Logger.getLogger(DBconnection.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }

    public static void main(String[] args) throws FileNotFoundException, IOException {
//        try (Connection con = getConnection()) {
//            if (con != null) {
//                System.out.println("Connect to Database Calendar success");
//            }
//        } catch (Exception ex) {
//            Logger.getLogger(DBconnection.class.getName()).log(Level.SEVERE, null, ex);
//        }
Properties props = new Properties();
props.load(new FileInputStream("src/main/resources/application.properties"));
String key = props.getProperty("GEMINI_API_KEY");
        
    }
}
