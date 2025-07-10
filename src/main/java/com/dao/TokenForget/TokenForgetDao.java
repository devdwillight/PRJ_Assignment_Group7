/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.dao.TokenForget;

import com.database.DBConnection;
import java.sql.Connection;
import com.entity.TokenForgetPassword;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;


/**
 *
 * @author HP
 */
public class TokenForgetDao {

    public String getFormatDate(LocalDateTime myDateObj) {
        DateTimeFormatter myFormatObj = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
        String formattedDate = myDateObj.format(myFormatObj);
        return formattedDate;
    }

    public boolean insertTokenForget(TokenForgetPassword tokenForget) {
        String sql = "INSERT INTO [dbo].[tokenForgetPassword] "
                + "([token], [expiryTime], [isUsed], [userId]) "
                + "VALUES (?, ?, ?, ?)";

        try (Connection c = DBConnection.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setString(1, tokenForget.getToken());
            ps.setTimestamp(2, Timestamp.valueOf(getFormatDate(tokenForget.getExpiryTime())));
            ps.setBoolean(3, tokenForget.isIsUsed());
            ps.setInt(4, tokenForget.getUserId());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();

            return false;
        }
    }

    public TokenForgetPassword getTokenPassword(String token) {
        String sql = "SELECT * FROM [tokenForgetPassword] WHERE token = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement st = conn.prepareStatement(sql)) {

            st.setString(1, token);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    return new TokenForgetPassword(
                            rs.getInt("id"),
                            rs.getInt("userId"),
                            rs.getBoolean("isUsed"),
                            rs.getString("token"),
                            rs.getTimestamp("expiryTime").toLocalDateTime()
                    );
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public void updateStatus(TokenForgetPassword token) {
        String sql = "UPDATE [tokenForgetPassword] SET isUsed = ? WHERE token = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement st = conn.prepareStatement(sql)) {

            st.setBoolean(1, token.isIsUsed());
            st.setString(2, token.getToken());
            st.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

}

