package com.reachu.assignment.dto.parquet;

import java.io.Serializable;

/**
 * Created by kamilinal on 12/18/18.
 */
public abstract class BaseParquetDTO implements Serializable{
    protected long timestamp;

    public BaseParquetDTO(long timestamp) {
        this.timestamp = timestamp;
    }

    public long getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(long timestamp) {
        this.timestamp = timestamp;
    }
}
