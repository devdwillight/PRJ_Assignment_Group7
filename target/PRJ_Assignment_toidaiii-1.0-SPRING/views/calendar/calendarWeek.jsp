<%-- 
    Document   : calendarWeek
    Created on : Jul 11, 2025, 10:04:30 PM
    Author     : DELL
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<div class="relative overflow-y-scroll h-[700px] bg-white">
    <div class="grid grid-cols-8 border-b text-center font-bold bg-white sticky top-0 z-10">
        <div class="py-2 text-xs text-gray-400">GMT+07</div>
        <div id="weekDaysHeader" class="col-span-7 flex"></div>
    </div>
    <div id="weekGridBody"></div>
</div>
