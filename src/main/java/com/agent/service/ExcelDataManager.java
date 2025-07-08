/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.agent.service;

import com.agent.model.CustomerResponse;
import com.agent.model.ScheduleItem;
import java.io.Serializable;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

/**
 *
 * @author Admin
 */
public class ExcelDataManager {
    private static final String SCHEDULE_FILE = "schedules_with_priority.xlsx";
    private static final String RESPONSES_FILE = "schedule_responses.xlsx";
    private static final DateTimeFormatter FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");

    /**
     * Load schedules from Excel file
     */
    public List<ScheduleItem> loadSchedules() {
        List<ScheduleItem> schedules = new ArrayList<>();

        try (FileInputStream fis = new FileInputStream(SCHEDULE_FILE);
             Workbook workbook = new XSSFWorkbook(fis)) {

            Sheet sheet = workbook.getSheetAt(0);

            for (int i = 1; i <= sheet.getLastRowNum(); i++) {
                Row row = sheet.getRow(i);
                if (row == null) continue;

                try {
                    String title = getCellValueAsString(row.getCell(0));
                    String startStr = getCellValueAsString(row.getCell(1));
                    String endStr = getCellValueAsString(row.getCell(2));
                    String time = getCellValueAsString(row.getCell(3));
                    String priority = getCellValueAsString(row.getCell(4));
                    String typeStr = getCellValueAsString(row.getCell(5));

                    LocalDateTime start = LocalDateTime.parse(startStr, FORMATTER);
                    LocalDateTime end = LocalDateTime.parse(endStr, FORMATTER);

                    ScheduleItem item = new ScheduleItem(title, start, end, time);
                    item.setPriority(priority);

                    // Parse schedule type
                    try {
                        ScheduleItem.ScheduleType type = ScheduleItem.ScheduleType.valueOf(typeStr);
                        item.setScheduleType(type);
                    } catch (Exception e) {
                        item.setScheduleType(ScheduleItem.ScheduleType.PERSONAL);
                    }

                    schedules.add(item);

                } catch (Exception e) {
                    System.err.println("Lỗi đọc lịch tại dòng " + (i + 1) + ": " + e.getMessage());
                }
            }

        } catch (IOException e) {
            System.err.println("Không thể đọc file: " + SCHEDULE_FILE);
        }

        return schedules;
    }

    /**
     * Save schedules to Excel file
     */
    public void saveSchedules(List<ScheduleItem> schedules) {
        try (Workbook workbook = new XSSFWorkbook()) {
            Sheet sheet = workbook.createSheet("Schedules");

            Row header = sheet.createRow(0);
            header.createCell(0).setCellValue("Tiêu đề");
            header.createCell(1).setCellValue("Thời gian bắt đầu");
            header.createCell(2).setCellValue("Thời gian kết thúc");
            header.createCell(3).setCellValue("Thời gian gốc (nếu có)");
            header.createCell(4).setCellValue("Mức độ ưu tiên");
            header.createCell(5).setCellValue("Loại lịch trình");

            for (int i = 0; i < schedules.size(); i++) {
                ScheduleItem item = schedules.get(i);
                Row row = sheet.createRow(i + 1);

                row.createCell(0).setCellValue(item.getTitle());
                row.createCell(1).setCellValue(
                        item.getStartTime() != null ? item.getStartTime().format(FORMATTER) : ""
                );
                row.createCell(2).setCellValue(
                        item.getEndTime() != null ? item.getEndTime().format(FORMATTER) : ""
                );
                row.createCell(3).setCellValue(item.getTime() != null ? item.getTime() : "");
                row.createCell(4).setCellValue(item.getPriority() != null ? item.getPriority() : "MEDIUM");
                row.createCell(5).setCellValue(
                        item.getScheduleType() != null ? item.getScheduleType().name() : "NORMAL"
                );
            }

            try (FileOutputStream fos = new FileOutputStream(SCHEDULE_FILE)) {
                workbook.write(fos);
            }
            System.out.println("📋 Số lượng schedule sẽ lưu: " + schedules.size());


            System.out.println("Đã lưu vào file: " + SCHEDULE_FILE);

        } catch (IOException e) {
            System.err.println("Lỗi khi ghi file: " + e.getMessage());
        }
    }


    /**
     * Load conversation history from responses file
     */
    public List<CustomerResponse> loadConversationHistory(String sessionId) {

        List<CustomerResponse> responses = new ArrayList<>();

        try (FileInputStream fis = new FileInputStream(RESPONSES_FILE);
             Workbook workbook = new XSSFWorkbook(fis)) {

            Sheet sheet = workbook.getSheetAt(0);

            for (int i = 1; i <= sheet.getLastRowNum(); i++) {
                Row row = sheet.getRow(i);
                if (row == null) continue;

                try {
                    String timestamp = getCellValueAsString(row.getCell(0));
                    String customerInput = getCellValueAsString(row.getCell(1));
                    String aiResponse = getCellValueAsString(row.getCell(2));
                    String storedSessionId = getCellValueAsString(row.getCell(3));

                    if (sessionId.equals(storedSessionId)) {
                        responses.add(new CustomerResponse(timestamp, customerInput, aiResponse, storedSessionId));
                    }
                } catch (Exception e) {
                    System.err.println("Lỗi đọc lịch sử tại hàng " + (i + 1) + ": " + e.getMessage());
                }
            }

        } catch (IOException e) {
            System.out.println("Tạo file lịch sử trò chuyện mới...");
        }

        return responses;
    }

    /**
     * Save conversation response to Excel file
     */
    public void saveConversationResponse(String customerInput, String aiResponse, String sessionId) {
        String timestamp = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));

        try {
            Workbook workbook;
            Sheet sheet;

            try (FileInputStream fis = new FileInputStream(RESPONSES_FILE)) {
                workbook = new XSSFWorkbook(fis);
                sheet = workbook.getSheetAt(0);
            } catch (IOException e) {
                workbook = new XSSFWorkbook();
                sheet = workbook.createSheet("Responses");

                Row headerRow = sheet.createRow(0);
                headerRow.createCell(0).setCellValue("Thời gian");
                headerRow.createCell(1).setCellValue("Câu hỏi khách hàng");
                headerRow.createCell(2).setCellValue("Phản hồi AI");
                headerRow.createCell(3).setCellValue("Session ID");
            }

            int lastRowNum = sheet.getLastRowNum();
            Row newRow = sheet.createRow(lastRowNum + 1);
            newRow.createCell(0).setCellValue(timestamp);
            newRow.createCell(1).setCellValue(customerInput);
            newRow.createCell(2).setCellValue(aiResponse);
            newRow.createCell(3).setCellValue(sessionId);

            try (FileOutputStream fos = new FileOutputStream(RESPONSES_FILE)) {
                workbook.write(fos);
            }

            workbook.close();

        } catch (IOException e) {
            System.err.println("Lỗi lưu phản hồi: " + e.getMessage());
        }
    }

    private String getCellValueAsString(Cell cell) {
        if (cell == null) return "";

        switch (cell.getCellType()) {
            case STRING:
                return cell.getStringCellValue().trim();
            case NUMERIC:
                if (DateUtil.isCellDateFormatted(cell)) {
                    return FORMATTER.format(cell.getLocalDateTimeCellValue());
                } else {
                    return String.valueOf((long) cell.getNumericCellValue());
                }
            case BOOLEAN:
                return String.valueOf(cell.getBooleanCellValue());
            case FORMULA:
                return cell.getCellFormula();
            default:
                return "";
        }
    }
}
