package com.reachu.assignment.dto;

import com.reachu.assignment.dto.parquet.BaseParquetDTO;

/**
 * Created by kamili on 18/12/2018.
 */
public class StatusDto<T extends BaseParquetDTO> implements BaseRestResponse {
    private boolean status;
    private int statusCode;
    private String reason;
    private T[] values;

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

    public StatusDto(boolean status, int statusCode, String reason, T[] values) {
        this.status = status;
        this.reason = reason;
        this.statusCode = statusCode;
        this.values = values;
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

    public T[] getValues() {
        return values;
    }

    public void setValues(T[] values) {
        this.values = values;
    }
}
