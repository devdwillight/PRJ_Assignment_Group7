/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.agent.service;

import com.agent.util.ConfigLoader;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.stream.Collectors;
import org.json.JSONObject;

/**
 *
 * @author Admin
 */
public class WheatherService {
    private static final String API_KEY =ConfigLoader.get("API_WEATHER");
    private static final String BASE_URL = "http://api.weatherapi.com/v1/forecast.json";

    public String getForecastNote(LocalDateTime date, String location) {
        try {
            String url = BASE_URL + "?key=" + API_KEY + "&q=" + URLEncoder.encode(location, StandardCharsets.UTF_8)
                         + "&dt=" + date + "&days=1";
            HttpURLConnection conn = (HttpURLConnection) new URL(url).openConnection();
            conn.setRequestMethod("GET");

            if (conn.getResponseCode() != 200) return null;

            String json = new BufferedReader(new InputStreamReader(conn.getInputStream()))
                    .lines().collect(Collectors.joining());

            JSONObject obj = new JSONObject(json);
            JSONObject day = obj.getJSONObject("forecast")
                                .getJSONArray("forecastday").getJSONObject(0)
                                .getJSONObject("day");

            String condition = day.getJSONObject("condition").getString("text");
            double rainChance = day.optDouble("daily_chance_of_rain", 0);

            if (condition.toLowerCase().contains("rain") || rainChance > 50) {
                return "Dự báo ngày " + date + " tại " + location + ": " + condition +
                       " 🌧 (khả năng mưa: " + rainChance + "%)";
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return "";
    }
}

