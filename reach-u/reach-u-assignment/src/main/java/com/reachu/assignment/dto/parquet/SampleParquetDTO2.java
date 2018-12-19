package com.reachu.assignment.dto.parquet;

import com.reachu.assignment.util.RandomUtil;

/**
 * Created by kamilinal on 12/18/18.
 */
public class SampleParquetDTO2 extends BaseParquetDTO {
    private String strField;
    private byte[] byteField;

    public SampleParquetDTO2() {
        super(System.currentTimeMillis());
        this.assignRandomValues();
    }

    public SampleParquetDTO2(long timestamp, String strField) {
        super(timestamp);
        this.strField = strField;
    }

    /**
     *  Create random values for DTO fields
     */
    public void assignRandomValues(){
        this.strField = RandomUtil.getRandomString();
        this.byteField = RandomUtil.getRandomBytes();
    }

    public String getStrField() {
        return strField;
    }

    public void setStrField(String strField) {
        this.strField = strField;
    }

    public byte[] getByteField() {
        return byteField;
    }

    public void setByteField(byte[] byteField) {
        this.byteField = byteField;
    }
}
