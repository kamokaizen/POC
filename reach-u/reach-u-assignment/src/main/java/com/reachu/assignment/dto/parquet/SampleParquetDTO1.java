package com.reachu.assignment.dto.parquet;

import com.reachu.assignment.util.RandomUtil;

/**
 * Created by kamilinal on 12/18/18.
 */
public class SampleParquetDTO1 extends BaseParquetDTO {
    private String strField;
    private int intField;
    private float floatField;
    private double doubleField;
    private long longField;
    private boolean booleanField;

    public SampleParquetDTO1() {
        super(System.currentTimeMillis());
        this.assignRandomValues();
    }

    public SampleParquetDTO1(long timestamp, String strField, int intField, float floatField, double doubleField, long longField, boolean booleanField) {
        super(timestamp);
        this.strField = strField;
        this.intField = intField;
        this.floatField = floatField;
        this.doubleField = doubleField;
        this.longField = longField;
        this.booleanField = booleanField;
    }

    /**
     *  Create random values for DTO fields
     */
    public void assignRandomValues(){
        this.strField = RandomUtil.getRandomString();
        this.intField = RandomUtil.getRandomInt();
        this.floatField = RandomUtil.getRandomFloat();
        this.doubleField = RandomUtil.getRandomDouble();
        this.longField = RandomUtil.getRandomLong();
        this.booleanField = RandomUtil.getRandomBoolean();
    }

    public String getStrField() {
        return strField;
    }

    public void setStrField(String strField) {
        this.strField = strField;
    }

    public float getFloatField() {
        return floatField;
    }

    public void setFloatField(float floatField) {
        this.floatField = floatField;
    }

    public double getDoubleField() {
        return doubleField;
    }

    public void setDoubleField(double doubleField) {
        this.doubleField = doubleField;
    }

    public boolean isBooleanField() {
        return booleanField;
    }

    public void setBooleanField(boolean booleanField) {
        this.booleanField = booleanField;
    }

    public long getLongField() {
        return longField;
    }

    public void setLongField(long longField) {
        this.longField = longField;
    }

    public int getIntField() {
        return intField;
    }

    public void setIntField(int intField) {
        this.intField = intField;
    }
}
