package com.reachu.assignment.dto;

/**
 * Created by kamili on 18/12/2018.
 */
public class StatusDto implements BaseRestResponse {
    private boolean status;
    private int statusCode;
    private String reason;

    public StatusDto() {

    }

    public StatusDto(boolean status, String reason) {
        this.status = status;
        this.reason = reason;
    }

    public StatusDto(boolean status, int statusCode, String reason) {
        this.status = status;
        this.reason = reason;
        this.statusCode = statusCode;
    }

    public boolean isStatus() {
        return status;
    }

    public void setStatus(boolean status) {
        this.status = status;
    }

    public String getReason() {
        return reason;
    }

    public void setReason(String reason) {
        this.reason = reason;
    }

    public int getStatusCode() {
        return statusCode;
    }

    public void setStatusCode(int statusCode) {
        this.statusCode = statusCode;
    }
}
