/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.agent.util;

import java.io.InputStream;
import java.util.Properties;

/**
 *
 * @author Admin
 */
public class ConfigLoader {
    private static Properties properties = new Properties();

    static {
        try (InputStream input = ConfigLoader.class.getClassLoader()
                .getResourceAsStream("application.properties")) {
            if (input == null) {
                throw new RuntimeException("❌ Không tìm thấy file application.properties!");
            }
            properties.load(input);
        } catch (Exception e) {
            throw new RuntimeException("❌ Lỗi khi load properties: " + e.getMessage());
        }
    }

    public static String get(String key) {
        return properties.getProperty(key);
    }
}
